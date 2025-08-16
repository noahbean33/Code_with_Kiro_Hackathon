#!/usr/bin/env bash
# Smallsh Spec Compliance Test Harness
# Requires: bash, gcc, coreutils, (optional) timeout
# Recommended environment: Linux or macOS; on Windows use WSL.

set -u

# Config
PROJECT_ROOT="$(cd "$(dirname "$0")"/.. && pwd)"
DEFAULT_SRC="$PROJECT_ROOT/attempt_1/smallsh.c"
BUILD_DIR="$PROJECT_ROOT/tests/.build"
BIN="$BUILD_DIR/smallsh"
WORKDIR="$PROJECT_ROOT/tests/.work"
TIMEOUT_BIN="$(command -v timeout || true)"
TIME_LIMIT=6s

mkdir -p "$BUILD_DIR" "$WORKDIR"

# Utilities
log() { printf "[INFO] %s\n" "$*"; }
warn() { printf "[WARN] %s\n" "$*"; }
err() { printf "[ERROR] %s\n" "$*"; }
hr() { printf "------------------------------\n"; }

run_with_input() {
  # Usage: run_with_input "input_text" [extra-args...]
  local input="$1"; shift || true
  if [[ -n "$TIMEOUT_BIN" ]]; then
    printf "%s" "$input" | "$TIMEOUT_BIN" "$TIME_LIMIT" "$BIN" "$@" 2>&1
  else
    printf "%s" "$input" | "$BIN" "$@" 2>&1
  fi
}

pass=0
fail=0
skipped=0

test_case() {
  local name="$1"; shift
  local input="$1"; shift
  local -a expect_contains=()
  local -a expect_absent=()
  local rc_expect=""

  # parse flags
  while (( "$#" )); do
    case "$1" in
      --expect) expect_contains+=("$2"); shift 2 ;;
      --absent) expect_absent+=("$2"); shift 2 ;;
      --rc) rc_expect="$2"; shift 2 ;;
      *) err "Unknown flag in test '$name': $1"; return 2 ;;
    esac
  done

  hr
  log "TEST: $name"
  local out
  set +e
  out=$(run_with_input "$input")
  local rc=$?
  set -e

  local ok=1

  # Check expected substrings
  for s in "${expect_contains[@]}"; do
    if ! grep -Fq -- "$s" <<<"$out"; then
      ok=0
      err "Missing expected text: $s"
    fi
  done

  # Check absent substrings
  for s in "${expect_absent[@]}"; do
    if grep -Fq -- "$s" <<<"$out"; then
      ok=0
      err "Unexpected text present: $s"
    fi
  done

  # Check return code (if specified)
  if [[ -n "$rc_expect" ]]; then
    if [[ "$rc" -ne "$rc_expect" ]]; then
      ok=0
      err "Return code $rc != expected $rc_expect"
    fi
  fi

  if [[ $ok -eq 1 ]]; then
    pass=$((pass+1))
    log "PASS: $name"
  else
    fail=$((fail+1))
    warn "FAIL: $name"
    log "Output:\n$out"
  fi
}

compile() {
  local src="${1:-$DEFAULT_SRC}"
  if [[ ! -f "$src" ]]; then
    err "Source not found: $src"
    exit 2
  fi
  log "Compiling: $src"
  cc -std=c99 -Wall -Wextra -O2 -o "$BIN" "$src"
}

main() {
  local src="${1:-$DEFAULT_SRC}"
  compile "$src"

  # 1) Prompt appears on start
  test_case "prompt_appears" $':\nexit\n' \
    --expect ":"

  # 2) Comments and blank lines are ignored (reprompt without error)
  test_case "comments_and_blanks" $'\n# this is a comment\n\nexit\n' \
    --expect ":" \
    --absent "this is a comment"

  # Prepare workdir
  rm -rf "$WORKDIR" && mkdir -p "$WORKDIR"

  # 3) Built-in: cd changes shell working directory and persists across commands
  (
    cd "$WORKDIR"
    mkdir -p a b
    out=$(run_with_input $'pwd\ncd a\npwd\nexit\n')
    first=$(grep -Eo "/.*" <<<"$out" | head -n1)
    second=$(grep -Eo "/.*" <<<"$out" | sed -n '2p')
    if [[ -n "$first" && -n "$second" && "$second" == "$first"/a* ]]; then
      pass=$((pass+1)); log "PASS: builtin_cd"
    else
      fail=$((fail+1)); warn "FAIL: builtin_cd"; log "Output:\n$out"
    fi
  )

  # 4) Built-in: status shows last foreground exit value (0 then 1)
  test_case "builtin_status" $'true\nstatus\nfalse\nstatus\nexit\n' \
    --expect "exit value 0" \
    --expect "exit value 1"

  # 5) Built-in: exit terminates shell (expect rc 0)
  test_case "builtin_exit" $'exit\n' --rc 0

  # 6) Exec external command
  test_case "exec_echo" $'echo hello\nexit\n' --expect "hello"

  # 7) Output redirection: echo -> file, then read it back
  (
    cd "$WORKDIR"
    out=$(run_with_input $'echo foo > out.txt\ncat < out.txt\nexit\n')
    if grep -Fq "foo" <<<"$out"; then
      pass=$((pass+1)); log "PASS: redirection_out_in"
    else
      fail=$((fail+1)); warn "FAIL: redirection_out_in"; log "Output:\n$out"
    fi
  )

  # 8) Foreground/background: background returns promptly with prompt shown
  test_case "background_ampersand" $'sleep 1 &\necho done\nexit\n' \
    --expect ":" \
    --expect "done"

  # 9) SIGTSTP toggles foreground-only mode (best-effort)
  # Many reference implementations print these exact messages.
  if [[ -t 0 ]]; then
    warn "Skipping SIGTSTP test in non-pty environment"
    skipped=$((skipped+1))
  else
    skipped=$((skipped+1))
    warn "Skipping SIGTSTP test (requires interactive pty)."
  fi

  # 10) SIGINT terminates foreground child but not shell (best-effort)
  # Hard to simulate reliably without pty; mark as skipped here.
  skipped=$((skipped+1))
  warn "Skipping SIGINT test (requires interactive pty)."

  hr
  log "Summary: PASS=$pass FAIL=$fail SKIPPED=$skipped"
  if [[ $fail -eq 0 ]]; then
    exit 0
  else
    exit 1
  fi
}

set -e
main "$@"

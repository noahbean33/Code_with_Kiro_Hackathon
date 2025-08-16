# Code_with_Kiro_Hackathon
Smallsh with Spec-Driven Development and Statistical Evaluation

## Overview
This repository is a submission for the Code with Kiro Hackathon. It explores how Kiro’s spec-driven workflow impacts software quality and consistency by implementing a Unix-like shell in C ("smallsh") and validating the approach with a reproducible evaluation plan.

The project builds on the classic "smallsh" assignment: a miniature shell that supports a subset of bash-like features. We implement and compare two approaches:

- Baseline: a conventional/assignment-style implementation (`original_smallsh/`).
- Kiro-guided: a structured, spec-driven implementation (`attempt_1/` with `/.kiro/`).

We aim to measure whether Kiro’s structured design yields higher quality, lower variance (more consistency), and faster completion time across repeated sessions.

## Smallsh Requirements (scope)
Derived from the original assignment brief in `original_smallsh/project_description.txt`:

- Provide a prompt (use `:`) for each command line.
- Handle blank lines and comments (lines starting with `#`).
- Built-in commands: `exit`, `cd`, `status`.
- Execute other commands via `exec*` in child processes.
- Support input/output redirection.
- Support foreground and background processes.
- Implement custom signal handling for `SIGINT` and `SIGTSTP`.

## Repository Structure
- `attempt_1/`
  - `.kiro/` — Kiro specs/config to demonstrate spec-driven development.
  - `smallsh.c` — work-in-progress Kiro-guided shell implementation.
- `original_smallsh/`
  - `project_description.txt` — original assignment scope and requirements.
  - `original_smallsh.c.txt` — reference/baseline implementation artifact.
- `conversation_about_statistical_analysis.txt` — experiment design for repeated sessions, sample sizing, reliability, and reporting.
- `README.md` — this document.
- `LICENSE` — project license.

## Build & Run (Linux/macOS)
From the directory containing a given implementation file (e.g., `attempt_1/`):

```bash
gcc -std=c99 -Wall -Wextra -o smallsh smallsh.c
./smallsh
```

Notes:
- The shell assumes a POSIX environment for processes, signals, and `exec*`.
- On Windows, use WSL for expected behavior.

## How Kiro Is Used
- Spec-driven scaffolding and iteration are captured under `attempt_1/.kiro/` (required by hackathon rules).
- Kiro assists with:
  - Turning specs into structured C modules (enums/structs) and handlers.
  - Iterative refinement via inline AI coding and multi-modal chat.
  - Maintaining consistency with a fixed rubric and test steps.

## Evaluation Plan (summary)
We validate the impact of Kiro’s approach with repeated, timeboxed sessions building the same shell:

- Metrics per session: quality (tests/spec compliance), consistency (variance), and time/effort.
- Pilot first (≈8–10 sessions) to estimate SD, then choose total `n` via CI half-width target:
  - n = (1.96 · σ̂ / m)^2 for 95% CI half-width m (see `conversation_about_statistical_analysis.txt`).
- Reliability: estimate ICC for single sessions; use Spearman–Brown to estimate reliability when averaging k sessions.
- Statistics: report mean, SD, 95% CI; paired t-test for within-person comparison across approaches.
- Visuals (for Devpost/demo): mean±CI bars (quality), learning curve, spec-compliance heatmap.

## Status
- Kiro-guided implementation lives in `attempt_1/smallsh.c`.
- Baseline materials in `original_smallsh/` provide scope and reference.
- Next steps: finalize test/grading scripts, run pilot, compute SD, finalize `n`, and document results.

## License
This repository is open-sourced under the license in `LICENSE`.

## Acknowledgments
- Original smallsh assignment concept referenced from `original_smallsh/project_description.txt`.
- Hackathon brief summarized from `code_with_kiro_hackathon_description.txt`.

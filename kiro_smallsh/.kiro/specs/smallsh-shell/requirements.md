# Requirements Document

## Introduction

This document outlines the requirements for developing smallsh, a command-line interpreter (shell) in C that provides a minimal user interface for executing commands and managing processes. The shell will support built-in commands, process management, I/O redirection, and signal handling, similar to bash but with a simplified feature set.

## Requirements

### Requirement 1

**User Story:** As a user, I want a command-line interface with a clear prompt, so that I can interact with the shell and execute commands.

#### Acceptance Criteria

1. WHEN the shell starts THEN the system SHALL display a colon (:) as the command prompt
2. WHEN any output is printed THEN the system SHALL call fflush(stdout) to ensure immediate display
3. WHEN a user enters a command line THEN the system SHALL accept up to 2048 characters
4. WHEN a user enters arguments THEN the system SHALL support a maximum of 512 arguments
5. WHEN a user enters a blank line THEN the system SHALL skip it and re-prompt
6. WHEN a user enters a line beginning with # THEN the system SHALL treat it as a comment and re-prompt

### Requirement 2

**User Story:** As a user, I want built-in commands for basic shell operations, so that I can navigate directories, check command status, and exit the shell.

#### Acceptance Criteria

1. WHEN a user types "exit" THEN the system SHALL terminate the shell and all background processes
2. WHEN a user types "cd" with no arguments THEN the system SHALL change to the directory specified in $HOME
3. WHEN a user types "cd" with one argument THEN the system SHALL change to the specified path
4. WHEN a user types "status" THEN the system SHALL print the exit status or terminating signal of the last non-built-in foreground command
5. IF no non-built-in command has been run THEN the system SHALL print exit value 0 for status
6. WHEN a built-in command has a trailing & THEN the system SHALL ignore & and run in foreground

### Requirement 3

**User Story:** As a user, I want to execute external commands, so that I can run programs and utilities available on the system.

#### Acceptance Criteria

1. WHEN a user enters a non-built-in command THEN the system SHALL fork a child process
2. WHEN the child process is created THEN the system SHALL use exec() family functions to execute the command
3. WHEN locating commands THEN the system SHALL use the PATH environment variable
4. IF exec() fails THEN the system SHALL print an error message and set status to 1
5. WHEN exec() fails THEN the child process SHALL terminate

### Requirement 4

**User Story:** As a user, I want I/O redirection capabilities, so that I can redirect input from files and output to files.

#### Acceptance Criteria

1. WHEN a command contains < followed by a filename THEN the system SHALL redirect stdin from that file
2. WHEN a command contains > followed by a filename THEN the system SHALL redirect stdout to that file
3. WHEN input redirection fails THEN the system SHALL print an error and set status to 1
4. WHEN output redirection fails THEN the system SHALL print an error and set status to 1
5. WHEN output redirection is used THEN the system SHALL truncate existing files or create new ones
6. WHEN both input and output redirection are specified THEN the system SHALL handle both in the same command
7. WHEN background processes have no input redirection THEN the system SHALL redirect stdin to /dev/null
8. WHEN background processes have no output redirection THEN the system SHALL redirect stdout to /dev/null

### Requirement 5

**User Story:** As a user, I want process management capabilities, so that I can run commands in foreground or background and monitor their completion.

#### Acceptance Criteria

1. WHEN a command does not end with & THEN the system SHALL run it in the foreground
2. WHEN a foreground command runs THEN the parent SHALL wait for completion using waitpid()
3. WHEN a command ends with & and not in foreground-only mode THEN the system SHALL run it in the background
4. WHEN a background process starts THEN the system SHALL print "background pid is <PID>"
5. WHEN the parent does not wait for background processes THEN the system SHALL check for completed background processes using waitpid(..., WNOHANG)
6. WHEN showing the prompt THEN the system SHALL print completion messages for finished background processes
7. WHEN a background process exits normally THEN the system SHALL print "background pid <PID> is done: exit value <status>"
8. WHEN a background process is terminated by signal THEN the system SHALL print "background pid <PID> is done: terminated by signal <signal>"

### Requirement 6

**User Story:** As a user, I want proper signal handling, so that I can interrupt foreground processes and toggle foreground-only mode.

#### Acceptance Criteria

1. WHEN SIGINT is received by the parent shell THEN the system SHALL ignore it
2. WHEN SIGINT is received by background children THEN the system SHALL ignore it
3. WHEN SIGINT is received by foreground children THEN the system SHALL use default behavior (terminate)
4. WHEN a foreground child is terminated by signal THEN the parent SHALL print "terminated by signal <signal>"
5. WHEN SIGTSTP is received by any child process THEN the system SHALL ignore it
6. WHEN SIGTSTP is received by the parent shell THEN the system SHALL toggle foreground-only mode
7. WHEN entering foreground-only mode THEN the system SHALL print "Entering foreground-only mode (& is now ignored)"
8. WHEN exiting foreground-only mode THEN the system SHALL print "Exiting foreground-only mode"
9. WHEN in foreground-only mode THEN the system SHALL ignore & and run all commands in foreground

### Requirement 7

**User Story:** As a developer, I want the code to follow technical requirements and best practices, so that the shell is maintainable and meets academic standards.

#### Acceptance Criteria

1. WHEN compiling the code THEN the system SHALL use GNU99 C standard
2. WHEN compiling THEN the system SHALL use the command "gcc --std=gnu99 -o smallsh *.c"
3. WHEN implementing functions THEN the system SHALL use clear, modular function design
4. WHEN handling errors THEN the system SHALL implement robust error handling
5. WHEN using dynamic memory THEN the system SHALL properly manage all allocations
6. WHEN parsing command syntax THEN the system SHALL recognize <, >, and & only when surrounded by spaces
7. WHEN processing & THEN the system SHALL treat it as special only if it appears as the last token
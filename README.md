# Code_with_Kiro_Hackathon
Smallsh with Spec-Driven Development and Statistical Evaluation

## Overview
This repository is a submission for the Code with Kiro Hackathon. It explores how Kiro’s spec-driven workflow impacts software quality and consistency by implementing a Unix-like shell in C ("smallsh") and validating the approach with a reproducible evaluation plan.

The project builds on the classic "smallsh" assignment: a miniature shell that supports a subset of bash-like features. We implement and compare two approaches:

- Baseline: a conventional/assignment-style implementation (original_smallsh/).
- Kiro-guided: a structured, spec-driven implementation (kiro_smallsh/).

## Smallsh Requirements (scope)
Derived from the original assignment brief in original_smallsh/project_description.txt:

- Provide a prompt (use :) for each command line.
- Handle blank lines and comments (lines starting with #).
- Built-in commands: exit, cd, status.
- Execute other commands via exec* in child processes.
- Support input/output redirection.
- Support foreground and background processes.
- Implement custom signal handling for SIGINT and SIGTSTP.

## Repository Structure
- kiro_smallsh/
  - .kiro/ — Kiro specs/config to demonstrate spec-driven development.
  - smallsh.c — Kiro-guided shell implementation.
- original_smallsh/
  - project_description.txt — original assignment scope and requirements.
  - original_smallsh.c.txt — reference/baseline implementation artifact.
- README.md — this document.
- LICENSE — project license.

## Build & Run (Linux)

gcc -std=c99 -Wall -Wextra -o smallsh smallsh.c
./smallsh


## How Kiro Is Used
- Spec-driven scaffolding and iteration are captured under kiro_smallsh/.kiro/ (required by hackathon rules).
- Kiro assists with:
  - Turning specs into structured C modules (enums/structs) and handlers.
  - Iterative refinement via inline AI coding and multi-modal chat.
  - Maintaining consistency with a fixed rubric and test steps.

## License
This repository is open-sourced under the license in LICENSE.

## Acknowledgments
- Original smallsh assignment concept referenced from original_smallsh/project_description.txt.
- Hackathon brief summarized from code_with_kiro_hackathon_description.txt.

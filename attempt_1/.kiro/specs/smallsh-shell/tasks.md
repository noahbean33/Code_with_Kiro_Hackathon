# Implementation Plan

- [x] 1. Set up project structure and core data types


  - Create main C source file with necessary includes
  - Define command_t structure and related enums
  - Define global variables for shell state and background process tracking
  - Create basic main function skeleton with compilation test
  - _Requirements: 7.1, 7.2_

- [x] 2. Implement command line parsing functionality



  - [ ] 2.1 Create basic tokenization function
    - Write function to split input line into tokens respecting spaces
    - Handle maximum line length (2048 chars) and argument count (512) validation

    - Create unit tests for basic tokenization


    - _Requirements: 1.3, 1.4, 7.6, 7.7_

  - [ ] 2.2 Implement command structure parsing
    - Write parse_command() function to populate command_t structure
    - Handle I/O redirection operators (<, >) when surrounded by spaces


    - Detect background operator (&) when it's the last token
    - Create unit tests for command parsing with various scenarios
    - _Requirements: 1.6, 4.1, 4.2, 5.3, 7.6, 7.7_


  - [x] 2.3 Add comment and blank line handling


    - Implement logic to skip blank lines and lines starting with #

    - Create free_command() function for memory cleanup
    - Write tests for comment handling and memory management
    - _Requirements: 1.5, 1.6, 7.5_





- [ ] 3. Implement built-in command functionality
  - [ ] 3.1 Create built-in command identification
    - Write get_builtin_type() function to identify exit, cd, status commands
    - Create execute_builtin() function skeleton





    - Write unit tests for command identification
    - _Requirements: 2.1, 2.2, 2.3_

  - [x] 3.2 Implement cd command functionality


    - Code cd command with no arguments (HOME directory handling)
    - Code cd command with one argument (absolute/relative paths)
    - Add error handling for invalid directories
    - Write unit tests for cd command variations
    - _Requirements: 2.2, 2.3_



  - [ ] 3.3 Implement status and exit commands
    - Code status command to print last foreground command status
    - Code exit command with background process cleanup
    - Handle built-in commands with trailing & (ignore and run in foreground)
    - Write unit tests for status and exit functionality


    - _Requirements: 2.1, 2.4, 2.5, 2.6_

- [ ] 4. Implement I/O redirection system
  - [ ] 4.1 Create file redirection setup function
    - Write setup_io_redirection() function using dup2()


    - Handle input redirection from files with error checking
    - Handle output redirection to files with truncation/creation
    - Write unit tests for basic redirection functionality
    - _Requirements: 4.1, 4.2, 4.3, 4.4, 4.5_

  - [ ] 4.2 Add background process I/O handling
    - Implement /dev/null redirection for background processes without explicit redirection


    - Handle combined input and output redirection in same command
    - Add comprehensive error handling and status setting
    - Write unit tests for background I/O and combined redirection
    - _Requirements: 4.6, 4.7, 4.8_


- [ ] 5. Implement process management system
  - [ ] 5.1 Create external command execution framework
    - Write execute_external_command() function with fork() and exec()
    - Implement PATH-based command location using execvp()
    - Add error handling for fork() and exec() failures
    - Write unit tests for basic external command execution
    - _Requirements: 3.1, 3.2, 3.3, 3.4, 3.5_



  - [ ] 5.2 Implement foreground process handling
    - Add waitpid() logic for foreground processes
    - Implement status collection and updating
    - Handle process termination by signals with appropriate messages
    - Write unit tests for foreground process management


    - _Requirements: 5.1, 5.2, 6.4_

  - [ ] 5.3 Implement background process management
    - Add background process tracking in global array
    - Implement background process startup with PID printing
    - Create check_background_processes() function with WNOHANG


    - Add completion message printing for finished background processes
    - Write unit tests for background process lifecycle
    - _Requirements: 5.3, 5.4, 5.5, 5.6, 5.7, 5.8_

- [ ] 6. Implement signal handling system



  - [ ] 6.1 Set up basic signal handlers
    - Create setup_signal_handlers() function
    - Implement SIGINT ignoring for parent shell and background children
    - Set default SIGINT behavior for foreground children
    - Write unit tests for SIGINT handling behavior
    - _Requirements: 6.1, 6.2, 6.3_

  - [ ] 6.2 Implement SIGTSTP handling and foreground-only mode
    - Write sigtstp_handler() function to toggle foreground-only mode
    - Add mode change message printing
    - Implement foreground-only mode logic in command execution
    - Ensure all children ignore SIGTSTP
    - Write unit tests for SIGTSTP handling and mode toggling
    - _Requirements: 6.5, 6.6, 6.7, 6.8, 6.9_

- [ ] 7. Integrate main shell loop
  - [ ] 7.1 Create main command processing loop
    - Implement main loop with prompt display and fflush(stdout)
    - Integrate command parsing, built-in detection, and execution
    - Add background process checking before each prompt
    - Write integration tests for basic shell operation
    - _Requirements: 1.1, 1.2, 5.6_

  - [ ] 7.2 Add comprehensive error handling and cleanup
    - Integrate error handling across all components
    - Ensure proper memory cleanup in all execution paths
    - Add graceful shutdown with background process cleanup
    - Write integration tests for error scenarios and cleanup
    - _Requirements: 7.4, 7.5_

- [ ] 8. Final testing and validation
  - [ ] 8.1 Create comprehensive test suite
    - Write end-to-end tests covering all requirements
    - Test edge cases: maximum arguments, line length, complex commands
    - Test signal handling during various shell states
    - Validate memory management with valgrind
    - _Requirements: All requirements validation_

  - [ ] 8.2 Verify compilation and submission requirements
    - Test compilation with "gcc --std=gnu99 -o smallsh *.c"
    - Verify code follows modular design principles
    - Ensure robust error handling throughout
    - Prepare final code organization for submission
    - _Requirements: 7.1, 7.2, 7.3, 7.4_
.data
    prompt:     .asciiz "Enter a string: "         # The prompt message
    inputBuffer: .space 100                        # Buffer to store the user input (100 bytes)

.text
    .globl main

main:
    # Print the prompt message
    li $v0, 4                  # Load syscall code for printing string (4)
    la $a0, prompt             # Load prompt message into $a0
    syscall                    # Make the syscall to print the prompt

    # Read the user's input
    li $v0, 8                  # Load syscall code for reading string (8)
    la $a0, inputBuffer        # Load address of inputBuffer into $a0
    li $a1, 40                 # Specify that I only want to read 40 characters
    syscall                    # Make the syscall to read the input

    # Print the user's input
    li $v0, 4                  # Load syscall code for printing string (4)
    la $a0, inputBuffer        # Load address of input buffer into $a0
    syscall                    # Make the syscall to print the user's input

    # Exit the program
    li $v0, 10                 # Load syscall code for program exit (10)
    syscall                    # Make the syscall to exit

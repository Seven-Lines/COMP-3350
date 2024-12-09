    .data
buffer:  .space  100                       # Create space for 100 chars 
prompt:  .asciiz "Enter a string of size less than 100 characters:\n"
result:  .asciiz "\nWord count: "

    .text
    .globl main

main:
    # Print prompt
    li $v0, 4                              # Syscall 4: Print string
    la $a0, prompt
    syscall

    # Read user input
    li $v0, 8                              # Syscall 8: Read string
    la $a0, buffer                         # Load buffer address
    li $a1, 100                            # Set buffer size
    syscall

    # Initialize word count and buffer pointer
    la $t0, buffer                         # Load buffer address into $t0
    li $t1, 0                              # Word count initialized to 0
    li $t2, 0                              # Inside-word flag initialized to 0

count_loop:
    lb $t3, 0($t0)                         # Load byte from buffer into $t3
    beq $t3, $zero, end_loop               # If null terminator, end loop

    # Check if alphabetic (a-z or A-Z)
    blt $t3, 65, non_alpha                 # If char < 'A', not alphabetic
    bgt $t3, 122, non_alpha                # If char > 'z', not alphabetic
    blt $t3, 91, is_alpha                  # If between 'A' and 'Z', it's alphabetic
    blt $t3, 97, non_alpha                 # If between 'Z' and 'a', not alphabetic
    bgt $t3, 122, non_alpha                # If char > 'z', not alphabetic

is_alpha:
    beq $t2, 1, next_char                  # If already inside a word, skip
    li $t2, 1                              # Set inside-word flag
    addi $t1, $t1, 1                       # Increment word count
    j next_char

non_alpha:
    li $t2, 0                              # Set inside-word flag to 0

next_char:
    addi $t0, $t0, 1                       # Move to the next character
    j count_loop                           # Repeat loop

end_loop:
    # Print word count
    li $v0, 4                              # Syscall 4: Print string
    la $a0, result
    syscall

    li $v0, 1                              # Syscall 1: Print integer
    move $a0, $t1                          # Move word count to $a0
    syscall

    # Exit program
    li $v0, 10                             # Syscall 10: Exit
    syscall

.data
prompt:    .asciiz "Enter an integer greater than zero: "
newline:   .asciiz "\n"

.text
.globl main

main:
    # Print the prompt message
    li $v0, 4              # syscall for printing a string
    la $a0, prompt          # load the address of the prompt string
    syscall

    # Read the integer input (N)
    li $v0, 5              # syscall for reading an integer
    syscall
    move $a0, $v0          # move the input integer N into $a0

    # Call the Fibonacci function with N
    jal Fib                # jump to the Fibonacci function
    # Result will be in $v0

    # Print the result (Fibonacci number)
    move $a0, $v0          # move the result into $a0 for printing
    li $v0, 1              # syscall for printing an integer
    syscall

    # Print a newline (optional for formatting)
    li $v0, 4              # syscall for printing a string
    la $a0, newline        # load newline string
    syscall

    # Exit the program
    li $v0, 10             # syscall to exit
    syscall

# Fibonacci function: Fib(N)
# Input: $a0 (N)
# Output: $v0 (Fib(N))
Fib:
    addi $sp, $sp, -12     # allocate space on stack for 3 items
    sw $ra, 8($sp)         # save return address
    sw $a0, 4($sp)         # save N
    sw $t1, 0($sp)         # save $t1 (temporary register)

    # Base case: if N == 0, return 0
    li $t0, 0              # load 0 into $t0
    beq $a0, $t0, Fib_base_case_0  # if N == 0, jump to return 0

    # Base case: if N == 1, return 1
    li $t0, 1              # load 1 into $t0
    beq $a0, $t0, Fib_base_case_1  # if N == 1, jump to return 1

    # Call Fib(N-1)
    addi $a0, $a0, -1      # N = N - 1
    jal Fib                # recursive call Fib(N-1)
    move $t1, $v0          # store Fib(N-1) result in $t1

    # Restore the original N from the stack
    lw $a0, 4($sp)         # restore original N

    # Call Fib(N-2)
    addi $a0, $a0, -2      # N = N - 2
    jal Fib                # recursive call Fib(N-2)

    # Add the results of Fib(N-1) and Fib(N-2)
    add $v0, $v0, $t1      # v0 = Fib(N-1) + Fib(N-2)

    j Fib_end              # jump to the end of function

Fib_base_case_0:
    li $v0, 0              # return 0 for Fib(0)
    j Fib_end

Fib_base_case_1:
    li $v0, 1              # return 1 for Fib(1)

Fib_end:
    lw $t1, 0($sp)         # restore $t1 (temporary register)
    lw $a0, 4($sp)         # restore N
    lw $ra, 8($sp)         # restore return address
    addi $sp, $sp, 12      # deallocate space on the stack
    jr $ra                 # return to the caller

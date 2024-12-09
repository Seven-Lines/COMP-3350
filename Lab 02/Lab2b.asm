.data
    Z: .word 0             # Reserve memory for storing Z

.text
    .globl main

main:
    # Load constants into registers
    li $t0, 15              # A = 15, stored in $t0
    li $t1, 10              # B = 10, stored in $t1
    li $t2, 7               # C = 7, stored in $t2
    li $t3, 2               # D = 2, stored in $t3
    li $t4, 18              # E = 18, stored in $t4
    li $t5, -3              # F = -3, stored in $t5

    # Z = (A + B) + (C - D) + (E + F) - (A - C)
    add $t6, $t0, $t1       # $t6 = A + B (15 + 10 = 25)
    sub $t7, $t2, $t3       # $t7 = C - D (7 - 2 = 5)
    add $t8, $t4, $t5       # $t8 = E + F (18 + -3 = 15)
    sub $t9, $t0, $t2       # $t9 = A - C (15 - 7 = 8)
    
    add $t6, $t6, $t7       # $t6 = (A + B) + (C - D) (25 + 5 = 30)
    add $t6, $t6, $t8       # $t6 = (A + B) + (C - D) + (E + F) (30 + 15 = 45)
    sub $t6, $t6, $t9       # $t6 = Final Z (45 - 8 = 37)

    # Store the final value of Z in memory
    sw $t6, Z               # Store $t6 (Z = 37) into memory location Z

    # End the program
    li $v0, 10              # Syscall to exit the program
    syscall

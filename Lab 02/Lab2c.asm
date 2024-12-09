.data
A:      .word 10       # Variable A initialized to 10
B:      .word 15       # Variable B initialized to 15
C:      .word 6        # Variable C initialized to 6
Z:      .word 0        # Variable Z initialized to 0

.text
.globl main

main:
    # Load A, B, C, and Z from memory into registers
    lw $t0, A           # $t0 = A (10)
    lw $t1, B           # $t1 = B (15)
    lw $t2, C           # $t2 = C (6)
    lw $t3, Z           # $t3 = Z (0)

    # Check (A > B) || (C < 5)
    bgt $t0, $t1, set_z1  # If A > B, go to set_z1
    blt $t2, 5, set_z1    # If C < 5, go to set_z1
    
    # Check (A > B) && ((C + 1) == 7)
    ble $t0, $t1, set_z3         # If A <= B, skip
    addi $t4, $t2, 1             # $t4 = C + 1
    li $t5, 7                    # $t5 = 7
    beq $t4, $t5, set_z2         # If (C + 1) == 7, go to set_z2
    
    # Else (other two checks failed) 
    j set_z3                     # Jump to set Z = 3

set_z1:
    li $t3, 1                    # Z = 1
    j switch_part                # Jump to switch

set_z2: 
    li $t3, 2                    # Z = 2
    j switch_part                # Jump to switch
    
set_z3:
    li $t3, 3                    # Z = 3
    j switch_part                # Jump to switch   

#### SWITCH PART ####
switch_part:
    # Check Z value
    li $t6, 1                    # Case 1: Z == 1
    beq $t3, $t6, case_1          # If Z == 1, jump to case 1

    li $t6, 2                    # Case 2: Z == 2
    beq $t3, $t6, case_2          # If Z == 2, jump to case 2

    j default_case               # Otherwise, go to default case

case_1:
    li $t3, -1                   # Z = -1 for case 1
    j end_program                # Break

case_2:
    li $t3, -2                   # Z = -2 for case 2
    j end_program                # Break

default_case:
    li $t3, 0                    # Z = 0 for default case
    j end_program                # Break

end_program:
    # Store Z back in memory
    sw $t3, Z                    # Store Z in memory

    # Exit program
    li $v0, 10                   # Syscall to exit
    syscall

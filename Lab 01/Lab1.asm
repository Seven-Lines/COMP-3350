.data
	A: .word 7, 42, 0, 27, 16, 8, 4, 15, 31, 45 # Store given array in variable 'A' 
	n: .word 3 # Store integer 3 in variable 'n'
	m: .word 6 # Store integer 6 in variable 'm'
.text
.globl main
main:
	# Load variables 
	la $a0, A        # Load address of array A into $a0
	lw $a1, n        # Load word n
	lw $a2, m        # Load word m 
	
	# Determine A[n] and store the value
	sll  $t0, $a1, 2 # Multiply n by 4 to get byte offset for A[n]
	add  $t0, $a0, $t0 # Add base address of A to offset, resulting in address of A[n]
	lw   $t2, 0($t0)  # Load the value at A[n] into $t2

	# Determine A[m]
	sll  $t1, $a2, 2  # Multiply m by 4 to get byte offset for A[m]
	add  $t1, $a0, $t1 # Add base address of A to offset, resulting in address of A[m]
	lw   $t3, 0($t1)  # Load the value at A[m] into $t3
	
	# Swap the values
	sw   $t2, 0($t1)  # Store A[n]'s value into the memory location of A[m]
	sw   $t3, 0($t0)  # Store A[m]'s value into the memory location of A[n]
	
	# Return
	jr   $ra          # Return to caller (end of the program)

# ============ factorial =============
.data
STR_1:	.asciiz "Please enter a number to calculate factorial "
STR_2:	.asciiz "The factorial is "
NL:		.asciiz ".\n"

.text
.globl main
#---------------main function-----------------
main:	addi	$s0, $zero, 1	# $s0 = factorial = 1
    	addi	$s1, $zero, 1	# $s1 = count = 1

	li	$v0, 4		# system call for print_str
	la	$a0, STR_1	# address of string to print
	syscall			# print the string

	li	$v0, 5		# system call for read_int
	syscall			# read the integer

loop:
        addi $s1, $s1, 1        # count++

	mul $s0, $s0, $s1       # $s0 = $s0 * $s1

        sub $t0, $s1, $v0       # $t0 = count - in_num
	beq	$t0, $zero, exit    # if $t0 == 0, go to exit

	j	loop		# goto loop


exit:	li	$v0, 4		# system call code for print_str
	la	$a0, STR_2	# address of string to print
	syscall			# print the string

	li	$v0, 1		# system call code for print_int
	add	$a0, $s0, $zero	# integer to print, factorial
	syscall			# print the integer

	li	$v0, 4		# system call code for print_str
	la	$a0, NL		# address of string to print
	syscall			# print the string

	jr	$ra			# exit program

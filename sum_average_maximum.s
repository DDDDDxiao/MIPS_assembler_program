# ============ calculate sum, average and maximum =============
.data
STR_1:	.asciiz "Enter a number (0 to exit): "
STR_2:	.asciiz "Total sum at this point is "
STR_3:	.asciiz "Average at this point is "
STR_4:	.asciiz "Maximum at this point is "
STR_5:	.asciiz "numbers in total  "
NL:	    .asciiz ".\n"

.text
.globl main
#---------------main function-----------------
main:   addi $s0, $zero, 0      # $s0 = sum = 0
        addi $s1, $zero, 0      # $s1 = count = 0
        addi $s2, $zero, 0      # $s2 = average = 0
        addi $s3, $zero, 0      # $s3 = max = 0
        addi $s4, $zero, 0      # $s4 = base address of arry[] = 0

loop:   li	$v0, 4		# system call for print_str
	la	$a0, STR_1	# address of string to print
	syscall			# print the string

	li	$v0, 5		# system call for read_int
	syscall			# read the integer

	beq	$v0, $zero, exit    # Check if in_num($v0) == 0, if true goto exit

        addi $s1, $s1, 1;       # count = count + 1

        add $s0, $s0, $v0       # sum = sum + in_num

        div $s0, $s1            # sum / count

        mflo $s2   # move value in HI to $s2 (quotient)
        # mfhi $t7   # move value in LO to $t7 (remainder)

        sub $t0, $s3, $v0       # $t0 = max - in_num
        slti $t1, $t0, 0        # if($t0 < 0) $t1 = 1, else $t1 = 0
        bne $t1, $zero, label   # if($t1 != $zero) go to label
        j loop

label:  add $s3, $v0, $zero     # max = in_num
		j loop
        

exit:	# ------- output sum ------------
        li	$v0, 4		# system call code for print_str
		la	$a0, STR_2	# address of string to print
		syscall			# print the string

		li	$v0, 1		    # system call code for print_int
		add	$a0, $s0, $zero	# integer to print, sum
		syscall			    # print the integer

		li	$v0, 4		# system call code for print_str
		la	$a0, NL		# address of string to print
		syscall			# print the string

        # ------- output average ------------
        li	$v0, 4		# system call code for print_str
		la	$a0, STR_3	# address of string to print
		syscall			# print the string

		li	$v0, 1		    # system call code for print_int
		add	$a0, $s2, $zero	# integer to print, average
		syscall			    # print the integer

		li	$v0, 4		# system call code for print_str
		la	$a0, NL		# address of string to print
		syscall			# print the string

        # ------- output maximum ------------
        li	$v0, 4		# system call code for print_str
		la	$a0, STR_4	# address of string to print
		syscall			# print the string

		li	$v0, 1		    # system call code for print_int
		add	$a0, $s3, $zero	# integer to print, max
		syscall			    # print the integer

		li	$v0, 4		# system call code for print_str
		la	$a0, NL		# address of string to print
		syscall			# print the string
        # -----------------------------------

		jr	$ra		# exit program

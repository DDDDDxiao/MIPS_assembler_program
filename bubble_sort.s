# ============ bubble sort =============
.data
STR_1:
    .asciiz "Input the array size:\n"
STR_2:
    .asciiz "Input the numbers to be sorted:\n"
STR_3:
    .asciiz "The array before sort:\n"
STR_4:
    .asciiz "The array after sort:\n"
STR_5:
    .asciiz"\n"

.text
.globl main

#---------------main function-----------------
main:
    la $a0, STR_1   # print STR_1
    li $v0, 4
    syscall

    li $v0, 5       # read data to register
    syscall

    move $s0, $v0   # save array.size to $s0

    la $a0, STR_2   # print STR_2
    li $v0, 4
    syscall

    #-- call read func.
    move $a0, $gp   # the base address is stored in $gp
    move $a1, $s0   # store array size to $a1
    jal read        # jump to read func. save the address of main func. to $ra

    #-- call print func. to print the array before sort
    la $a0, STR_3
    li $v0, 4
    syscall

    move $a0, $gp
    move $a1, $s0
    jal print

    la $a0, STR_5
    li $v0, 4
    syscall

    #-- call bubble sort func.
    move $a0, $gp
    move $a1, $s0
    jal sort

    #-- call print func. to print the array after sort
    la $a0, STR_4
    li $v0, 4
    syscall

    move $a0, $gp
    move $a1, $s0
    jal print

#---------------read function-----------------
read:
    addi $sp, $sp, -4   # create a space in stack
    sw $s0, 0($sp)      # push the array size ($s0) to stack 0($sp)
    li $s0, 0           # assign $s0 = 0, use $s0 as a counter for read steps

    read_loop:
        sltu $t0, $s0, $a1          # if($s0 < $a1) $t0 = 1, else $t0 = 0
        beq $t0, $zero, exit_read   # if($t0 = 0) jump to exit_read (enough numbers are read)
        sll $t0, $s0, 2             # left shift 2 bits of $s0 ($t0 = 4*$s0)
        add $t1, $a0, $t0           # new addr = base addr + offset
        
        li $v0, 5       # read a number
        syscall

        sw $v0, 0($t1)  # store the input number to register

        addi $s0, $s0, 1    # $s0 ++
        j read_loop
    
    exit_read:
        lw $s0, 0($sp)      # pop the array size 0($sp) to register ($s0)
        addi $sp, $sp, 4    # free stack space
        jr $ra              # return to main func.

#---------------sort function-----------------
sort:
    addi $sp, $sp, -20      # create 5 spaces in stack
    sw $ra, 16($sp)         # push return address to stack
    sw $s3, 12($sp)         # push array size to stack
    sw $s2, 8($sp)          # push base address of array to stack
    sw $s1, 4($sp)          # push j to stack
    sw $s0, 0($sp)          # push i to stack

    move $s2, $a0           # base address of array
    move $s3, $a1           # array size
    move $s0, $zero         # assign counter(i) to 0

    loop_out:
        slt $t0, $s0, $s3   # if($s0 < $s3), that is (i < array.size), $t0 = 1
        beq $t0, $zero, exit_out    # if ($t0 = 0), jump to exit_out
        addi $s1, $s0, -1   # j = i - 1

    loop_in:
        slti $t0, $s1, 0    # if($s1 < 0) $t0 = 1
        bne $t0, $zero, exit_in     # if ($t0 != 0), jump to exit_in
                            # that is, as long as $s1(j) >= 0, skip bne instruction and keep going
        sll $t1, $s1, 2     # left shift 2 bits of $s1 ($s1*4)
        add $t2, $s2, $t1   # new address = base address($s2) + offset($t1)
        lw $t3, 0($t2)      # $t3 = array[j]
        lw $t4, 4($t2)      # $t4 = array[j+1]

        slt $t0, $t4, $t3   # if(array[j] > array[j+1]), $t0 = 1
        beq $t0, $zero, exit_in     # if ($t0 = 0), jump to exit_in

        move $a0, $s2       # pass the base address of array to swap func.
        move $a1, $s1       # pass j to swap func.
        jal swap

        addi $s1, $s1, -1   # j --
        j loop_in

    exit_in:
        addi $s0, $s0, 1    # i ++
        j loop_out
    
    exit_out:
        lw $s0, 0($sp)
        lw $s1, 4($sp)
        lw $s2, 8($sp)
        lw $s3, 12($sp)
        lw $ra, 16($sp)
        addi $sp, $sp, 20
        jr $ra

    swap:
        sll $t0, $a1, 2     # left shift 2 bits of $a1 (4*j)
        add $t0, $a0, $t0   # new addr. = base addr. + offset
        lw $t1, 0($t0)      # $t1 = array[j]
        lw $t2, 4($t0)      # $t2 = array[j+1]
        sw $t1, 4($t0)      # store array[j+1] to the memory addr. of array[j]
        sw $t2, 0($t0)      # store array[j] to the memory addr. of array[j+1]
        jr $ra

#---------------print function-----------------
print:
    addi $sp, $sp, -4   # create a space in stack
    sw $s0, 0($sp)      # push the array size ($s0) to stack 0($sp)
    li $s0, 0           # assign $s0 = 0, use $s0 as a counter for read steps

    print_loop:
        sltu $t0, $s0, $a1
        beq $t0, $zero, exit_print
        sll $t0, $s0, 2             # left shift 2 bits of $s0 ($t0 = 4*$s0)
        add $t1, $a0, $t0           # new addr = base addr + offset
        move $t2, $a0               # temporarily store value of $a0 (base addr)

        lw $a0, 0($t1)              # load world from memory to register ($a0)
        li $v0, 1                   # print integer to screen
        syscall

        li $a0, ','
        li $v0, 11                  # print character to screen
        syscall

        move $a0, $t2               # return value of $a0
        addi $s0, $s0, 1            # $s0 ++
        j print_loop

    exit_print:
        lw $s0, 0($sp)
        addi $sp, $sp, 4
        jr $ra


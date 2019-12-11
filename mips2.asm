            .data
msg_s:      .asciiz "\r\nSuccess! Location: "
msg_f:      .asciiz "\r\nFail!\r\n"
s_end:      .asciiz "\r\n"
buf:        .space 100

            .text
            .globl main
main:       la $a0, buf # address of input buffer
            la $a1, 100 # maximum number of characters to read
            li $v0, 8 # read string
            syscall

inputchar:  li $v0, 12 # read character
            syscall
            
            # if '?'
            addi $t7, $0, 63
            sub $t6, $t7, $v0
            beq $t6, $0, exit
            
            li $t0, 0 # t0=0
            la $s1, buf

find_loop:  lb $s0, 0($s1) # move s1 to s0
            sub $t1, $v0, $s0
            beq $t1, $0, success
            addi $t0, $t0, 1  # t0++
            slt $t3, $t0, $a1 # t0>=100 fail
            beq $t3, $0, fail
            addi $s1 $s1, 1
            j find_loop

success:    la $a0, msg_s
            li $v0, 4 # print string
            syscall
            addi $a0, $t0, 1
            li $v0, 1 # print integer
            syscall
            la $a0, s_end
            li $v0, 4
            syscall
            j inputchar

fail:       la $a0, msg_f
            li $v0, 4
            syscall
            j inputchar

exit:       li $v0, 10
            syscall
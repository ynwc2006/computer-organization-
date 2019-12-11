            .data
u_word:	    .asciiz
            "Alpha ","Bravo ","China ","Delta ","Echo ","Foxtrot ",
	    "Golf ","Hotel ","India ","Juliet ","Kilo ","Lima ",
            "Mary ","November ","Oscar ","Paper ","Quebec ","Research ",
            "Sierra ","Tango ","Uniform ","Victor ","Whisky ","X-ray ",
            "Yankee ","Zulu "
uw_offset:  .word
            0,7,14,21,28,34,43,49,56,63,71,
            77,83,89,99,106,113,121,131,
            139,146,155,163,171,178,186
l_word:     .asciiz
            "alpha ","bravo ","china ","delta ","echo ","foxtrot ",
            "golf ","hotel ","india ","juliet ","kilo ","lima ",
            "mary ","november ","oscar ","paper ","quebec ","research ",
            "sierra ","tango ","uniform ","victor ","whisky ","x-ray ",
            "yankee ","zulu "
lw_offset:  .word
            0,7,14,21,28,34,43,49,56,63,71,
            77,83,89,99,106,113,121,131,
            139,146,155,163,171,178,186
number:     .asciiz
            "zero ", "First ", "Second ", "Third ", "Fourth ",
            "Fifth ", "Sixth ", "Seventh ","Eighth ","Ninth "
n_offset:   .word
            0,6,13,21,28,36,43,50,59,67
 
            .text
            .globl main
main:       # wrap
            addi $a0, $0, 0xA
	    addi $v0, $0, 0xB
            syscall

	    li $v0, 12 # read character
            syscall

            # is  '?'
            sub $t1, $v0, 63 # $v0 - 63 == 0
            beqz $t1, exit
            
            # others
            sub $t1, $v0, 48 # $v0 - 48 < 0
            slt $s0, $t1, $0
            bnez $s0, others
 
            # is number?
            sub $t2, $t1, 10 # $v0 - 48 -10 < 0    0~9
            slt $s1, $t2, $0
            bnez $s1, getnum
 
            # is capital?
            sub $t2, $v0, 91 # 64 < $v0 < 91      A~Z
            slt $s3, $t2, $0
            sub $t3, $v0, 64 
            sgt $s4, $t3, $0
            and $s0, $s3, $s4
            bnez $s0, getuword
 
            # is lower case?
            sub $t2, $v0, 123 # 96 < $v0 < 123      a~z
            slt $s3, $t2, $0
            sub $t3, $v0, 96 
            sgt $s4, $t3, $0
            and $s0, $s3, $s4
            bnez $s0, getlword
            
            # others
            j others
 
getnum:     add $t2, $t2, 10
            sll $t2, $t2, 2
            la $s0, n_offset
            add $s0, $s0, $t2
            lw $s1, ($s0)
            la $a0, number
            add $a0, $a0, $s1
            li $v0, 4
            syscall
            j main
 
            # upper case word
getuword:   sub $t3, $t3, 1
            sll $t3, $t3, 2
            la $s0, uw_offset
            add $s0, $s0, $t3
            lw $s1, ($s0)
            la $a0, u_word
            add $a0, $s1, $a0
            li $v0, 4
            syscall
            j main
 
            # lower case word
getlword:   sub $t3, $t3, 1
            sll $t3, $t3, 2
            la $s0, lw_offset
            add $s0, $s0, $t3
            lw $s1, ($s0)
            la $a0, l_word
            add $a0, $s1, $a0
            li $v0, 4
            syscall
            j main
 
others:     and $a0, $0, $0
            add $a0, $a0, 42 # '*'
            li $v0, 11 # print character
            syscall
            j main
            
exit:       li $v0, 10 # exit
            syscall

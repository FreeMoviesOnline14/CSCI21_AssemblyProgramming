#
#
# Filename: q5.asm
# Date created: 11/29/2021
#
# Author(s): Marcellus Von Sacramento 
#
# Purpose: The program will take 3 digits through MM I/O and make a real decimal value 
#		   out of it. The program will also output the result.
#
# Copyright(c)
#
#
# Last date modified: 12/12/2021
#
#

    .text
    .globl main

main:                       # start of text segment
    li      $t1, 0          # counter for the digit place

    lui     $t0, 0xffff     # 0xFFFF0000, base address of I/O

waitLoop:
    lw      $s0, 0($t0)     # load contents of receiver control register to $t1
    nop                     # delay
    andi    $s0, 0x0001     # extract the ready bit
    beqz    $s0, waitLoop   # check if ready bit is 1, reloop if not
    nop                     # delay

# extract the input from receiver data register
    lw      $s1, 4($t0)     # load contents of receiver data register
    nop                     # delay
    sll     $s1, $s1, 28         # shift left logical by 28 to get the lower 4 bits
    srl     $s1, $s1, 28         # shift right logical to get actual decimal digit

# check which digit place was read (i.e. 1st digit will be on the "hundreds" place, 2nd will be on the "tens" place, and so on)

    or      $a0, $s1, $s1   # copy contents of $s1 to $a0 for display
    li      $v0, 1          # service code for printing string
    syscall

exit:
    li      $v0, 10         # service code for returning control to OS
    syscall                 # return control to OS


# end of program
# end of file
#
#
# Filename: q5.asm
# Date created: 12/12/2021
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

    lui     $t0, 0xffff     # 0xFFFF0000, base address of I/O

waitLoop:
    lw      $s0, 0($t0)     # load contents of receiver control register to $t1
    nop                     # delay
    andi    $s0, 0x0001     # extract the ready bit
    beqz    $s0, waitLoop   # check if ready bit is 1, reloop if not
    nop                     # delay


# end of program
# end of file
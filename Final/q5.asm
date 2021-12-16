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
# Note: There's no need to check if user enterned a letter or any other character  
#       because the program will trim the lower 4 bits of the 8 bits from receiver data.
#
# For example: 'A' == 65 == 0100 0001 ---> after the shift manipulation we get 0001, the lower 4 bits.
#               Due to this, we will get a decimal of 1 instead of 65. This may be a bad design, but for
#               demonstration purposes I'll stick with this approach.
#
#
# service code for printing integer: 1
# service code for printing string : 4
# service code for returning control to OS: 10
#
# Registers used by the program:
# $s0 = holds extracted the lower 8 bit from receiver data register.
# $s1 = holds the total or the final output entered by the user.
# $t1 = holds the counter for determining the digit.
# $t3 = holds the address of the jump table for switch case implementation.
#
#
#
# Last date modified: 12/16/2021
#
#

        .data
        .align 2
jTable: .word   hundredsPlace, tensPlace, onesPlace  # jumptable
header: .asciiz "This program will prompt user to enter three digits, and then displays it in the order it was entered (i.e. 1..2..3 ---> 123)...\n\n"
msg:    .asciiz "\n\nInput is: "                     # message for final input
exMsg:  .asciiz "\nExiting program...\n"             # exit message
prompt: .asciiz "\nPress 0 to 9 key only..."         # prompt for user

        .text
        .globl main

main:                       # start of text segment
    la      $a0, header     # load address of the header of the program to be displayed
    li      $v0, 4          # service code for printing string
    syscall
    li      $s3, 0          # holds the final decimal input
    li      $t1, 0          # counter for the digit place
    la      $t3, jTable     # load address of the jumptable
    lui     $t0, 0xffff     # 0xFFFF0000, base address of I/O

promptUser:
    la      $a0, prompt     # load address of prompt to be displayed
    li      $v0, 4          # service code for printing string
    syscall     


waitLoop:
    lw      $s0, 0($t0)     # load contents of receiver control register to $t1
    nop                     # delay
    andi    $s0, 0x0001     # extract the ready bit
    beqz    $s0, waitLoop   # check if ready bit is 1, reloop if not
    nop                     # delay

# extract the input from receiver data register
    lw      $s1, 4($t0)     # load contents of receiver data register
    nop                     # delay
    sll     $s1, $s1, 28    # shift left logical by 28 to get the lower 4 bits
    srl     $s1, $s1, 28    # shift right logical to get actual decimal digit

# check which digit place was read 
# (i.e. 1st digit will be on the "hundreds" place, 2nd will be on the "tens" place, and so on)
# each will be on their respective cases

# switch case($s2)
    sll     $s0, $t1, 2     # calculate offset from base address of jumptable
    addu    $s0, $s0, $t3   # calculate jump address
    lw      $s2, 0($s0)     # load the address contained in $s0
    nop                     # delay
    jr      $s2             # jump to address contained in $s0
    addi    $t1, 1          # increment counter for the next offset  

# case 1:
hundredsPlace:
    li      $s0, 100        # $s0 = 100
    mult    $s1, $s0        # calculate the "hundreds" place by multiplying input by 100
    mflo    $s1             # get result from lo register
    j       promptUser      # jump back to waitloop to get next input
    addu    $s3, $s3, $s1   # add result to $s3

# case 2:
tensPlace:
    li      $s0, 10         # $s0 = 10
    mult    $s1, $s0        # calculate the "hundreds" place by multiplying input by 100
    mflo    $s1             # get result from lo register
    j       promptUser      # jump back to waitloop to get next input
    addu    $s3, $s3, $s1   # add result to $s3

# case 3:
onesPlace:
    addu    $s3, $s3, $s1   # add last input digit to calculate final result

display:
    la      $a0, msg        # load address of the message to be displayed
    li      $v0, 4          # service code for printing string
    syscall
    or      $a0, $s3, $s3   # copy contents of $s1 to $a0 for display
    li      $v0, 1          # service code for printing integer
    syscall

exit:
    la      $a0, exMsg      # load address of the message to be displayed
    li      $v0, 4          # service code for printing string
    syscall
    li      $v0, 10         # service code for returning control to OS
    syscall                 # return control to OS


# end of program
# end of file

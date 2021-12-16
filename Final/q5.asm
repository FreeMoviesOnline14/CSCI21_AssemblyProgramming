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
# service code for printing integer: 1
# service code for printing string : 4
# service code for returning control to OS: 10
#
# Note: There's no need to check if user enterned a letter or any other character  
#       because the program will trim the lower 4 bits of the 8 bits from receiver data.
#
# For example: 'A' == 65 == 0100 0001 ---> after the shift manipulation we get 0001, the lower 4 bits.
#               Due to this, we will get a decimal of 1 instead of 65. This may be a bad design, but for
#               demonstration purposes I'll stick with this approach.
#
#
#   Below is the list of questions that was asked in the final exam question #1:
#
#   What kind of register should we use for MMIO?
#       - Because the exam only asked for input, the registers we need to use for MMIO are the
#         "Receiver control" register and "Receiver data" register. For output, however, we need to use 
#         "Transmitter control" register and "Transmitter data" register.
#
#   What part of the registers did you use and why? What value did you set or get from the register?
#       - I'm assuming this question is asking about the parts of the "Receiver control" and "Receiver data" registers that was used.
#         If so, then for "Receiver control" register I used the ready bit located at 0 bit to signal if a key was pressed
#         by the user. Now, for "Receiver data" register I used the first lower 8 bits which contains the ASCII binary value
#         of the pressed key. And I used syscall to display the final output instead of using "Transmitter" registers for displaying
#         the result.
#
#   Show your abstractional expression to calculate the decimal value from the inputs.
#       - For this program, I used register $s1 to hold the 8 bits from "Receiver data" register. Then, I manipulate 
#         it to extract only the lower 4 bits of the 8 bits, so that even if the user entered any character
#         it will corresspond to numbers 1-9, depending on its lower 4 bits. Again, this may be a bad design, but
#         For demonstration purposes, I'll stick with this approach. A loop can be used to check if non-numeric character 
#         was pressed by the user. I used register $s3 to hold the sum of the manipulated $s1 for final output.
#
#
# Last date modified: 12/12/2021
#
#


        .data
        .align 2
jTable: .word   hundredsPlace, tensPlace, onesPlace  # jumptable
msg:    .asciiz "Input is: "                         # message for final input
exMsg:  .asciiz "\nExiting program...\n"             # exit message

        .text
        .globl main

main:                       # start of text segment
    li      $s3, 0          # holds the final decimal input
    li      $t1, 0          # counter for the digit place
    la      $t3, jTable     # load address of the jumptable
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
    j       waitLoop        # jump back to waitloop to get next input
    addu    $s3, $s3, $s1   # add result to $s3

# case 2:
tensPlace:
    li      $s0, 10         # $s0 = 10
    mult    $s1, $s0        # calculate the "hundreds" place by multiplying input by 100
    mflo    $s1             # get result from lo register
    j       waitLoop        # jump back to waitloop to get next input
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

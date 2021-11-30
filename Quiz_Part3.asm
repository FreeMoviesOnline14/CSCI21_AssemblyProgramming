#
#
# Filename: Quiz_Part3.asm
# Date created: 11/30/2021
#
# Author(s): Marcellus Von Sacramento
#
# Purpose: The purpose of this program is to take input from user for value of n.
#          Then evaluates the Newton's method formula: x = (x + (n/x)) / 2 
#		   or equivalent to x = (x + (n/x)) * 0.5
#
#
# Copyright(c)
#
# Last date modified: 11/30/2021
#
# 
# service code 4: printing string
# service code 6: reading float input
# service code 2: printing float value
#


        # data segment
        .data

# static variable
limit:  .float   0.00001

# prompt message
nVal:    .asciiz "Enter value for n: "
exitMsg: .asciiz "Exiting program..."
lineF:   .asciiz "\n"
CurrentApprox: .asciiz "Current approximation: "
FinalApprox: .asciiz "Final approximation: "

        # text segment
        .text
        .globl main

main:
# initialize registers to be used
    li.s    $f1, 1.0        # $f1 = 1.0
    li.s    $f2, 0.5        # $f2 = 0.5 == 1/2
    l.s     $f3, limit      # $f3 = limit, load from memory to float register
    nop                     # delay

# display prompt for value of n
    li      $v0, 4
    la      $a0, nVal
    syscall
    li      $v0, 6
    syscall

# while loop to simulate Newton's method
# $f4 becomes "newX"
newtsMethod:
    div.s       $f4, $f0, $f1   # $f4 = n/x
    add.s       $f4, $f1, $f4   # $f4 = x + (n/x)
    mul.s		$f12, $f4, $f2  # $f4 = (x + (n/x)) / 2 == (x + (n/x)) * 0.5    
								# $f12 = current approximation to be displayed

# display current approximation
    li      $v0, 4
    la      $a0, CurrentApprox
    syscall
    li      $v0, 2
    syscall
	li      $v0, 4
    la      $a0, lineF
    syscall

# check if we reach the limit
    sub.s   $f5, $f12, $f1  # $f5 = (newX - oldX)
    abs.s   $f5, $f5        # absolute value of |newX - oldX|

    c.le.s  $f5, $f3        # check if |newX - oldX| < limit
    bc1f newtsMethod       # branch back to newtsMethod loop, else exit
    mov.s   $f1, $f12       # oldX = newX, for next approximation
    
# exit
exit:
    li      $v0, 4
    la      $a0, exitMsg
    syscall
    li      $v0, 10
    syscall

# end of program
# end of file

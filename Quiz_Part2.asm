#
#
# Filename: Quiz_Part2.asm
# Date created: 11/29/2021
#
# Author(s): Marcellus Von Sacramento
#
# Purpose: The purpose of this program is to take input from user for values of x, a, b, c.
#          Then evaluates the expression ax^2 + bx + c
#
# Note: ax^2 + bx + c == x(ax + b) + c
#
# Copyright(c)
#
# Last date modified: 11/29/2021
#
# 

# service code 4: printing string
# service code 6: reading float input
# service code 2: printing float value

        # data segment
        .data

# prompt message
xVal:   .asciiz "Enter value for x: "
aVal:   .asciiz "\nEnter value for a: "
bVal:   .asciiz "\nEnter value for b: "
cVal:   .asciiz "\nEnter value for c: "
result: .asciiz "\nResult: "
exitMsg:.asciiz "\n\nExiting program..."

        # text segment
        .text
        .globl main

main:

# get value for x
        li      $v0, 4			# service code for printing string
        la      $a0, xVal       # prompt user for value of x
        syscall     
		li 		$v0, 6			# service code for reading floating value
		syscall
		mov.s	$f1, $f0		# $f1 = x

# get value for a	
        li      $v0, 4
        la      $a0, aVal       # prompt user for value of a
        syscall
		li 		$v0, 6			# service code for reading floating value
		syscall
		mov.s	$f2, $f0		# $f2 = a

# get value for b
        li      $v0, 4
        la      $a0, bVal       # prompt user for value of b
        syscall
		li 		$v0, 6			# service code for reading floating value
		syscall
		mov.s	$f3, $f0		# $f3 = b

# get value for c
        li      $v0, 4
        la      $a0, cVal       # prompt user for value of c
        syscall
		li 		$v0, 6			# service code for reading floating value
		syscall
		mov.s	$f4, $f0		# $f4 = c

# evaluate the expression ax^2 + bx + c, which is the same as x(ax + b) + c
		mul.s	$f2, $f1, $f2	# $f2 = ax
		add.s	$f2, $f2, $f3	# $f2 = ax + b
		mul.s	$f1, $f1, $f2	# $f1 = ax^2 + bx
		add.s	$f12, $f1, $f4	# $f1 = ax^2 + bx + c

# display result of evaluation
		li 	$v0, 4
		la  $a0, result
		syscall
		li	$v0, 2
		syscall

exit:
		li 	$v0, 4
		la  $a0, exitMsg
		syscall
		li 	$v0, 10
		syscall

# end of program
# end of file

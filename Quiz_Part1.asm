#
#
# Filename: FahrenheitToCelsius.asm
# Date created: 11/29/2021
#
# Author(s): Marcellus Von Sacramento
#
# Purpose: The purpose of this program is to take Fahrenheit temperature input from user and convert 
#		   it to Celsius
#
# Copyright(c)
#
#
# Last date modified: 11/29/2021
#
# Note: single precision will be used for this simple quiz demonstration

        
		# data segment
		.data
prompt: .asciiz "Enter temperature in Fahrenheit: "
h1:     .asciiz "You entered: "
h2:     .asciiz " Fahrenheit"
h3:     .asciiz "\n"
h4:     .asciiz "That is equivalent to "
h5:     .asciiz " Celsius"
exitMsg: .asciiz "Exiting program..."

        # text segment
        .text
        .globl main


main:
        jal     getInput        # call function to take input from user
        nop                     # delay
        or      $t0, $v0, $zero # store input integer to $t0

# display user input with message
        li      $v0, 4          # service code for printing string
        la      $a0, h1
        syscall
        li      $v0, 1          # service code for printing integer
        or      $a0, $t0, $zero
        syscall
        li      $v0, 4          # service code for printing string
        la      $a0, h2     
        syscall
        la      $a0, h3         # print "\n"
        syscall

        mtc1    $t0, $f0        # move integer input from general purpose register to float register
        cvt.s.w $f0, $f0        # convert integer to single precision

# convert input Farehnheit temperature to Celsius
convertFarenheitToCelsius:
        li.s    $f1, 32.0       # f1 = 32.0
        li.s    $f2, 5.0        # $f2 = 5.0
        li.s    $f3. 9.0        # $f3 = 9.0
        div.s   $f2, $f2, $f3   # $f2 = 5.0/9.0
        sub.s   $f0, $f0, $f1   # $f0 = $f0 - 32.0
        mul.s   $f12, $f0, $f2   # $f12 = ($f0 - 32.0) * (5.0/9.0)

# display result with message
        li      $v0, 4          # service code for printing string
        la      $a0, h4
        syscall
        li      $v0, 2          # service code for printing floating value
        syscall
        li      $v0, 4          # service code for printing string
        la      $a0, h5
        syscall

exit:
        li      $v0, 4          # service code for printing string
        la      $a0, h3         # print "\n"
        syscall
        la      $a0, exitMsg
        syscall
        li      $v0, 10         # service code for program termination
        syscall                 # perform syscall to terminate program
        

# function to get input from user
# returns an integer
getInput:

# display prompt
        li      $v0, 4          # service code for printing string
        la      $a0, prompt     # load address of the prompt to $a0 to be displayed
        syscall                 # perform syscall with code 4 to display prompt

# take input
        li      $v0, 5          # service code for reading integer input
        syscall                 # perform syscall with code 5 to read integer input
        jr      $ra             # return to caller
        nop                     # delay

# end of program
# end of file
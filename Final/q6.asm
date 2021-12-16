#
#
# Filename: q6.asm
# Date created: 12/15/2021
#
# Author(s): Marcellus Von Sacramento
#
# Purpose: The purpose of this program is to take the user character and print it in a console until 'q' is typed.
#		   When 'q' is type, program will terminate.
#
# Copyright(c)
#
#
# Last date modified: 12/15/2021
#
#

        .data
initMsg: .asciiz "Pressed any key... Press 'q' to Exit...\n\n"
extMsg: .asciiz "Exiting program...\n"

        .text
        .globl main

main:   # start of text segment

        la      $a0, initMsg
        li      $v0, 4  
        syscall 
# enable all interrupts for status register $12 and receiver control register
        li      $s0, 0xffff0000     # base address of I/O
        li      $s1, 2              # 0x000000002 to enable keyboard interrupt
        sw      $s1, 0($s0)         # store 0x000000002 to $s1 to enable interrupt bit of receiver control
        li      $s1, 0xfff1         # will be used to enable all exception in status register $12
        mtc0    $s1, $12

here:
        j       here    # stay here until q is pressed, kernel will handle that

        li      $v0, 10     # service code for returning control to OS
        syscall


        .kdata
        .align 2
save1:  .word 0
save2:  .word 0

entryMsg: .asciiz "Entered exception handler... Printing pressed key...\n"
out:      .asciiz "You pressed: "
        
        
        .ktext  0x80000180 

exceptionHandler:       # start of kernel text segment
        sw      $v0, save1      # save $v0 to save1
        sw      $a0, save2      # save $a0 to save2

# notify user that we are in exception handling phase
# for debugging purposes
        la      $a0, entryMsg   # load address of message to be displayed
        li      $v0, 4          # service code for printing string
        syscall

# extract exception code from cause register $13
        li      $k0, 113        # ASCII value of 'q'
        mfc0    $k1, $13        # load current value of $13 to $k1
        nop
        srl     $k1, $k1, 2     # shift left logical to extract exception code
        andi    $k1, $k1, 0x1f  # extract exception code
        bgtz    $k1, done       # we are only interested with interrupts from hardware
                                # if exception code is not 0 then we ignore the exception
        li      $a1, 0xffff0000 # load base address of I/O
        lw      $v1, 4($a1)     # extract input from receiver data register, that was placed here from main
        nop
        beq     $k0, $v1, qWasPressed   # if 'q' was pressed then we terminate the program
        nop
        la      $a0, out        # load address of output message
        li      $v0, 4          # service code for printing string
        syscall

        sw      $v1, 12($a1)     # display pressed key to console





qWasPressed:

        


done:


        



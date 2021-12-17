#
#
# Filename: q6.asm
# Date created: 12/15/2021
#
# Author(s): Marcellus Von Sacramento
#
# Purpose: The purpose of this program is to take the user character and print it in a console until 'q' is typed.
#          When 'q' is type, program will terminate.
#
# Copyright(c)
#
#
#
# service code for printing string : 4
# service code for returning control to OS: 10
#
# Registers used by the program:
#
# $s0 = holds base address of I/O in main.
# $s1 = holds the value extracted from status register $12 in main.
# $t0 = holds the ASCII value of 'q' in exception handling phase.
# $k1 = holds the value extracted from cause register $13. Also, used to manipulate EPC.
#
#
#
# Last date modified: 12/16/2021
#
#

                .data
initMsg:        .asciiz "Press any key... Press 'q' to Exit...\n\n"
extMsg:         .asciiz "\nExiting program...\n"
out:            .asciiz "\nYou pressed: "
twoLF:          .asciiz "\n\n"

                .text
                .globl main

main:   # start of text segment
        li      $t0, 113            # ASCII value of 'q'

# enable all interrupts for status register $12 and receiver control register
        li      $s0, 0xffff0000     # base address of I/O
        li      $s1, 2              # 0x000000002 to enable keyboard interrupt
        sw      $s1, 0($s0)         # store 0x000000002 to $s1 to enable interrupt bit of receiver control
        li      $s1, 0xfff1         # will be used to enable all exception in status register $12
        mtc0    $s1, $12

echoPrompt:
        la      $a0, initMsg        # load address of initial message to be printed
        li      $v0, 4              # service code for printing string
        syscall 

stayHere:
        j       stayHere             # stay here until q is pressed, kernel will handle that
        nop                          # delay

# display pressed key and check if 'q' was pressed
echoCheckKey:         
        lw      $s2, 4($s0)          # extract lower input from receiver data register
        la      $a0, out             # load address of output message
        li      $v0, 4               # service code for printing string
        syscall
        sw      $s2, 12($s0)         # echo pressed key to console
        beq     $t0, $s2, exit       # if 'q' was pressed then we terminate the program
        la      $a0, twoLF           # load address of new line, act as delay
        li      $v0, 4               # service code to print string
        syscall
        j       echoPrompt           # else, get next input
        nop                          # delay


exit:
        la      $a0, extMsg          # load address of exit message, act as delay
        li      $v0, 4          # service code for printing text
        syscall
        li      $v0, 10         # service code for returning control to OS
        syscall


###########################################################
#                                                         #
#                Exception Handler Code                   #
#                                                         #
###########################################################

                .kdata
                .align 2
save1:          .word 0
save2:          .word 0
entryMsg:       .asciiz "Entered exception handler... Printing pressed key...\n"
ignoreMsg:      .asciiz "Exception level greater than 0... Ignoring exception...\n"
       

                .ktext  0x80000180 # address of kerne text segment

exceptionHandler:       # start of kernel text segment
        sw      $v0, save1      # save $v0 to save1
        sw      $a0, save2      # save $a0 to save2
        nop

# notify user that we are in exception handling phase
# for debugging purposes
        la      $a0, entryMsg   # load address of message to be displayed
        li      $v0, 4          # service code for printing string
        syscall

# extract exception code from cause register $13
        mfc0    $k1, $13        # load current value of $13 to $k1
        nop
        srl     $k1, $k1, 2     # shift left logical to extract exception code
        andi    $k1, $k1, 0x1f  # extract exception code
        bgtz    $k1, ignore     # we are only interested with interrupts from hardware
                                # if exception code is not 0 then we ignore the exception
        nop                     # delay
        mfc0    $k1, $14        # load address where exception occurred
        addiu   $k1, 4          # add 4 to EPC because we are in branch/jump when returned to main
        mtc0    $k1, $14        # store next address of the instruction to execute when returned to when
        j       done            # jump to exit code segment of the handler
        nop                     # delay
        
# if exception level greater than 0, we ignore exception
# print message
ignore:
        la      $a0, ignore     # load address of ignore message
        li      $v0, 4          # service code for printing string
        syscall
        j       done            # jump to exit code segment of the handler
        nop

done:
# restore original status before exception handling phase
        lw      $v0, save1      # restore $v0 old value
        lw      $a0, save2      # restore $a0, old value
        mtc0    $zero, $13      # clear cause register $13
        mfc0    $k1, $12        # extract current value of status register $12
        andi    $k1, 0xfffd     # reset status register $12 to enable interrupts
        mtc0    $k1, $12        # store back to status register $12 
        eret                    # return control back to program


# end of program
# end of file
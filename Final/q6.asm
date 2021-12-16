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
extMsg: .asciiz "Exiting program...\n"

        .text
        .globl main

main:   # start of text segment

        li      $s0, 0xffff0000     # base address of I/O
        li      $s1, 2              # 0x000000002 to enable keyboard interrupt
        sw      $s1, 0($s0)         # store 0x000000002 to $s1 to enable interrupt bit of receiver control
        li      $s1, 0xffff         # will be used to enable all exception in status register $12





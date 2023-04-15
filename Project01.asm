.data
title: .asciiz "\n                   Number converter"


separator: .asciiz "\n----------------------------------------------------------"

prompt: .asciiz "\n1. Binary to hexadecimal and decimal\n2. Hexadecimal to binary and decimal\n3. Decimal to binary and hexadecimal\n4. Exit\n"
prompt_msg: .asciiz "\nEnter a value from the menu: "

binary_prompt: .asciiz "\nEnter a 16-bit binary number: "
decimal_prompt: .asciiz "\nEnter a decimal number between 0 and 65,535: "
hexadecimal_prompt: .asciiz "\n Enter a 4 digit hexadecimal number: 0x"

binary_msg: .asciiz "\nBinary number: "

decimal_msg: .asciiz "\nDecimal number: "

hexadecimal_msg: .asciiz "\nHexadecimal number: 0x"



invalid_msg: .asciiz "\nInvalid. Please try again"

input_hex: .space 4
empty: .asciiz " "
input_binary: .space 16
empty2: .asciiz " "
hex_result: .space 4
empty3: .asciiz " "
binary_result: .space 16

.text
main_loop:
    li      $v0,                                    4
    la      $a0,                                    title
    syscall 

    la      $a0,                                    separator
    syscall 

    la      $a0,                                    prompt
    syscall 

    la      $a0,                                    prompt_msg
    syscall 

    li      $v0,                                    5
    syscall 

    move    $s0,                                    $v0
    addi    $sp,                                    $sp,                    -4
    sw      $s0,                                    0($sp)

    li      $t0,                                    1
    beq     $v0,                                    $t0,                    binary

    li      $t0,                                    2
    beq     $v0,                                    $t0,                    hexadecimal

    li      $t0,                                    3
    beq     $v0,                                    $t0,                    decimal

    li      $t0,                                    4
    beq     $v0,                                    $t0,                    exit

    j       main_loop

binary:
    li      $v0,                                    4
    la      $a0,                                    separator
    syscall 

    li      $v0,                                    4
    la      $a0,                                    binary_prompt
    syscall 

    li      $v0,                                    8
    la      $a0,                                    input_binary
    li      $a1,                                    17
    syscall 

    move    $t0,                                    $a0

    li      $v0,                                    4
    la      $a0,                                    separator
    syscall 

    li      $v0,                                    11
    li      $a0,                                    '\n'
    syscall 

    move    $a0,                                    $t0
    jal     binaryToDecimal
    addi    $sp,                                    $sp,                    -4
    sw      $v0,                                    0($sp)

    move    $a0,                                    $v0
    jal     decimalToHex

    la      $a0,                                    input_binary
    la      $a2,                                    hex_result

    lw      $a1,                                    0($sp)
    addi    $sp,                                    $sp,                    4
    j       displayResults

hexadecimal:
    li      $v0,                                    4
    la      $a0,                                    separator
    syscall 

    li      $v0,                                    4
    la      $a0,                                    hexadecimal_prompt
    syscall 

    li      $v0,                                    8
    la      $a0,                                    input_hex
    li      $a1,                                    5
    syscall 

    move    $t0,                                    $a0

    li      $v0,                                    4
    la      $a0,                                    separator
    syscall 

    li      $v0,                                    11
    li      $a0,                                    '\n'
    syscall 

    move    $a0,                                    $t0
    jal     hexToDecimal
    addi    $sp,                                    $sp,                    -4
    sw      $v0,                                    0($sp)

    move    $a0,                                    $v0
    jal     decimalToBinary

    la      $a0,                                    binary_result
    la      $a2,                                    input_hex

    lw      $a1,                                    0($sp)
    addi    $sp,                                    $sp,                    4
    j       displayResults

decimal:
    li      $v0,                                    4
    la      $a0,                                    separator
    syscall 

    li      $v0,                                    4
    la      $a0,                                    decimal_prompt
    syscall 

    li      $v0,                                    5
    syscall 

    li      $t1,                                    65536
    slt     $t1,                                    $v0,                    $t1
    li      $t2,                                    -1
    slt     $t2,                                    $t2,                    $v0
    bne     $t2,                                    $t1,                    invalid

    addi    $sp,                                    $sp,                    -4
    sw      $v0,                                    0($sp)

    li      $v0,                                    4
    la      $a0,                                    separator
    syscall 

    li      $v0,                                    11
    li      $a0,                                    '\n'
    syscall 

    lw      $a0,                                    0($sp)
    jal     decimalToBinary
    lw      $a0,                                    0($sp)
    jal     decimalToHex

    la      $a0,                                    binary_result
    la      $a2,                                    hex_result

    lw      $a1,                                    0($sp)
    addi    $sp,                                    $sp,                    4
    j       displayResults

binaryToDecimal:                                                                                                                                # a0 = string address, $a1 = string length (17 exclusive), $v0 = return word
    addi    $a1,                                    $a1,                    -1                                                                  # $a1 = 16
    addi    $sp,                                    $sp,                    -8
    sw      $s0,                                    0($sp)
    sw      $s1,                                    4($sp)
    li      $s0,                                    0

binaryToDecimal_loop:
    beqz    $a1,                                    binaryToDecimal_exit
    lbu     $t0,                                    0($a0)
    li      $t1,                                    '2'
    li      $t2,                                    '/'

    addi    $a1,                                    $a1,                    -1
    slt     $t3,                                    $t0,                    $t1
    slt     $t4,                                    $t2,                    $t0
    bne     $t3,                                    $t4,                    invalid

    addi    $sp,                                    $sp,                    -12
    sw      $a0,                                    0($sp)
    sw      $a1,                                    4($sp)
    sw      $ra,                                    8($sp)
    li      $a0,                                    2

    jal     power

    lw      $a0,                                    0($sp)
    lw      $a1,                                    4($sp)
    lw      $ra,                                    8($sp)
    addi    $sp,                                    $sp,                    12

    li      $t1,                                    -48
    add     $t0,                                    $t0,                    $t1
    mult    $v0,                                    $t0
    mflo    $t0
    add     $s0,                                    $s0,                    $t0
    addi    $a0,                                    $a0,                    1

    j       binaryToDecimal_loop

binaryToDecimal_exit:
    move    $v0,                                    $s0
    lw      $s0,                                    0($sp)
    addi    $sp,                                    $sp,                    4
    jr      $ra

decimalToHex:                                                                                                                                   # $a0 = word [0, 65535], $v0 = return string of length 4
    la      $v0,                                    hex_result
    li      $t1,                                    0
    addi    $v0,                                    $v0,                    3

decimalToHex_loop:
    li      $t2,                                    4
    slt     $t2,                                    $t1,                    $t2
    beqz    $t2,                                    decimalToHex_exit

    li      $t2,                                    16
    div     $a0,                                    $t2
    mfhi    $t2
    mflo    $a0

    li      $t3,                                    10
    slt     $t3,                                    $t2,                    $t3
    beqz    $t3,                                    decimalToHex_Letter
    addi    $t2,                                    $t2,                    '0'
    sb      $t2,                                    0($v0)
    addi    $v0,                                    $v0,                    -1
    addi    $t1,                                    $t1,                    1
    j       decimalToHex_loop

decimalToHex_Letter:
    addi    $t2,                                    $t2,                    'A'
    addi    $t2,                                    $t2,                    -10
    sb      $t2,                                    0($v0)
    addi    $v0,                                    $v0,                    -1
    addi    $t1,                                    $t1,                    1
    j       decimalToHex_loop

decimalToHex_exit:
    jr      $ra

decimalToBinary:                                                                                                                                # $a0 = word [0, 65535], $v0 = return string of length 4
    la      $v0,                                    binary_result
    li      $t1,                                    0
    addi    $v0,                                    $v0,                    15

decimalToBinary_loop:
    li      $t2,                                    16
    slt     $t2,                                    $t1,                    $t2
    beqz    $t2,                                    decimalToBinary_exit

    li      $t2,                                    2
    div     $a0,                                    $t2
    mfhi    $t2
    mflo    $a0

    addi    $t2,                                    $t2,                    '0'
    sb      $t2,                                    0($v0)
    addi    $v0,                                    $v0,                    -1
    addi    $t1,                                    $t1,                    1
    j       decimalToBinary_loop

decimalToBinary_exit:
    jr      $ra

displayResults:                                                                                                                                 # a0 = binary number (str), $a1 = decimal, $a2, hex (str)
    move    $t0,                                    $a0

    li      $v0,                                    4
    la      $a0,                                    binary_msg
    syscall 

    move    $a0,                                    $t0
    syscall 

    la      $a0,                                    decimal_msg
    syscall 

    li      $v0,                                    1
    move    $a0,                                    $a1
    syscall 

    li      $v0,                                    4
    la      $a0,                                    hexadecimal_msg
    syscall 

    move    $a0,                                    $a2
    syscall 

    la      $a0,                                    separator
    syscall 

    li      $v0,                                    11
    li      $a0,                                    '\n'
    syscall 

    lw      $s0,                                    0($sp)
    addi    $sp,                                    $sp,                    4

    j       main_loop

hexToDecimal:                                                                                                                                   # a0 = string address, $a1 = string length (5 exclusive), $v0 = return word
    addi    $a1,                                    $a1,                    -1                                                                  # $a1 = 4
    addi    $sp,                                    $sp,                    -8
    sw      $s0,                                    0($sp)
    sw      $s1,                                    4($sp)
    li      $s0,                                    0

hexToDecimal_loop:
    beqz    $a1,                                    hexToDecimal_exit
    lbu     $t0,                                    0($a0)
    li      $t1,                                    ':'
    li      $t2,                                    '/'

    addi    $a1,                                    $a1,                    -1
    slt     $t3,                                    $t0,                    $t1
    slt     $t4,                                    $t2,                    $t0
    bne     $t3,                                    $t4,                    hexToDecimal_checkLetterUpperCase
    j       hextoDecimal_convertNumber

hexToDecimal_checkLetterUpperCase:
    li      $t1,                                    'G'
    li      $t2,                                    '@'

    slt     $t3,                                    $t0,                    $t1
    slt     $t4,                                    $t2,                    $t0
    bne     $t3,                                    $t4,                    hexToDecimal_checkLetterLowerCase
    j       hexToDecimal_convertLetterUpperCase

hexToDecimal_checkLetterLowerCase:
    li      $t1,                                    'g'
    li      $t2,                                    '`'

    slt     $t3,                                    $t0,                    $t1
    slt     $t4,                                    $t2,                    $t0
    bne     $t3,                                    $t4,                    invalid
    j       hexToDecimal_convertLowerCaseLetter

hextoDecimal_convertNumber:

    addi    $sp,                                    $sp,                    -12
    sw      $a0,                                    0($sp)
    sw      $a1,                                    4($sp)
    sw      $ra,                                    8($sp)
    li      $a0,                                    16

    jal     power

    lw      $a0,                                    0($sp)
    lw      $a1,                                    4($sp)
    lw      $ra,                                    8($sp)
    addi    $sp,                                    $sp,                    12

    li      $t1,                                    -48
    add     $t0,                                    $t0,                    $t1
    mult    $v0,                                    $t0
    mflo    $t0
    add     $s0,                                    $s0,                    $t0
    addi    $a0,                                    $a0,                    1

    j       hexToDecimal_loop

hexToDecimal_convertLetterUpperCase:
    addi    $sp,                                    $sp,                    -12
    sw      $a0,                                    0($sp)
    sw      $a1,                                    4($sp)
    sw      $ra,                                    8($sp)
    li      $a0,                                    16

    jal     power

    lw      $a0,                                    0($sp)
    lw      $a1,                                    4($sp)
    lw      $ra,                                    8($sp)
    addi    $sp,                                    $sp,                    12

    li      $t1,                                    -55
    add     $t0,                                    $t0,                    $t1
    mult    $v0,                                    $t0
    mflo    $t0
    add     $s0,                                    $s0,                    $t0
    addi    $a0,                                    $a0,                    1

    j       hexToDecimal_loop

hexToDecimal_convertLowerCaseLetter:
    addi    $sp,                                    $sp,                    -12
    sw      $a0,                                    0($sp)
    sw      $a1,                                    4($sp)
    sw      $ra,                                    8($sp)
    li      $a0,                                    16

    jal     power

    lw      $a0,                                    0($sp)
    lw      $a1,                                    4($sp)
    lw      $ra,                                    8($sp)
    addi    $sp,                                    $sp,                    12

    li      $t1,                                    -87
    add     $t0,                                    $t0,                    $t1
    mult    $v0,                                    $t0
    mflo    $t0
    add     $s0,                                    $s0,                    $t0
    addi    $a0,                                    $a0,                    1

    j       hexToDecimal_loop

hexToDecimal_exit:
    move    $v0,                                    $s0
    lw      $s0,                                    0($sp)
    addi    $sp,                                    $sp,                    4
    jr      $ra

invalid:
    li      $v0,                                    4
    la      $a0,                                    invalid_msg
    syscall 

    lw      $s0,                                    0($sp)
    # addi    $sp,                                    $sp,                    4
    li      $t0,                                    1
    beq     $s0,                                    $t0,                    binary

    li      $t0,                                    2
    beq     $s0,                                    $t0,                    hexadecimal

    li      $t0,                                    3
    beq     $s0,                                    $t0,                    decimal

    j       main_loop

power:                                                                                                                                          # $a0 = base, $a1 = power (possitive int)
    li      $v0,                                    1

power_loop:
    beqz    $a1,                                    power_return
    mult    $v0,                                    $a0
    mflo    $v0
    addi    $a1,                                    $a1,                    -1
    j       power_loop

power_return:
    jr      $ra

exit:
    la      $a0,                                    separator
    syscall 

    li      $v0,                                    10
    syscall 
.DEVICE ATmega328P

.EQU CLK_FREQ   = 1000000

.EQU PORTB      = 0x05
.EQU DDRB       = 0x04
.EQU PINB       = 0x03

.EQU SPL        = 0x3D
.EQU SPH        = 0x3E

.DEF    XH = r26
.DEF    XL = r27

.EQU message    = 0x100 ;16 bytes for LCD message

.CSEG
.ORG 0x000
    RJMP RESET


.ORG 0x01A
RESET:
    ; Initialize Stack Pointer
    ; The SPH register in the datasheet appears wrong but idk
    LDI r16, LOW(0x08FF)
    OUT SPL, r16
    LDI r16, HIGH(0x08FF)
    OUT SPH, r16
    
    LDI r18, 50

    ; Initialize pins
    LDI r16, 0b11111110
    OUT DDRB, r16

    ; Initialize LCD
    LDI r16, 0b00101000
    CALL lcd_instruction
    CALL delay
    LDI r16, 0b00001111
    CALL lcd_instruction
    CALL delay
    LDI r16, 0b00000110
    CALL lcd_instruction
    CALL delay
    LDI r16, 0b00000001
    CALL lcd_instruction
    CALL delay
    CALL delay
    CALL delay
    CALL delay
    CALL delay


    LDI r16, 'H'
    call lcd_char
    call delay
    LDI r16, 'e'
    call lcd_char
    call delay
    LDI r16, 'l'
    call lcd_char
    call delay
    LDI r16, 'l'
    call lcd_char
    call delay
    LDI r16, 'o'
    call lcd_char
    call delay
    LDI r16, ','
    call lcd_char
    call delay
    LDI r16, ' '
    call lcd_char
    call delay
    LDI r16, 'w'
    call lcd_char
    call delay
    LDI r16, 'o'
    call lcd_char
    call delay
    LDI r16, 'r'
    call lcd_char
    call delay
    LDI r16, 'l'
    call lcd_char
    call delay
    LDI r16, 'd'
    call lcd_char
    call delay
    LDI r16, '!'
    call lcd_char
    call delay


loop:
    RJMP loop


; Sends an instruction to the LCD
;
; Takes r16 as argument (the instruction)
lcd_instruction:
    PUSH r17

    MOV r17, r16
    ANDI r17, 0xF0
    OUT PORTB, r17
    SBI PORTB, 3
    CBI PORTB, 3

    MOV r17, r16
    SWAP r17
    ANDI r17, 0xF0
    OUT PORTB, r17
    SBI PORTB, 3
    CBI PORTB, 3

    POP r17
    RET


; Sends an instruction to the LCD
;
; Takes r16 as argument (the instruction)
lcd_char:
    PUSH r17

    MOV r17, r16
    ANDI r17, 0xF0
    OUT PORTB, r17
    SBI PORTB, 1
    SBI PORTB, 3
    CBI PORTB, 3

    MOV r17, r16
    SWAP r17
    ANDI r17, 0xF0
    OUT PORTB, r17
    SBI PORTB, 1
    SBI PORTB, 3
    CBI PORTB, 3

    POP r17
    RET


; Loops for a period of time
;
; Takes r18 as argument
; Doesn't return anything, doesn't modify r16
;
; waits r18 * 2ms before returning
; *not very precise
delay:
    ; Using this register pair for the loop
    PUSH r24
    PUSH r25

    ; Initialize counter
    CLR r24
    MOV r25, r18

delay_loop:
    NOP
    NOP
    NOP
    NOP
    SBIW r24, 1
    BRNE delay_loop

    ; Put the old value back in place
    POP r25
    POP r24
    RET


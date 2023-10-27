.include "m328pdef.inc"

.org 0x00
rjmp start

start:
    ; Initialize PORTD (all pins) as input.
    ldi  r16, 0x00
    out  DDRD, r16

    ; Initialize PORTB (B0 to B5) as output
    ldi  r16, 0b00111111
    out  DDRB, r16

    ; Initialize PORTC (C0 to C1) as output
    ldi  r16, 0b00000011
    out  DDRC, r16

main_loop:
    ; Read the state of PORTD
    in   r16, PIND

    ; Mask off the higher bits to preserve just D0 to D5, then output to PORTB
    andi r16, 0b00111111
    out  PORTB, r16

    ; Read the state of PORTD again for D6 and D7
    in   r16, PIND

    ; Check D6 (bit 6 of PORTD), and update C0 (bit 0 of PORTC)
    sbrs r16, 6       ; Skip next instruction if D6 is set (1)
    cbi  PORTC, 0     ; Clear C0 if D6 is 0
    sbrc r16, 6       ; Skip next instruction if D6 is clear (0)
    sbi  PORTC, 0     ; Set C0 if D6 is 1

    ; Check D7 (bit 7 of PORTD), and update C1 (bit 1 of PORTC)
    sbrs r16, 7       ; Skip next instruction if D7 is set (1)
    cbi  PORTC, 1     ; Clear C1 if D7 is 0
    sbrc r16, 7       ; Skip next instruction if D7 is clear (0)
    sbi  PORTC, 1     ; Set C1 if D7 is 1

    rjmp main_loop

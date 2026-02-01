; === CODE23 ===
        LDA #'-'
FOUT14        STA FBUFFR+1,Y
        LDA #'E'
        STA FBUFFR,Y
        TXA
        LDX #$2F
        SEC
FOUT15        INX
        SBC #$0A
        BCS FOUT15
        ADC #$3A
        STA FBUFFR+3,Y
        TXA
        STA FBUFFR+2,Y
        LDA #0
        STA FBUFFR+4,Y
        BEQ FOUT20
FOUT19        STA FBUFFR-1,Y
FOUT17        LDA #0
        STA FBUFFR,Y
FOUT20        LDA #<FBUFFR
        LDY #>FBUFFR
        RTS
FHALF        .byte $80,0
ZERO        .byte 0,0,0
FOUTBL        .byte $FA,$0A,$1F,0,0
        .byte $98,$96,$80,$FF
        .byte $F0,$BD,$C0,0
        .byte 1,$86,$A0,$FF
        .byte $FF,$D8,$F0,0,0
        .byte 3,$E8,$FF,$FF
        .byte $FF,$9C,0,0,0,$0A
        .byte $FF,$FF,$FF,$FF
FDCEND        .byte $FF,$DF,$0A,$80
        .byte 0,3,$4B,$C0,$FF
        .byte $FF,$73,$60,0,0
        .byte $0E,$10,$FF,$FF
        .byte $FD,$A8,0,0,0,$3C
TIMEND
;
CKSMA0        .byte $00        ;$8000 8K ROOM CHECK SUM ADJ
; CHANGE: Removed 30-byte PATCHS area to save space
;
; CHANGE: Power function (^) disabled - requires LOG/EXP which were removed
; Users should use multiplication for integer powers: X*X instead of X^2
;
FPWRT        jmp FCERR        ; Power function not available
NEGOP        LDA FACEXP
        BEQ NEGRTS
        LDA FACSGN
        EOR #$FF
        STA FACSGN
NEGRTS        RTS

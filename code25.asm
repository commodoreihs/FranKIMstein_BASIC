; =============================================================================
; CODE25 - POLY, RND (EXP removed)
; CHANGE: Removed EXP continuation code (STOLD, EXP1, etc.) to save space
; =============================================================================

POLYX    sta POLYPT
         sty POLYPT+1
         jsr MOV1F
         lda #TEMPF1
         jsr FMULT
         jsr POLY1
         lda #<TEMPF1
         ldy #>TEMPF1
         jmp FMULT

POLY     sta POLYPT
         sty POLYPT+1
POLY1    jsr MOV2F
         lda (POLYPT),y
         sta DEGREE
         ldy POLYPT
         iny
         tya
         bne POLY3
         inc POLYPT+1
POLY3    sta POLYPT
         ldy POLYPT+1
POLY2    jsr FMULT
         lda POLYPT
         ldy POLYPT+1
         clc
         adc #4+ADDPRC
         bcc POLY4
         iny
POLY4    sta POLYPT
         sty POLYPT+1
         jsr FADD
         lda #<TEMPF2
         ldy #>TEMPF2
         dec DEGREE
         bne POLY2
         rts

RMULC    .byte $98,$35,$44,$7A,0
RADDC    .byte $68,$28,$B1,$46,0

; =============================================================================
; RND - Random number generator
; CHANGE: Use VIA1 timers instead of RDBAS kernal call
; =============================================================================
RND      jsr SIGN
         bmi RND1
         bne QSETNR
         ; CHANGE: Read VIA1 timers directly instead of RDBAS
         lda $1804       ; VIA1 Timer 1 Low
         sta FACHO
         lda $1805       ; VIA1 Timer 1 High
         sta FACMO
         lda $1808       ; VIA1 Timer 2 Low
         sta FACMOH
         lda $1809       ; VIA1 Timer 2 High
         sta FACLO
         jmp STRNEX
QSETNR   lda #<RNDX
         ldy #>RNDX
         jsr MOVFM
         lda #<RMULC
         ldy #>RMULC
         jsr FMULT
         lda #<RADDC
         ldy #>RADDC
         jsr FADD
RND1     ldx FACLO
         lda FACHO
         sta FACLO
         stx FACHO
         ldx FACMOH
         lda FACMO
         sta FACMOH
         stx FACMO
STRNEX   lda #0
         sta FACSGN
         lda FACEXP
         sta FACOV
         lda #$80
         sta FACEXP
         jsr NORMAL
         ldx #<RNDX
         ldy #>RNDX
GMOVMF   jmp MOVMF

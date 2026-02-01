; =============================================================================
; TOKEN2 - Reserved Word List Continuation and Error Messages
; =============================================================================

; More reserved words (continuation from tokens.asm)
         .byte 'T','A','B','('+$80
         .byte 'T','O'+$80
         .byte 'F','N'+$80
         .byte 'S','P','C','('+$80
         .byte 'T','H','E','N'+$80
         .byte 'N','O','T'+$80
         .byte 'S','T','E','P'+$80
         .byte '+'+$80           ; PLUS
         .byte '-'+$80           ; MINUS
         .byte '*'+$80           ; MULTIPLY
         .byte '/'+$80           ; DIVIDE
         .byte '^'+$80           ; POWER
         .byte 'A','N','D'+$80
         .byte 'O','R'+$80
         .byte '>'+$80           ; GREATER
         .byte '='+$80           ; EQUAL
         .byte '<'+$80           ; LESS
         .byte 'S','G','N'+$80
; ONEFUN label not needed here - defined in declare.asm
         .byte 'I','N','T'+$80
         .byte 'A','B','S'+$80
         .byte 'U','S','R'+$80
         .byte 'F','R','E'+$80
         .byte 'P','O','S'+$80
         .byte 'S','Q','R'+$80
         .byte 'R','N','D'+$80
         .byte 'L','O','G'+$80
         .byte 'E','X','P'+$80
         .byte 'C','O','S'+$80
         .byte 'S','I','N'+$80
         .byte 'T','A','N'+$80
         .byte 'A','T','N'+$80
         .byte 'P','E','E','K'+$80
         .byte 'L','E','N'+$80
         .byte 'S','T','R','$'+$80
         .byte 'V','A','L'+$80
         .byte 'A','S','C'+$80
         .byte 'C','H','R','$'+$80
; LASNUM label not needed - defined in declare.asm
         .byte 'L','E','F','T','$'+$80
         .byte 'R','I','G','H','T','$'+$80
         .byte 'M','I','D','$'+$80
         .byte 'G','O'+$80
         .byte 0                 ; End of reserved word list

; =============================================================================
; ERROR MESSAGES
; CHANGE: Trimmed file-related messages to save space
; =============================================================================
ERR01    .byte '?'+$80          ; Was "TOO MANY FILES"
ERR02    .byte '?'+$80          ; Was "FILE OPEN"
ERR03    .byte '?'+$80          ; Was "FILE NOT OPEN"
ERR04    .byte '?'+$80          ; Was "FILE NOT FOUND"
ERR05    .byte '?'+$80          ; Was "DEVICE NOT PRESENT"
ERR06    .byte '?'+$80          ; Was "NOT INPUT FILE"
ERR07    .byte '?'+$80          ; Was "NOT OUTPUT FILE"
ERR08    .byte '?'+$80          ; Was "MISSING FILE NAME"
ERR09    .byte '?'+$80          ; Was "ILLEGAL DEVICE NUMBER"
ERR10    .text "NXT/FO"
         .byte 'R'+$80
ERR11    .text "SYNTA"
         .byte 'X'+$80
ERR12    .text "RET/GS"
         .byte 'B'+$80
ERR13    .text "NO DAT"
         .byte 'A'+$80
ERR14    .text "BA"
         .byte 'D'+$80
ERR15    .text "OVFL"
         .byte 'W'+$80
ERR16    .text "O"
         .byte 'M'+$80
ERR17    .text "UND"
         .byte 'F'+$80
ERR18    .text "SUBS"
         .byte 'C'+$80
ERR19    .text "REDI"
         .byte 'M'+$80
ERR20    .text "DIV"
         .byte '0'+$80
ERR21    .text "DIR"
         .byte 'T'+$80
ERR22    .text "TYP"
         .byte 'E'+$80
ERR23    .text "LO"
         .byte 'N'+$80
ERR24    .text "DA"
         .byte 'T'+$80
ERR25    .text "CMP"
         .byte 'X'+$80
ERR26    .text "CN"
         .byte 'T'+$80
ERR27    .text "UDF"
         .byte 'N'+$80
ERR28    .text "VF"
         .byte 'Y'+$80
ERR29    .text "LD"
         .byte 'E'+$80

; Error message address table
ERRTAB   .word ERR01
         .word ERR02
         .word ERR03
         .word ERR04
         .word ERR05
         .word ERR06
         .word ERR07
         .word ERR08
         .word ERR09
         .word ERR10
         .word ERR11
         .word ERR12
         .word ERR13
         .word ERR14
         .word ERR15
         .word ERR16
         .word ERR17
         .word ERR18
         .word ERR19
         .word ERR20
         .word ERR21
         .word ERR22
         .word ERR23
         .word ERR24
         .word ERR25
         .word ERR26
         .word ERR27
         .word ERR28
         .word ERR29
         .word ERR30

OKMSG    .byte $0D
         .text "OK"
         .byte $0D,$00
ERR      .text " ERR"
         .byte 0
INTXT    .text " IN "
         .byte 0
REDDY    .byte $0D,$0A
         .text "OK"
         .byte $0D,$0A,0
BRKTXT   .byte $0D,$0A
ERR30    .text "BRK"
         .byte 0,$A0

; =============================================================================
; UTILITY ROUTINES
; =============================================================================
; FORSIZ defined in declare.asm

FNDFOR   tsx
         inx
         inx
         inx
         inx
FFLOOP   lda 257,x
         cmp #FORTK
         bne FFRTS
         lda FORPNT+1
         bne CMPFOR
         lda 258,x
         sta FORPNT
         lda 259,x
         sta FORPNT+1
CMPFOR   cmp 259,x
         bne ADDFRS
         lda FORPNT
         cmp 258,x
         beq FFRTS
ADDFRS   txa
         clc
         adc #FORSIZ
         tax
         bne FFLOOP
FFRTS    rts

BLTU     jsr REASON
         sta STREND
         sty STREND+1
BLTUC    sec
         lda HIGHTR
         sbc LOWTR
         sta INDEX
         tay
         lda HIGHTR+1
         sbc LOWTR+1
         tax
         inx
         tya
         beq DECBLT
         lda HIGHTR
         sec
         sbc INDEX
         sta HIGHTR
         bcs BLT1
         dec HIGHTR+1
         sec
BLT1     lda HIGHDS
         sbc INDEX
         sta HIGHDS
         bcs MOREN1
         dec HIGHDS+1
         bcc MOREN1
BLTLP    lda (HIGHTR),y
         sta (HIGHDS),y
MOREN1   dey
         bne BLTLP
         lda (HIGHTR),y
         sta (HIGHDS),y
DECBLT   dec HIGHTR+1
         dec HIGHDS+1
         dex
         bne MOREN1
         rts

GETSTK   asl a
         adc #NUMLEV+NUMLEV+16
         bcs _OMERR1
         sta INDEX
         tsx
         cpx INDEX
         bcc _OMERR1
         rts
_OMERR1  jmp OMERR       ; Trampoline for far branch

REASON   cpy FRETOP+1
         bcc REARTS
         bne TRYMOR
         cmp FRETOP
         bcc REARTS
TRYMOR   pha
         ldx #8+ADDPRC
         tya
REASAV   pha
         lda HIGHDS-1,x
         dex
         bpl REASAV
         jsr GARBA2
         ldx #248-ADDPRC
REASTO   pla
         sta HIGHDS+8+ADDPRC,x
         inx
         bmi REASTO
         pla
         tay
         pla
         cpy FRETOP+1
         bcc REARTS
         bne _OMERR2
         cmp FRETOP
         bcc REARTS
_OMERR2  jmp OMERR       ; Trampoline for far branch
REARTS   rts

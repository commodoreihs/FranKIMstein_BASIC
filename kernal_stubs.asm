; =============================================================================
; KERNAL_STUBS - Replacement routines for CBM Kernal calls
; =============================================================================

; Serial I/O - must preserve Y since OUTCH destroys it
INCHR    jsr GETCH       ; Get char from serial
         pha
         jsr OUTCH       ; Echo
         pla
         rts

; Channel stubs
CLSCHN   lda #0
         sta CHANNL
         rts

COIN     jmp GETCH
COOUT    jmp OUTCH

; STOP key check - always return "no stop key pressed"
; Called via JSR $FFE1 but we redirect it
STOPKEY  lda #$FF        ; Return non-zero (STOP not pressed)
         clc             ; Carry clear = no stop key
         rts

; Stubs returning 0
RDTIM    tax
         tay
READST
CGETL    lda #0
         rts

SETTIM
SETMSG
CCALL
CWAIT
COPEN
CCLOS    rts

PLOT     ldx #0
         ldy #0
         clc
         rts

NOFUNC
FCERR2   jmp FCERR

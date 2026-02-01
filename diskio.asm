; =============================================================================
; DISKIO - Disk I/O Routines (LOAD, SAVE, SYS)
; FranKIMstein: Direct calls to monitor ROM disk routines
; =============================================================================

; =============================================================================
; CSYS - Execute machine language at address
; =============================================================================
CSYS     jsr FRMNUM      ; Evaluate expression
         jsr GETADR      ; Convert to address in LINNUM
         lda #>CSYSRZ    ; Push return address
         pha
         lda #<CSYSRZ
         pha
         lda SPREG       ; Get saved status
         pha
         lda SAREG       ; Load saved registers
         ldx SXREG
         ldy SYREG
         plp             ; Restore status
         jmp (LINNUM)    ; Execute
CSYSRZ   = *-1           ; Return point
         php             ; Save status
         sta SAREG       ; Save registers
         stx SXREG
         sty SYREG
         pla
         sta SPREG
         rts

; =============================================================================
; CSAVE - Save BASIC program to disk
; Calls FranKIMstein BSAVE at $F7CE
; =============================================================================
CSAVE    jsr PLSV        ; Parse filename into savename
         ; Get program bounds
         lda TXTTAB
         sta sal
         lda TXTTAB+1
         sta sah
         lda VARTAB
         sta eal
         lda VARTAB+1
         sta eah
         ; Call FranKIMstein BSAVE
         jsr BSAVE
         bne DSKERR      ; A<>0 means error
         jmp READYX

; =============================================================================
; CLOAD - Load BASIC program from disk
; Calls FranKIMstein BLOAD at $F7E4
; =============================================================================
CLOAD    lda #0
         sta VERCK       ; Load mode (not verify)
         jsr PLSV        ; Parse filename into savename
         ; Set load destination to TXTTAB (BLOAD will use sal/sah in BASIC mode)
         lda TXTTAB
         sta sal
         lda TXTTAB+1
         sta sah
         ; Call FranKIMstein BLOAD
         jsr BLOAD
         bne DSKERR      ; A<>0 means error
         ; Success - set up BASIC pointers
         ; TXTTAB stays the same, VARTAB = end of loaded data
         ; eal/eah was set by BLOAD to the end address
         lda eal
         sta VARTAB
         lda eah
         sta VARTAB+1
         ; Relink BASIC program
         jsr LNKPRG      ; Re-establish line links
         ; Set up TXTPTR for CHRGET
         jsr STXTPT
         ; Vectors at $0660 are outside disk buffers, no need for INITV
         jmp READYX

; Shared disk error handler
DSKERR   ldx #ERLOAD
         jmp ERROR

; LINKPRG is in code1.asm

; =============================================================================
; CFORMAT - Format disk (FMT"NAME,ID")
; =============================================================================
CFORMAT  jsr FRMEVL
         jsr FRESTR        ; A=length, INDEX1=pointer
         sec
         sbc #3            ; A = name length (total - ",ID")
         bcc CFERR
         pha               ; save name length for later
         ; First, pad dskname with $A0 (shifted space)
         ldx #15
         lda #$A0
CFPAD    sta dskname,x
         dex
         bpl CFPAD
         ; Get disk ID from end of string
         pla               ; A = name length
         tay
         iny               ; Y = position of first ID char
         lda (INDEX1),y
         sta dskid
         iny
         lda (INDEX1),y
         sta dskid+1
         dey
         dey               ; Y = name length - 1 (last char index)
CFCP     lda (INDEX1),y
         sta dskname,y
         dey
         bpl CFCP
CFDONE   jsr BFORMAT
         bne DSKERR
         jmp READYX
CFERR    jmp SNERR
PLSV     ; First clear savename with $A0
         ldy #15
         lda #$A0
PLCL     sta savename,y
         dey
         bpl PLCL
         ; Now parse filename if present
         jsr CHRGOT
         beq PLSVDN      ; No filename
         jsr FRMEVL      ; Evaluate string
         jsr FRESTR      ; Free temp, get descriptor
         tax
         beq PLSVDN      ; Empty string
         cpx #16
         bcc PLSV2
         ldx #16         ; Max 16 chars
PLSV2    ldy #0
PLSV3    lda (INDEX1),y
         sta savename,y
         iny
         dex
         bne PLSV3
PLSVDN   rts

; PRFNAM removed - not needed without SAVING/LOADING messages

; =============================================================================
; INIT - BASIC Initialization
; CHANGE: Memory layout for stock 1541 with 2KB RAM ($0701-$07FF)
; =============================================================================

PANIC    jsr CLSCHN      ; Warm start BASIC
         lda #0          ; Clear channels
         sta CHANNL
         ; CHANGE: Only clear job slot 0 (single job queue)
         ; $01-$04 are now stepper variables (as, af, aclstp, rsteps)
         sta $00         ; Job 0 only
         jsr STKINI      ; Restore stack
         ; CHANGE: Keep IRQs disabled - BASIC uses synchronous I/O only
         sei             ; Disable IRQ's (no async disk ops needed)

READY    ldx #$80
         jmp (IERROR)

NERROR   txa             ; Get high bit
         bmi NREADY
         jmp NERROX
NREADY   jmp READYX

INIT     jsr INITV       ; Init vectors
         jsr INITCZ      ; Init CHRGET & zero page
         jsr INITMS      ; Print init messages
         ldx #STKEND-256 ; Set up stack
         txs
         bne READY       ; Jump to READY

; =============================================================================
; CHRGET template - copied to $48 at startup (original self-modifying code)
; TXTPTR is embedded at $4F-$50 within the LDA instruction
; Moved from $30 to avoid conflict with disk controller ZP ($30-$3D)
; =============================================================================
INITAT                   ; Label for code that checks memory bounds
CHRTAB   .byte $E6, $4F        ; INC $4F (TXTPTR low)
         .byte $D0, $02        ; BNE +2 (skip high byte inc)
         .byte $E6, $50        ; INC $50 (TXTPTR high)
         .byte $AD, $00, $00   ; LDA $0000 (CHRGOT - $4F-$50 are TXTPTR)
         .byte $C9, $3A        ; CMP #':'
         .byte $B0, $0A        ; BCS +10 (to RTS)
         .byte $C9, $20        ; CMP #' '
         .byte $F0, $EF        ; BEQ -17 (back to CHRGET)
         .byte $38             ; SEC
         .byte $E9, $30        ; SBC #'0'
         .byte $38             ; SEC
         .byte $E9, $D0        ; SBC #$D0
         .byte $60             ; RTS
CHRLEN   = * - CHRTAB          ; Should be 24 bytes

; RND seed - copied to RNDX at init
RNDSEED  .byte 128,79,199,82,88

INITCZ   lda #76         ; JMP instruction
         sta JMPER
         sta USRPOK
         lda #<FCERR
         ldy #>FCERR
         sta USRPOK+1
         sty USRPOK+2
         lda #<GIVAYF
         ldy #>GIVAYF
         sta ADRAY2
         sty ADRAY2+1
         lda #<FLPINT
         ldy #>FLPINT
         sta ADRAY1
         sty ADRAY1+1
         ; Copy CHRGET to ZP at $48
         ldx #CHRLEN-1
CPYCHR   lda CHRTAB,x
         sta CHRGET,x
         dex
         bpl CPYCHR
         ; Copy RND seed to RNDX
         ldx #4
CPYRND   lda RNDSEED,x
         sta RNDX,x
         dex
         bpl CPYRND
         lda #STRSIZ
         sta FOUR6
         lda #0
         sta BITS
         sta CHANNL
         sta LASTPT+1
         ; CHANGE: Only clear job slot 0 (single job queue)
         ; $01-$04 are now stepper variables (as, af, aclstp, rsteps)
         sta $00         ; Job 0 only
         ldx #1
         stx BUF-3
         stx BUF-4
         ldx #TEMPST
         stx TEMPPT
         ; CHANGE: BASIC program space is $0401-$04FF (255 bytes)
         ; Using $0401 for PET compatibility (PET BASIC starts at $0401)
         ; This also works on VIC-20 and C64 which relocate on load
         ; MEMSIZ = $0500 (before buff2 which FORMAT uses)
         lda #$01
         sta TXTTAB
         lda #$04
         sta TXTTAB+1
         ; Initialize byte before TXTTAB ($0400) for NEWSTT
         lda #$00
         sta $0400
         lda #$00
         sta MEMSIZ
         lda #$05
         sta MEMSIZ+1
         lda MEMSIZ
         sta FRETOP
         lda MEMSIZ+1
         sta FRETOP+1
         ; Note: SCRTCH (called from INITMS) will properly initialize
         ; the program area with two zero bytes at TXTTAB
INIT20   rts

; FLPINT defined in code12.asm

INITMS   lda TXTTAB
         ldy TXTTAB+1
         jsr REASON
         lda #<FREMES
         ldy #>FREMES
         jsr STROUT
         lda MEMSIZ
         sec
         sbc TXTTAB
         tax
         lda MEMSIZ+1
         sbc TXTTAB+1
         jsr LINPRT
         lda #<WORDS
         ldy #>WORDS
         jsr STROUT
         jmp SCRTCH

; Vector table
BVTRS    .word NERROR,NMAIN,NCRNCH,NQPLOP,NGONE,NEVAL

INITV    ldx #INITV-BVTRS-1
INITV1   lda BVTRS,x
         sta IERROR,x
         dex
         bpl INITV1
         rts

WORDS    .text " BYTES FREE"
         .byte 13,0
FREMES   .byte 13
         .text "FranKIMstein BASIC"
         .byte 13,0

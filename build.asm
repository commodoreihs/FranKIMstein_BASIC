; =============================================================================
; FranKIMstein BASIC - Master Build File for 64tass
; =============================================================================
; Commodore MAX BASIC V2 ported to run on the FranKIMstein 1541 disk drive
;
; Build command:
;   64tass --nostart -o basic_c000.bin build.asm
;
; Output: 8K ROM image for $C000-$DFFF
; =============================================================================

; Set the ROM origin
* = $C000

; Include declarations first (must set up zero page before ROM code)
.include "declare.asm"

; ROM code starts here
.include "tokens.asm"       ; ROM header and dispatch tables
.include "token2.asm"       ; Reserved words and error messages
.include "kernal_stubs.asm" ; Kernal replacement stubs
.include "diskio.asm"       ; Disk I/O (LOAD, SAVE, SYS) - must be before code uses them

; Core BASIC interpreter
.include "code1.asm"        ; Error handling, main loop, INLIN
.include "code2.asm"        ; Crunch, FNDLIN, CLEAR
.include "code3.asm"        ; LIST, FOR
.include "code4.asm"        ; NEWSTT, GONE, STOP, END
.include "code5.asm"        ; DATA, REM, IF, GOTO, GOSUB, RETURN

; I/O routines
.include "code6.asm"        ; PRINT, string output
.include "code7.asm"        ; INPUT, READ, GET

; More interpreter code
.include "code8.asm"        ; INPUT continuation, NEXT
.include "code9.asm"        ; FRMEVL, expression evaluation
.include "code10.asm"       ; GET, GETTIM
.include "code11.asm"       ; Math operations
.include "code12.asm"       ; Integer/array routines
.include "code13.asm"       ; Trig helpers
.include "code14.asm"       ; ATN
.include "code15.asm"       ; String functions
.include "code16.asm"       ; More string functions
.include "code17.asm"       ; VAL, STR$
.include "code18.asm"       ; Float conversion
.include "code19.asm"       ; PEEK, POKE, FRE
.include "code20.asm"       ; Variable handling, SGN, ABS
.include "code21.asm"       ; FIN, DEF FN
.include "code22.asm"       ; Number output
.include "code23.asm"       ; More number output
.include "code24.asm"       ; Float constants
.include "code25.asm"       ; EXP, POLY, RND

; Trigonometry
.include "trig.asm"         ; LOG, SQR, SIN, COS, TAN

; Initialization
.include "init.asm"         ; CHANGE: FranKIMstein memory setup

; Pad to end of 8K ROM
.fill $E000 - *, $FF

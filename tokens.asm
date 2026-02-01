; =============================================================================
; TOKENS - ROM Header and Dispatch Tables
; =============================================================================

; ROM Header - executable entry points
         jmp INIT        ; $C000 Cold start
         jmp PANIC       ; $C003 Warm start
         .text "CB"      ; $C006 Signature (shortened)

; Statement dispatch table
STMDSP   .word END-1
         .word FOR-1
         .word NEXT-1
         .word DATA-1
         .word INPUTN-1
         .word INPUT-1
         .word DIM-1
         .word READ-1
         .word LET-1
         .word GOTO-1
         .word RUN-1
         .word IF-1
         .word RESTOR-1
         .word GOSUB-1
         .word RETURN-1
         .word REM-1
         .word STOP-1
         .word ONGOTO-1
         .word CWAIT-1       ; WAIT (stub)
         .word CLOAD-1
         .word CSAVE-1
         .word CFORMAT-1
         .word DEF-1
         .word POKE-1
         .word PRINTN-1
         .word PRINT-1
         .word CONT-1
         .word LIST-1
         .word CLEAR-1
         .word CMD-1
         .word CSYS-1
         .word COPEN-1
         .word CCLOS-1
         .word GET-1
         .word SCRTCH-1

; Function dispatch table
; CHANGE: Removed LOG, EXP, COS, SIN, TAN, ATN, SQR to save space
FUNDSP   .word SGN
         .word INT
         .word ABS
USRLOC   .word USRPOK
         .word FRE
         .word POS
         .word NOFUNC        ; Was SQR (needs LOG/EXP)
         .word RND
         .word NOFUNC        ; Was LOG
         .word NOFUNC        ; Was EXP
         .word NOFUNC        ; Was COS
         .word NOFUNC        ; Was SIN
         .word NOFUNC        ; Was TAN
         .word NOFUNC        ; Was ATN
         .word PEEK
         .word LEN
         .word STRD
         .word VAL
         .word ASC
         .word CHRD
         .word LEFTD
         .word RIGHTD
         .word MIDD

; Operator table (priority, dispatch address)
OPTAB    .byte 121
         .word FADDT-1
         .byte 121
         .word FSUBT-1
         .byte 123
         .word FMULTT-1
         .byte 123
         .word FDIVT-1
         .byte 127
         .word FPWRT-1
         .byte 80
         .word ANDOP-1
         .byte 70
         .word OROP-1
NEGTAB   .byte 125
         .word NEGOP-1
NOTTAB   .byte 90
         .word NOTOP-1
PTDORL   .byte 100
         .word DOREL-1

; Reserved word list
RESLST   .byte 'E','N','D'+$80
         .byte 'F','O','R'+$80
         .byte 'N','E','X','T'+$80
         .byte 'D','A','T','A'+$80
         .byte 'I','N','P','U','T','#'+$80
         .byte 'I','N','P','U','T'+$80
         .byte 'D','I','M'+$80
         .byte 'R','E','A','D'+$80
         .byte 'L','E','T'+$80
         .byte 'G','O','T','O'+$80
         .byte 'R','U','N'+$80
         .byte 'I','F'+$80
         .byte 'R','E','S','T','O','R','E'+$80
         .byte 'G','O','S','U','B'+$80
         .byte 'R','E','T','U','R','N'+$80
         .byte 'R','E','M'+$80
         .byte 'S','T','O','P'+$80
         .byte 'O','N'+$80
         .byte 'W','A','I','T'+$80
         .byte 'L','O','A','D'+$80
         .byte 'S','A','V','E'+$80
         .byte 'F','M','T'+$80
         .byte 'D','E','F'+$80
         .byte 'P','O','K','E'+$80
         .byte 'P','R','I','N','T','#'+$80
         .byte 'P','R','I','N','T'+$80
         .byte 'C','O','N','T'+$80
         .byte 'L','I','S','T'+$80
         .byte 'C','L','R'+$80
         .byte 'C','M','D'+$80
         .byte 'S','Y','S'+$80
         .byte 'O','P','E','N'+$80
         .byte 'C','L','O','S','E'+$80
         .byte 'G','E','T'+$80
         .byte 'N','E','W'+$80

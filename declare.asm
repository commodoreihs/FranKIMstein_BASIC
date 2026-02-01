; =============================================================================
; FranKIMstein BASIC - DECLARATIONS  
; =============================================================================
; CHRGET relocated to $48-$5F in ZP (original self-modifying code)
; Avoids conflict with disk controller's $30-$3D variables (used during IRQ)
; =============================================================================

ADDPRC   = 1
ROMLOC   = $C000
LINLEN   = 80
BUFLEN   = 80
BUFPAG   = 2
BUF      = $0200
STKEND   = 507
CLMWID   = 10
PI       = 255
NUMLEV   = 23
STRSIZ   = 3

; Monitor entry points (must match 1541_kim1.asm)
GETCH    = $E177
OUTCH    = $E198
CRLF     = $E1F8
PRTBYT   = $E20B

; Disk routines (monitor entry points)
BSAVE    = $F7F3
BLOAD    = $F809
BFORMAT  = $F81F

; Disk workspace (shared with monitor ROM - only what BASIC needs)
savename = $0640          ; 16 bytes - filename for LOAD/SAVE (must match monitor!)
sal      = $0650          ; start address low (for SAVE, set by LOAD)
sah      = $0651          ; start address high
eal      = $0652          ; end address low (for SAVE, set by LOAD)
eah      = $0653          ; end address high
dskname  = $0630          ; 16 bytes - disk name for FORMAT
dskid    = $60            ; 2 bytes - disk ID for FORMAT (zero page)

; =============================================================================
; CHRGET at $48-$5F in ZP (moved from $30 to avoid disk controller conflict)
; Disk controller uses $30-$3D during IRQ, which corrupted CHRGET/TXTPTR
; =============================================================================
CHRGET   = $48           ; Start of CHRGET routine
CHRGOT   = $4E           ; Entry to get current char without increment
TXTPTR   = $4F           ; 2 bytes - embedded in CHRGET's LDA instruction

; =============================================================================
; BASIC ZERO PAGE $80-$F3 - Original layout restored
; =============================================================================
BLANK0   = $80
ADRAY1   = $83
ADRAY2   = $85
INTEGR   = $87
CHARAC   = $87
ENDCHR   = $88
TRMPOS   = $89
VERCK    = $8A
COUNT    = $8B
DIMFLG   = $8C
VALTYP   = $8D
INTFLG   = $8E
GARBFL   = $8F
DORES    = $8F
SUBFLG   = $90
INPFLG   = $91
DOMASK   = $92
TANSGN   = $92
CHANNL   = $93
POKER    = $94
LINNUM   = $94
TEMPPT   = $96
LASTPT   = $97
TEMPST   = $99
INDEX    = $A2
INDEX1   = $A2
INDEX2   = $A4
RESHO    = $A6
RESMOH   = $A7
ADDEND   = $A8
RESMO    = $A8
RESLO    = $A9
TXTTAB   = $AB
VARTAB   = $AD
ARYTAB   = $AF
STREND   = $B1
FRETOP   = $B3
FRESPC   = $B5
MEMSIZ   = $B7
CURLIN   = $B9
OLDLIN   = $BB
OLDTXT   = $BD
DATLIN   = $BF
DATPTR   = $C1
INPPTR   = $C3
VARNAM   = $C5
FDECPT   = $C7
VARPNT   = $C7
LSTPNT   = $C9
ANDMSK   = $C9
FORPNT   = $C9
EORMSK   = $CA
VARTXT   = $CB
OPPTR    = $CB
OPMASK   = $CD
GRBPNT   = $CE
TEMPF3   = $CE
DEFPNT   = $CE
DSCPNT   = $D0
FOUR6    = $D3
JMPER    = $D4
SIZE     = $D5
OLDOV    = $D6
TEMPF1   = $D7
APTS     = $D7
HIGHDS   = $D7
ARYPNT   = $D7
HIGHTR   = $D9
TEMPF2   = $DB
DECCNT   = $DC
LOWDS    = $DC
GRBTOP   = $DE
DPTFLG   = $DE
LOWTR    = $DE
EXPSGN   = $DF
TENEXP   = $DD
EPSGN    = $DE
DSCTMP   = $E0
FAC      = $E0
FACEXP   = $E0
FACHO    = $E1
FACMOH   = $E2
INDICE   = $E2
FACMO    = $E3
FACLO    = $E4
FACSGN   = $E5
DEGREE   = $E6
SGNFLG   = $E7
BITS     = $E8
ARGEXP   = $E9
ARGHO    = $EA
ARGMOH   = $EB
ARGMO    = $EC
ARGLO    = $ED
ARGSGN   = $EE
STRNGI   = $EF
ARISGN   = $EF
FACOV    = $F0
BUFPTR   = $F1
STRNG2   = $F1
POLYPT   = $F1
CURTOL   = $F1
FBUFPT   = $F1
; $F3 free
; $F4-$FF monitor - DO NOT USE

; Stack page
QNUM     = $0100
CHRRTS   = $010A
RNDX     = $010B

; Float buffer
LOFBUF   = $01F0
FBUFFR   = $0100        ; Moved from $01F1 to avoid stack collision

; BASIC vectors
IERROR   = $0660
IMAIN    = $0662
ICRNCH   = $0664
IQPLOP   = $0666
IGONE    = $0668
IEVAL    = $066A
SAREG    = $030C
SXREG    = $030D
SYREG    = $030E
SPREG    = $030F
USRPOK   = $0310

; Aliases
STRNG1   = ARISGN
DESSION  = TEMPF2
FAESSION = TEMPF2
INTMEM   = STRNG2
TEMP3    = TEMPF1
TEMP4    = TEMPF2
FACOVER  = BITS
DPTS     = DEGREE
TENPTS   = SGNFLG
APTS2    = HIGHTR
APTS3    = HIGHTR+1
JESSION  = SIZE

; Error codes
ERRNF=10
ERRSN=11
ERRRET=12
ERRRG=ERRRET
ERROD=13
ERRFC=14
ERROV=15
ERROM=16
ERRUS=17
ERRBS=18
ERRDD=19
ERRDV0=20
ERRID=21
ERRTM=22
ERRLS=23
ERRBD=24
ERRST=25
ERRCN=26
ERRUF=27
ERVFY=28
ERLOAD=29
ERBRK=30

; Tokens
ENDTK=$80
FORTK=$81
NEXTTK=$82
DATATK=$83
INPUTTK=$84
DIMTK=$85
READTK=$86
LETTK=$87
GOTOTK=$88
RUNTK=$89
IFTK=$8A
RESTRTK=$8B
GOSUTK=$8C
RETTK=$8D
REMTK=$8E
STOPTK=$8F
ONTK=$90
PRINTTK=$99
PRINTK=$99
SCRATK=$A2
TABTK=$A3
TOTK=$A4
FNTK=$A5
SPCTK=$A6
THENTK=$A7
NOTTK=$A8
STEPTK=$A9
PLUSTK=$AA
MINUTK=$AB
GREATK=$B1
EQULTK=$B2
LESSTK=$B3
ONEFUN=$B4
LASNUM=$C7
GOTK=$CB
FORSIZ=18
LOWSAV   = $02A3         ; 2 bytes for LOWTR save in LIST
LNTEMP   = $02A5         ; 2 bytes for line number temp in LIST

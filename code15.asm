; === CODE15 ===
        STA INDEX1
        STX INDEX1+1
SVAR        CPX ARYTAB+1
        BNE SVARGO
        CMP ARYTAB
        BEQ ARYVAR
SVARGO        JSR DVARS
        BEQ SVAR
ARYVAR        STA ARYPNT
        STX ARYPNT+1
        LDA #STRSIZ
        STA FOUR6
ARYVA2        LDA ARYPNT
        LDX ARYPNT+1
ARYVA3        CPX STREND+1
        BNE ARYVGO
        CMP STREND
        BNE *+5
        JMP GRBPAS
ARYVGO        STA INDEX1
        STX INDEX1+1
        LDY #1-ADDPRC
        LDA (INDEX1),y
        TAX
        INY
        LDA (INDEX1),y
        PHP
        INY
        LDA (INDEX1),y
        ADC ARYPNT
        STA ARYPNT
        INY
        LDA (INDEX1),y
        ADC ARYPNT+1
        STA ARYPNT+1
        PLP
        BPL ARYVA2
        TXA
        BMI ARYVA2
        INY
        LDA (INDEX1),y
        LDY #0
        ASL A
        ADC #5
        ADC INDEX1
        STA INDEX1
        BCC ARYGET
        INC INDEX1+1
ARYGET        LDX INDEX1+1
ARYSTR        CPX ARYPNT+1
        BNE GOGO
        CMP ARYPNT
        BEQ ARYVA3
GOGO        JSR DVAR
        BEQ ARYSTR
DVARS        LDA (INDEX1),y
        BMI DVARTS
        INY
        LDA (INDEX1),y
        BPL DVARTS
        INY
DVAR        LDA (INDEX1),y
        BEQ DVARTS
        INY
        LDA (INDEX1),y
        TAX
        INY
        LDA (INDEX1),y
        CMP FRETOP+1
        BCC DVAR2
        BNE DVARTS
        CPX FRETOP
        BCS DVARTS
DVAR2        CMP GRBTOP+1
        BCC DVARTS
        BNE DVAR3
        CPX GRBTOP
        BCC DVARTS
DVAR3        STX GRBTOP
        STA GRBTOP+1
        LDA INDEX1
        LDX INDEX1+1
        STA GRBPNT
        STX GRBPNT+1
        LDA FOUR6
        STA SIZE
DVARTS        LDA FOUR6
        CLC
        ADC INDEX1
        STA INDEX1
        BCC GRBRTS
        INC INDEX1+1
GRBRTS        LDX INDEX1+1
        LDY #0
        RTS
GRBPAS        LDA GRBPNT+1
        ORA GRBPNT
        BEQ GRBRTS
        LDA SIZE
        AND #4
        LSR A
        TAY
        STA SIZE
        LDA (GRBPNT),y
        ADC LOWTR
        STA HIGHTR
        LDA LOWTR+1
        ADC #0
        STA HIGHTR+1
        LDA FRETOP
        LDX FRETOP+1
        STA HIGHDS
        STX HIGHDS+1
        JSR BLTUC
        LDY SIZE
        INY
        LDA HIGHDS
        STA (GRBPNT),y
        TAX
        INC HIGHDS+1
        LDA HIGHDS+1
        INY
        STA (GRBPNT),y
        JMP FNDVAR
CAT        LDA FACLO
        PHA
        LDA FACMO
        PHA
        JSR EVAL
        JSR CHKSTR
        PLA
        STA STRNG1
        PLA
        STA STRNG1+1
        LDY #0
        LDA (STRNG1),y
        CLC
        ADC (FACMO),y
        BCC SIZEOK
        LDX #ERRLS
        JMP ERROR
SIZEOK        JSR STRINI
        JSR MOVINS
        LDA DSCPNT
        LDY DSCPNT+1
        JSR FRETMP
        JSR MOVDO
        LDA STRNG1
        LDY STRNG1+1
        JSR FRETMP
        JSR PUTNEW
        JMP TSTOP
MOVINS        LDY #0
        LDA (STRNG1),y
        PHA
        INY

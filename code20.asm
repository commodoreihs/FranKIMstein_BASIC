; === CODE20 ===
MOVFR        LDA RESHO
        STA FACHO
        LDA RESMOH
        STA FACMOH
        LDA RESMO
        STA FACMO
        LDA RESLO
        STA FACLO
        JMP NORMAL
MOVFM        STA INDEX1
        STY INDEX1+1
        LDY #3+ADDPRC
        LDA (INDEX1),y
        STA FACLO
        DEY
        LDA (INDEX1),y
        STA FACMO
        DEY
        LDA (INDEX1),y
        STA FACMOH
        DEY
        LDA (INDEX1),y
        STA FACSGN
        ORA #$80
        STA FACHO
        DEY
        LDA (INDEX1),y
        STA FACEXP
        STY FACOV
        RTS   
MOV2F        LDX #TEMPF2
        .byte $2C
MOV1F        LDX #TEMPF1
        LDY #0
        BEQ MOVMF
MOVVF        LDX FORPNT
        LDY FORPNT+1
MOVMF        JSR ROUND
        STX INDEX1
        STY INDEX1+1
        LDY #3+ADDPRC
        LDA FACLO
        STA (INDEX),y
        DEY
        LDA FACMO
        STA (INDEX),y
        DEY
        LDA FACMOH
        STA (INDEX),y
        DEY
        LDA FACSGN
        ORA #$7F
        AND FACHO
        STA (INDEX),y
        DEY
        LDA FACEXP
        STA (INDEX),y
        STY FACOV
        RTS
MOVFA        LDA ARGSGN
MOVFA1        STA FACSGN
        LDX #4+ADDPRC
MOVFAL        LDA ARGEXP-1,X
        STA FACEXP-1,X
        DEX
        BNE MOVFAL
        STX FACOV
        RTS
MOVAF        JSR ROUND
MOVEF        LDX #5+ADDPRC
MOVAFL        LDA FACEXP-1,X
        STA ARGEXP-1,X
        DEX
        BNE MOVAFL
        STX FACOV
MOVRTS        RTS
ROUND        LDA FACEXP
        BEQ MOVRTS
        ASL FACOV
        BCC MOVRTS
INCRND        JSR INCFAC
        BNE MOVRTS
        JMP RNDSHF
SIGN        LDA FACEXP
        BEQ SIGNRT
FCSIGN        LDA FACSGN
FCOMPS        ROL A
        LDA #$FF
        BCS SIGNRT
        LDA #1
SIGNRT        RTS
SGN        JSR SIGN
FLOAT        STA FACHO
        LDA #0
        STA FACHO+1
        LDX #$88
FLOATS        LDA FACHO
        EOR #$FF
        ROL A
FLOATC        LDA #0
        STA FACLO
        STA FACMO
FLOATB        STX FACEXP
        STA FACOV
        STA FACSGN
        JMP FADFLT
ABS        LSR FACSGN
        RTS
FCOMP        STA INDEX2
FCOMPN        STY INDEX2+1
        LDY #0
        LDA (INDEX2),y
        INY
        TAX
        BEQ SIGN
        LDA (INDEX2),y
        EOR FACSGN
        BMI FCSIGN
        CPX FACEXP
        BNE FCOMPC
        LDA (INDEX2),y
        ORA #$80
        CMP FACHO
        BNE FCOMPC
        INY
        LDA (INDEX2),y
        CMP FACMOH
        BNE FCOMPC
        INY
        LDA (INDEX2),y
        CMP FACMO
        BNE FCOMPC
        INY
        LDA #$7F
        CMP FACOV
        LDA (INDEX2),y
        SBC FACLO
        BEQ QINTRT
FCOMPC        LDA FACSGN
        BCC FCOMPD
        EOR #$FF
FCOMPD        JMP FCOMPS

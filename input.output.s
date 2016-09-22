********************************
* Input/Output Routines        *
* Uses: IO.MAC                 *
********************************

* External references
           ; jewel.of.kaldun.s
DATA       EXT

********************************
* Turn on text screen.         *
********************************

TEXT        ENT
            STA     $C056
            STA     $C054
            STA     $C051
            RTS

********************************
* Routine to pause for RETURN  *
* to be pressed.               *
********************************

GETRET      ENT
            LDA     #23
            STA     TLINE
            JSR     TEXTADDR
            LDA     ESCABORT
            BMI     :ESCCR
            CENTER  GRSTR
            JMP     :XXX
:ESCCR      MOVB    #0;TTAB
            PRINT   ESCCRSTR
:XXX        JSR     M:GETKEY
            BIT     ESCABORT
            BPL     :YYY
            CMP     #$9B        ; ESCAPE
            BEQ     :EXIT
:YYY        CMP     #$8D        ; RETURN
            BNE     :XXX
:EXIT       LDA     #23
            STA     TLINE
            JSR     TEXTADDR
            LDA     KEYBOARD
            CMP     #$9B
            BNE     :LEAVE
            PLA                 ; CLEAR STACK OF ADDRESS
            PLA
:LEAVE      LDA     #%00000000
            STA     ESCABORT
            STA     KEYSTROB    ; clear keypress
            JMP     CLINE
ESCABORT    HEX     00
GRSTR       ASC     "Press <RETURN> to continue"00
ESCCRSTR    ASC     "<RETURN> to continue or <ESCAPE> to stop"00

********************************
* Routine to wait for a Y or   *
* a N.                         *
********************************

GETYN       JSR     M:GETKEY
            CMP     #"Y"
            BEQ     :YES
            CMP     #"y"
            BEQ     :YES
            CMP     #"n"
            BEQ     :NO
            CMP     #"N"
            BNE     GETYN
:NO         SEC
            RTS
:YES        CLC
            RTS

********************************
* Routine to center a string.  *
********************************

CSTRING     ENT
            LDY     #0
:0          LDA     (DATA),Y
            BEQ     :FINISH
            CMP     #$8D
            BEQ     :FINISH
            INY
            BNE     :0
:FINISH     TYA
            LSR
            STA     TEMP
            SEC
            LDA     #20
            SBC     TEMP
            STA     TTAB
            JSR     PRSTR

********************************
* Print a carriage return.     *
********************************

PRCR        INC     TLINE
            JSR     TEXTADDR
            LDY     #0
            STY     TTAB
            LDA     TLINE
            CMP     #24
            BCC     END1
            STY     TLINE
END1        RTS

********************************
* The following routine(s)     *
* handle printing with special *
* control characters:          *
*                              *
*   ^I ($89)  Inverse mode     *
*   ^N ($8E)  Normal mode      *
*   ^M ($8D)  Carriage Return  *
*   ^@ ($80)  Print Hex number *
*             that is stored   *
*             at the pointer   *
*             location in Dec. *
*   ^A ($81)  Print Hex WORD   *
*             that is stored   *
*             at the pointer   *
*             location in Dec. *
*   ^B ($82)  To clear bottom  *
*             3 lines.         *
*   ^C ($83)  To center the    *
*             following line   *
*             of text on scrn. *
*   %00xxxxxx Htab + 1         *
*   %01xxxxxx Vtab             *
*                              *
* All other characters lower   *
* than a SPACE ($A0) are       *
* ignored.                     *
********************************

* MASK byte and PTR increment routine:

MASK        HEX     FF
DATAINC     INC     DATA
            BNE     END2
            INC     DATA+1
END2        RTS

* This is the Print routine:

PRSTR       ENT
            LDY     #0
            LDA     (DATA),Y
            BEQ     END2
            BMI     :0
            CMP     #%00111111
            BGE     :VTAB
            STA     TTAB
            DEC     TTAB
:NEXT       JSR     DATAINC
            JMP     PRSTR
:VTAB       AND     #%00111111
:V0         STA     TLINE
            JSR     TEXTADDR
            BCC     :NEXT
            LDA     #0
            BEQ     :V0
:0          CMP     #$89
            BNE     :1
            LDA     #%00111111
:MASK       STA     MASK
            BNE     :NEXT
:1          CMP     #$8E
            BNE     :2
            LDA     #%11111111
            BNE     :MASK
:2          CMP     #$8D
            BNE     :3
:NEWLINE    JSR     PRCR
            JMP     :NEXT
:3          CMP     #$80
            BNE     :4
            JSR     DATAINC
            LDA     (DATA),Y
            STA     PTR
            JSR     DATAINC
            LDA     (DATA),Y
            STA     PTR+1
            JSR     CONVERT
            JMP     :NEXT
:4          CMP     #$83
            BNE     :5
            LDY     #1          ; pass #$83
:40         LDA     (DATA),Y
            CMP     #$A0
            BLT     :41
            INY
            BNE     :40
:41         TYA
            LSR
            STA     TEMP
            SEC
            LDA     #20
            SBC     TEMP
            STA     TTAB
            JMP     :NEXT
:5          CMP     #$82
            BNE     :6
            JSR     CBOT3
            JMP     :NEXT
:6          CMP     #$81
            BNE     :7
            JSR     DATAINC
            LDA     (DATA),Y
            STA     PTR
            JSR     DATAINC
            LDA     (DATA),Y
            STA     PTR+1
            JSR     CONVWORD
            JMP     :NEXT
:7          CMP     #$A0
            BLT     :NEXTPTR
            BIT     AUTOCAPS
            BPL     :GO
            JSR     CHARCAPS    ; capitalize letter
:GO         LDY     TTAB
            AND     MASK
            STA     (TPTR),Y
            STA     SPEAKER
            INY
            STY     TTAB
            CPY     #40
            BLT     :NEXTPTR
            LDY     #0
            STY     TTAB
:NEXTPTR    JMP     :NEXT
AUTOCAPS    HEX     00          ; default: Mixed mode

********************************
* CLINE clears the current     *
* line pointed to by TPTR.     *
********************************

CLINE       LDY     #40
            LDA     #$A0
:0          STA     (TPTR),Y
            DEY
            BPL     :0
            RTS

********************************
* CLRMID clears middle portion *
* of text screen.  Lines 1-22. *
* (line 0 = vtab 1)            *
********************************

CLRMID      ENT
            LDA     #22
            STA     TLINE
:0          JSR     TEXTADDR
            JSR     CLINE
            DEC     TLINE
            BNE     :0
            RTS

********************************
* CBOT3 clears the bottom      *
* three (3) lines of the text  *
* screen.                      *
********************************

CBOT3       ENT
            LDA     #21
            BNE     CLRSCRN0

********************************
* Clears the text screen.      *
********************************

CLRSCRN     ENT
            LDA     #0
CLRSCRN0    STA     TLINE
:0          JSR     TEXTADDR
            BCS     END0
            JSR     CLINE
            INC     TLINE
            JMP     :0

********************************
* TEXTADDR uses the lookup     *
* tables to find the address   *
* of the line number stored in *
* TLINE.                       *
********************************

TEXTADDR    ENT
            LDA     TLINE
            CMP     #24
            BGE     END0
            TAY
            LDA     TEXTLOW,Y
            STA     TPTR
            LDA     TEXTHIGH,Y
            STA     TPTR+1
            CLC
END0        RTS

********************************
* The lookup tables for the    *
* text screen:                 *
********************************

TEXTLOW     HEX     0080008000800080
            HEX     28A828A828A828A8
            HEX     50D050D050D050D0
TEXTHIGH    HEX     0404050506060707
            HEX     0404050506060707
            HEX     0404050506060707

********************************
* Sets inverse status line and *
* clears last three lines of   *
* text screen.                 *
********************************

STATLINE    PRINT   STATTEXT
            JSR     CBOT3
            LDA     #21
            STA     TLINE
            JSR     TEXTADDR
            RTS
STATTEXT    HEX     015489      ; htab 1:vtab 21:inverse
            ASC     "                             KY HP XP GP"
            HEX     8E00        ; normal


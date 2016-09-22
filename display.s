********************************
* Display map routines:        *
********************************

* Default values:

WSCREEN     =      24
HSCREEN     =      20
WMAP        =      48
HMAP        =      32

********************************
* Get the value of map @ (x,y) *
********************************

MAPINDEX    DEX
            DEY
            STX    XOFF
            STY    YOFF
            LDA    #0
            STA    XOFF+1
            STA    YOFF+1
            LDA    MAPSW
            BMI    :NOMONS
*-------------------------------
            LDY    #0
:REPEAT     LDA    M_HP,Y           ; if HP = 0, no monster at this
            BEQ    :CHECK           ;   location.
            LDA    M_LEVEL,Y        ; check if monster is on the
            CMP    MAPADDR+1        ;   correct level
            BNE    :CHECK
            LDA    M_X,Y            ; check x-coordinate against
            CMP    XOFF             ;   map x-coordinate.
            BNE    :CHECK
            LDA    M_Y,Y            ; check y-coordinate
            CMP    YOFF
            BNE    :CHECK
            LDA    XOFF             ; ensure that map x and map y
            ORA    YOFF             ;   are not both 0 (no monster)
            BEQ    :CHECK
            LDA    M_TYPE,Y         ; get the monster type!
            STY    MAP_MNUM
            RTS                     ; have mons type, so exit
:CHECK      INY
            CPY    #MONSMAX
            BLT    :REPEAT
*-------------------------------
:NOMONS     IMULW  YOFF;#WMAP;PTR
            ADDW   PTR;MAPADDR;PTR
            LDY    XOFF
            LDA    (PTR),Y
            RTS
MAP_MNUM    HEX    00

********************************
* Update Screen                *
********************************

UPSCREEN    MOVB   X0;AX
            MOVB   Y0;AY
            MOVB   CX;X0
            MOVB   CY;Y0
            MOVB   CX;X1
            MOVB   CY;Y1
            LDA    #%10000000
            STA    CLRFLAG
            LDA    #%00000000
            STA    XORFLAG
:0          LDA    Y0
            CMP    #2
            BLT    :1
            DEC    Y0
            LDX    CX
            LDY    Y0
            JSR    MAPCHECK
            BCC    :0
:1          LDA    X0
            CMP    #2
            BLT    :2
            DEC    X0
            LDX    X0
            LDY    CY
            JSR    MAPCHECK
            BCC    :1
:2          LDA    X1
            CMP    #WMAP+1
            BGE    :3
            INC    X1
            LDX    X1
            LDY    CY
            JSR    MAPCHECK
            BCC    :2
:3          LDA    Y1
            CMP    #HMAP+1
            BGE    :4
            INC    Y1
            LDX    CX
            LDY    Y1
            JSR    MAPCHECK
            BCC    :3
:4          SEC
            LDA    Y1
            SBC    Y0
            CMP    #HSCREEN-1
            BLT    :5
            SEC
            LDA    CY
            SBC    Y0
            STA    TEMP0
            SEC
            LDA    Y1
            SBC    CY
            CMP    TEMP0
            BLT    :40
            DEC    Y1
            JMP    :4
:40         INC    Y0
            JMP    :4
:5          SEC
            LDA    X1
            SBC    X0
            CMP    #WSCREEN-1
            BLT    :6
            SEC
            LDA    CX
            SBC    X0
            STA    TEMP0
            SEC
            LDA    X1
            SBC    CX
            CMP    TEMP0
            BLT    :50
            DEC    X1
            JMP    :5
:50         INC    X0
            JMP    :5
:6          SUBB   X1;X0;WX
            SUBB   Y1;Y0;WY
            LDA    WX
            LSR
            STA    ZX
            SEC
            LDA    #WSCREEN/2
            SBC    ZX
            STA    ZX
            LDA    WY
            LSR
            STA    ZY
            SEC
            LDA    #HSCREEN/2
            SBC    ZY
            STA    ZY
            LDA    OX
            ORA    OY
            BPL    :7
            MOVB   ZX;OX
            MOVB   ZY;OY
            JSR    HCLEAR
            JMP    :8
:7          LDA    #%10000000       ; to erase old picture
            STA    XORFLAG          ; of Meltok ...
            LDA    #%00000000
            STA    CLRFLAG
            MOVB   #2;SNUM
            LDA    CH:X+1           ; Should be current location
            LDX    CH:X             ; of Meltok on screen.
            LDY    CH:Y             ; Including "sliding" movement.
            JSR    DRAWSHAP         ; Draw it
            LDA    #%00000000       ; Clear reverse flag
            STA    XORFLAG          ; Done.
            LDA    #%10000000
            STA    CLRFLAG
            SUBB   AX;X0;DX
            SUBB   AY;Y0;DY
            SUBB   OX;DX;NX
            SUBB   OY;DY;NY
:70         LDA    NX
            BPL    :71
            JSR    HRIGHT
            INC    NX
            JMP    :70
:71         LDA    NY
            BPL    :72
            JSR    HDOWN
            INC    NY
            JMP    :71
:72         CLC
            LDA    NY
            ADC    WY
            CMP    #19
            BLT    :73
            JSR    HUP
            DEC    NY
            JMP    :72
:73         CLC
            LDA    NX
            ADC    WX
            CMP    #24
            BLT    :74
            JSR    HLEFT
            DEC    NX
            JMP    :73
:74         MOVB   NX;ZX
            MOVB   NY;ZY
            MOVB   ZX;OX
            MOVB   ZY;OY
:8          MOVB   Y0;TEMPY
:_NEXTY     MOVB   X0;TEMPX
:_NEXTX     LDY    TEMPY
            LDX    TEMPX
            JSR    MAPINDEX
            CMP    #15              ; show monsters too!
            BLT    :SHGOOD
            CMP    #98
            BNE    :NEXTSH1
            LDA    #1
            JMP    :SHGOOD
:NEXTSH1    CMP    #99
            BNE    :NEXTSH2
            LDA    #6
            JMP    :SHGOOD
:NEXTSH2    CMP    #97
            BNE    :NEXTSH3
            LDA    #4
            JMP    :SHGOOD
:NEXTSH3    CMP    #100
            BLT    :NEXTSH4
            LDA    #0
            JMP    :SHGOOD
:NEXTSH4    CMP    #22              ; barred door
            BEQ    :SHGOOD
:NEXTSH5    LDA    #15              ; circle -- for errors
:SHGOOD     STA    SNUM
            NILB   XPLACE+1
            NILB   YPLACE+1
            MOVB   ZX;XPLACE
            MOVB   ZY;YPLACE
            LDY    #3
:MUL8       ASL    XPLACE
            ROL    XPLACE+1
            ASL    YPLACE
            ROL    YPLACE+1
            DEY
            BNE    :MUL8
            LDA    SNUM
            CMP    #12
            BLT    :MOREYET
            CMP    #14+1
            BGE    :MOREYET
            LDY    MAP_MNUM
            LDA    YPLACE
            STA    M_Y0,Y
            LDA    XPLACE
            STA    M_X0,Y
            LDA    XPLACE+1
            STA    M_X1,Y
:MOREYET    LDY    YPLACE
            LDX    XPLACE
            LDA    XPLACE+1
            JSR    DRAWSHAP
            LDA    TEMPX
            CMP    CX
            BNE    :99
            LDA    TEMPY
            CMP    CY
            BNE    :99
            LDA    #%00000000
            STA    CLRFLAG
            LDA    #%10000000
            STA    XORFLAG
            MOVB   #2;SNUM
            LDY    YPLACE
            LDX    XPLACE
            LDA    XPLACE+1
            JSR    DRAWSHAP
            MOVW   XPLACE;CH:X
            MOVW   YPLACE;CH:Y
            LDA    #%00000000
            STA    XORFLAG
            LDA    #%10000000
            STA    CLRFLAG
:99         INC    ZX
            INC    TEMPX
            LDA    TEMPX
            CMP    #WMAP
            BEQ    :9999
            BGE    :100
:9999       CMP    X1
            BLT    :NEXTX
            BEQ    :NEXTX
:100        SUBB   ZX;WX;ZX
            DEC    ZX
            INC    ZY
            INC    TEMPY
            LDA    TEMPY
            CMP    #HMAP
            BEQ    :1111
            BGE    :EXIT
:1111       CMP    Y1
            BLT    :NEXTY
            BEQ    :NEXTY
            JMP    :EXIT
:NEXTY      JMP    :_NEXTY
:NEXTX      JMP    :_NEXTX
:EXIT       RTS

********************************
* Map Check verifies that the  *
* check square is valid to     *
* see through.                 *
********************************
MAPSW       HEX    00
MAPCHECK    LDA    #$80             ; special switch to ignore the
            STA    MAPSW            ;   monsters!
            JSR    MAPINDEX         ; get data
            PHA                     ; save data
            LDA    #0               ; reset switch to normal
            STA    MAPSW            ;   ...
            PLA                     ; restore data and work with it:
            CMP    #99
            BGE    :GOOD
            CMP    #0
            BEQ    :GOOD
            CMP    #6
            BLT    :BAD
            CMP    #12              ; for monsters #12-#14
            BGE    :BAD
:GOOD       CLC
            RTS
:BAD        SEC
            RTS


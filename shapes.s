* External references
           ; jewel.of.kaldun.s
;DATA       EXT

********************************
* Jewel of Kaldun shape        *
* drawing routines.            *
* Uses:  GRAPHICS              *
*        MATH                  *
*        MATH.MAC              *
*        GENERAL.MAC           *
********************************

SHTABLE     DFB       %00000000             ; Shape #0: Blank space
            DFB       %00000000
            DFB       %00000000
            DFB       %00000000
            DFB       %00000000
            DFB       %00000000
            DFB       %00000000
            DFB       %00000000

            DFB       %11111111             ; Shape #1: Wall
            DFB       %11111111
            DFB       %11111111
            DFB       %11111111
            DFB       %11111111
            DFB       %11111111
            DFB       %11111111
            DFB       %11111111

            DFB       %00111100             ; Shape #2: Meltok
            DFB       %00111100
            DFB       %00011000
            DFB       %11111111
            DFB       %00011000
            DFB       %00111100
            DFB       %00100100
            DFB       %01100110

            DFB       %11111111             ; Shape #3: Door (unlocked)
            DFB       %11111111
            DFB       %11100111
            DFB       %11000011
            DFB       %11000011
            DFB       %11000011
            DFB       %11000011
            DFB       %11000011

            DFB       %11111111             ; Shape #4: Locked Door
            DFB       %11111111
            DFB       %11100111
            DFB       %11000011
            DFB       %11000011
            DFB       %11010011
            DFB       %11000011
            DFB       %11000011

            DFB       %11111111             ; Shape #5: Secret Door (found)
            DFB       %11100111
            DFB       %11011011
            DFB       %11011011
            DFB       %11011011
            DFB       %11011011
            DFB       %11011011
            DFB       %11011011

            DFB       %00000000             ; Shape #6: Chest
            DFB       %00000000
            DFB       %00111100
            DFB       %01100110
            DFB       %01111110
            DFB       %01100110
            DFB       %01100110
            DFB       %01111110

            DFB       %00000000             ; Shape #7: Opened Chest
            DFB       %00001100
            DFB       %00000110
            DFB       %00000110
            DFB       %01111110
            DFB       %01100110
            DFB       %01100110
            DFB       %01111110

            DFB       %00000000             ; Shape #8: Ladder
            DFB       %01100110
            DFB       %01111110
            DFB       %01100110
            DFB       %01111110
            DFB       %01100110
            DFB       %01111110
            DFB       %01100110

            DFB       %00000000             ; Shape #9: Throne
            DFB       %00000110
            DFB       %00000110
            DFB       %00000110
            DFB       %01111110
            DFB       %01100110
            DFB       %01100110
            DFB       %01100110

            DFB       %00011000             ; Shape #10: Jewel of Kaldun
            DFB       %00111100
            DFB       %00111100
            DFB       %00011000
            DFB       %11000011
            DFB       %01111110
            DFB       %00011000
            DFB       %00111100

            DFB       %00000000             ; Shape #11: Empty Holder
            DFB       %00000000             ;       (Jewel of Kaldun gone)
            DFB       %00000000
            DFB       %00000000
            DFB       %11000011
            DFB       %01111110
            DFB       %00011000
            DFB       %00111100

            DFB       %00000000             ; Shape #12: Ghost
            DFB       %00111100
            DFB       %01111110
            DFB       %01101010
            DFB       %01111110
            DFB       %01111110
            DFB       %01011010
            DFB       %00000000

            DFB       %00000000             ; Shape #13: Blob
            DFB       %01100110
            DFB       %00101100
            DFB       %00111100
            DFB       %01111110
            DFB       %01010110
            DFB       %01000100
            DFB       %00000000

            DFB       %00000000             ; Shape #14: Zombie
            DFB       %00011000
            DFB       %01111110
            DFB       %00011000
            DFB       %00111100
            DFB       %01100110
            DFB       %01100110
            DFB       %00000000

            DFB       %00000000             ; Shape #15: Circle
            DFB       %00111100
            DFB       %01111110
            DFB       %01111110
            DFB       %01111110
            DFB       %01111110
            DFB       %00111100
            DFB       %00000000

            DFB       %00000000             ; Shape #16: Dot
            DFB       %00000000
            DFB       %00000000
            DFB       %00011000
            DFB       %00011000
            DFB       %00000000
            DFB       %00000000
            DFB       %00000000

            DFB       %10101010             ; Shape #17: Half wall (fade-in)
            DFB       %01010101
            DFB       %10101010
            DFB       %01010101
            DFB       %10101010
            DFB       %01010101
            DFB       %10101010
            DFB       %01010101

            DFB       %01010101             ; Shape #18: Half wall (fade-in)
            DFB       %10101010
            DFB       %01010101
            DFB       %10101010
            DFB       %01010101
            DFB       %10101010
            DFB       %01010101
            DFB       %10101010

            DFB       %01111111             ; Shape #19: Letter "R"
            DFB       %11000011
            DFB       %11000011
            DFB       %11000011
            DFB       %01111111
            DFB       %00110011
            DFB       %01100011
            DFB       %11000011

            DFB       %11111111             ; Shape #20: Letter "I"
            DFB       %00011000
            DFB       %00011000
            DFB       %00011000
            DFB       %00011000
            DFB       %00011000
            DFB       %00011000
            DFB       %11111111

            DFB       %01111111             ; Shape #21: Letter "P"
            DFB       %11000011
            DFB       %11000011
            DFB       %11000011
            DFB       %01111111
            DFB       %00000011
            DFB       %00000011
            DFB       %00000011

            DFB       %11111111             ; Shape #22: Barred Door
            DFB       %11111111
            DFB       %11100111
            DFB       %11000011
            DFB       %11111111
            DFB       %11000011
            DFB       %11111111
            DFB       %11000011

********************************
* Shape draw variables         *
********************************

XOFFSET     HEX       0000
XLOC        HEX       0000
YLOC        HEX       00
SNUM        ENT
            HEX       0000
DRAWREP     HEX       00
CLRFLAG     ENT
            DFB       %10000000             ; flag for clearing background
XORFLAG     ENT
            DFB       %00000000             ; flag to XOR with background
BITMASK     DFB       %01111111,%00111111   ; bits to keep for
            DFB       %00011111,%00001111   ; offset values
            DFB       %00000111,%00000011
            DFB       %00000001
BITABLE1    DFB       %00000000,%00000001   ; bits to keep in 1st
            DFB       %00000011,%00000111   ; graphic byte
            DFB       %00001111,%00011111
            DFB       %00111111
BITABLE2    DFB       %01111110,%01111100   ; bits to keep in 2nd
            DFB       %01111000,%01110000   ; graphicbyte
            DFB       %01100000,%01000000
            DFB       %00000000

********************************
* Draw a shape routine.  Upon  *
* entry:                       *
*     X-axis: AAXX             *
*     Y-axis: YY               *
*  Shape Num: preset           *
********************************

DRAWSHAP    ENT
            STA       XLOC+1                ; save entry values:
            STX       XLOC                  ;   xval = XXAA
            STY       YLOC                  ;   yval = YY
            STY       HLINE
            IMULW     #8;SNUM;DATA
            ADDW      DATA;#SHTABLE;DATA
            IDIVMODW  XLOC;#7;XLOC;XOFFSET  ; calc offset(s)
            MOVB      #8;DRAWREP
:REPEAT     JSR       HADDR
            LDX       XOFFSET
            LDY       XLOC
            CPY       #40
            BGE       :SECOND
            BIT       CLRFLAG
            BPL       :20
            LDA       BITABLE1,X
            AND       (HPTR),Y
            STA       (HPTR),Y
:20         LDY       #0
            LDA       BITMASK,X
            STA       BITSTORE
            AND       (DATA),Y
            LDX       XOFFSET
:10         CPX       #0
            BEQ       :11
            ASL
            DEX
            JMP       :10
:11         LDY       XLOC
            BIT       XORFLAG
            BMI       :2X1
            ORA       (HPTR),Y
            JMP       :2X2
:2X1        EOR       (HPTR),Y
:2X2        STA       (HPTR),Y
:SECOND     LDX       XOFFSET
            LDY       XLOC
            INY
            CPY       #40
            BGE       :NOTGOOD
            BIT       CLRFLAG
            BPL       :30
            LDA       BITABLE2,X
            AND       (HPTR),Y
            STA       (HPTR),Y
:30         LDY       #0
            LDA       BITSTORE
            EOR       #%11111111
            AND       (DATA),Y
            LDX       XOFFSET
:0          CPX       #7
            BGE       :1
            LSR
            INX
            JMP       :0
:1          LDY       XLOC
            INY
            BIT       XORFLAG
            BMI       :3X1
            ORA       (HPTR),Y
            JMP       :3X2
:3X1        EOR       (HPTR),Y
:3X2        STA       (HPTR),Y
:NOTGOOD    INC       DATA
            BNE       :2
            INC       DATA+1
:2          INC       HLINE
            DEC       DRAWREP
            BNE       :REPEATX
            RTS
:REPEATX    JMP       :REPEAT
BITSTORE    HEX       00

* NOTE: This is a hack.  -8 is treated as 8 bites by Merlin32; 
*       thus the MOVW is in error.  Using the value of $FFF8 
*       because my trusty PC calculator tells me that is correct. :-)
ARRIVEC2    MOVW      #$FFF8;XMELTOK
            MOVB      #2;SNUM
            LDA       #%00000000
            STA       CLRFLAG
            LDA       #%10000000
            STA       XORFLAG
:REPEAT     LDY       #151
            LDA       XMELTOK+1
            LDX       XMELTOK
            JSR       DRAWSHAP
            LDA       #70
            JSR       WAIT
            LDY       #151
            LDA       XMELTOK+1
            LDX       XMELTOK
            JSR       DRAWSHAP
            INC       XMELTOK
            BNE       :1
            INC       XMELTOK+1
:1          LDA       XMELTOK+1
            CMP       #>71
            BNE       :REPEAT
            LDA       XMELTOK
            CMP       #<71
            BNE       :REPEAT
            BEQ       COMMONCX

XMELTOK     HEX       0000

LEAVEC1     MOVW      #131;XMELTOK
            MOVB      #2;SNUM
            LDA       #%00000000
            STA       CLRFLAG
            LDA       #%10000000
            STA       XORFLAG
:REPEAT     LDY       #151
            LDA       XMELTOK+1
            LDX       XMELTOK
            JSR       DRAWSHAP
            LDA       #70
            JSR       WAIT
            LDY       #151
            LDA       XMELTOK+1
            LDX       XMELTOK
            JSR       DRAWSHAP
            INC       XMELTOK
            BNE       :1
            INC       XMELTOK+1
:1          LDA       XMELTOK+1
            CMP       #>280
            BNE       :REPEAT
            LDA       XMELTOK
            CMP       #<280
            BNE       :REPEAT
COMMONCX    LDY       #151
            LDX       XMELTOK
            LDA       XMELTOK+1
            JSR       DRAWSHAP
            LDA       #%10000000
            STA       CLRFLAG
            LDA       #%00000000
            STA       XORFLAG
            RTS


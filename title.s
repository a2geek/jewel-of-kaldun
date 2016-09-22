********************************
* Jewel of Kaldun title page.  *
* Uses:  MATH.MAC              *
*        MATH                  *
*        SHAPES                *
*        GENERAL.MAC           *
*        GRAPHICS              *
********************************

TITLEPG     JSR    SETHGR
            STA    $C052               ; full page graphics
            JSR    DRAWBKGD
            LDY    #15
:PAUSE      LDX    ROL_CTR
            INC    ROL_CTR
            LDA    ROL_CTR,X
            TAX
:XXX        DEX
            BNE    :XXX
            STA    SPEAKER
            DEY
            BNE    :PAUSE
            JSR    ROLJEWEL
            LDA    #%00000000
            STA    CLRFLAG
            STA    XORFLAG

DRAWLETS    MOVW   #TTABLE;PTR
:PREPARE    LDY    #0
            LDA    (PTR),Y
            BNE    :GO
            JMP    :FINISHD
:GO         STA    TITINCR
            JSR    PTRINC
            LDA    (PTR),Y
            STA    SNUM
            JSR    PTRINC
            LDA    (PTR),Y
            STA    TITLECTR
            JSR    PTRINC
            LDA    (PTR),Y
            STA    TITDELAY
            JSR    PTRINC
            LDA    (PTR),Y
            STA    TITX
            LDA    #0
            STA    TITX+1
            JSR    PTRINC
            LDA    (PTR),Y
            STA    TITY
            JSR    PTRINC
            IMULW  TITINCR;TITX;TITX
            IMULW  TITINCR;TITY;TITY
            JMP    :START
:LOOP       MOVB   TITINCR;LINECTR
            LDY    #0
            LDA    (PTR),Y
            STA    DIRX
            JSR    PTRINC
            LDA    (PTR),Y
            STA    DIRY
            JSR    PTRINC
:DRAW       LDA    TITX+1
            LDX    TITX
            LDY    TITY
            JSR    DRAWSHAP
            LDA    DIRX
            CMP    #-1
            BEQ    :XDEC
            CLC
            ADC    TITX
            STA    TITX
            BNE    :YTEST
            INC    TITX+1
            JMP    :YTEST
:XDEC       DEC    TITX
            LDA    TITX
            CMP    #-1
            BNE    :YTEST
            DEC    TITX+1
:YTEST      LDA    DIRY                ; y is only 1 byte
            CLC
            ADC    TITY
            STA    TITY
            DEC    LINECTR
            BNE    :DRAW
:START      DEC    TITLECTR
            BNE    :LOOP
            JMP    :PREPARE
:FINISHD    LDA    #%10000000
            STA    CLRFLAG
            RTS

WAIT        ENT
            SEC
:1          PHA
:0          SBC    #1
            BNE    :0
            PLA
            SBC    #1
            BNE    :1
            RTS

PTRINC      INC    PTR
            BNE    :0
            INC    PTR+1
:0          RTS

TITLECTR    HEX    00
LINECTR     HEX    00
TITX        HEX    0000
TITY        HEX    0000
DIRX        HEX    00
DIRY        HEX    00
TITINCR     HEX    0000
TITDELAY    HEX    00

********************************
* Table of (x,y) on a 35x20    *
* grid for title page.         *
********************************

TTABLE      DFB    2,16,41             ; "the", 39 points, 2x2
            DFB    100,17,4            ; beginning
            DFB    0,1,0,1,0,1,0,1,0,1,1,1,1,0,1,-1,1,-1,0,-1,0,-1
            DFB    0,-1,0,-1,0,1,0,1,0,1,0,1,0,1,0,1,0,-1,0,-1
            DFB    0,-1,1,-1,1,0,1,1,0,1,0,1,1,1,1,0,1,-1,1,-1
            DFB    1,-1,-1,-1,-1,0,-1,1,0,1,0,1,1,1,1,0,1,0
            DFB    2,16,4              ; cross the "t", 2x2, 4 pts
            DFB    100,16,6
            DFB    1,0,1,0,1,0
            DFB    8,15,11             ; "J", 11 points, 8x8
            DFB    50,6,6              ; beginning (x,y)
            DFB    1,1,1,0,1,0,1,-1,0,-1,0,-1,0,-1,0,-1,0,-1,-1,0
            DFB    8,15,15             ; "e", 15 points, 8x8
            DFB    50,12,5
            DFB    1,0,1,0,1,0,0,-1,-1,-1,-1,0,-1,0,-1,1,0,1,0,1
            DFB    1,1,1,0,1,0,1,0
            DFB    8,15,13             ; "w", 13 points, 8x8
            DFB    50,16,3
            DFB    0,1,0,1,0,1,1,1,1,-1,0,-1,0,1,1,1,1,-1,0,-1
            DFB    0,-1,0,-1
            DFB    8,15,15             ; "e", 15 points, 8x8
            DFB    50,22,5
            DFB    1,0,1,0,1,0,0,-1,-1,-1,-1,0,-1,0,-1,1,0,1,0,1
            DFB    1,1,1,0,1,0,1,0
            DFB    8,15,11             ; "l", 11 points, 8x8
            DFB    50,26,1
            DFB    1,0,0,1,0,1,0,1,0,1,0,1,-1,1,1,0,1,0,-1,-1
            DFB    2,16,41             ; "of", 44 pts, 2x2
            DFB    100,111,4
            DFB    1,1,1,0,1,-1,1,0,-1,0,-1,1,0,1,0,1,1,1
            DFB    1,0,1,0,1,-1,0,-1,0,-1,-1,-1,1,1,1,1,1,1,1,0
            DFB    1,-1,0,-1,0,-1,0,-1,-1,-1,-1,1,0,1,0,1
            DFB    0,1,0,1,0,1,0,1,0,1,1,1,1,-1,0,-1,0,-1,-1,-1
            DFB    1,0,1,0,1,-1
            DFB    8,15,7              ; "K", left line, 8x8
            DFB    50,4,9
            DFB    0,1,0,1,0,1,0,1,0,1,0,1
            DFB    8,15,7              ; "K", finish it off, 8x8
            DFB    50,7,9
            DFB    -1,1,-1,1,-1,1,1,1,1,1,1,1
            DFB    8,15,14             ; "a", 14 points, 8x8
            DFB    50,9,11
            DFB    1,0,1,0,1,1,0,1,0,1,0,1,-1,0,-1,0,-1,0,-1,-1
            DFB    1,-1,1,0,1,0
            DFB    8,15,11             ; "l", 11 points, 8x8
            DFB    50,13,9
            DFB    1,0,0,1,0,1,0,1,0,1,0,1,-1,1,1,0,1,0,-1,-1
            DFB    8,15,16             ; "d", 16 points, 8x8
            DFB    50,20,9
            DFB    0,1,0,1,0,1,0,1,0,1,0,1,-1,0,-1,0,-1,0,-1,-1
            DFB    0,-1,0,-1,1,-1,1,0,1,0
            DFB    8,15,14             ; "u", 14 points, 8x8
            DFB    50,21,11
            DFB    0,1,0,1,0,1,1,1,1,0,1,-1,1,-1,0,-1,0,-1,0,1
            DFB    0,1,0,1,0,1
            DFB    8,15,14             ; "n", 14 points, 8x8
            DFB    50,26,11
            DFB    0,1,0,1,0,1,0,1,0,-1,0,-1,1,-1,1,-1,1,0,1,1
            DFB    0,1,0,1,0,1
            DFB    0                   ; end

********************************
* Draw Background routine.     *
* Leave bit set for blue, or   *
* strip it off for purple.     *
********************************
DRAWBKGD    LDA    #0
            STA    HLINE
            LDA    #2
            STA    HLINE2
:LOOP       JSR    HADDR
            JSR    HADDR2
            BCS    :ALLDONE
            JSR    BKLINE12
            ADDB   #4;HLINE;HLINE
            ADDB   #4;HLINE2;HLINE2
            LDA    HLINE
            CMP    #180
            BLT    :LOOP
:ALLDONE    RTS

BKLINE12    LDY    #0
:1          LDX    #0
:0          LDA    BACKGND1,X
            STA    (HPTR),Y
            LDA    BACKGND2,X
            STA    (HPTR2),Y
            INX
            INY
            CPX    #8
            BLT    :0
            CPY    #40
            BLT    :1
            RTS
BACKGND1    HEX    858A94A8D0A0C182    ; high bit is set..
BACKGND2    HEX    D0A0C182858A94A8    ; blue background.

********************************
* Roll Jewel of Kaldun onto    *
* the graphics screen.         *
*   Jewel picture is stored    *
*   in hi-res page 2, or       *
*   locations $4000-$5FFF      *
********************************
ROLJEWEL    LDA    #0
            STA    ROL_CTR
            LDA    #174
            STA    ROLSTART
:LOOP       STA    HLINE2              ; on page one
            LDA    #14
            STA    HLINE               ; on page two
:SCROLL     JSR    HADDR
            JSR    HADDR2
            ADDB   #$20;HPTR+1;HPTR+1  ; make page 2 hires
            LDY    #8
:COPY       LDA    (HPTR),Y            ; copy a line of the jewel
            STA    (HPTR2),Y           ; onto the graphics page.
            INY
            CPY    #32
            BLT    :COPY
            INC    HLINE               ; increas copying until
            INC    HLINE2              ; at bottom of window
*-------------------------------
            LDX    ROL_CTR
            INC    ROL_CTR
            LDY    $FF00,X
:0TEST0     DEY
            BNE    :0TEST0
*-------------------------------
            STA    SPEAKER
            LDA    HLINE2              ; on page 1.
            CMP    #177
            BLT    :SCROLL
            STA    SPEAKER
            LDY    ROLSTART            ; do a pause that decreases
:PAUSE      LDA    #20                 ;  as jewel moves farther
            JSR    WAIT                ;  onto the page
            DEY
            BNE    :PAUSE
            LDA    ROLSTART            ; check if we are already
            CMP    #14                 ; finished
            BEQ    :EXIT
            DEC    ROLSTART            ; move jewel up a bit
            DEC    ROLSTART
            DEC    ROLSTART
            DEC    ROLSTART
            LDA    ROLSTART
            CMP    #14                 ; if.lt.14, we have final
            BGE    :LOOP               ; if.ge.14, keep on going
            LDA    #14                 ; show at top.
            BNE    :LOOP               ; always
:EXIT       RTS
ROLSTART    HEX    00                  ; where we are on scroll
ROL_CTR     HEX    00                  ; -----

********************************
* Fade the Castle wall in for  *
* the title page.              *
********************************

WALLFADE    STA    $C052
            MOVW   #WFTABLE;PTR
            MOVB   #246;TITLECTR
            LDA    #%00000000
            STA    CLRFLAG
            LDA    #%00000000
            STA    XORFLAG
:REPEAT     JSR    TITBUZZ
            NILW   TITX
            NILW   TITY
            MOVB   #18;SNUM
            LDY    #0
            LDA    (PTR),Y
            STA    TITX
            JSR    PTRINC
            LDA    (PTR),Y
            BPL    :0
            PHA
            MOVB   #17;SNUM
            PLA
            AND    #%01111111
:0          STA    TITY
            JSR    PTRINC
            DEC    TITY
            DEC    TITX
            IMULW  #8;TITX;TITX
            IMULW  #8;TITY;TITY
            LDY    TITY
            LDX    TITX
            LDA    TITX+1
            STA    SPEAKER
            JSR    DRAWSHAP
            DEC    TITLECTR
            BEQ    :DONE
            JMP    :REPEAT
:DONE       LDA    #%10000000
            STA    CLRFLAG
            LDA    #%00000000
            STA    XORFLAG
            RTS

TITBUZZ     STA    SPEAKER
            LDX    ROL_CTR
            INC    ROL_CTR
:REPEAT     DEX
            BNE    :REPEAT
            STA    SPEAKER
            RTS

********************************
* Data for fade in of castle   *
* wall.  These are randomly    *
* generated locations.  High   *
* bit on the Y coordinate      *
* determines the shape number. *
*   ON = shape #17             *
*   OFF= shape #18             *
********************************

WFTABLE     DFB    33,149,24,149,28,22,25,148,2,22,23,151
            DFB    13,151,3,149,22,21,29,21,2,150,4,21
            DFB    29,20,33,23,27,149,12,151,24,150,7,148
            DFB    11,21,17,21,30,150,34,21,33,148,11,149
            DFB    33,151,2,151,9,20,16,23,16,150,16,22
            DFB    7,151,14,150,23,23,26,151,8,21,34,22
            DFB    1,22,21,20,8,149,3,21,6,150,22,149,21,151
            DFB    32,22,31,23,8,22,10,149,21,150,26,23
            DFB    27,20,6,151,8,23,35,148,10,23,34,151
            DFB    23,148,21,23,25,21,24,22,26,22,5,150
            DFB    8,150,14,151,13,148,16,149,11,148,28,151
            DFB    17,151,14,21,18,149,34,23,19,20,19,151
            DFB    19,149,28,23,20,150,5,20,7,23,4,151
            DFB    14,23,9,22,29,150,33,150,32,149,9,151
            DFB    1,21,5,22,1,23,35,151,9,21,2,21
            DFB    1,20,18,23,13,22,34,149,17,20,20,151
            DFB    9,148,22,22,3,150,25,22,15,150,15,21
            DFB    3,22,23,20,30,23,27,21,31,22,12,22
            DFB    20,22,22,23,3,23,13,149,5,148,16,151
            DFB    1,148,3,148,17,148,29,151,31,148,27,151
            DFB    27,22,9,149,13,23,5,23,5,149,19,148
            DFB    15,148,3,151,11,23,30,151,6,149,35,21
            DFB    10,150,6,22,9,23,30,21,5,151,19,150
            DFB    25,23,32,151,17,23,32,23,26,150,26,149
            DFB    28,150,25,20,23,150,16,21,6,21,7,22
            DFB    7,150,17,149,23,22,14,22,25,150,27,150
            DFB    17,150,13,21,31,21,19,23,20,149,33,22
            DFB    19,21,22,151,35,149,30,22,28,21,12,149
            DFB    29,22,1,151,35,150,20,21,26,21,7,149
            DFB    15,151,35,22,30,149,12,23,4,150,19,22
            DFB    18,150,10,151,7,21,29,148,11,22,27,148
            DFB    15,20,3,20,9,150,11,151,2,23,21,149
            DFB    22,150,12,21,28,149,25,151,21,148,5,21
            DFB    33,20,7,20,13,20,15,23,27,23,4,149
            DFB    1,150,1,149,29,149,12,150,35,20,13,150
            DFB    21,22,2,149,31,151,15,149,29,23,17,22
            DFB    34,150,10,21,20,23,32,21,15,22,18,151
            DFB    24,21,24,151,14,149,11,150,32,150,25,149
            DFB    4,22,4,23,24,23,33,21,23,21,6,23
            DFB    31,20,31,149,18,21,23,149,10,22,8,151
            DFB    21,21,11,20,18,22,31,150,35,23

********************************
* Prepare for scrolling:       *
********************************

LINE21      =      $650
LINE22      =      $6D0
LINE23      =      $750

SCPREP      JSR    CLRSCRN
            LDY    #40
            LDA    #$20                ; inverse space
:0          STA    LINE21-1,Y
            STA    LINE22-1,Y
            STA    LINE23-1,Y
            DEY
            BPL    :0
            STA    $C053
            RTS

********************************
* Scrolling line:              *
********************************

SCLINE      INV    "                                        "
            INV    "... THE JEWEL OF KALDUN "
            INV    "... PROGRAMMED BY A2GEEK "
            INV    "... STORY BY BSHAGE "
            INV    "... PRESS <RETURN> TO PLAY "
            INV    "... PRESS <I> FOR INSTRUCTIONS AND INFORMATION "
            INV    "..."
            HEX    00

********************************
* Scroll that line, and check  *
* to see if a RETURN or I has  *
* been pressed.  (or Q)        *
********************************

SCROLL      LDA    #0
            STA    KEYSTROB
:REPEAT     TAY
            PHA
            LDX    #0
:1          LDA    SCLINE,Y
            BNE    :0
            LDY    #0
            BEQ    :1
:0          STA    LINE22,X
            INY
            INX
            CPX    #40
            BLT    :1
            LDA    #220
            JSR    WAIT
            LDA    KEYBOARD
            BMI    :KEY
:RESUME     PLA
            TAY
            INY
            LDA    SCLINE,Y
            BEQ    SCROLL
            TYA
            JMP    :REPEAT
:KEY        STA    KEYSTROB
            CMP    #$8D
            BEQ    :EXIT
            CMP    #"Q"
            BEQ    :EXIT
            CMP    #"q"
            BEQ    :EXIT
            CMP    #"I"
            BEQ    :EXIT
            CMP    #"i"
            BEQ    :EXIT
            DEC    RANDOM1             ; delay until all three
            BNE    :RESUME             ;   bytes of RANDOM (aka
            DEC    RANDOM2             ;   counter) become
            BNE    :RESUME             ;   zero once again.
****     DEC  RANDOM3     ; Then, trick the program
****     BNE   :RESUME    ;   into thinking that "I"
            LDA    #"I"                ;   has been pressed.
:EXIT       PHA
            JSR    SCPREP              ; clear out scrolling region.
            PLA
            TAY                        ; do this to preserve
            PLA                        ; keypress...
            TYA
            RTS


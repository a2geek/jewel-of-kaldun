********************************
* Draw CASTLE1, CASTLE2, and   *
* lower the drawbridge for     *
* castle #1.                   *
* Uses:  GENERAL.MAC           *
********************************

********************************
* Draw King Aradeas' castle    *
********************************

CASTLE1     ENT
            LDX   #5
            JSR   HCOLOR        ; HCOLOR = 5
            MOVB  #159;EY       ; set starting points:
            NILW  EX            ;  HPLOT 0,? TO 0,159
            NILW  SX
            MOVB  #5;CTR0
:0          JSR   PARAPET1      ; draw 5 sets of parapets
            DEC   CTR0
            BNE   :0
            MOVB  #10;SY        ; draw a bar 10 pixels wide
            JSR   PARAPET0      ;  !
            MOVB  #0;SY         ;  !
            JSR   PARAPET0      ;  !
            MOVB  #10;SY        ;  !
            JSR   PARAPET0      ; finished tower
            MOVW  #90;SX        ; prepare for sloped left
            MOVW  #90;EX        ; side of tower
            MOVB  #0;SY
            MOVB  #20;EY
            JSR   SLOPDOWN
            MOVW  #130;SX       ; prepare for sloped right
            MOVW  #130;EX       ; side of tower
            MOVB  #0;SY
            JSR   SLOPUP
            LDX   #7            ; HCOLOR = 7
            JSR   HCOLOR
            MOVB  #40;SY        ; and prepare for drawing the
            NILW  SX            ; outline of castle
            MOVW  #10;EX
            MOVB  #40;EY
            MOVB  #5;CTR0
:1          JSR   OUTLINE1      ; draw outline of parapets
            DEC   CTR0
            BNE   :1
            MOVW  #100;SX       ; begin outlining the tower
            MOVB  #159;SY
            MOVW  #100;EX
            MOVB  #30;EY
            JSR   DRAWLINE
            MOVW  #90;EX
            MOVB  #20;EY
            JSR   LINETO
            MOVB  #0;EY
            JSR   LINETO
            MOVB  #0;SY
            MOVW  #90;SX
            MOVW  #100;EX
            MOVB  #2;CTR0
:4          JSR   OUTLINE1      ; now outlining upper parapets
            DEC   CTR0          ; of the tower
            BNE   :4
            MOVW  #140;EX       ; and finish off the tower.
            JSR   LINETO
            MOVB  #20;EY
            JSR   LINETO
            MOVW  #130;EX
            MOVB  #31;EY
            JSR   LINETO
            MOVB  #159;EY
            JSR   LINETO
            NILW  SX            ; draw the bottom line.
            MOVB  #159;SY
            MOVW  #279;EX
            JSR   DRAWLINE
            RTS

********************************
* Draw the Castle of Kaldun.   *
********************************

CASTLE2     LDX   #5
            JSR   HCOLOR
            MOVB  #159;EY
            MOVW  #80;EX
            MOVB  #70;SY
            MOVW  #80;SX
            JSR   PARAPET0
            MOVB  #60;SY
            JSR   PARAPET0
            MOVB  #70;SY
            JSR   PARAPET0
            MOVB  #100;SY
            JSR   PARAPET0
            JSR   PARAPET0
            MOVB  #5;CTR0
:0          JSR   PARAPET2
            DEC   CTR0
            BNE   :0
            MOVW  #70;SX
            MOVW  #70;EX
            MOVB  #60;SY
            MOVB  #80;EY
            JSR   SLOPDOWN
            MOVB  #90;EY
            MOVW  #110;SX
            MOVW  #110;EX
            JSR   SLOPUP
            LDX   #7
            JSR   HCOLOR
            MOVB  #159;SY
            MOVB  #159;EY
            NILW  SX
            MOVW  #279;EX
            JSR   DRAWLINE
            MOVW  #45;SX
            MOVB  #125;EY
            MOVW  #80;EX
            JSR   DRAWLINE
            MOVB  #159;SY
            MOVW  #80;SX
            MOVW  #80;EX
            MOVB  #90;EY
            JSR   DRAWLINE
            MOVW  #70;EX
            MOVB  #80;EY
            JSR   LINETO
            MOVB  #60;EY
            JSR   LINETO
            MOVW  #70;SX
            MOVB  #60;SY
            MOVW  #80;EX
            JSR   OUTLINE1
            JSR   OUTLINE1
            MOVW  #120;EX
            JSR   LINETO
            MOVB  #80;EY
            JSR   LINETO
            MOVW  #110;EX
            MOVB  #90;EY
            JSR   LINETO
            MOVB  #100;EY
            JSR   LINETO
            MOVW  #130;EX
            JSR   LINETO
            MOVW  #130;SX
            MOVB  #100;SY
            MOVW  #130;EX
            MOVB  #90;EY
            MOVB  #5;CTR0
:1          JSR   OUTLINE2
            DEC   CTR0
            BNE   :1
            MOVW  #80;SX
            MOVB  #155;SY
            MOVW  #279;EX
            MOVB  #155;EY
            MOVB  #11;CTR0
:2          JSR   LAYERS2
            DEC   CTR0
            BNE   :2
            MOVW  #110;EX
            JSR   LAYERS2
            JSR   LAYERS2
            JSR   LAYERS2
            MOVW  #75;SX
            MOVW  #115;EX
            JSR   LAYERS2
            MOVW  #70;SX
            MOVW  #120;EX
            JSR   LAYERS2
            JSR   LAYERS2
            MOVW  #80;SX
            MOVB  #81;SY
            MOVW  #80;EX
            MOVB  #84;EY
            JSR   BRICKS2
            MOVW  #90;SX
            MOVB  #76;SY
            MOVW  #90;EX
            MOVB  #79;EY
            JSR   BRICKS2
            MOVW  #100;SX
            MOVB  #81;SY
            MOVW  #100;EX
            MOVB  #84;EY
            JSR   BRICKS2
            MOVW  #110;SX
            MOVB  #76;SY
            MOVW  #110;EX
            MOVB  #79;EY
            JSR   DRAWLINE
            MOVB  #9;CTR0
:3          MOVB  #106;SY
            MOVB  #109;EY
            JSR   BRICKS2
            ADDW  SX;#10;SX
            MOVW  SX;EX
            MOVB  #111;SY
            MOVB  #114;EY
            JSR   BRICKS2
            ADDW  SX;#10;SX
            MOVW  SX;EX
            DEC   CTR0
            BNE   :3
            RTS

********************************
* General subroutines used by  *
* castle drawing routines.     *
********************************

BRICKS2     JSR   DRAWLINE
            ADDB  SY;#10;SY
            ADDB  EY;#10;EY
            LDA   EY
            CMP   #160
            BLT   BRICKS2
            RTS

LAYERS2     JSR   DRAWLINE
            SUBB  SY;#5;SY
            SUBB  EY;#5;EY
            RTS

OUTLINE2    JSR   DRAWLINE
            SUBB  SY;#10;SY     ; SY=SY-10
            ADDW  EX;#20;EX     ; EX=EX+20
            JSR   DRAWLINE
            ADDW  SX;#20;SX     ; SX=SX+20
            ADDB  EY;#10;EY     ; EY=EY+10
            JSR   DRAWLINE
            ADDB  SY;#10;SY     ; SY=SY+10
            ADDW  EX;#9;EX      ; EX=EX+9 (not off page..)
            JSR   DRAWLINE
            ADDW  EX;#1;EX      ; EX=EX+1 (correct ^^^)
            ADDW  SX;#10;SX     ; SX=SX+10
            SUBB  EY;#10;EY     ; EY=EY-10
            RTS

OUTLINE1    JSR   DRAWLINE
            ADDB  #10;SX;SX     ; SX=SX+10
            ADDB  #10;EY;EY     ; EY=EY+10
            JSR   DRAWLINE
            ADDB  #10;SY;SY     ; SY=SY+10
            ADDB  #10;EX;EX     ; EX=EX+10
            JSR   DRAWLINE
            ADDB  #10;SX;SX     ; SX=SX+10
            SUBB  EY;#10;EY     ; EY=EY-10
            JSR   DRAWLINE
            SUBB  SY;#10;SY     ; SY=SY-10
            ADDB  #10;EX;EX     ; EX=EX+10
            RTS

DRAWLINE    ENT
            LDA   SY            ; draws a hi-res line
            LDX   SX            ; using the AppleSoft
            LDY   SX+1          ; routines:
            JSR   HPOSN         ; HPLOT SX,SY TO EX,EY
LINETO      LDY   EY
            LDA   EX
            LDX   EX+1
            JSR   HPLOTTO
            RTS

PARAPET1    MOVB  #40;SY        ; draw the high part of
            JSR   PARAPET0      ; a parapet and then the
            MOVB  #50;SY        ; low part of it.
            JMP   PARAPET0      ; (King Aradeas' castle)

PARAPET2    MOVB  #90;SY        ; draw parapets for
            JSR   PARAPET0      ; Kalduns' castle.
            JSR   PARAPET0
            MOVB  #100;SY

PARAPET0    MOVB  #10;CTR1      ; draw a block of 10 lines
:0          JSR   DRAWLINE      ; (vertical)
            JSR   INCX
            DEC   CTR1
            BNE   :0
            RTS

SLOPDOWN    MOVB  #10;CTR0
:0          JSR   DRAWLINE
            JSR   INCX
            INC   EY
            DEC   CTR0
            BNE   :0
            RTS

SLOPUP      MOVB  #10;CTR0
:0          JSR   DRAWLINE
            JSR   INCX
            DEC   EY
            DEC   CTR0
            BNE   :0
            RTS

INCX        INC   SX            ; increase both
            BNE   :0            ; SX and EX by one.
            INC   SX+1
:0          INC   EX
            BNE   :1
            INC   EX+1
:1          RTS

********************************
* Variables used by the Castle *
* drawing routines.            *
********************************

SX          ENT
            HEX   0000
SY          ENT
            HEX   00
EX          ENT
            HEX   0000
EY          ENT
            HEX   00
CTR0        HEX   00
CTR1        HEX   00

********************************
* Lower King Aradeas'          *
* drawbridge:                  *
********************************

DRAWBRID    MOVB  #0;CTR0
            NILW  SX
            NILW  EX
            MOVB  #131;SX
:0          LDX   #7
            JSR   DISPLAYB
            LDA   #100
            JSR   MONWAIT
            LDX   #4
            JSR   DISPLAYB
            INC   CTR0
            LDA   CTR0
            CMP   #27
            BLT   :0
            DEC   CTR0          ; fall through to Display
            LDX   #7            ; Bridge routine...

DISPLAYB    JSR   HCOLOR
            MOVB  #159;SY
            LDY   CTR0
            MOVB  BRIDGEX,Y;EX
            MOVB  BRIDGEY,Y;EY
            JSR   DRAWLINE
            MOVB  #120;SY
            LDY   CTR0
            MOVB  CHAINX,Y;EX
            MOVB  CHAINY,Y;EY
            JSR   DRAWLINE
            RTS

********************************
* Drawbridge points:           *
********************************

BRIDGEX     DFB   131,133,136,139,142,145,148,151,154
            DFB   156,159,161,163,166,168,170,171,173
            DFB   175,176,177,178,179,180,180,180,180
BRIDGEY     DFB   109,109,109,109,110,111,112,113,114
            DFB   116,117,119,121,123,125,127,130,132
            DFB   135,138,140,143,146,149,152,155,159
CHAINX      DFB   131,133,135,138,140,142,145,147,149
            DFB   151,153,155,157,159,160,162,163,165
            DFB   166,167,168,169,169,170,170,170,170
CHAINY      DFB   119,119,119,119,120,120,121,122,123
            DFB   124,125,127,128,130,132,134,136,138
            DFB   140,142,144,146,149,151,153,156,159


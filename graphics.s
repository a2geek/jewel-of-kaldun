********************************
* High-Resolution Graphics     *
* routines for Jewel of Kaldun *
* Uses:  MATH                  *
********************************

SETHGR      ENT
            STA   $C057
            STA   $C053
            STA   $C050
            RTS

********************************
* Turn on the hi-res screen    *
* and clear it.                *
********************************

HGR         JSR   SETHGR
HGRCLEAR    ENT
            LDA   #191
            STA   HLINE
:0          JSR   HADDR
            BCC   :CONT
            RTS
:CONT       LDA   #0
            LDY   #39
:1          STA   (HPTR),Y
            DEY
            BPL   :1
            DEC   HLINE
            JMP   :0

********************************
* Store Hi-Res Screen @ $4000. *
********************************
HSTORE      MOVW  #$2000;HPTR
            MOVW  #$4000;HPTR2
:YLOOP      LDY   #0
:LOOP       LDA   (HPTR),Y
            STA   (HPTR2),Y
            INY
            BNE   :LOOP
            INC   HPTR2+1
            INC   HPTR+1
            LDA   HPTR+1
            CMP   #$40
            BLT   :YLOOP
            RTS

********************************
* Restore hires screen to 4000 *
********************************
HRESTORE    MOVW  #$4000;HPTR
            MOVW  #$2000;HPTR2
:YLOOP      LDY   #0
:LOOP       LDA   (HPTR),Y
            STA   (HPTR2),Y
            INY
            BNE   :LOOP
            INC   HPTR+1
            INC   HPTR2+1
            LDA   HPTR2+1
            CMP   #$40
            BLT   :YLOOP
            RTS

********************************
* Clear the scrolling portion  *
* of the hi-res screen.        *
********************************

HCLEAR      LDA   #159
            STA   HLINE
:1          JSR   HADDR
            BCS   :END
            LDY   #28
            LDA   #0
:0          STA   (HPTR),Y
            DEY
            BPL   :0
            DEC   HLINE
            JMP   :1
:END        RTS

********************************
* Scroll the hi-res screen to  *
* the left two pixels.         *
********************************

HLEFT       LDA   #159
            STA   HLINE
:1          JSR   HADDR
            BCS   :END
            LDY   #1
:0          LDA   (HPTR),Y
            AND   #%01111110
            LSR
            STA   TEMP
            INY
            LDA   (HPTR),Y
            AND   #%00000001
            ASL
            ASL
            ASL
            ASL
            ASL
            ASL
            ORA   TEMP
            DEY
            DEY
            STA   (HPTR),Y
            INY
            INY
            CPY   #28
            BLT   :0
            LDY   #28
            LDA   (HPTR),Y
            AND   #%01111110
            LSR
            DEY
            STA   (HPTR),Y
            INY
            LDA   #0
            STA   (HPTR),Y
            DEC   HLINE
            JMP   :1
:END        RTS

********************************
* Scroll the hi-res screen to  *
* the right two pixels.        *
********************************

HRIGHT      LDA   #159
            STA   HLINE
:1          JSR   HADDR
            BCS   :END
            LDY   #26
:0          LDA   (HPTR),Y
            AND   #%01000000
            LSR
            LSR
            LSR
            LSR
            LSR
            LSR
            STA   TEMP
            INY
            LDA   (HPTR),Y
            AND   #%00111111
            ASL
            ORA   TEMP
            INY
            STA   (HPTR),Y
            DEY
            DEY
            DEY
            CPY   #-1
            BNE   :0
            LDY   #0
            LDA   (HPTR),Y
            AND   #%00111111
            ASL
            INY
            STA   (HPTR),Y
            DEY
            TYA
            STA   (HPTR),Y
            DEC   HLINE
            LDY   #28
            LDA   (HPTR),Y
            AND   #%00001111    ; chop off rightmost bits
            STA   (HPTR),Y
            JMP   :1
:END        RTS

********************************
* Scroll the hi-res screen up  *
* two pixels.                  *
********************************

HUP         LDA   #0
            STA   HLINE2
            LDA   #8
            STA   HLINE
:0          JSR   HADDR2
            JSR   HADDR
            BCS   :END
            LDY   #28
:1          LDA   (HPTR),Y
            STA   (HPTR2),Y
            DEY
            BPL   :1
            INC   HLINE2
            INC   HLINE
            JMP   :0
:END        LDY   #28
            LDA   #0
:2          STA   (HPTR2),Y
            DEY
            BPL   :2
            INC   HLINE2
            JSR   HADDR2
            BCC   :END
            RTS

********************************
* Scroll the hi-res screen     *
* down two pixels.             *
********************************

HDOWN       LDA   #159
            STA   HLINE2
            LDA   #151
            STA   HLINE
:0          JSR   HADDR2
            JSR   HADDR
            BCS   :END
            LDY   #28
:1          LDA   (HPTR),Y
            STA   (HPTR2),Y
            DEY
            BPL   :1
            DEC   HLINE2
            DEC   HLINE
            JMP   :0
:END        LDY   #28
            LDA   #0
:2          STA   (HPTR2),Y
            DEY
            BPL   :2
            DEC   HLINE2
            JSR   HADDR2
            BCC   :END
            RTS

********************************
* This routine calculates the  *
* hi-res address of line that  *
* is stored in LINE via the    *
* look-up tables.              *
********************************

HADDR       ENT
            LDA   HLINE
            CMP   #192
            BCS   :END
            TAY
            LDA   HLOW,Y
            STA   HPTR
            LDA   HHIGH,Y
            STA   HPTR+1
            CLC
:END        RTS

********************************
* This routine calculates the  *
* hi-res address of line that  *
* is stored in LINE2 via the   *
* look-up tables.              *
********************************

HADDR2      ENT
            LDA   HLINE2
            CMP   #192
            BCS   :END
            TAY
            LDA   HLOW,Y
            STA   HPTR2
            LDA   HHIGH,Y
            STA   HPTR2+1
            CLC
:END        RTS

********************************
* Low-order bytes of hi-res    *
* row address:                 *
********************************

HLOW        HEX   0000000000000000
            HEX   8080808080808080
            HEX   0000000000000000
            HEX   8080808080808080
            HEX   0000000000000000
            HEX   8080808080808080
            HEX   0000000000000000
            HEX   8080808080808080
            HEX   2828282828282828
            HEX   A8A8A8A8A8A8A8A8
            HEX   2828282828282828
            HEX   A8A8A8A8A8A8A8A8
            HEX   2828282828282828
            HEX   A8A8A8A8A8A8A8A8
            HEX   2828282828282828
            HEX   A8A8A8A8A8A8A8A8
            HEX   5050505050505050
            HEX   D0D0D0D0D0D0D0D0
            HEX   5050505050505050
            HEX   D0D0D0D0D0D0D0D0
            HEX   5050505050505050
            HEX   D0D0D0D0D0D0D0D0
            HEX   5050505050505050
            HEX   D0D0D0D0D0D0D0D0

********************************
* High-order bytes of hi-res   *
* row address:                 *
********************************

HHIGH       HEX   2024282C3034383C
            HEX   2024282C3034383C
            HEX   2125292D3135393D
            HEX   2125292D3135393D
            HEX   22262A2E32363A3E
            HEX   22262A2E32363A3E
            HEX   23272B2F33373B3F
            HEX   23272B2F33373B3F
            HEX   2024282C3034383C
            HEX   2024282C3034383C
            HEX   2125292D3135393D
            HEX   2125292D3135393D
            HEX   22262A2E32363A3E
            HEX   22262A2E32363A3E
            HEX   23272B2F33373B3F
            HEX   23272B2F33373B3F
            HEX   2024282C3034383C
            HEX   2024282C3034383C
            HEX   2125292D3135393D
            HEX   2125292D3135393D
            HEX   22262A2E32363A3E
            HEX   22262A2E32363A3E
            HEX   23272B2F33373B3F
            HEX   23272B2F33373B3F

********************************
* Graphically displays the     *
* amount of Gold Pieces        *
* character has.               *
********************************

STATUSGP    LDY   #38
            LDA   GP+1
            BNE   LOTAGOLD
            LDA   #160
            SEC
            SBC   GP
            BCS   STATUS
LOTAGOLD    LDA   #0
STATUS      STA   TEMP
            STY   YTEMP
            LDA   #160
            STA   HLINE
:1          JSR   HADDR
            BCS   :EXIT
            LDY   YTEMP
            LDA   COLORS-29,Y
            STA   (HPTR),Y
            INY
            LDA   COLORS-29,Y
            STA   (HPTR),Y
            DEC   HLINE
            LDA   HLINE
            CMP   TEMP
            BGE   :1
:3          JSR   HADDR
            BCC   :2
:EXIT       RTS
:2          LDA   #0
            LDY   YTEMP
            STA   (HPTR),Y
            INY
            STA   (HPTR),Y
            DEC   HLINE
            JMP   :3

********************************
* The colors associated with   *
* the various statuses.        *
********************************

COLORS      HEX   D5AA00552A00
            HEX   AAD5002A55

********************************
* Graphically displays the     *
* status of your keys.         *
********************************

STATUSKY    LDY   #29
            LDX   KEY
            LDA   SPKEY
            BEQ   :0
            INX
:0          LDA   #160
:1          CPX   #0
            BEQ   :DONE
            SEC
            SBC   #10
            DEX
            CMP   #0
            BNE   :1
:DONE       JMP   STATUS

********************************
* Graphically display the      *
* percent of hitpoints         *
* remaining.                   *
********************************

STATUSHP    LDA   #0
            STA   NUM1+1
            STA   NUM2+1
            LDA   #160
            STA   NUM1
            LDA   HP
            STA   NUM2
            JSR   IMUL
            LDA   RESULT
            STA   NUM1
            LDA   RESULT+1
            STA   NUM1+1
            LDA   #0
            STA   NUM2+1
            LDA   MAXHP
            STA   NUM2
            JSR   IDIV
            SEC
            LDA   #160
            SBC   RESULT
            BCS   :0
            LDA   #0
:0          LDY   #32
            JMP   STATUS

********************************
* Graphically display the      *
* percent of experience        *
* points required.             *
********************************
* problems occur here because when the player needs more
* than (or equal amount of) 800 XP, multiplied number
* grows larger than the 16 bit number allows (65,536)!

* Old routine:   [[ (XP * 160) / XPREQD = graphics X ]]
*       MOVW   XP;NUM1
*       MOVW   #160;NUM2
*       JSR    IMUL
*       MOVW   RESULT;NUM1
*       MOVW   XPREQD;NUM2
*       JSR    IDIV

* New routine:  [[ ( (1600/XPREQD) * (XP/10) ) ]]
* it's not quite as accurate, but at least the graphics bar
* will work for the higher levels!

STATUSXP    MOVW  #1600;NUM1
            MOVW  XPREQD;NUM2
            JSR   IDIV          ;      RESULT = 1600 / XPREQD
            MOVW  RESULT;NUM1
            MOVW  XP;NUM2
            JSR   IMUL          ;      RESULT = RESULT * XP
            MOVW  RESULT;NUM1
            MOVW  #10;NUM2
            JSR   IDIV          ;      RESULT = RESULT / 10
            LDA   RESULT+1
            BNE   :1
            LDA   RESULT
            CMP   #160
            BLT   :0
:1          LDA   #0
:0          LDY   #35
            JMP   STATUS


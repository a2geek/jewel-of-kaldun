********************************
* End Game routines:           *
*   death                      *
*   and WINNING!               *
********************************

* External routines
            ; graphics.s
HGRCLEAR    EXT
HADDR       EXT
HADDR2      EXT
SETHGR      EXT
            ; input.output.s
PRSTR       EXT
CBOT3       EXT
CLRSCRN     EXT
TEXT        EXT
TEXTADDR    EXT
CSTRING     EXT
CLRMID      EXT
GETRET      EXT
            ; title.s
WAIT        EXT
            ; shapes.s
CLRFLAG     EXT
XORFLAG     EXT
SNUM        EXT
DRAWSHAP    EXT
            ; noise.s
DONOISE     EXT
DURATION    EXT
FREQUENC    EXT
VOLUME      EXT
            ; castles.s
SX          EXT
SY          EXT
EX          EXT
EY          EXT
DRAWLINE    EXT
CASTLE1     EXT

********************************
* This is the death routine.   *
********************************
THEDEATH    ENT
            JSR     HGRCLEAR
            JSR     GREENBCK
            LDY     #10
            JSR     PAUSE
            PRINT   DEATH1
            JSR     RAISTONE
            LDY     #15
            JSR     PAUSE
            PRINT   DEATH2
            JSR     DRAWRIP
            LDY     #10
            JSR     PAUSE
            JSR     CBOT3
            RTS
DEATH1      HEX     825583
            ASC     "... You're dead! ..."00
DEATH2      HEX     825583
            ASC     "All good things must"8D83
            ASC     "come to and end!"00

********************************
* Pause for a bit.             *
********************************
PAUSE       LDA     #255
            JSR     WAIT
            DEY
            BNE     PAUSE
            RTS

********************************
* Do the green background for  *
* death scene.                 *
********************************
GREENBCK    LDA     #90
            STA     HLINE
            LDA     #92
            STA     HLINE2
:LOOP       JSR     HADDR
            JSR     HADDR2
            BCS     :ALLDONE
            JSR     GREEN12
            ADDB    #4;HLINE;HLINE
            ADDB    #4;HLINE2;HLINE2
            LDA     HLINE2
            CMP     #159
            BLT     :LOOP
:ALLDONE    RTS

********************************
* Do two lines of green.       *
********************************
GREEN12     LDY     #0
:1          LDX     #0
:0          LDA     GREEN1,X
            STA     (HPTR),Y
            LDA     GREEN2,X
            STA     (HPTR2),Y
            INX
            INY
            CPX     #8
            BLT     :0
            CPY     #40
            BLT     :1
            RTS
GREEN1      HEX     204102050A142850
GREEN2      HEX     0A14285020410205

********************************
* Draw R. I. P. on gravestone. *
********************************
DRAWRIP     LDA     #%00000000        ; prepare to draw R. I. P.
            STA     CLRFLAG
            LDA     #%10000000
            STA     XORFLAG
            MOVB    #19;SNUM          ; Draw "R"
            LDY     #100
            LDX     #<115
            LDA     #>115
            JSR     DRAWSHAP
            MOVB    #16;SNUM          ; Draw "."
            LDY     #103
            LDX     #<121
            LDA     #>121
            JSR     DRAWSHAP
            JSR     DO_THUMP          ; make noise
            MOVB    #20;SNUM          ; Draw "I"
            LDY     #100
            LDX     #<135
            LDA     #>135
            JSR     DRAWSHAP
            MOVB    #16;SNUM          ; Draw "."
            LDY     #103
            LDX     #<141
            LDA     #>141
            JSR     DRAWSHAP
            JSR     DO_THUMP          ; make noise
            MOVB    #21;SNUM          ; Draw "P"
            LDY     #100
            LDX     #<155
            LDA     #>155
            JSR     DRAWSHAP
            MOVB    #16;SNUM          ; Draw "."
            LDY     #103
            LDX     #<159
            LDA     #>159
            JSR     DRAWSHAP
            JSR     DO_THUMP
            RTS

********************************
* Make a thumping sound.       *
********************************
DO_THUMP    LDY     #35               ; make a sound similar to
:LOOP       BIT     SPEAKER           ; typical "thump"
            LDA     #45
            JSR     WAIT
            DEY
            BNE     :LOOP
            LDY     #2
            LDA     #255              ; pause for effect.
            JSR     WAIT
            RTS

********************************
* Routine to raise gravestone  *
* out of the ground.           *
********************************
RAISTONE    LDY     #140
:LOOP       STY     :YSAVE
            JSR     DRAWSTON
            MOVB    #15;VOLUME
            MOVB    #1;DURATION
            MOVB    #150;FREQUENC
            JSR     DONOISE
            LDY     :YSAVE
            DEY
            CPY     #70
            BGE     :LOOP
            RTS
:YSAVE      HEX     00

********************************
* Routine to draw gravestone   *
* from Y to 140.               *
********************************
DRAWSTON    STY     SY                ; set starting and
            STY     EY                ; ending y positions
            MOVB    #0;:COUNTER       ; init counter
            LDX     #3
            JSR     HCOLOR            ; HCOLOR=3
:LOOP       MOVW    #104;SX           ; default starting and
            MOVW    #174;EX           ; ending x positions
            LDA     :COUNTER          ; check counter
            CMP     #15               ; if < 15 then use data
            BGE     :DRAW             ; if =>15 then use default
            ASL                       ; multiply by 2
            TAY
            LDA     GRAVSTON,Y        ; set endpoints
            STA     SX                ; for hline
            LDA     GRAVSTON+1,Y
            STA     EX
:DRAW       JSR     DRAWLINE          ; use drawline routine
            BIT     SPEAKER           ; buzz
            INC     :COUNTER          ; counter+= 1
            LDA     :COUNTER          ; exit early -- no need
            CMP     #16               ; to draw the WHOLE gravestone
            BGE     :EXIT             ; again!
            INC     SY                ; sy+= 1
            INC     EY                ; ey+= 1
            LDA     SY                ; check if y is still
            CMP     #141              ; < 141.
            BLT     :LOOP             ; if y<141 then repeat
:EXIT       RTS
:COUNTER    HEX     00                ; used for offset in table

********************************
* Data for gravestone.         *
********************************
GRAVSTON    DFB     128,150           ; for y=70 (final position)
            DFB     123,155           ; y=71
            DFB     120,158           ; y=72
            DFB     118,160           ; y=73
            DFB     116,162           ; y=74
            DFB     114,164           ; y=75
            DFB     112,166           ; y=76
            DFB     111,167           ; y=77
            DFB     110,168           ; y=78
            DFB     108,170           ; y=79
            DFB     107,171           ; y=80
            DFB     107,171           ; y=81
            DFB     106,172           ; y=82
            DFB     105,173           ; y=83
            DFB     105,173           ; y=84

GAMEWON     ENT
            JSR     CLRSCRN
            JSR     TEXT
            LDA     #11
            STA     TLINE
            JSR     TEXTADDR
            CENTER  CONGRATS
            JSR     HGRCLEAR
            JSR     CASTLE1
            LDY     #15
:DELAY      LDA     #255
            JSR     WAIT
            DEY
            BNE     :DELAY
            JSR     CLRMID
            JSR     SETHGR
            PRINT   GAMEWIN1
            JSR     GETRET
            JSR     CLRMID
            PRINT   GAMEWIN2
            JSR     GETRET
            JSR     CLRMID
            PRINT   GAMEWIN3
            JSR     GETRET
            JSR     CLRMID
            JSR     TEXT
            PRINT   GAMEWIN4
            JSR     GETRET
            JSR     CLRMID
            PRINT   GAMEWIN5
            JSR     GETRET
            JSR     CLRMID
            JSR     SETHGR
            PRINT   GAMEWIN6
            RTS

CONGRATS    ASC     "Contragulations!!"00
GAMEWIN1    HEX     54
            ASC     "As you return from your successful"8D
            ASC     "journey to retrieve the Jewel of Kaldun,"8D
            ASC     "the kingdom stirs with renewed hope!"00
GAMEWIN2    HEX     54
            ASC     "The king, upon hearing of your return,"8D
            ASC     "prepares a royal reception in honor of"8D
            ASC     "the kingdoms hero."00
GAMEWIN3    HEX     54
            ASC     "However, throughout the whole affair,"8D
            ASC     "the king appears troubled.  By what, you"8D
            ASC     "do know."00
GAMEWIN4    HEX     43
            ASC     "Later, while the two of you relax in the"8D
            ASC     "plush surroundings, you inquire why he"8D
            ASC     "looked troubled."8D
            HEX     8D
            ASC     "'Alas,' he replies, 'the whole kingdom"8D
            ASC     "rejoices at your wonderful success."8D
            ASC     "However, my daughter is another matter."8D
            ASC     "You see, she is a particularly strong-"8D
            ASC     "willed woman.  I'm afraid that she is"8D
            ASC     "too dear to me to force her into an un-"8D
            ASC     "wanted marriage.  And, I also don't wish"8D
            ASC     "for you to be forced to marry.'"8D
            HEX     8D
            ASC     "You breathe a sigh of relief, that is"8D
            ASC     "not really your style.  You tell the"8D
            ASC     "king that you understand, and was think-"8D
            ASC     "ing the same thing."00
GAMEWIN5    HEX     43
            ASC     "The king answers, 'I like you kid, and"8D
            ASC     "you definately are good material.  So,"8D
            ASC     "here is the deal:  I will give you a"8D
            ASC     "dutchy.'"8D
            HEX     8D
            ASC     "Wow, your own dutchy...  now if you can"8D
            ASC     "just figure out that last comment.  When"8D
            ASC     "you left, the king mumbled, 'For the"8D
            ASC     "sake of the kingdom, I hope I have done"8D
            ASC     "the right thing...'"00
GAMEWIN6    HEX     54
            ASC     "Stay tuned for part two!"00


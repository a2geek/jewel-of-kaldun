********************************
* Monster Routines:            *
********************************

* Init Monster variables:
MONSINIT    LDY    #0             ; zero out all monster
            LDA    #0             ;  data.
:FINISH     STA    M_HP,Y
            STA    M_TYPE,Y
            STA    M_X,Y
            STA    M_Y,Y
            STA    M_MOVE,Y
            STA    M_X0,Y
            STA    M_X1,Y
            STA    M_Y0,Y
            INY
            CPY    #MONSMAX
            BLT    :FINISH
            RTS

********************************
* Check to see if another      *
* monster has appeared.        *
********************************
MONCHECK    LDA    RANDOM2
            EOR    RANDOM3        ; 1 in 16 chance of appearing:
            AND    #%00001111     ;   check if monster is
            BNE    :NOMONS0       ;   appearing this time
            LDY    #0
:CONT       LDA    M_HP,Y         ; find space in monster
            STY    CURMONST       ;  list.
            BEQ    :FOUND
            INY
            CPY    #MONSMAX
            BLT    :CONT
:NOMONS0    JMP    _NOMONST       ; no space in list.
:FOUND      LDA    RANDOM1
            EOR    RANDOM3
            AND    #%00011111     ; y location (max = 32)
            STA    CURMON_Y
            INC    CURMON_Y
            LDA    RANDOM2
            AND    #%00011111     ; 1st part of x (gives 0-32)
            STA    CURMON_X       ;   map is 32 + 16 = 48.
            INC    CURMON_X
            LDA    RANDOM3
            AND    #%00001111     ; 2nd part of x (gives 0-15)
            CLC
            ADC    CURMON_X
            STA    CURMON_X
            CMP    #WMAP          ; ensure that map does not
            BGE    :NOMONS0       ;   exceed X coordinate max
            LDA    CURMON_Y
            CMP    #HMAP          ; ensure that map does not
            BGE    :NOMONS0       ;   exceed Y coordinate max
            LDX    #>LEVEL1
            LDA    RANDOM1
            EOR    RANDOM2
            EOR    RANDOM3
            AND    #%00000001
            BEQ    :ATLVL1
:ATLVL2     LDX    #>LEVEL2
:ATLVL1     STX    CURMON_L
*-------------------------------
            JSR    MONMOVCK       ; check if good locale
            BCC    :GOODLOC
            JMP    _NOMONST       ; bad location
*-------------------------------
:GOODLOC    LDY    CURMONST
            LDA    RANDOM1        ; randomize
            EOR    RANDOM2
            EOR    RANDOM3
            AND    #%00000111
            CMP    #2
            BLT    :GHOST
            CMP    #4
            BLT    :ZOMBIE
:BLOB       LDA    #2
            STA    M_HP,Y
            LDA    #4
            STA    M_MOVE,Y
            LDA    #13
            BNE    :FINISH        ; always
:GHOST      LDA    #8
            STA    M_HP,Y
            LDA    #2
            STA    M_MOVE,Y
            LDA    #12
            BNE    :FINISH        ; always
:ZOMBIE     LDA    #16
            STA    M_HP,Y
            LDA    #1
            STA    M_MOVE,Y
            LDA    #14
:FINISH     STA    M_TYPE,Y
            LDA    CURMON_X
            STA    M_X,Y
            LDA    CURMON_Y
            STA    M_Y,Y
            LDA    CURMON_L
            STA    M_LEVEL,Y
            CMP    MAPADDR+1      ; no at same level
            BNE    _NOMONST
            LDA    M_X,Y
            TAX
            LDA    M_Y,Y
            TAY
            CPX    X0
            BLT    _NOMONST       ; exit, keep monster
            CPX    X1
            BGE    _NOMONST       ; exit, keep monster
            CPY    Y0
            BLT    _NOMONST       ; exit, keep monster
            CPY    Y1
            BGE    _NOMONST       ; exit, keep monster
            LDA    #0             ; no good -- same screen as
            STA    M_HP,Y         ;   Meltok!
_NOMONST    RTS
CURMONST    HEX    00
CURMON_X    HEX    00
CURMON_Y    HEX    00
CURMON_L    HEX    00

********************************
* Make monsters move about!    *
********************************
MOVMONST    LDY    #0
:DOMORE     STY    CURMONST
            LDA    M_HP,Y
            BEQ    :NEXTMON
            LDA    M_MOVE,Y
            BEQ    :MOVEIT
            SEC
            SBC    #1
            STA    M_MOVE,Y
            JSR    CH4CHAR        ; attack anyway!
            JMP    :NEXTMON
:MOVEIT     LDA    M_TYPE,Y
            TAX
            LDA    TYPCONST-12,X  ; update move counter
            STA    M_MOVE,Y       ; again...
            LDA    M_Y,Y
            STA    CURMON_Y
            LDA    M_X,Y
            STA    CURMON_X
            LDA    M_LEVEL,Y
            STA    CURMON_L
            JSR    CH4CHAR        ; if M near, attack him
            BCC    :NEXTMON       ;   carry clear = attacked
            LDA    RANDOM1
            AND    #%00000011
            BNE    :MOVETOW
:MOVERAN    JSR    M_RANDOM       ; move randomly
            JMP    :NEXTMON
:MOVETOW    JSR    M_TOWARD       ; move toward Meltok
:NEXTMON    INC    CURMONST
            LDY    CURMONST
            CPY    #MONSMAX
            BLT    :DOMORE
            LDY    #0
:CHECKIT    LDA    M_HP,Y         ; see if monster is in table
            BEQ    :DOTHAT        ;   if HP = 0, not there
            LDA    M_TYPE,Y       ; check if the monster moved
            TAX                   ;   this turn.  That is, check
            LDA    TYPCONST-12,X  ;if at the maximum number of
            CMP    M_MOVE,Y       ;   turns allowed for type.
            BNE    :DOTHAT        ;   if not eq, did not move
            LDA    M_X,Y          ; see if monster is actually
            TAX                   ;   in the same room as
            INX                   ;   Meltok is.
            CPX    X0             ; checking the X range
            BLT    :DOTHAT
            CPX    X1
            BEQ    :SKIP00        ; only if > than
            BGE    :DOTHAT
:SKIP00     LDA    M_Y,Y          ; checking the Y range
            TAX
            INX
            CPX    Y0
            BLT    :DOTHAT
            CPX    Y1
            BEQ    :SKIP11        ; if <=, in the same room
            BGE    :DOTHAT
:SKIP11     LDA    M_LEVEL,Y
            CMP    MAPADDR+1
            BEQ    :DOTHIS        ; if ==, save level too!
:DOTHAT     INY
            CPY    #MONSMAX
            BGE    :EXITNOW
            BLT    :CHECKIT
:DOTHIS     JSR    UPSCREEN
:EXITNOW    RTS
TYPCONST    DFB    2,4,1

CH4CHAR     LDA    M_LEVEL,Y      ; check if on same leve
            CMP    MAPADDR+1      ;   as Meltok
            BEQ    :CHECKX
            SEC
            RTS
:CHECKX     LDA    M_X,Y
            SEC
            SBC    CX
            CLC                   ; why, i do not know
            ADC    #1
            CMP    #1
            BEQ    :CHECKY0       ; Y should = 0; horizontal
            CMP    #-1
            BEQ    :CHECKY0       ; Y should = 0; horizontal
            CMP    #0
            BEQ    :CHECKY        ; check for vertical
            SEC
            RTS
:CHECKY     LDA    M_Y,Y
            SEC
            SBC    CY
            CLC                   ; why, i do not know
            ADC    #1
            CMP    #1
            BEQ    :ATTACK
            CMP    #-1
            BEQ    :ATTACK
            SEC
            RTS
:CHECKY0    LDA    M_Y,Y
            SEC
            SBC    CY
            CLC                   ; why, i do not know
            ADC    #1
            CMP    #0             ; we have a horizontal attack!
            BEQ    :ATTACK
            SEC
            RTS
:ATTACK     LDA    M_TYPE,Y
            JSR    M:OWIE
            CLC
            RTS

M_TOWARD    LDA    CURMON_X
            CMP    CX
            BEQ    :CHECKY
            BLT    :XISLESS
            DEC    CURMON_X
            JMP    :FINISHX
:XISLESS    INC    CURMON_X
:FINISHX    JSR    MONMOVCK
            BCC    M_REGMOV       ; ok move!
            LDY    CURMONST
            LDA    M_X,Y
            STA    CURMON_X
:CHECKY     LDA    CURMON_Y
            CMP    CY
            BEQ    :_RANDOM       ; do random move
            BLT    :YISLESS
            DEC    CURMON_Y
            JMP    :FINISHY
:YISLESS    INC    CURMON_Y
:FINISHY    JSR    MONMOVCK
            BCC    M_REGMOV       ; ok, move!
            LDY    CURMONST
            LDA    M_Y,Y
            STA    CURMON_Y
:_RANDOM    JMP    M_RANDOM

M_REGMOV    LDY    CURMONST
            LDA    CURMON_X
            STA    M_X,Y
            LDA    CURMON_Y
            STA    M_Y,Y
            RTS

M_RANDOM    LDA    RANDOM1
            BMI    :XDOWN
:XUP        INC    CURMON_X
            JMP    :CHECKX
:XDOWN      DEC    CURMON_X
:CHECKX     JSR    MONMOVCK
            BCS    :DO_Y          ; was bad location
            JMP    M_REGMOV
:DO_Y       LDY    CURMONST       ; restore old X value
            LDA    M_X,Y          ;  (this way monster does not
            STA    CURMON_X       ;  move diagonally)
            LDA    RANDOM2
            BMI    :YDOWN
:YUP        INC    CURMON_Y
            JMP    :CHECKY
:YDOWN      DEC    CURMON_Y
:CHECKY     JSR    MONMOVCK
            BCS    :NO_GO         ; was bad location
            JMP    M_REGMOV
:NO_GO      LDA    #0             ; make a move possible
            LDY    CURMONST       ;   next time through.
            STA    M_MOVE,Y       ;   (no move done this time)
            LDA    M_Y,Y          ; restore current Y value to
            STA    CURMON_Y       ;   general locations..
            RTS

MONMOVCK    LDX    CURMON_X       ; monster move check routine
            LDY    CURMON_Y
            LDA    CURMON_L
            CMP    MAPADDR+1      ; check level
            BNE    :GO_ON
            INX                   ; to overcome MAPINDEX's add
            INY
            CPX    CX
            BNE    :GO_ON
            CPY    CY
            BEQ    :BAD           ; that is the character!
:GO_ON      LDA    MAPADDR+1
            PHA
            LDA    CURMON_L
            STA    MAPADDR+1
            JSR    MAPINDEX
            CMP    #100           ; text = blank space
            BGE    :GOOD
            CMP    #3             ; unlocked door
            BEQ    :GOOD
            CMP    #5             ; found secret door
            BEQ    :GOOD
            CMP    #6             ; chest
            BEQ    :GOOD
            CMP    #7             ; opened chest
            BEQ    :GOOD
            CMP    #8             ; ladder
            BEQ    :GOOD
            CMP    #9             ; throne
            BEQ    :GOOD
            CMP    #10            ; Jewel of Kaldun
            BEQ    :GOOD
            CMP    #11            ; empty holder
            BEQ    :GOOD
:BAD        PLA                   ; restore real address
            STA    MAPADDR+1      ;   of map.
            SEC
            RTS
:GOOD       PLA                   ; restore real address
            STA    MAPADDR+1      ;   of map.
            CLC
            RTS


********************************
* Monsters Hit                 *
********************************
MONSHIT     LDY    #0
:NEXTMON    LDA    M_HP,Y
            BEQ    :NOTHERE
            LDA    M_X,Y
            TAX
            INX
            CPX    DIR:X
            BNE    :NOTHERE
            LDA    M_Y,Y
            TAX
            INX
            CPX    DIR:Y
            BNE    :NOTHERE
            LDA    M_HP,Y
            SEC
            SBC    CLEVEL         ; lose CLEVEL hit points
            STA    M_HP,Y
            BEQ    :DEAD
            BCS    :ALIVE
:DEAD       LDA    M_TYPE,Y
            TAX
            LDA    M_XPER-12,X
            STA    XPGAIN
            ADDW   XPGAIN;XP;XP
            TYA
            PHA
            JSR    STATUSXP
            PRINT  MONDEAD
            PLA
            TAY
            LDA    #0
            STA    M_HP,Y
            JSR    UPSCREEN       ; monster died, redraw screen
:ALIVE      LDA    #0
            RTS
:NOTHERE    INY
            CPY    #MONSMAX
            BNE    :NEXTMON
            LDA    #0
            RTS
M_XPER      DFB    30,10,75       ; experience points/monsters
MONDEAD     HEX    825501         ; vtab 22:htab 1
            ASC    "You killed the monster!  You receive"8D80
            DA     XPGAIN
            ASC    " experience points."00
XPGAIN      HEX    0000


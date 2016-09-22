********************************
*                              *
*       Jewel of Kaldun        *
* (primary application segment)*
*                              *
*          written by          *
*  https://github.com/a2geek   *
*                              *
*           story by           *
*  https://github.com/bshagle  *
*                              *
*    Copyright (c) 1990,2016   *
*                              *
********************************

* Code location:

            ORG    $6000

* External references:
            ; reset.s
RESETUP     EXT
RESTORE     EXT
            ; endgame.s
THEDEATH    EXT
            ; graphics.s
HGRCLEAR    EXT

* Memory map:
*      __________
*     |          | $FFFF
*     |  ProDOS  |   to    ProDOS/ROM
*     |__________| $BF00
*     |          | $BEFF
* --> |  J.O.K.  |   to    Main program
*     |__________| $6000
*     |          | $5FFF
*     |  HGR P2  |   to    Copy of title page
*     |__________| $4000
*     |          | $3FFF
*     |  HGR P1  |   to    Graphics display
*     |__________| $2000
*     |          | $1FFF
*     | Map/Stat |   to    Map & Stats (to $1Cxx)
*     |__________| $1000
*     |          | $0FFF
*     |  J.O.K.  |   to    JOK End Game routines
*     |__________| $0800       Reset routines
*     |          | $07FF
*     | TextPage |   to    Text page
*     |__________| $0400
*     |          | $03FF   Free         ($0200-$03CF)
*     | Zp & St  |   to    System Stack ($0100-$01FF)
*     |__________| $0000   Zero Page    ($0000-$00FF)
*

* Save file name:

            DSK    JEWEL.OF.KALDUN.bin

* Add in macro files:

            USE    jok-includes.inc
            PAG
            USE    io.mac
            PAG
            USE    general.mac
            PAG
            USE    math.mac
            PAG
            USE    prolib.mac
            PAG

RETURN      =      $8D                 ; ASCII for <return> (high bit on)
ESCAPE      =      $9B                 ; ASCII for <escape> ( "    "  " )

LEVEL1      =      $1000
LEVEL2      =      $1600

********************************
* Jewel Of Kaldun, main file:  *
********************************

            JSR    RESETUP
            LDA    #$20                ; page 1 of Hires...
            STA    230
            JSR    INIT                ; initialize screens, etc.
            JSR    CLRSCRN
            JSR    CHEKCASE
            JSR    HGRCLEAR
            JSR    TITLEPG             ; draw title page
            JSR    WALLFADE            ; fade in wall
            JSR    HSTORE              ; store hi-res page @ $4000
MAIN        ENT
            JSR    HRESTORE            ; restore hi-res page
            JSR    SCPREP
            JSR    SETHGR              ; ensure that hi-res is on
            JSR    SCROLL
            CMP    #RETURN
            BEQ    :PLAYGAM
            CMP    #"Q"
            BEQ    :BYEQUIT
            CMP    #"q"
            BEQ    :BYEQUIT
            CMP    #"I"
            BEQ    :INSTR
            CMP    #"i"
            BNE    MAIN
:INSTR      JSR    TEXT
            JSR    STORY
            JMP    MAIN
:BYEQUIT    JSR    DOQUIT
            JMP    MAIN
:PLAYGAM    JSR    LOADER
            JSR    HGRCLEAR
            JSR    CLRSCRN
            LDA    LOADSTAT
            CMP    #1
            BEQ    :RESTART
            JSR    MONSINIT            ; clear out monsters
            MOVW   #0;GP
            MOVW   #0;XP
            MOVW   #100;XPREQD
            MOVB   #0;KEY
            MOVB   #0;SPKEY
            MOVB   #10;HP
            MOVB   #10;MAXHP
            MOVB   #1;CLEVEL
            MOVB   #25;CX
            MOVB   #32;CY
            MOVB   #-1;OX
            MOVB   #-1;OY
            MOVB   #-1;X0
            MOVB   #-1;Y0
            MOVW   #LEVEL1;MAPADDR
:RESTART    JSR    STATLINE
            JSR    STATUSGP
            JSR    STATUSKY
            JSR    STATUSHP
            JSR    STATUSXP
:UPDATE     JSR    UPSCREEN
:GOING      JSR    CHKLEVEL
            JSR    CTRLLOOP
            PHA                        ; save exit code
            JSR    MOVMONST
            PLA                        ; and restore it
            JSR    CHKLIFE
            BEQ    :GOING
            CMP    #-1
            BNE    :UPDATE
            JSR    CBOT3
            JSR    GETRET
            JMP    MAIN

********************************
* Check if user can handle     *
* lower case letters.          *
********************************
CHEKCASE    LDX    #%00000000          ; default: Mixed mode
            LDA    MACHID
            AND    #%11001000          ; Keep ID bits
            BEQ    :CHECK              ; Have an Apple II
            CMP    #%01000000          ; Check for an Apple II+
            BNE    :OKAY               ;  Nope.
:CHECK      PRINT  CASEMSG             ; ask if user can view in
            JSR    GETYN               ; lower case
            BCC    :OKAY
            LDX    #%10000000
:OKAY       STX    AUTOCAPS            ; adjust for user.
            RTS
CASEMSG     HEX    4A83
            ASC    "DO YOU HAVE LOWERCASE?"8D83
            ASC    "(Y/N)"00

********************************
* Check if player wishes to    *
* quit.                        *
********************************
DOQUIT      ENT
            PRINT  QUITMSG
            JSR    GETYN
            BCC    :QUITJOK
            JSR    CBOT3
            RTS

:QUITJOK    LDY    #0                  ; copy quit-code
:QLOOP      LDA    BEGQUIT,Y           ; to $200
            STA    $200,Y
            INY
            CPY    #ENDQUIT-BEGQUIT+1
            BLT    :QLOOP
            LDY    #0                  ; restore
:MLOOP      LDA    RESTORE,Y           ; old reset vector
            STA    $3F2,Y
            INY
            CPY    #3
            BLT    :MLOOP
            JMP    $200+$7             ; skip quit code
BEGQUIT     DFB    4                   ; quit code
            DFB    0
            DW     0000
            DFB    0
            DW     0000

            MOVW   #$400;PTR           ; clear memory
            LDA    #0                  ; from $400 to
            LDY    #0                  ; $BEFF
:LOOP       STA    (PTR),Y
            INY
            BNE    :LOOP
            STA    SPEAKER
            INC    PTR+1
            LDA    PTR+1
            CMP    #$BF
            BLT    :LOOP
            JSR    $FB2F               ; text..
            JSR    $FC58               ; clear screen
            LDA    #"S"                ; print "SMILE!"
            STA    $400                ; the hard way...
            LDA    #"M"
            STA    $401
            LDA    #"I"
            STA    $402
            LDA    #"L"
            STA    $403
            LDA    #"E"
            STA    $404
            LDA    #"!"
            STA    $405
            LDY    #20                 ; pause
:PAUSE      LDA    #255
            JSR    $FCA8
            DEY
            BNE    :PAUSE
            JSR    $BF00               ; quit.
            DFB    $65
            DW     $200
            HEX    00
ENDQUIT
QUITMSG     HEX    5783
            ASC    "Do you wish to exit?"00

********************************
* Check to see if Meltok is    *
* still alive!                 *
********************************
CHKLIFE     PHA
            LDA    HP                  ; check hp
            BEQ    :DEATH              ; if hp=0, dead
            CMP    MAXHP               ; check against max
            BLT    :ALIVE              ; if hp<max, alive
            BEQ    :ALIVE              ; if hp=max, alive
:DEATH      PLA                        ; throw away old status
            JSR    CLRSCRN             ; clear text screen
            PRINT  DEATHMSG
            JSR    THEDEATH            ; do death routine
            LDA    #-1                 ; done with game
            RTS
:ALIVE      PLA                        ; use old status
            RTS
DEATHMSG    HEX    825583
            ASC    "... Suddenly ..."00

********************************
* Check to see if Meltok has   *
* advanced a level.            *
********************************
CHKLEVEL    LDA    XP+1                ; check hi byte of xp
            CMP    XPREQD+1            ; against xpreq'd
            BLT    :NOINCR             ; if xp<xpreq'd, no up lvl
            BEQ    :CHECKLO            ; if xp=xpreq'd, check lo byte
            BGE    :UPLEVEL            ; if xp>xpreq'd, go up level!
:NOINCR     RTS
:CHECKLO    LDA    XP                  ; check lo byte of xp
            CMP    XPREQD              ; against xpreq'd
            BLT    :NOINCR             ; if xp<xpreq'd, no up lvl
:UPLEVEL    SUBW   XP;XPREQD;XP        ; xp= xp - xpreq'd
            IMULW  XPREQD;#2;XPREQD    ; xpreq'd= xpreq'd * 2
            INC    CLEVEL              ; add 1 to character level
            LDA    RANDOM1             ; generate random number
            EOR    RANDOM3
            AND    #%00001111          ; go up 1-16 hit points
            CLC
            ADC    MAXHP
            STA    MAXHP               ; add 0-15 to maxhp
            INC    MAXHP               ; add +1 to maxhp.
            MOVB   MAXHP;HP            ; and restore char to full H.
            JSR    STATUSXP            ; update XP
            JSR    STATUSHP            ; and HP...
            PRINT  ADVANCED            ; print advancement msg
            STA    KEYSTROB
:WAITESC    LDA    KEYBOARD            ; wait for user to press
            CMP    #$8D                ;   RET to continue with
            BNE    :WAITESC            ;   game.
            STA    KEYSTROB
            JSR    CBOT3
            RTS                        ; serves as exit.
ADVANCED    HEX    825501              ; vtab 22:htab 1
            ASC    "You have advanced a level!  Meltok is"8D
            ASC    "now level "80
            DA     CLEVEL
            ASC    " and needs "81
            DA     XPREQD
            ASC    " experience"8D
            ASC    "points to advance to next level.  [RET]"00

********************************
* Initialize Text Screen and   *
* any variables that are       *
* required to be pre-set.      *
********************************

INIT        LDA    #149
            JSR    $FDED               ; disable 80 colums
            JSR    TEXT                ; set text mode
            LDA    #0
            STA    KEY
            STA    SPKEY
            STA    GP
            STA    XP
            STA    XP+1
            LDA    #<100
            STA    XPREQD
            LDA    #>100
            STA    XPREQD+1
            LDA    #10
            STA    HP
            STA    MAXHP
            LDA    #1
            STA    CLEVEL
            RTS

********************************
* Variables for Jewel of       *
* Kaldun, all are external:    *
*   GP: Gold Pieces            *
*   XP: Experience             *
*   XPREQD: Experience required*
*   KEY: Number of keys        *
*   SPKEY: Special key flag    *
*   HP: Hit Points             *
*   MAXHP: Maximum HP          *
*   CLEVEL: Character level    *
********************************

GP          =      $1C00
XP          =      $1C02
XPREQD      =      $1C04
KEY         =      $1C06
SPKEY       =      $1C07
HP          =      $1C08
MAXHP       =      $1C09
CLEVEL      =      $1C0A
CX          =      $1C0B
CY          =      $1C0C
XOFF        =      $1C0D
YOFF        =      $1C0F
MAPADDR     =      $1C11
OX          =      $1C13
OY          =      $1C14
DX          =      $1C15
DY          =      $1C16
AX          =      $1C17
AY          =      $1C18
X0          =      $1C19
Y0          =      $1C1A
X1          =      $1C1B
Y1          =      $1C1C
TEMP0       =      $1C1D
WX          =      $1C1E
WY          =      $1C1F
ZX          =      $1C20
ZY          =      $1C21
TEMPX       =      $1C22
TEMPY       =      $1C23
XPLACE      =      $1C24
YPLACE      =      $1C26
NX          =      $1C28
NY          =      $1C29
CH:X        =      $1C2A
CH:Y        =      $1C2C

* Monster variables:

MONSMAX     =      30
M_HP        =      $1C2E
M_TYPE      =      $1C4C
M_X         =      $1C6A
M_Y         =      $1C88
M_MOVE      =      $1CA6
M_X0        =      $1CC4
M_X1        =      $1CE2
M_Y0        =      $1D00
M_LEVEL     =      $1D1E

* Add in all routines:

            PAG
            PUT    input.output
            PAG
            PUT    convert
            PAG
            PUT    graphics
            PAG
            PUT    math
            PAG
            PUT    castles
            PAG
            PUT    shapes
            PAG
            PUT    title
            PAG
            PUT    prolib
            PAG
            PUT    filing
            PAG
            PUT    places
            PAG
            PUT    noise
            PAG
            PUT    display
            PAG
            PUT    monsters
            PAG
            PUT    main.control
            PAG
            PUT    story


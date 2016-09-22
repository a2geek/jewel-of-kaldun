* External references
            ; endgame.s
GAMEWON     EXT
           ; jewel.of.kaldun.s
DATA       EXT

********************************
* Main Control Loop            *
********************************
CTRLLOOP    STA    KEYSTROB
            MOVB   #2;SNUM
            LDA    #%00000000
            STA    DRAWFLAG
            LDX    CX
            LDY    CY
            JSR    MAPINDEX
            CMP    #3
            BEQ    :SETFLAG
            CMP    #5
            BNE    :KEYLOOP
:SETFLAG    LDA    #%10000000
            STA    DRAWFLAG
:KEYLOOP    JSR    M:GETKEY
            PHA
            JSR    MONCHECK          ; check for new monsters
            JSR    CBOT3
            PLA
            CMP    #ESCAPE
            BNE    :CHKKEY
            JSR    GAMEDONE
            JMP    :KEYLOOP
:CHKKEY     JSR    CHARCAPS
:CONT       CMP    #"I"
            BEQ    :_UP
            CMP    #"M"
            BEQ    :_DOWN
            CMP    #"J"
            BEQ    :_LEFT
            CMP    #"K"
            BEQ    :_RIGHT
            CMP    #"F"
            BEQ    :_FIGHT
            CMP    #"$"
            BEQ    :_SAVE
            CMP    #"O"
            BEQ    :_OPENCH
            CMP    #"U"
            BEQ    :_UNLOCK
            CMP    #"R"
            BEQ    :_REST
            CMP    #"S"
            BEQ    :_SEARCH
            CMP    #"H"
            BEQ    :_HEALTH
            CMP    #"W"
            BEQ    :_WEALTH
            CMP    #"A"
            BEQ    :_ASCEND
            CMP    #"D"
            BEQ    :_DESCEN
            CMP    #"L"
            BEQ    :_LOOK
            CMP    #"T"
            BEQ    :_TAKE
            CMP    #"?"
            BEQ    :_HELP
            JSR    CBOT3
            JMP    :KEYLOOP
:_UP        JMP    M:UP              ; command table
:_DOWN      JMP    M:DOWN
:_LEFT      JMP    M:LEFT
:_RIGHT     JMP    M:RIGHT
:_FIGHT     JMP    M:FIGHT
:_SAVE      JMP    SAVER
:_OPENCH    JMP    M:OPENCH
:_UNLOCK    JMP    M:UNLOCK
:_SEARCH    JMP    M:SEARCH
:_HEALTH    JMP    M:HEALTH
:_WEALTH    JMP    M:WEALTH
:_REST      JMP    M:REST
:_ASCEND    JMP    M:ASCEND
:_DESCEN    JMP    M:DESCEN
:_LOOK      JMP    M:LOOK
:_TAKE      JMP    M:TAKE
:_HELP      JMP    M:HELP

********************************
* Gets a key, keeping counters *
* randomizing.                 *
********************************
M:GETKEY    STA    KEYSTROB
:REPEAT     INC    RANDOM1
            BNE    :MORE
            INC    RANDOM2
            BNE    :MORE
            INC    RANDOM3
:MORE       LDA    KEYBOARD
            BPL    :REPEAT
            RTS
RANDOM1     HEX    00
RANDOM2     HEX    00
RANDOM3     HEX    00

********************************
* Capitalizes character stored *
* in Accumulator.              *
********************************
CHARCAPS    CMP    #"a"              ; compare to "a"
            BLT    :CONT             ; if Acc < "a" then exit
            CMP    #"z"+1            ; compare to "z"+1
            BGE    :CONT             ; if Acc => "z"+1, exit
            SEC
            SBC    #"a"-"A"          ; capitalize char
:CONT       RTS

********************************
* Get direction to do an act.  *
********************************
DIR:X       HEX    00                ; direction to go X
DIR:Y       HEX    00                ; direction to go Y
M:GETDIR    JSR    M:GETKEY          ; get a keypress
            JSR    CHARCAPS          ; capitalize key
            LDX    #0
            LDY    #-1
            CMP    #"I"
            BEQ    :FOUND
            LDY    #1
            CMP    #"M"
            BEQ    :FOUND
            LDY    #0
            LDX    #-1
            CMP    #"J"
            BEQ    :FOUND
            LDX    #1
            CMP    #"K"
            BNE    M:GETDIR
:FOUND      STX    DIR:X             ; exits with X, Y
            STY    DIR:Y             ; and Acc relating to call.
            RTS

********************************
* Print a help screen.         *
********************************
M:HELP      STA    $C051             ; switch to text
            JSR    CLRSCRN           ; clear the text screen
            PRINT  HELPMSG
            JSR    GETRET            ; wait for a RETURN.
            JSR    CLRSCRN
            STA    $C050             ; switch to graphics
            JSR    STATLINE          ; re-print status line
            LDA    #0
            RTS
HELPMSG     HEX    4083
            ASC    "<< Help >>"8D
            ASC    "Key        Description"8D
            ASC    "---------  ----------------------------"8D
            ASC    "?          Display this help screen."8D
            ASC    "$          Saves current game to disk."8D
            ASC    "A,D        Tell Meltok to Ascend or"8D
            ASC    "           Descend a ladder."8D
            ASC    "L,T,U      Look, Take, or Unlock.  Use"8D
            ASC    "           direction keys to point."8D
            ASC    "O          Open a chest that Meltok is"8D
            ASC    "           standing over."8D
            ASC    "H,W,R      Health, Wealth, or Rest."8D
            ASC    "           Displays Meltoks' condition."8D
            ASC    "           Rest heals Meltok by one HP."8D
            ASC    "F          Fight monster, use dir keys."8D8D83
            ASC    "<< DIRECTION KEYS >>"8D83
            ASC    "(north)"8D83
            ASC    "I"8D83
            ASC    "(west)  J K  (east)"8D83
            ASC    "M"8D83
            ASC    "(south)"00

********************************
* Fight a monster.             *
********************************
M:FIGHT     PRINT  FIGHTMSG
            JSR    M:GETDIR          ; get direction offsets
            ADDB   CX;DIR:X;DIR:X
            ADDB   CY;DIR:Y;DIR:Y
            LDX    DIR:X
            LDY    DIR:Y
            JSR    MAPINDEX
            CMP    #12
            BNE    :NEXT01
            JMP    :AGHOST
:NEXT01     CMP    #13
            BNE    :NEXT02
            JMP    :ABLOB
:NEXT02     CMP    #14
            BNE    :NEXT03
            JMP    :AZOMBIE
:NEXT03     CMP    #100
            BNE    :NEXT04
            JMP    :BLANK
:NEXT04     CMP    #1
            BNE    :NEXT05
            JMP    :WALL
:NEXT05     CMP    #3
            BNE    :NEXT06
            JMP    :DOOR
:NEXT06     CMP    #4
            BNE    :NEXT07
            JMP    :DOOR
:NEXT07     CMP    #5
            BNE    :NEXT08
            JMP    :DOOR
:NEXT08     CMP    #6
            BNE    :NEXT09
            JMP    :CHEST
:NEXT09     CMP    #7
            BNE    :NEXT10
            JMP    :CHEST
:NEXT10     CMP    #8
            BNE    :NEXT11
            JMP    :LADDER
:NEXT11     CMP    #9
            BNE    :NEXT12
            JMP    :THRONE
:NEXT12     CMP    #10
            BNE    :NEXT13
            JMP    :JEWEL
:NEXT13     CMP    #11
            BNE    :NEXT14
            JMP    :HOLDER
:NEXT14     CMP    #98
            BNE    :NEXT15
            JMP    :WALL
:NEXT15     CMP    #99
            BNE    :NEXT16
            JMP    :CHEST
:NEXT16     PRINT  FIGHTHUH
            LDA    #0
            RTS
:AGHOST     LDA    CLEVEL            ; auto hit at lvl > 6
            CMP    #7
            BGE    :HITIT
            LDA    RANDOM1
            AND    #%00000011        ; 1 in 4 chance of hitting
            BEQ    :HITIT            ;   a ghost
:MISSED     PRINT  FIGHTMIS
            LDA    #0
            RTS
:ABLOB      LDA    CLEVEL            ; automatic hit at lvl > 2
            CMP    #3
            BGE    :HITIT
            LDA    RANDOM1
            AND    #%00000001        ; 50% chance of a blob
            BEQ    :HITIT
            BNE    :MISSED
:AZOMBIE    LDA    CLEVEL            ; auto hit at lvl > 4
            CMP    #5
            BGE    :HITIT
            LDA    RANDOM1
            AND    #%00000001        ; 50% chance of a zombie
            BNE    :MISSED
:HITIT      PRINT  FIGHTHIT
            JSR    MONSBUZZ
            JSR    MONSHIT
            LDA    #0
            RTS
:BLANK      PRINT  FIGHTBLA
            LDA    #0
            RTS
:WALL       PRINT  FIGHTWAL
            LDA    #0
            RTS
:DOOR       PRINT  FIGHTDOO
            LDA    #0
            RTS
:CHEST      PRINT  FIGHTCHE
            LDA    #255              ; smashed chest
:DISAPPR    PHA
            LDX    DIR:X
            LDY    DIR:Y
            JSR    MAPINDEX
            PLA
            STA    (PTR),Y
            JSR    UPSCREEN
            LDA    #0
            RTS
:LADDER     PRINT  FIGHTLAD
            LDA    #254              ; smashed ladder
            JMP    :DISAPPR
:THRONE     PRINT  FIGHTTHR
            JSR    GOTDAMAG
            LDA    #0
            RTS
:JEWEL      PRINT  FIGHTJE1
            LDY    #5
:WAIT1      LDA    #0
            JSR    WAIT
            DEY
            BNE    :WAIT1
            JSR    GOTDAMAG
            LDA    #0                ; and erase all HP's!
            STA    HP
            JSR    STATUSHP
            PRINT  FIGHTJE2
            LDY    #5
:WAIT2      LDA    #0
            JSR    WAIT
            DEY
            BNE    :WAIT2
            LDA    #0
            RTS
:HOLDER     PRINT  FIGHTHOL
            LDA    #0
            RTS
MONSBUZZ    MOVB   #15;SNUM
            LDA    #%00000000
            STA    CLRFLAG
            LDA    #%10000000
            STA    XORFLAG
            MOVB   #4;HITCOUNT
:BUZZER     LDY    MAP_MNUM
            LDA    M_X0,Y
            TAX
            LDA    M_X1,Y
            PHA
            LDA    M_Y0,Y
            TAY
            PLA
            JSR    DRAWSHAP
            MOVB   #20;VOLUME
            MOVB   #150;DURATION
            MOVB   #$80;FREQUENC
            JSR    DONOISE
            DEC    HITCOUNT
            BNE    :BUZZER
            LDA    #0
            STA    XORFLAG
            RTS
TEMP:X      HEX    00
TEMP:Y      HEX    00
FIGHTMSG    HEX    825683
            ASC    "Fight which monster?"
            HEX    00
FIGHTHUH    HEX    825683
            ASC    "huh?"
            HEX    00
FIGHTBLA    HEX    825683
            ASC    "Swish..."
            HEX    00
FIGHTWAL    HEX    825683
            ASC    "You give the wall a sound beating."
            HEX    00
FIGHTDOO    HEX    825683
            ASC    "Thwop!  A few nicks appear in the door."
            HEX    00
FIGHTCHE    HEX    825683
            ASC    "Thwump!  The chest breaks into"8D83
            ASC    "splinters!"
            HEX    00
FIGHTLAD    HEX    825683
            ASC    "Whoops!  Now you've destroyed the"8D83
            ASC    "ladder... better control your anger!"
            HEX    00
FIGHTTHR    HEX    825683
            ASC    "You hurt your hands as the blade"8D83
            ASC    "bounces off of the throne."
            HEX    00
FIGHTJE1    HEX    825683
            ASC    "Oops.  Now you've done it!"
            HEX    00
FIGHTJE2    HEX    825683
            ASC    "The Jewel explodes!"
            HEX    00
FIGHTHOL    HEX    825683
            ASC    "Why?"
            HEX    00
FIGHTMIS    HEX    825683
            ASC    "You missed it!"
            HEX    00
FIGHTHIT    HEX    825683
            ASC    "You hit the monster!"
            HEX    00

********************************
* Take some object.            *
********************************
M:TAKE      PRINT  TAKEMSG
            JSR    M:GETDIR          ; get direction offsets
            ADDB   CX;DIR:X;DIR:X
            ADDB   CY;DIR:Y;DIR:Y
            LDX    DIR:X
            LDY    DIR:Y
            JSR    MAPINDEX
            CMP    #10               ; check for JOK
            BNE    :NOWAY
            LDA    #11               ; place empty holder
            STA    (PTR),Y
            LDA    #$80              ; mark "special key" variable
            STA    SPKEY             ;   with $80 for have Jewel
            PRINT  GOTJEWEL
            MOVW   #LEVEL1;MAPADDR   ; placing @ level 1
            LDX    #1                ; place main gate with a wall...
            LDY    #30               ;   @(24,30) - (26,30)
            JSR    MAPINDEX          ; trick to get address..
            LDY    #23               ; (x=24,25,26) set for x-1...
            LDA    #22               ; a wall --
            STA    (PTR),Y           ;   across
            INY                      ;   all
            STA    (PTR),Y           ;   of the
            INY                      ;   main
            STA    (PTR),Y           ;   gate!!  No way out!
            MOVW   #LEVEL2;MAPADDR   ; return to level 2
            JSR    UPSCREEN          ; update screen at new location
            MOVB   #29;CY            ; place Meltok in another
            MOVB   #4;CX             ; position.
            MOVB   #-1;OX            ; tell display routine
            MOVB   #-1;OY            ; that the screen must
            MOVB   #-1;X0            ; be erased and redrawn
            MOVB   #-1;Y0
            LDY    #15
:PAUSE      LDA    #255
            JSR    WAIT              ; pause a bit
            DEY
            BNE    :PAUSE
            PRINT  TELEPORT
            JSR    UPSCREEN          ; surprise!!
            LDA    #0
            RTS
:NOWAY      PRINT  NOTEQUIP
            RTS
TAKEMSG     HEX    825683
            ASC    "What do you wish to take?"00
NOTEQUIP    HEX    825683
            ASC    "I regret to inform you that you are"8D83
            ASC    "not equipped to take that!!"00
GOTJEWEL    HEX    825683
            ASC    "As you pick up the Jewel, you realize"8D83
            ASC    "that there is probably some trap!"00
TELEPORT    HEX    825683
            ASC    "Alas, you were right.  You have been"8D83
            ASC    "teleported elsewhere in the castle!"00

********************************
* Look in some direction.      *
********************************
M:LOOK      PRINT  LOOKMSG
            JSR    M:GETDIR          ; get direction offsets
            ADDB   CX;DIR:X;DIR:X    ; modify current x
            ADDB   CY;DIR:Y;DIR:Y    ; and y
            LDX    DIR:X
            LDY    DIR:Y
            JSR    MAPINDEX          ; get index at that location.
            CMP    #98               ; check for secret door
            BNE    :CONT255          ; if it is one, make it a
            LDA    #1                ; wall.
:CONT255    CMP    #255              ; check if it is a smashed
            BNE    :CONT254          ; chest (#255)
            PRINT  SEE255
            LDA    #0
            RTS
:CONT254    CMP    #254              ; check if it is a smashed
            BNE    :CONT             ; ladder (#254)
            PRINT  SEE254
            LDA    #0
            RTS
:CONT       CMP    #99               ; check for special chest
            BNE    :CONT2            ; if it is one, do some
            PRINT  SEE99             ; special handling.
            LDA    #0
            RTS
:CONT2      CMP    #22               ; barred door
            BNE    :CONT3
            PRINT  SEE22             ; special handling
            LDA    #0
            RTS
:CONT3      CMP    #97               ; check if special door
            BNE    :MORE
            LDA    #4                ; make special door "locked"
:MORE       CMP    #15               ; no shapes => #15
            BLT    :DOLOOK           ; this handles room desc.
            LDA    #0                ; fake it - blank space!
:DOLOOK     PHA
            JSR    CBOT3             ; clear botton 3 lines
            LDA    #22               ; set vtab @ 22.
            STA    TLINE
            JSR    TEXTADDR
            PLA
            ASL                      ; multiply shape # by 2
            TAY
            LDA    SEETABLE,Y        ; get address of message
            STA    DATA              ; and prepare for center
            INY                      ; routine
            LDA    SEETABLE,Y
            STA    DATA+1
            JSR    CSTRING           ; center string...
            LDA    #0
            RTS
SEETABLE    DA     SEE00,SEE01,SEE02,SEE03,SEE04,SEE05
            DA     SEE06,SEE07,SEE08,SEE09,SEE10,SEE11
            DA     SEE12,SEE13,SEE14
SEE00       ASC    "The empty air confounds you."00
SEE01       ASC    "The wall appears very solid."00
SEE02       ASC    "Huh?  That's yourself!"00
SEE03       ASC    "This door is standing wide open."00
SEE04       ASC    "The door appears to be locked..."00
SEE05       ASC    "Remember?  You found the secret door!"00
SEE06       ASC    "The chest might contain something!"00
SEE07       ASC    "You glance at an empty chest."00
SEE08       ASC    "That is a ladder."00
SEE09       ASC    "You see an ornate throne."00
SEE10       ASC    "That is the Jewel of Kaldun!!"00
SEE11       ASC    "It appears to be an empty holder..."00
SEE12       ASC    "You barely see the outline of a ghost."00
SEE13       ASC    "You see a blob creeping up on you!"00
SEE14       ASC    "Watch out!  That is a zombie!"00
SEE22       HEX    825683
            ASC    "The door is barred.  No way out!?"00
SEE99       HEX    825683
            ASC    "This chest has arcane symbols written"8D83
            ASC    "all over.  It may be dangerous!"00
SEE254      HEX    825683
            ASC    "Whoa, that ladder is ruined!"00
SEE255      HEX    825683
            ASC    "Wow, you really smashed this chest."00
LOOKMSG     HEX    825683
            ASC    "Look in which direction?"00

********************************
* Ascend a ladder.             *
********************************
M:ASCEND    LDX    CX
            LDY    CY
            JSR    MAPINDEX          ; get attr @ (x,y)
            CMP    #8                ; is it a ladder?
            BNE    :NOGO             ; nope -- can't do.
            LDA    #>LEVEL1          ; check if on first
            CMP    MAPADDR+1         ; level...
            BNE    :CANT             ; cant ascend!
            PRINT  DOASCEND
            MOVW   #LEVEL2;MAPADDR   ; point to 2nd level
            MOVB   #-1;OX            ; notify update routine
            MOVB   #-1;OY            ;  that the screen must
            MOVB   #-1;X0            ;  be cleared first.
            MOVB   #-1;Y0
            LDA    #1                ; ensure game is continued,
            RTS                      ; and map is updated
:CANT       PRINT  NOASCEND
            RTS
:NOGO       PRINT  NOLADDER
            RTS
DOASCEND    HEX    825683
            ASC    "Climbing up the ladder..."00
NOLADDER    HEX    825683
            ASC    "Meltok looks around and fails to"8D83
            ASC    "find a ladder that is near him!"00
NOASCEND    HEX    825683
            ASC    "You are already on the second level!"00

********************************
* Allow Meltok to descend a    *
* ladder.                      *
********************************
M:DESCEN    LDX    CX
            LDY    CY
            JSR    MAPINDEX          ; get attr @ (x,y)
            CMP    #8                ; is it a ladder?
            BNE    :NOGO             ; nope -- need a ladder
            LDA    #>LEVEL2          ; check to see if we are
            CMP    MAPADDR+1         ; on the second level.
            BNE    :CANT             ; nope -- can't descend.
            PRINT  DODESCEN          ; print message
            MOVW   #LEVEL1;MAPADDR   ; update pointer
            MOVB   #-1;OX            ; notify display routine
            MOVB   #-1;OY            ; that we need to clear
            MOVB   #-1;X0            ; the screen, since we are
            MOVB   #-1;Y0            ; on a new map!
            LDA    #1                ; ensure that game is continued,
            RTS                      ; and map is updated.
:CANT       PRINT  NODESCEN          ; can't descend this ladder.
            RTS
:NOGO       PRINT  NOLADDER          ; ain't no ladder 'round, bud!
            RTS
DODESCEN    HEX    825683
            ASC    "Climbing down the ladder..."00
NODESCEN    HEX    825683
            ASC    "You are already on the first level!"00

********************************
* Allows Meltok to rest: one   *
* hit point is healed.         *
********************************
M:REST      PRINT  RESTING           ; print message
            INC    HP                ; add 1 to hp
            LDA    MAXHP
            CMP    HP                ; compare maxhp w/ hp
            BGE    :OK               ; if maxhp => hp, ok
            STA    HP                ; not ok.  hp= maxhp.
:OK         JSR    STATUSHP          ; update hit points
            LDA    #0
            RTS
RESTING     HEX    825683
            ASC    "Meltok is resting."00

********************************
* Health routine: displays     *
* Meltok's health status.      *
* Incl. HP/Max HP              *
*       XP/Max XP              *
*       Character Level        *
********************************
M:HEALTH    PRINT  CHHEALTH
            RTS
CHHEALTH    HEX    825501
            ASC    "Meltok has:  "80
            DA     HP
            ASC    "/"80
            DA     MAXHP
            ASC    " Hit Points"8D0E81
            DA     XP
            ASC    "/"81
            DA     XPREQD
            ASC    " Exp. Points"8D0E
            ASC    "(Level "80
            DA     CLEVEL
            ASC    ".)"00

********************************
* Wealth routine: displays     *
* Meltok's wealth.             *
* Incl. GP and Keys            *
********************************
M:WEALTH    PRINT  CHWEALTH
            LDA    SPKEY
            CMP    #1
            BNE    :CJEWEL
            PRINT  CHSPKEY
:EXIT       LDA    #0
            RTS
:CJEWEL     CMP    #$80
            BNE    :EXIT
            PRINT  CHJEWEL
            JMP    :EXIT
CHWEALTH    HEX    825501
            ASC    "Meltok has:  "81
            DA     GP
            ASC    " Gold Pieces"8D0D
            ASC    " and "80
            DA     KEY
            ASC    " keys"00
CHSPKEY     HEX    570E
            ASC    "and a very ornate key!"00
CHJEWEL     HEX    570E
            ASC    "and the Jewel of Kaldun!"00

********************************
* Search for a secret door.    *
********************************
M:SEARCH    PRINT  SEARCHDI          ; get direction of search
            JSR    M:GETDIR
            ADDB   CX;DIR:X;DIR:X    ; add directions to char
            ADDB   CY;DIR:Y;DIR:Y    ; locations
            LDX    DIR:X
            LDY    DIR:Y
            JSR    MAPINDEX          ; get value @ (x,y)
            CMP    #98               ; check for secret door
            BNE    :NOGOOD           ; no door there
            LDA    #5                ; place found secret door
            STA    (PTR),Y           ; @ (x,y)
            JSR    UPSCREEN
            PRINT  SECFOUND
            RTS
:NOGOOD     PRINT  SECLOST
            RTS
SECFOUND    HEX    825683
            ASC    "You have found a secret door!"00
SECLOST     HEX    825683
            ASC    "You don't find anything of interest."00
SEARCHDI    HEX    825683
            ASC    "Search in which direction?"00

********************************
* Unlock a door.  Checks to    *
* see that user has a key, and *
* that a locked door is        *
* present in direction choosen.*
********************************
M:UNLOCK    LDA    KEY
            CLC
            ADC    SPKEY
            CMP    #1                ; do we have 1 or more keys?
            BLT    :NOKEYS           ; nope, error!
            PRINT  UNLOCKDI          ; get direction
            JSR    M:GETDIR
            ADDB   CX;DIR:X;DIR:X    ; add directions to char
            ADDB   CY;DIR:Y;DIR:Y    ; locations.
            LDX    DIR:X
            LDY    DIR:Y
            JSR    MAPINDEX          ; get the index
            CMP    #97               ; # for special door
            BEQ    :SPECIAL          ; yes, special door
            CMP    #3                ; # for opened door
            BEQ    :OPENED           ; door already opened.
            CMP    #4                ; # for locked door
            BNE    :NODOOR           ; locked door not there.
            LDA    KEY               ; check if we have normal keys
            BNE    :NORMAL           ; we have a normal door
            BEQ    :NOCANDO          ; no normal keys!
:SPECIAL    LDA    SPKEY
            BEQ    :NOCANDO          ; w/o special key, no go
            LDA    #0
            STA    SPKEY             ; kill special key, make it
            INC    KEY               ; a "normal" key...
:NORMAL     LDA    #3
            STA    (PTR),Y           ; place opened door...
            DEC    KEY               ; get rid of used key
            JSR    UPSCREEN          ; update screen
            JSR    STATUSKY          ; update key graph
            PRINT  UNLOCKGD
            RTS                      ; all done
:NOKEYS     PRINT  UNLOCKNO
            RTS
:NODOOR     PRINT  UNLOCKBD
            RTS
:OPENED     PRINT  OPENDOOR
            RTS
:NOCANDO    PRINT  OPENPROB
            RTS
UNLOCKDI    HEX    825683
            ASC    "Unlock door in which direction?"00
UNLOCKGD    HEX    825683
            ASC    "The door is unlocked!"00
UNLOCKNO    HEX    825683
            ASC    "You have no keys to unlock a door!"00
UNLOCKBD    HEX    825683
            ASC    "There is no door there!"00
OPENDOOR    HEX    825683
            ASC    "The door is already unlocked!"00
OPENPROB    HEX    825683
            ASC    "None of your keys fit this door!"00

********************************
* Opens a chest.  Checks for   *
* presence of a chest @ cx,cy  *
* and then uses random numbers *
* 1-3 to open, amount of gold, *
* and if a key is found.       *
********************************
SPECHEST    LDA    CLEVEL
            CMP    #2                ; must be level 2 or higher!!
            BLT    :NOLUCK
            LDA    RANDOM1
            AND    #%00001111        ; 0-16, 0 opens = 6.25% chance
            BNE    :NOLUCK
            LDA    #7
            STA    (PTR),Y
            LDA    #1                ; add special key to
            STA    SPKEY             ; inventory
            LDA    RANDOM2
            AND    #%00001111        ; 0-15 damage!
            STA    OPENTMP3
            ADDW   #250;XP;XP        ; +250 experience!
            SUBB   HP;OPENTMP3;HP
            JSR    UPSCREEN
            JSR    STATUSXP
            JSR    STATUSHP
            JSR    STATUSKY
            PRINT  G_ORNATE          ; got ornate!
            LDA    OPENTMP3          ; check if dart hit.
            BEQ    :EXIT             ; nope: lucky!
            PRINT  CDARTHIT
:EXIT       JSR    GETRET
            JSR    CBOT3
            RTS
:NOLUCK     PRINT  OPENNO
            RTS
M:SPEC      JMP    SPECHEST          ; too far to branch!
M:OPENCH    LDX    CX
            LDY    CY
            JSR    MAPINDEX
            CMP    #7                ; ID # for opened chest
            BEQ    :ISOPEN
            CMP    #99
            BEQ    M:SPEC
            CMP    #6                ; ID # for a chest
            BNE    :NOCHEST
            LDA    RANDOM1
            AND    #%00000111        ; 0-7, 0 opens = 12.5% chance
            BNE    :BADLUCK
            LDA    #7                ; ID # for opened chest.
            STA    (PTR),Y           ; store it.
            LDA    RANDOM2
            AND    #%00011111        ; 0-31 GP found
            STA    OPENTMP1
            ADDW   OPENTMP1;GP;GP
            ADDW   OPENTMP1;XP;XP
            LDA    RANDOM3
            AND    #%00000001        ; 0-1 KEYs found
            STA    OPENTMP2
            ADDB   OPENTMP2;KEY;KEY
            JSR    UPSCREEN          ; Show our opened chest.
            JSR    STATUSKY          ; update keys
            JSR    STATUSGP          ; update gp
            JSR    STATUSXP          ; update exp
            LDA    OPENTMP2          ; check if key found
            BNE    :PLUSKEY          ; yes -- say so, w/ gold
            BEQ    :GOTGOLD          ; no -- just tell of gold
:ISOPEN     PRINT  CHOPENED
            RTS
:NOCHEST    PRINT  OPENBAD
            RTS
:BADLUCK    PRINT  OPENNO
            RTS
:GOTGOLD    PRINT  OPEN0KEY          ; just got gp
:CHKDART    LDA    RANDOM1           ; check for dart hit.
            EOR    RANDOM2           ; randomize from 3 random
            EOR    RANDOM3           ; counters
            AND    #%00000011        ; damage, if any from dart.
            BEQ    :WHEW             ; missed.
            STA    OPENTMP3
            SUBB   HP;OPENTMP3;HP    ; subtract damage
            JSR    STATUSHP          ; update hit points
            PRINT  CDARTHIT
:WHEW       RTS
:PLUSKEY    PRINT  OPEN1KEY          ; gp + key
            JMP    :CHKDART          ; go and check for dart hit
CHOPENED    HEX    825583
            ASC    "The chest is already open!"00
OPENBAD     HEX    825583
            ASC    "I see no chest here!"00
OPEN1KEY    HEX    825503
            ASC    "You find "80
            DA     OPENTMP1
            ASC    " Gold Pieces and a Key!"00
OPEN0KEY    HEX    825508
            ASC    "You find "80
            DA     OPENTMP1
            ASC    " Gold Pieces!"00
OPENNO      HEX    825583
            ASC    "You had no luck!"
            HEX    5783
            ASC    "(Try try again.)"00
G_ORNATE    HEX    825583
            ASC    "You've found a very ornate key!"00
CDARTHIT    HEX    5602
            ASC    "and are hit by a dart for "80
            DA     OPENTMP3
            ASC    " damage!"00
OPENTMP1    HEX    0000              ; made a word for addition
OPENTMP2    HEX    00                ; tmp1=gp/xp, tmp2=keys
OPENTMP3    HEX    00                ; this is damage from dart.

********************************
* Ask player if they want to   *
* exit the game.               *
********************************
GAMEDONE    STY    :YSAVE
            STX    :XSAVE
            STA    :ASAVE
            PRINT  EXITQUES
            JSR    GETYN
            BCS    :NO
            PLA                      ; pull return address off
            PLA                      ; of stack
            LDA    #-1               ; -1 = kill game
            RTS                      ; return to main routine.
:NO         LDA    :ASAVE
            LDY    :YSAVE
            LDX    :XSAVE
            RTS
:YSAVE      HEX    00
:XSAVE      HEX    00
:ASAVE      HEX    00
EXITQUES    HEX    825683
            ASC    "Do you wish to exit this game?"8D83
            ASC    "(Y/N)"00

********************************
* Allow Meltok to move upwards *
* Check for any obstacles...   *
********************************
M:UP        DEC    CY
            LDX    CX
            LDY    CY
            BNE    :CONT
            JSR    GAMEWON           ; game winning routine
            INC    CY
            LDA    #-1
            RTS
:CONT       JSR    MAPVALID
            BCS    :ABORT
            LDX    #0
            LDY    #-2
            JMP    MOVEMENT
:ABORT      INC    CY
M:OWIE      CMP    #12
            BEQ    M:GHOST
            CMP    #13
            BEQ    M:BLOB
            CMP    #14
            BEQ    M:ZOMBIE
            PRINT  WALLOUCH
GOTHIT01    DEC    HP
            JSR    STATUSHP
            LDA    #0
            RTS
M:GHOST     PRINT  GHOSOUCH
GOTDAMAG    MOVB   #15;SNUM
            LDA    #%00000000
            STA    CLRFLAG
            LDA    #%10000000
            STA    XORFLAG
            MOVB   #4;HITCOUNT
:BUZZER     LDY    CH:Y
            LDX    CH:X
            LDA    #0
            JSR    DRAWSHAP
            MOVB   #20;VOLUME
            MOVB   #150;DURATION
            MOVB   #$80;FREQUENC
            JSR    DONOISE
            DEC    HITCOUNT
            BNE    :BUZZER
            LDA    #0
            STA    XORFLAG
            JMP    GOTHIT01
HITCOUNT    HEX    00
M:BLOB      PRINT  BLOBOUCH
            JMP    GOTDAMAG
M:ZOMBIE    PRINT  ZOMBOUCH
            JMP    GOTDAMAG
WALLOUCH    HEX    825683
            ASC    "Ouch!!"00
GHOSOUCH    HEX    825683
            ASC    "Yiiee!  The ghost gotcha!"00
BLOBOUCH    HEX    825683
            ASC    "Squish, the blob squirts you!"00
ZOMBOUCH    HEX    825683
            ASC    "Ooomph, the zombie hits you!"00

********************************
* Allow Meltok to move south.  *
********************************
M:DOWN      INC    CY
            LDX    CX
            LDY    CY
            CPY    #HMAP+1
            BLT    :CONT
            JSR    GAMEDONE
            DEC    CY
            LDA    #0
            RTS
:CONT       JSR    MAPVALID
            BCS    :ABORT
            LDX    #0
            LDY    #2
            BNE    MOVEMENT
:ABORT      DEC    CY
            JMP    M:OWIE

********************************
* Allow Meltok to move west..  *
********************************
M:LEFT      DEC    CX
            LDX    CX
            LDY    CY
            JSR    MAPVALID
            BCS    :ABORT
            LDX    #-2
            LDY    #0
            BEQ    MOVEMENT
:ABORT      INC    CX
            JMP    M:OWIE

********************************
* Allow Meltok to move East.   *
********************************
M:RIGHT     INC    CX
            LDX    CX
            LDY    CY
            JSR    MAPVALID
            BCS    :ABORT
            LDX    #2
            LDY    #0
            BEQ    MOVEMENT
:ABORT      DEC    CX
            JMP    M:OWIE

********************************
* Movement variables           *
********************************
M:DIRX      HEX    00
M:DIRY      HEX    00
M:COUNT     HEX    00

********************************
* Movement routines: Draw      *
* Meltok moving, and update    *
* the map.                     *
********************************
MOVEMENT    STX    M:DIRX
            STY    M:DIRY
            JSR    ROOMDESC          ; display room description
            MOVB   #4;M:COUNT
            MOVB   #2;SNUM
            LDA    #%00000000
            STA    CLRFLAG
            LDA    #%10000000
            STA    XORFLAG
:REPEAT     LDY    CH:Y
            LDX    CH:X
            LDA    #0                ; CH:X should not exceed 255
            JSR    DRAWSHAP
            ADDB   M:DIRY;CH:Y;CH:Y
            ADDB   M:DIRX;CH:X;CH:X
            LDY    CH:Y
            LDX    CH:X
            LDA    #0
            JSR    DRAWSHAP
            LDA    #25
            JSR    WAIT
            DEC    M:COUNT
            BNE    :REPEAT
            LDA    #%00000000
            STA    XORFLAG
            LDA    #%10000000
            STA    CLRFLAG
            LDA    CX
            CMP    X0
            BEQ    :REDRAW
            CMP    X1
            BEQ    :REDRAW
            LDA    CY
            CMP    Y0
            BEQ    :REDRAW
            CMP    Y1
            BEQ    :REDRAW
            LDA    DRAWFLAG
            BMI    :REDRAW
            LDA    #0
            RTS
:REDRAW     LDA    #1
            RTS
DRAWFLAG    HEX    00

********************************
* Check to see if location at  *
* (x,y) is a valid walking     *
* location for Meltok.  If so, *
* carry bit is clear.  If not, *
* carry bit is on.             *
********************************
MAPVALID    CPY    #HMAP
            BGE    :BAD
            CPX    #WMAP
            BGE    :BAD
            JSR    MAPINDEX
            BEQ    :GOOD
            CMP    #99
            BGE    :GOOD
            CMP    #3
            BEQ    :GOOD
            CMP    #5
            BLT    :BAD
            CMP    #12
            BGE    :BAD
:GOOD       CLC
            RTS
:BAD        SEC
            RTS


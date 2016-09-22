********************************
* Filer Module: Load and Save  *
* game states.                 *
* Uses:  PROLIB                *
*        PROLIB.MAC            *
*        IO                    *
*        IO.MAC                *
********************************

BUFFER      =         $BB00
GAMEDATA    =         $1000

********************************
* Loader:  Loads a new game    *
* or an old game.  Selected by *
* the user.                    *
********************************

LOADER      PRINT     LOADSTR
            MOVB      #0;LOADSTAT
            STA       KEYSTROB
:AGAIN      LDA       KEYBOARD
            BPL       :AGAIN
            STA       KEYSTROB
            CMP       #"N"
            BEQ       :NEWGAME
            CMP       #"n"
            BEQ       :NEWGAME
            CMP       #"O"
            BEQ       :OLDGAME
            CMP       #"o"
            BNE       :AGAIN
:OLDGAME    JSR       CLINE
            PRINT     OLDSTR
            MOVB      #1;LOADSTAT
            @OPEN     #OLDNAME;#BUFFER;REFNUM
            JMP       :LOAD
:NEWGAME    JSR       CLINE
            PRINT     NEWSTR
            @OPEN     #NEWNAME;#BUFFER;REFNUM
:LOAD       @READ     REFNUM;#GAMEDATA;#$D3C
            @CLOSE    REFNUM
            JSR       CLINE
            RTS

LOADSTR     HEX       5783
            ASC       "Play New or Old game? (N/O)"00
OLDSTR      HEX       5783
            ASC       "... Loading old game ..."00
NEWSTR      HEX       5783
            ASC       "... Loading new game ..."00
OLDNAME     STR       "OLDGAME"
NEWNAME     STR       "NEWGAME"
REFNUM      HEX       00
LOADSTAT    HEX       00

********************************
* Saves a game currently in    *
* play.                        *
********************************

SAVER       PRINT     SAVESTR
            JSR       GETYN
            BCC       :YUP
            JMP       :NOPE
:YUP        PRINT     SAVESTR2
            @DESTROY  #OLDNAME
            CMP       #0                              ; no error?
            BEQ       :FINISH                         ; ok!
            CMP       #$46                            ; file not found?
            BEQ       :FINISH                         ; ok!
            JMP       _MLICHK                         ; unknown error
:FINISH     @CREATE   #OLDNAME;#$C3;#$F6;#$1000;#$01
            @OPEN     #OLDNAME;#BUFFER;REFNUM
            @WRITE    REFNUM;#GAMEDATA;#$D3C
            @FLUSH    REFNUM
            @CLOSE    REFNUM
:NOPE       JSR       CLINE
            RTS

SAVESTR     HEX       5783
            ASC       "Do you wish to save the game?"00
SAVESTR2    HEX       825783
            ASC       "... Saving: Please Wait ..."00


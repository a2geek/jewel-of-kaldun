* External references
           ; jewel.of.kaldun.s
DATA       EXT
           ; input.output.s
PRSTR      EXT

********************************
* Input/Output Macros          *
********************************

PRINT       MAC
            LDA   #<]1
            STA   DATA
            LDA   #>]1
            STA   DATA+1
            JSR   PRSTR
            EOM

CENTER      MAC
            LDA   #<]1
            STA   DATA
            LDA   #>]1
            STA   DATA+1
            JSR   CSTRING
            EOM


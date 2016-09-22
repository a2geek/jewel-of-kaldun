* External references

_CLOSE      EXT
D:CCREF     EXT
DOQUIT      EXT
MAIN        EXT

********************************
* Reset routine handler.       *
********************************
RESETUP     ENT
            LDY     #0          ; save old reset
:0          LDA     $3F2,Y      ; handler
            STA     RESTORE,Y
            INY
            CPY     #3
            BLT     :0
            LDA     #<DORESET   ; install my own reset
            STA     $3F2        ; handler
            LDA     #>DORESET
            STA     $3F3
            EOR     #$A5
            STA     $3F4
            RTS
RESTORE     ENT
            HEX     000000      ; store old reset bytes

********************************
* Actual reset routine:        *
*   close all files,           *
*   print message,             *
*   and call DOQUIT            *
********************************
DORESET     @CLOSE  #0          ; close all files
            JSR     TEXT
            JSR     CLRSCRN
            PRINT   RESETMSG
            LDY     #5          ; pause a bit
:LOOP       LDA     #255
            JSR     WAIT
            DEY
            BNE     :LOOP
            JSR     DOQUIT
            JMP     MAIN
RESETMSG    HEX     4A83
            ASC     "You didn't really want to do"8D83
            ASC     "that now, did you?"00


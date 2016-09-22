********************************
* ProDOS MLI calls.            *
* Uses:  IO                    *
*        IO.MAC                *
********************************

_QUIT       JSR     MLI             ; Perform QUIT function
            DFB     ~QUIT
            DW      D:QUIT
_MLICHK     BNE     MLIERROR        ; Error occured ...
            RTS

MLIERROR    LDA     #23
            STA     TLINE
            JSR     TEXTADDR
            JSR     CLINE
            LDA     #$40
            JSR     WAIT
            LDY     #$C0
:BELL       LDA     #$10
            JSR     WAIT
            STA     SPEAKER
            DEY
            BNE     :BELL
            CENTER  MLIERR_S
            STA     KEYSTROB
:KEYLOOP    LDA     KEYBOARD
            CMP     #RETURN
            BNE     :KEYLOOP
            STA     KEYSTROB
            JMP     MAIN
MLIERR_S    ASC     "AN ERROR HAS OCCURED! PRESS <RETURN>"00

_GETTIME    JSR     MLI             ; perform get_time function
            DFB     ~GETTIME
            DW      0
            JMP     _MLICHK

_CREATE     @GETTIME                ; perform create function
            MOVW    _DATE;D:C0DATE
            MOVW    _TIME;D:C0TIME
            JSR     MLI
            DFB     ~CREATE
            DW      D:CREATE
            JMP     _MLICHK

_DESTROY    JSR     MLI             ; perform destroy function
            DFB     ~DESTROY
            DW      D:DESTR
            RTS                     ; error checking nulled

_OPEN       JSR     MLI             ; perform open function
            DFB     ~OPEN
            DW      D:OPEN
            JMP     _MLICHK

_READ       JSR     MLI             ; perform read function
            DFB     ~READ
            DW      D:READ
            JMP     _MLICHK

_WRITE      JSR     MLI             ; perform write function
            DFB     ~WRITE
            DW      D:WRITE
            JMP     _MLICHK

_CLOSE      ENT
            JSR     MLI             ; perform close function
            DFB     ~CLOSE
            DW      D:CLOSE
            JMP     _MLICHK

_FLUSH      JSR     MLI             ; perform flush function
            DFB     ~FLUSH
            DW      D:FLUSH
            JMP     _MLICHK

* ProDOS data/parameters --

D:QUIT      DFB     4               ; 4 parameters
            DFB     0               ; all are reserved.
            DW      0
            DFB     0
            DW      0

D:CREATE    DFB     $7              ; 7 parameters
D:C0PATH    DW      0               ; address of pathname
D:C0ACC     DFB     0               ; access bits
D:C0FTYP    DFB     0               ; file type
D:C0ATYP    DW      0               ; auxiliary file type
D:C0STYP    DFB     0               ; storage type
D:C0DATE    DW      0               ; creation date
D:C0TIME    DW      0               ; creation time

D:DESTR     DFB     $1              ; 1 parameter
D:C1PATH    DW      0               ; address of pathname

D:OPEN      DFB     $3              ; 3 parameters
D:C8PATH    DW      0               ; address of path name
D:C8BUFF    DW      0               ; address of file buffer
D:C8REF     DFB     0               ; reference number (returned)

D:READ      DFB     $4              ; 4 parameters
D:CAREF     DFB     0               ; reference number
D:CABUFF    DW      0               ; address of data buffer
D:CARLEN    DW      0               ; requested length
D:CAALEN    DW      0               ; actual length

D:WRITE     DFB     $4              ; 4 parameters
D:CBREF     DFB     0               ; reference number
D:CBBUFF    DW      0               ; address of data buffer
D:CBRLEN    DW      0               ; requested length
D:CBALEN    DW      0               ; actual length

D:CLOSE     DFB     $1              ; 1 parameter
D:CCREF     ENT
            DFB     0               ; reference number

D:FLUSH     DFB     $1              ; 1 parameter
D:CDREF     DFB     0               ; reference number


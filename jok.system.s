********************************
* Jewel of Kaldun loader       *
* program.                     *
********************************

            TYP     $FF                         ; system program
            ORG     $2000                       ; they originate @ $2000
            EXP     OFF                         ; macro expansion
            TR      ON                          ; truncate

* General Macros --

MOVB        MAC
            LDA     ]1
            STA     ]2
            EOM

MOVW        MAC
            MOVB    ]1;]2
            IF      #=]1
            MOVB    ]1/$100;]2+1
            ELSE
            MOVB    ]1+1;]2+1
            FIN
            EOM

* ProDOS Command Codes --

OPEN        =       $C8                         ; open file
READ        =       $CA                         ; read file
CLOSE       =       $CC                         ; close file

* ProDOS addresses --

MLI         =       $BF00

* ProDOS Macro commands --
* call: @name parameter #1;parameter #2; ... ;parameter #n

@OPEN       MAC                                 ; @open path;file_buffer; (1K)
            MOVW    ]1;D:C8PATH                 ;      reference_number (ret)
            MOVW    ]2;D:C8BUFF
            JSR     _OPEN
            MOVB    D:C8REF;]3
            EOM

@READ       MAC                                 ; @read ref_num;input_buff;
            MOVB    ]1;D:CAREF                  ;       requested_length
            MOVW    ]2;D:CABUFF                 ; (actual_length returned)
            MOVW    ]3;D:CARLEN
            JSR     _READ
            EOM

@CLOSE      MAC                                 ; @close reference_number
            MOVB    ]1;D:CCREF
            JSR     _CLOSE
            EOM

* Memory locations:

PTR         EQU     $00                         ; pointer for checksum
LINE10      EQU     $05A8                       ; text line #10
LINE12      EQU     $06A8                       ;   "   "   #12
LINE15      EQU     $0450                       ;   "   "   #15
LINE24      EQU     $07D0                       ;   "   "   #24
JOK_BUFF    EQU     $3000                       ; ProDOS buffer
JOK_ADDR    EQU     $6000                       ; Address to load at
JOK_LEN     EQU     $5EFF                       ; Length of JOK (this is max)
JOK2BUFF    EQU     $3000
JOK2ADDR    EQU     $0800
JOK2LEN     EQU     $07FF
TIT_BUFF    EQU     $3000                       ; ProDOS buffer
TIT_ADDR    EQU     $4000                       ; Address to load at
TIT_LEN     EQU     $2000                       ; Length of Title (full screen)

********************************
* Main program:                *
********************************
            LDA     #149                        ; disable 80 columns
            JSR     $FDED
            JSR     $FB2F                       ; text
            JSR     $FC58                       ; home
* Draw title lines:
            LDY     #13
:LINE10     LDA     DATA10-1,Y
            STA     LINE10+12,Y
            DEY
            BNE     :LINE10
            LDY     #26
:LINE12     LDA     DATA12-1,Y
            STA     LINE12+6,Y
            DEY
            BNE     :LINE12
            LDY     #19
:LINE15     LDA     DATA15A-1,Y
            STA     LINE15+9,Y
            DEY
            BNE     :LINE15
* Clear memory:
            LDY     #24                         ; clear the bitmap of the
            LDA     #0                          ; system...
:CLRMEM     STA     $BF58-1,Y
            DEY
            BPL     :CLRMEM
            LDA     #$CF                        ; and set back to memory
            STA     $BF58                       ; as being empty except
            LDA     #$01                        ; ProDOS.
            STA     $BF6F
* Load in Title:
            @OPEN   #TIT_NAME;#TIT_BUFF;REFNUM
            BCS     :HELPERR                    ; can't quite make it.
            @READ   REFNUM;#TIT_ADDR;#TIT_LEN
            @CLOSE  REFNUM
* Print version of Loader:
            LDY     #19
:LINE15B    LDA     DATA15B-1,Y
            STA     LINE15+9,Y
            DEY
            BNE     :LINE15B
* Calculate checksum:
            JSR     CHECKSUM
* Load in JOK:
            @OPEN   #JOK_NAME;#JOK_BUFF;REFNUM
:HELPERR    BCS     :HELPER2
            @READ   REFNUM;#JOK_ADDR;#JOK_LEN
            @CLOSE  REFNUM
* Load in JOK end game:
            @OPEN   #JOK2NAME;#JOK2BUFF;REFNUM
:HELPER2    BCS     LOADERR2
            @READ   REFNUM;#JOK2ADDR;#JOK2LEN
            @CLOSE  REFNUM
* Check Checksum:              (A0E647)
            LDA     SUM+2
            CMP     #$A0
            BNE     DATACORR
            LDA     SUM+1
            CMP     #$E6
            BNE     DATACORR
            LDA     SUM
            CMP     #$47
            BNE     DATACORR
* Start JOK:
            JMP     JOK_ADDR                    ; begin game!

LOADERR     LDY     #40
:LOOP       LDA     ERRORMSG-1,Y
            STA     LINE24-1,Y
            DEY
            BNE     :LOOP
            BEQ     ERRORXX
LOADERR2    LDY     #40
:LOOP2      LDA     ERRORMS2-1,Y
            STA     LINE24-1,Y
            DEY
            BNE     :LOOP2
ERRORXX     JSR     $FF3A                       ; bell
FOREVER     LDA     #<$0200                     ; sets $03F0 (BRK address) to
            STA     $3F0                        ;  point at $0200.
            STA     $201                        ; And, sets $0200:4C 00 02
            LDA     #>$0200                     ;  ie, JMP $0200.
            STA     $3F1                        ; ... the begining of FOREVER!
            STA     $202
            LDA     #$4C
            STA     $200
            LDA     $3F3                        ; scramble power-up byte, so
            EOR     #%11111111                  ;  power-up automatically occurs
            STA     $3F3                        ;  upon RESET.
            LDY     #0                          ; prepare to erase memory from
            LDA     #<$4000                     ; $4000 - $BEFF ...
            STA     $00
            LDA     #>$4000
            STA     $01
            LDA     #0
:ERASE      STA     ($00),Y                     ; erase a page.
            INY
            BNE     :ERASE
            INC     $01                         ; add 1 to hi byte
            LDA     $01
            CMP     #$BF                        ; at end?
            BLT     :ERASE                      ; nope, do more
            LDA     #$20                        ; yes: Erase loader program.
            STA     $01                         ; will exit when BRK
            JMP     :ERASE                      ;  encountered.

DATACORR    LDY     #28
:LOOP       LDA     DATA15C-1,Y
            STA     LINE15+5,Y
            DEY
            BNE     :LOOP
            JSR     $FF3A                       ; bell
            JMP     FOREVER

ERRORMSG    ASC     "ERROR:  JEWEL.OF.KALDUN IS UNACCESSABLE!"
ERRORMS2    ASC     "ERROR:  JEWEL.END.GAME  IS UNACCESSABLE!"
JOK2NAME    STR     "JEWEL.END.GAME"
JOK_NAME    STR     "JEWEL.OF.KALDUN"
TIT_NAME    STR     "JEWEL.TITLE.PIC"
REFNUM      HEX     00
DATA10      INV     " PLEASE WAIT "
DATA12      ASC     "JEWEL OF KALDUN IS LOADING"
DATA15A     ASC     "    L O A D E R    "
DATA15B     ASC     "LOADER: VERSION 1.3"
DATA15C     ASC     "CANNOT LOAD: DATA CORRUPTED!"

* ProDOS Routines --

_OPEN       JSR     MLI                         ; perform open function
            DFB     OPEN
            DW      D:OPEN
            RTS

_READ       JSR     MLI                         ; perform read function
            DFB     READ
            DW      D:READ
            RTS

_CLOSE      JSR     MLI                         ; perform close function
            DFB     CLOSE
            DW      D:CLOSE
            RTS

* ProDOS data/parameters --

D:OPEN      DFB     $3                          ; 3 parameters
D:C8PATH    DW      0                           ; address of path name
D:C8BUFF    DW      0                           ; address of file buffer
D:C8REF     DFB     0                           ; reference number (returned)

D:READ      DFB     $4                          ; 4 parameters
D:CAREF     DFB     0                           ; reference number
D:CABUFF    DW      0                           ; address of data buffer
D:CARLEN    DW      0                           ; requested length
D:CAALEN    DW      0                           ; actual length

D:CLOSE     DFB     $1                          ; 1 parameter
D:CCREF     DFB     0                           ; reference number

********************************
* Compute a checksum on the    *
* graphic title page after     *
* being loaded into memory.    *
********************************
CHECKSUM    LDA     #$00                        ; point to location
            STA     PTR                         ; $4000, beginning
            LDA     #$40                        ; of graphics page
            STA     PTR+1
            LDA     #0                          ; initialize checksum
            STA     SUM                         ; to be zero.
            STA     SUM+1
            STA     SUM+2
            LDY     #0
:LOOP       CLC
            LDA     (PTR),Y                     ; grab byte
            ADC     SUM                         ; and add it to
            STA     SUM                         ; the sum.
            ADC     SUM+1                       ; add following
            STA     SUM+1                       ; carry bits.
            ADC     SUM+2
            STA     SUM+2
            INY
            BNE     :LOOP
            INC     PTR+1
            CMP     #$60                        ; check if done
            BLT     :LOOP                       ; if not, continue
            LDA     SUM+2                       ; dump sum to screen.
            JSR     $FDDA                       ; will be replaced to
            LDA     SUM+1                       ; actually check if a
            JSR     $FDDA                       ; an unmodified page
            LDA     SUM                         ; was loaded.
            JSR     $FDDA
            RTS
SUM         HEX     000000                      ; check sum

* Save file:

            SAV     JOK.SYSTEM



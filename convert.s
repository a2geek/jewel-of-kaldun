********************************
* Integer conversion routines. *
* Uses:  IO                    *
*        IO.MAC                *
*        MATH                  *
********************************

* External references
           ; jewel.of.kaldun.s
DATA       EXT


********************************
* CONVERT converts a hex byte  *
* to decimal and prints it in  *
* the form:  XXX.              *
* I.E.  $10 = 016              *
********************************

CONVERT     LDA    #"0"
            LDY    #3
:0          STA    CONVSTR-1,Y
            DEY
            BNE    :0
            LDA    (PTR),Y
:1          CMP    #100
            BLT    :2
            SBC    #100
            INC    CONVSTR
            JMP    :1
:2          CMP    #10
            BLT    :3
            SBC    #10
            INC    CONVSTR+1
            JMP    :2
:3          CMP    #1
            BLT    :DONE
            SBC    #1
            INC    CONVSTR+2
            JMP    :3
:DONE       LDY    #0           ; kill leading zeros
:LOOP       LDA    CONVSTR,Y
            CMP    #"0"
            BNE    :JUSTIFY
            INY
            CPY    #2           ; check only 1st two 0's
            BLT    :LOOP
:JUSTIFY    CPY    #0           ; Y contains how many 0's
            BEQ    :PRINTIT     ; to "zap"
:JBEGIN     LDX    #0           ; the Jloop shifts data left
:JLOOP      LDA    CONVSTR+1,X
            STA    CONVSTR,X
            INX
            CPX    #3
            BLT    :JLOOP
            DEY
            BNE    :JBEGIN
:PRINTIT    LDA    DATA         ; call output routine to
            PHA                 ; print number string.
            LDA    DATA+1
            PHA
            PRINT  CONVSTR
            PLA
            STA    DATA+1
            PLA
            STA    DATA
            RTS
CONVSTR     ASC    "999"00

********************************
* Converts a hex word into a   *
* printable string.            *
* I.E.  $FFFF = 65535          *
*       $0000 = 00000          *
********************************

CONVWORD    LDY    #5
            LDA    #"0"
:0          STA    CWSTR-1,Y
            DEY
            BNE    :0
            LDX    #0
:AGAIN      LDY    #0
:LOOP       LDA    (PTR),Y
            STA    NUM1,Y
            LDA    NUMBERS,X
            STA    NUM2,Y
            INX
            INY
            CPY    #2
            BLT    :LOOP
            STX    XTEMP
            JSR    IDIV
            LDX    XTEMP
            LDA    #<NUM1
            STA    PTR
            LDA    #>NUM1
            STA    PTR+1
            TXA
            LSR
            TAY
            LDA    RESULT
            CLC
            ADC    CWSTR-1,Y
            STA    CWSTR-1,Y
            CPX    #10
            BLT    :AGAIN
:KILL       LDY    #0           ; kill leading zeros
:KILLOOP    LDA    CWSTR,Y
            CMP    #"0"
            BNE    :JUSTIFY
            INY
            CPY    #4           ; check 1st 4 zeros
            BLT    :KILLOOP
:JUSTIFY    CPY    #0           ; Y contains how many 0's
            BEQ    :PRINTIT     ; to "zap"
:JBEGIN     LDX    #0           ; the Jloop shifts data left
:JLOOP      LDA    CWSTR+1,X
            STA    CWSTR,X
            INX
            CPX    #5
            BLT    :JLOOP
            DEY                 ; check if another leading 0
            BNE    :JBEGIN      ; must be killed.
:PRINTIT    LDA    DATA         ; call output routine to
            PHA                 ; print number string.
            LDA    DATA+1
            PHA
            PRINT  CWSTR
            PLA
            STA    DATA+1
            PLA
            STA    DATA
            RTS
CWSTR       ASC    "99999"00
NUMBERS     DA     10000,1000,100,10,1


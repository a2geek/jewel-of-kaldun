********************************
* Mathematical routines used   *
* by Jewel of Kaldun           *
********************************


********************************
* Integer division routine.    *
*   NUM0 = routine scratch     *
*          space               *
*   NUM1 = numerator           *
*   NUM2 = denominator         *
* RESULT = quotient            *
* remainder is in NUM1 after   *
* completion of division.      *
********************************

IDIV        LDA   #0
            STA   RESULT
            STA   RESULT+1
            LDA   NUM2
            ORA   NUM2+1
            BNE   :PREP
            SEC
            RTS
:PREP       LDX   #0
            LDA   NUM2
            STA   NUM0
            LDA   NUM2+1
            STA   NUM0+1
:99         ASL   NUM0
            ROL   NUM0+1
            BCS   :GO
            INX
            JMP   :99
:GO         LDA   NUM2
            STA   NUM0
            LDA   NUM2+1
            STA   NUM0+1
            TXA
            TAY
            BEQ   :SKIP
:0          ASL   NUM0
            ROL   NUM0+1
            DEY
            BNE   :0
:SKIP       LDA   NUM0+1
            CMP   NUM1+1
            BEQ   :1
            BGE   :CONT
            BLT   :2
:1          LDA   NUM0
            CMP   NUM1
            BEQ   :2
            BGE   :CONT
:2          SEC
            LDA   NUM1
            SBC   NUM0
            STA   NUM1
            LDA   NUM1+1
            SBC   NUM0+1
            STA   NUM1+1
            LDA   #0
            STA   NUM0+1
            LDA   #1
            STA   NUM0
            TXA
            TAY
            BEQ   :11
:10         ASL   NUM0
            ROL   NUM0+1
            DEY
            BNE   :10
:11         CLC
            LDA   RESULT
            ADC   NUM0
            STA   RESULT
            LDA   RESULT+1
            ADC   NUM0+1
            STA   RESULT+1
:CONT       DEX
            BPL   :GO
            CLC
            RTS

********************************
* Integer multiplication       *
* routine:                     *
*   NUM1 = one number          *
*   NUM2 = second number       *
* RESULT = answer to NUM1xNUM2 *
********************************

IMUL        LDA   #0
            STA   RESULT
            STA   RESULT+1
:MORE       LDA   NUM2
            BNE   :GO
            LDA   NUM2+1
            BNE   :GO
            RTS
:GO         LSR   NUM2+1
            ROR   NUM2
            BCC   :SHIFT
            CLC
            LDA   NUM1
            ADC   RESULT
            STA   RESULT
            LDA   NUM1+1
            ADC   RESULT+1
            STA   RESULT+1
:SHIFT      ASL   NUM1
            ROL   NUM1+1
            JMP   :MORE

********************************
* Variables used by the        *
* integer multiplication and   *
* division routines:           *
********************************

NUM0        HEX   0000
NUM1        HEX   0000
NUM2        HEX   0000
RESULT      HEX   0000


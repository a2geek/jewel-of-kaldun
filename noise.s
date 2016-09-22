********************************
* Do noise routines:           *
********************************

* Take from April issue of Nibble:
DONOISE     ENT
            LDA   SPEAKER
            LDY   VOLUME      ; get volume
:YLOOP      DEY               ; pause for volume control
            BNE   :YLOOP
            STA   SPEAKER     ; click again
            LDY   DURATION    ; load duration
            LDA   $F000,Y     ; and use as index to ran #s
            CLC
            ADC   FREQUENC    ; add pitch
            TAX               ; get pause length
:XLOOP      DEX               ; pause
            BNE   :XLOOP
            DEC   DURATION    ; decrement duration
            BNE   DONOISE
            RTS
DURATION    ENT 
            HEX   00
FREQUENC    ENT
            HEX   00
VOLUME      ENT
            HEX   00


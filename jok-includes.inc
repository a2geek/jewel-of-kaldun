* ZP Equates:

TLINE       EQU    $00                 ; address of text screen line
TPTR        EQU    $01                 ; line number of current text
TTAB        EQU    $03                 ; index for text screen (HTAB)
TEMP        EQU    $04                 ; temporary storage
DATA        EQU    $05                 ; data address
PTR         EQU    $07                 ; an extra pointer...
HPTR        EQU    $09                 ; address of hi-res line
HPTR2       EQU    $0B                 ; address of 2ndary hi-res line
HLINE       EQU    $0D                 ; current hi-res line number
HLINE2      EQU    $0F                 ; secondary hi-res line number
YTEMP       EQU    $10                 ; temporary storage for Y reg.
XTEMP       EQU    $11                 ; temporary storage for X reg.

* ProDOS locations:

MACHID      EQU    $BF98               ; machine ID in ProDOS global pg

* I/O locations:

KEYBOARD    EQU    $C000               ; address for keyboard input
KEYSTROB    EQU    $C010               ; clears current keypress
SPEAKER     EQU    $C030               ; to click the speaker: noise

* AppleSoft locations:

HCOLOR      =     $F6F0
HPLOTTO     =     $F53A
HPOSN       =     $F411

* ROM locations: 

MONWAIT     EQU    $FCA8               ; monitor wait routine (Acc.)


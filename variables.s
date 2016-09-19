********************************
* Variables for Jewel of       *
* Kaldun:                      *
*   GP: Gold Pieces            *
*   XP: Experience             *
*   XPREQD: Experience required*
*   KEY: Number of keys        *
*   SPKEY: Special key flag    *
*   HP: Hit Points             *
*   MAXHP: Maximum HP          *
*   CLEVEL: Character level    *
*   CX: Character X position   *
*   CY: Character Y position   *
********************************

GP          HEX   0000
XP          HEX   0000
XPREQD      HEX   0000
KEY         HEX   00
SPKEY       HEX   00
HP          HEX   00
MAXHP       HEX   00
CLEVEL      HEX   00
CX          HEX   00
CY          HEX   00

* Odds'n'ends variables:

XOFF        HEX   0000
YOFF        HEX   0000
MAPADDR     HEX   0000
OX          DFB   -1
OY          DFB   -1
DX          HEX   00
DY          HEX   00
AX          HEX   00
AY          HEX   00
X0          DFB   -1
Y0          DFB   -1
X1          HEX   00
Y1          HEX   00
TEMP0       HEX   00
WX          HEX   00
WY          HEX   00
ZX          HEX   00
ZY          HEX   00
TEMPX       HEX   00
TEMPY       HEX   00
XPLACE      HEX   0000
YPLACE      HEX   0000
NX          HEX   00
NY          HEX   00
CH:X        HEX   0000
CH:Y        HEX   0000

********************************
* Monster variables:           *
*          TABLE               *
* S# Name   HP   XP   Speed    *
* -- ------ ---- ---- -------- *
* 12 Ghost  8    30   2 (med)  *
* 13 Blob   2    10   4 (slow) *
* 14 Zombie 16   75   1 (fast) *
********************************
MONSMAX     =     30          ; maximum number of monsters
M_HP        DS    MONSMAX     ; hit points
M_TYPE      DS    MONSMAX     ; type of monster
M_X         DS    MONSMAX     ; monster X location
M_Y         DS    MONSMAX     ; monster Y location
M_MOVE      DS    MONSMAX     ; # char moves before M move
M_X0        DS    MONSMAX     ; screen position
M_X1        DS    MONSMAX     ; screen position
M_Y0        DS    MONSMAX     ; screen position
M_LEVEL     DS    MONSMAX     ; level of castle


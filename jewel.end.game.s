********************************
*                              *
*       Jewel of Kaldun        *
*                              *
*          written by          *
*  https://github.com/a2geek   *
*                              *
*           story by           *
*  https://github.com/bshagle  *
*                              *
*    Copyright (c) 1990,2016   *
*                              *
********************************

* Code location:

            ORG    $0800

* Add in macro files:

            USE    jok-includes.inc
            PAG
            USE    io.mac
            PAG
            USE    general.mac
            PAG
            USE    prolib.mac
            PAG

* Memory map:
*      __________
*     |          | $FFFF
*     |  ProDOS  |   to    ProDOS/ROM
*     |__________| $BF00
*     |          | $BEFF
*     |  J.O.K.  |   to    Main program
*     |__________| $6000
*     |          | $5FFF
*     |  HGR P2  |   to    Copy of title page
*     |__________| $4000
*     |          | $3FFF
*     |  HGR P1  |   to    Graphics display
*     |__________| $2000
*     |          | $1FFF
*     | Map/Stat |   to    Map & Stats (to $1Cxx)
*     |__________| $1000
*     |          | $0FFF
* --> |  J.O.K.  |   to    JOK End Game routines
*     |__________| $0800       Reset routines
*     |          | $07FF
*     | TextPage |   to    Text page
*     |__________| $0400
*     |          | $03FF   Free         ($0200-$03CF)
*     | Zp & St  |   to    System Stack ($0100-$01FF)
*     |__________| $0000   Zero Page    ($0000-$00FF)


* Save file name:

            DSK    JEWEL.END.GAME.bin

            PAG
* End Game Routines

            PUT    endgame
            PAG
            PUT    reset


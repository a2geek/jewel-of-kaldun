* External references
            ; jewel.of.kaldun.s
DATA        EXT
            ; input.output.s
PRSTR       EXT

********************************
* Print a room description for *
* the location at (cx,cy).     *
* If on/in some item, describe *
* that.                        *
********************************

ROOMDESC    JSR    CBOT3
            LDA    #22           ; set vtab at 23.
            STA    TLINE
            JSR    TEXTADDR
            LDX    CX
            LDY    CY
            JSR    MAPINDEX
            CMP    #100
            BGE    :DOROOMS
            CMP    #12           ; won't handle a # > 11.
            BLT    :THINGS
            CMP    #99           ; handle special chest
            BNE    :BLANK
            LDA    #12           ; special case
            JMP    :THINGS
:BLANK      LDA    #0
:THINGS     ASL
            TAY
            LDA    D:THINGS,Y
            STA    DATA
            LDA    D:THINGS+1,Y
            STA    DATA+1
            JSR    PRSTR
            RTS
:DOROOMS    CMP    #254
            BLT    :DOROOM0
            BEQ    :DORM254
            PRINT  ROOM255
            RTS
:DORM254    PRINT  ROOM254
            RTS
:DOROOM0    SEC
            SBC    #100
            CMP    #63           ; deal with only rooms
            BLT    :ROOMS        ; 100 - 162.
            LDA    #63           ; print warning msg.
:ROOMS      ASL
            TAY
            LDA    D:ROOMS,Y
            STA    DATA
            LDA    D:ROOMS+1,Y
            STA    DATA+1
            JSR    PRSTR
            RTS

D:THINGS    DA     SHAPE00,SHAPE01,SHAPE02,SHAPE03
            DA     SHAPE04,SHAPE05,SHAPE06,SHAPE07
            DA     SHAPE08,SHAPE09,SHAPE10,SHAPE11
            DA     SHAPE99
SHAPE00     HEX    00
SHAPE01     HEX    00
SHAPE02     HEX    00
SHAPE03     HEX    83
            ASC    "You are in a doorway."00
SHAPE04     HEX    00
SHAPE05     HEX    83
            ASC    "You are in a secret passage."00
SHAPE06     HEX    83
            ASC    "You stand before a chest."00
SHAPE07     HEX    83
            ASC    "You stand before an opened chest."00
SHAPE08     HEX    83
            ASC    "You stand before a ladder."00
SHAPE09     HEX    83
            ASC    "You stand before an ornate throne."00
SHAPE10     HEX    83
            ASC    "You are before the fabled"8D83
            ASC    "Jewel of Kaldun!"00
SHAPE11     HEX    83
            ASC    "You are before an empty stand..."00
SHAPE99     HEX    83
            ASC    "... A very ornate chest ..."00

D:ROOMS     DA     ROOM100,ROOM101,ROOM102,ROOM103
            DA     ROOM104,ROOM105,ROOM106,ROOM107
            DA     ROOM108,ROOM109,ROOM110,ROOM111
            DA     ROOM112,ROOM113,ROOM114,ROOM115
            DA     ROOM116,ROOM117,ROOM118,ROOM119
            DA     ROOM120,ROOM121,ROOM122,ROOM123
            DA     ROOM124,ROOM125,ROOM126,ROOM127
            DA     ROOM128,ROOM129,ROOM130,ROOM131  ; boo-boo in map:
            DA     ROOM132,ROOM133,ROOM134,ROOM135  ; no 131-139 rooms!
            DA     ROOM136,ROOM137,ROOM138,ROOM139
            DA     ROOM140,ROOM141,ROOM142,ROOM143
            DA     ROOM144,ROOM145,ROOM146,ROOM147
            DA     ROOM148,ROOM149,ROOM150,ROOM151
            DA     ROOM152,ROOM153,ROOM154,ROOM155
            DA     ROOM156,ROOM157,ROOM158,ROOM159
            DA     ROOM160,ROOM161,ROOM162,ROOM163
ROOM100     HEX    83
            ASC    "You are in front of the castle."00
ROOM101     HEX    83
            ASC    "You stand in the courtyard."00
ROOM104                          ; same message as #102
ROOM102     HEX    83
            ASC    "You are in a secret hallway."00
ROOM103     HEX    83
            ASC    "The south-west tower."00
ROOM105     HEX    83
            ASC    "The south-east tower."00
ROOM106     HEX    83
            ASC    "The guards room."00
ROOM107     HEX    83
            ASC    "The captain of the guards room."00
ROOM108     HEX    83
            ASC    "Someones' horde of ???"00
ROOM109     HEX    83
            ASC    "A hidden closet."00
ROOM110     HEX    83
            ASC    "The ladder room."00
ROOM111     HEX    83
            ASC    "A hall."00
ROOM112     HEX    83
            ASC    "The processional hall."00
ROOM113     HEX    83
            ASC    "The guest room."00
ROOM114     HEX    83
            ASC    "You are in the kitchen."00
ROOM115     HEX    83
            ASC    "The storage room."8D83
            ASC    "It smells a bit in here!"00
ROOM116     HEX    83
            ASC    "The Kings' guards room."00
ROOM117     HEX    83
            ASC    "The Kings' closet."00
ROOM118     HEX    83
            ASC    "The Kings' bathroom."00
ROOM119     HEX    83
            ASC    "A private hall."00
ROOM120     HEX    83
            ASC    "The Kings' bedroom."00
ROOM121     HEX    83
            ASC    "The throne room and"8D83
            ASC    "audience chamber."00
ROOM122     HEX    83
            ASC    "The dining room."00
ROOM123     HEX    83
            ASC    "The wine cellar."00
ROOM124     HEX    83
            ASC    "The north-west tower."00
ROOM125     HEX    83
            ASC    "The wizards' magic chamber!"00
ROOM126     HEX    83
            ASC    "The wizards' room."00
ROOM127     HEX    83
            ASC    "A secret back passage..."00
ROOM128     HEX    83
            ASC    "The north-east tower."00
ROOM129     HEX    83
            ASC    "You stand behind the castle"8D83
            ASC    "Freedom is but a step away!"00
ROOM130     HEX    83
            ASC    "You stand somewhere on the"8D83
            ASC    "second level!"00
ROOM131                          ; these rooms do not exist
ROOM132                          ; on either level!!
ROOM133
ROOM134
ROOM135
ROOM136
ROOM137
ROOM138
ROOM139     HEX    00            ; cover for boo-boo
ROOM140     HEX    83
            ASC    "You stand in a long, winding"8D83
            ASC    "hallway."00
ROOM141     HEX    83
            ASC    "... some odd little room ..."00
ROOM142     HEX    83
            ASC    "This appears to be a reception"8D83
            ASC    "room."00
ROOM143     HEX    83
            ASC    "Boy, this guy must've been rich!"00
ROOM144     HEX    83
            ASC    "You have no idea what this empty room"8D83
            ASC    "was used for!"00
ROOM145     HEX    83
            ASC    "... another hallway ..."00
ROOM146     HEX    83
            ASC    "... and yet one more hallway ..."00
ROOM147     HEX    83
            ASC    "This looks like a great hall."00
ROOM148     HEX    83
            ASC    "A guests' room?"00
ROOM149     HEX    83
            ASC    "Maybe this is a guest room."00
ROOM150     HEX    83
            ASC    "And yet, another guest room!"00
ROOM151     HEX    83
            ASC    "Boy, one more ..."00
ROOM152     HEX    83
            ASC    "Wait, maybe these are servants"8D83
            ASC    "quarters!"00
ROOM153     HEX    83
            ASC    "Someone must've done a lot of"8D83
            ASC    "work here.  The walls are black!"00
ROOM154     HEX    83
            ASC    "There is a beautiful jewel in"8D83
            ASC    "this room."00
ROOM155     HEX    83
            ASC    "The south-west tower has a beautiful"8D83
            ASC    "view of the landscape."00
ROOM156     HEX    83
            ASC    "Boy, ain't this fun?"00
ROOM157     HEX    83
            ASC    "The south-east tower doesn't have as"8D83
            ASC    "beautiful a view as the south-west."00
ROOM158     HEX    83
            ASC    "Time to leave this place, eh?"00
ROOM159     HEX    83
            ASC    "Where do you think you are going?"00
ROOM160     HEX    83
            ASC    "The north-west tower... Ah, there"8D83
            ASC    "is a ladder!"00
ROOM161     HEX    83
            ASC    "Boy, you feel tired."00
ROOM162     HEX    83
            ASC    "The south-west tower... There is a"8D83
            ASC    "ladder here!"00
ROOM163     HEX    83
            ASC    "Oh dear, I have no idea what room"8D83
            ASC    "this is!!"00
ROOM254     HEX    83
            ASC    "A rather broken up ladder."00
ROOM255     HEX    83
            ASC    "A smashed chest."00


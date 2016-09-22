* External references
            ; graphics.s
HGRCLEAR    EXT

********************************
* The story behind the Jewel   *
* of Kaldun along with the     *
* instructions for play.       *
* Uses:  IO                    *
*        IO.MAC                *
*        CASTLES               *
********************************

STORY       JSR     CLRSCRN
            LDA     #0
            STA     TLINE
            JSR     TEXTADDR
            CENTER  TITLE00
            PRINT   STORYP1
            JSR     GETRET
            JSR     CLRMID
            PRINT   STORYP2
            JSR     HGRCLEAR
            JSR     CASTLE1
            JSR     GETRET
            JSR     CLRMID
            JSR     SETHGR
            PRINT   STORYP3
            JSR     GETRET
            JSR     CLRMID
            PRINT   STORYP4
            JSR     DRAWBRID
            JSR     GETRET
            JSR     CLRMID
            PRINT   STORYP5
            JSR     LEAVEC1
            JSR     GETRET
            JSR     CLRMID
            JSR     TEXT
            PRINT   STORYP6
            JSR     GETRET
            JSR     CLRMID
            PRINT   STORYP7
            JSR     HGRCLEAR
            JSR     CASTLE2
            JSR     GETRET
            JSR     CLRMID
            JSR     SETHGR
            PRINT   STORYP8
            JSR     ARRIVEC2
            JSR     GETRET
            JSR     CLRSCRN
            PRINT   STORYP9
            LDA     #%10000000
            STA     ESCABORT
            JSR     GETRET
            JSR     CLRSCRN
            JSR     TEXT
            LDA     #0
            STA     TLINE
            JSR     TEXTADDR
            CENTER  INSTR00
            PRINT   INSTRP1
            JSR     GETRET
            JSR     CLRMID
            PRINT   INSTRP2
            JSR     GETRET
            JSR     CLRMID
            PRINT   INSTRP3
            JSR     GETRET
            JSR     CLRMID
            PRINT   INSTRP4
            LDA     #%10000000
            STA     ESCABORT
            JSR     GETRET
            JSR     CLRSCRN
            LDA     #0
            STA     TLINE
            JSR     TEXTADDR
            CENTER  PLAY00
            PRINT   PLAYP1
            LDA     #%10000000
            STA     ESCABORT
            JSR     GETRET
            JSR     CLRSCRN
            LDA     #0
            STA     TLINE
            JSR     TEXTADDR
            CENTER  GPL00
            PRINT   GPLP1
            LDA     #%10000000
            STA     ESCABORT
            JSR     GETRET
            JSR     CLRSCRN
            RTS

GPL00       ASC     "CONTACT & LICENSE"00
PLAY00      ASC     "PLAYING NOTES"00
INSTR00     ASC     "INSTRUCTIONS"00
TITLE00     ASC     "THE STORY"00
STORYP1     HEX     43
            ASC     "For many years, there had been a legend"8D
            ASC     "of a magical emerald, entitled the"8D
            ASC     "'Jewel of Kaldun.'  This gem had been"8D
            ASC     "lost in a deserted castle that was once"8D
            ASC     "occupied by the great magician Kaldun."8D
            HEX     8D
            ASC     "This castle is rumored to be haunted"8D
            ASC     "with ghosts, zombies and magical bats,"8D
            ASC     "and has been acclaimed as being 'fates"8D
            ASC     "friend or foe.'  It has been said that"8D
            ASC     "whatever kingdom possesses this 'Jewel"8D
            ASC     "of Kaldun' shall have only peace and"8D
            ASC     "health for the rest of its days."8D
            HEX     8D
            ASC     "King Aradea was ruling during troubled"8D
            ASC     "times.  Famine and disease plagued his"8D
            ASC     "kingdom.  When he heard of this jewel,"8D
            ASC     "he announced the following proclamation:"8D00
STORYP2     HEX     4305
            ASC     "Whosoever finds the Jewel of"8D05
            ASC     "Kaldun shall be given the hand"8D05
            ASC     "of my beautiful daughter Lydia"8D05
            ASC     "in marriage and will follow as"8D05
            ASC     "my successor.  However, there"8D05
            ASC     "is one stipulation to this"8D05
            ASC     "quest:  he whoever tries must"8D05
            ASC     "begin his search in the deserted"8D05
            ASC     "castle at sunset and return to"8D05
            ASC     "me by noon the following day."8D05
            ASC     "For whosoever accomplishes this"8D05
            ASC     "task must be quick of mind and"8D05
            ASC     "stout of heart.  The one who is"8D05
            ASC     "capable of this task will be"8D05
            ASC     "worthy of my daughter, and of my"8D05
            ASC     "kingdom."8D14
            ASC     "- King Aradea"00
STORYP3     HEX     54
            ASC     "The kingdom stirred with hope and"8D
            ASC     "intrigue.  Many men attempted the quest"8D
            ASC     "and were never seen again."00
STORYP4     HEX     54
            ASC     "One day a local peasant named Meltok"8D
            ASC     "decided to undertake the proclaimed"8D
            ASC     "search."00
STORYP5     HEX     54
            ASC     "After telling King Aradea of his plans,"8D
            ASC     "he leaves the castle in hopes of the"8D
            ASC     "Jewel of Kaldun ..."00
STORYP6     HEX     43
            ASC     "As Meltok left the castle, he realized"8D
            ASC     "that he needed to know more about this"8D
            ASC     "castle and the wizard, Kaldun..."8D
            HEX     8D
            ASC     "As you talk to your fellow peasants,"8D
            ASC     "you notice that noone really knows of"8D
            ASC     "the wizard Kaldun -- it's all made up!"8D
            HEX     8D
            ASC     "However, about the Castle of Kaldun and"8D
            ASC     "the Jewel of Kaldun, there is plenty to"8D
            ASC     "tell.  For one, it is said that the"8D
            ASC     "castle lies deserted.  However, it is"8D
            ASC     "also told that the moment a live creature"8D
            ASC     "sets foot upon the castles' ground,"8D
            ASC     "monsters begin to appear.  From where,"8D
            ASC     "noone can tell..."00
STORYP7     HEX     43
            ASC     "There is a rumor that makes you stop"8D
            ASC     "in your tracks.  'It is said,' an old"8D
            ASC     "man says, 'that if the Jewel of Kaldun"8D
            ASC     "is removed from the castle, the land"8D
            ASC     "will prosper but a few years before all"8D
            ASC     "of mankind is lost!  Be careful, my"8D
            ASC     "son.'  And with that, he leaves you."8D
            ASC     "When you look around for the man, he is"8D
            ASC     "no where to be seen..."00
STORYP8     HEX     55
            ASC     "Finally, Meltok arrived at the Castle of"8D
            ASC     "Kaldun."00
STORYP9     HEX     54
            ASC     "It is time for you to help Meltok find"8D
            ASC     "the Jewel of Kaldun.  Are you capable"8D
            ASC     "of this formidable task?"00

INSTRP1     HEX     43
            ASC     "To move Meltok, use the I, J, K, and M"8D
            ASC     "keys:"8D83
            ASC     "(north)"8D83
            ASC     "I"8D83
            ASC     "(west)  J   K  (east)"8D83
            ASC     "M"8D83
            ASC     "(south)"8D
            HEX     8D
            ASC     "When Meltok is on a ladder, press:"8D05
            ASC     "[A] to ascend (go up) and"8D05
            ASC     "[D] to descend (go down)"8D
            HEX     8D
            ASC     "When you are unsure of what an item on"8D
            ASC     "the screen is, press [L] for look."8D
            HEX     8D
            ASC     "To open a chest, press [O], but beware:"8D
            ASC     "Some treasure chests have traps in them"8D
            ASC     "that can hurt Meltok!"00
INSTRP2     HEX     43
            ASC     "To search for secret doors, press [S]"8D
            ASC     "and the direction you wish to search in."8D
            HEX     8D
            ASC     "When Meltok has found keys, he may"8D
            ASC     "unlock some of the locked doors in the"8D
            ASC     "castle by pressing [U] and the direction"8D
            ASC     "of the door.  (There are some special"8D
            ASC     "doors that will not be opened by the"8D
            ASC     "general keys ... you must find those.)"8D
            HEX     8D
            ASC     "To heal Meltok, press [R] to rest him."8D
            ASC     "Hit Points will slowly heal."8D
            HEX     8D
            ASC     "When the JEWEL OF KALDUN is found, press"8D
            ASC     "[T] and the direction of the gem to take"8D
            ASC     "it."00
INSTRP3     HEX     43
            ASC     "To get a numerical status, press:"8D05
            ASC     "[H] for health, or"8D05
            ASC     "[W] for wealth"8D
            ASC     "Health consists of Hit Points, Exper-"8D
            ASC     "ience and level.  Wealth consists of"8D
            ASC     "Gold Pieces, Keys, and any special"8D
            ASC     "items."8D
            HEX     8D
            ASC     "When Meltok encounters those vile"8D
            ASC     "creatures that inhabit the Castle of"8D
            ASC     "Kaldun, press [F] and a direction key"8D
            ASC     "to fight them.  You will do more damage"8D
            ASC     "as you go up levels, and will even gain"8D
            ASC     "automatic hits -- if you live that long."00
INSTRP4     HEX     43
            ASC     "Whenever you are asked for the direc-"8D
            ASC     "tion you wish to perform an action in,"8D
            ASC     "use the movement keys to indicate the"8D
            ASC     "direction (I, J, K, and M)."8D
            HEX     8D
            ASC     "To get a summary of the commands"8D
            ASC     "available to Meltok, press [?]."8D
            HEX     8D83
            ASC     "We hope you enjoy the Jewel of Kaldun!"8D83
            ASC     "A2 Geek / BShagle"00

PLAYP1      HEX     43
            ASC     "For those of you interested, here are"8D
            ASC     "all of the monster statistics:"8D
            HEX     8D05
            ASC     "Name    HP  XP  Movement"8D05
            ASC     "------- --  --  --------"8D05
            ASC     "Blob     2  10      4"8D05
            ASC     "Zombie  16  75      1"8D05
            ASC     "Ghost    8  30      2"8D
            HEX     8D
            ASC     "Movement is how many turns Meltok can"8D
            ASC     "make before the monster will move.  It"8D
            ASC     "should be said, however, that the mon-"8D
            ASC     "sters can attack on every move!!"00

GPLP1       HEX     43
            ASC     "This program is licensed under the GPL."8D
            ASC     "Please see the LICENSE file available"8D
            ASC     "in the source code."8D
            HEX     8D
            ASC     "Visit us to report bugs, make"8D
            ASC     "suggestions, or to just grab the code"8D
            ASC     "to hack on!"8D
            HEX     8D83
            ASC     "github.com/a2geek/jewel-of-kaldun"8D
            HEX     00


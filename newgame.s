********************************
* Jewel Of Kaldun NEWGAME file *
********************************

* The following files follow this code:
*    1 = wall                  6 = chest
*    3 = door                  4 = locked door
*    5 = (found) secret door   7 = opened chest
*    8 = ladder                9 = throne/chair
*   10 = Jewel of Kaldun      11 = empty JOK holder
*   98 = secret door          99 = special chest
*   97 = special locked door

* Numbers => 100 are room descriptions.

            TR    ON
            ORG   $1000

********************************
* Following are files that     *
* comprise the NEWGAME file:   *
********************************

            PAG
            PUT   castle-level-1
            PAG
            PUT   castle-level-2
            PAG
            PUT   variables
            PAG

********************************
* Save as file type $F6        *
********************************

            TYP   $F6
            SAV   NEWGAME.bin


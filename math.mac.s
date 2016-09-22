********************************
* Math macros used by Jewel of *
* Kaldun source:               *
* Uses:                        *
*    GENERAL.MAC               *
*    MATH                      *
********************************

IMULW       MAC
            MOVW   ]1;NUM1
            MOVW   ]2;NUM2
            JSR    IMUL
            MOVW   RESULT;]3
            EOM

IDIVW       MAC
            MOVW   ]1;NUM1
            MOVW   ]2;NUM2
            JSR    IDIV
            MOVW   RESULT;]3
            EOM

IMODW       MAC
            MOVW   ]1;NUM1
            MOVW   ]2;NUM2
            JSR    IDIV
            MOVW   NUM1;]3
            EOM

IDIVMODW    MAC
            IDIVW  ]1;]2;]3
            MOVW   NUM1;]4
            EOM


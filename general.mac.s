********************************
* General Macros used by       *
* Jewel of Kaldun source       *
********************************

MOVB        MAC
            LDA   ]1
            STA   ]2
            EOM

MOVW        MAC
            MOVB  ]1;]2
            IF    #=]1
            MOVB  ]1/$100;]2+1
            ELSE
            MOVB  ]1+1;]2+1
            FIN
            EOM

NILB        MAC
            LDA   #0
            STA   ]1
            EOM

NILW        MAC
            LDA   #0
            STA   ]1
            STA   ]1+1
            EOM

ADDB        MAC
            CLC
            LDA   ]1
            ADC   ]2
            STA   ]3
            EOM

ADDW        MAC
            ADDB  ]1;]2;]3
            IF    #=]1
            LDA   ]1/$100
            ELSE
            LDA   ]1+1
            FIN
            IF    #=]2
            ADC   ]2/$100
            ELSE
            ADC   ]2+1
            FIN
            STA   ]3+1
            EOM

SUBB        MAC
            SEC
            LDA   ]1
            SBC   ]2
            STA   ]3
            EOM

SUBW        MAC
            SUBB  ]1;]2;]3
            IF    #=]1
            LDA   ]1/$100
            ELSE
            LDA   ]1+1
            FIN
            IF    #=]2
            SBC   ]2/$100
            ELSE
            SBC   ]2+1
            FIN
            STA   ]3+1
            EOM


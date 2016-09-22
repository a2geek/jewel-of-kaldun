********************************
* ProDOS Library Macro command *
* list:                        *
********************************

~QUIT       =     $65          ; quit
~GETTIME    =     $82          ; get time
~CREATE     =     $C0          ; create
~DESTROY    =     $C1          ; destroy
~OPEN       =     $C8          ; open file
~READ       =     $CA          ; read file
~WRITE      =     $CB          ; write file
~CLOSE      =     $CC          ; close file
~FLUSH      =     $CD          ; flush file

* ProDOS addresses --

MLI         =     $BF00
_DATE       =     $BF90
_TIME       =     $BF92

* ProDOS Macro commands --
* call: @name parameter #1;parameter #2; ... ;parameter #n

@QUIT       MAC                ; @quit
            JSR   _QUIT
            EOM

@GETTIME    MAC                ; @gettime
            JSR   _GETTIME
            EOM

@CREATE     MAC                ; @create path;access;file_type;
            MOVW  ]1;D:C0PATH  ;        auxiliary_type;
            MOVB  ]2;D:C0ACC   ;         storage_type
            MOVB  ]3;D:C0FTYP
            MOVW  ]4;D:C0ATYP
            MOVB  ]5;D:C0STYP
            JSR   _CREATE
            EOM

@DESTROY    MAC                ; @destroy path
            MOVW  ]1;D:C1PATH
            JSR   _DESTROY
            EOM

@OPEN       MAC                ; @open path;file_buffer; (1K)
            MOVW  ]1;D:C8PATH  ;      reference_number (ret)
            MOVW  ]2;D:C8BUFF
            JSR   _OPEN
            MOVB  D:C8REF;]3
            EOM

@READ       MAC                ; @read ref_num;input_buff;
            MOVB  ]1;D:CAREF   ;       requested_length
            MOVW  ]2;D:CABUFF  ; (actual_length returned)
            MOVW  ]3;D:CARLEN
            JSR   _READ
            EOM

@WRITE      MAC                ; @write ref_num;output_buff;
            MOVB  ]1;D:CBREF   ;        requested_length
            MOVW  ]2;D:CBBUFF  ; (actual_length returned)
            MOVW  ]3;D:CBRLEN
            JSR   _WRITE
            EOM

@CLOSE      MAC                ; @close reference_number
            MOVB  ]1;D:CCREF
            JSR   _CLOSE
            EOM

@FLUSH      MAC                ; @flush reference_number
            MOVB  ]1;D:CDREF
            JSR   _FLUSH
            EOM


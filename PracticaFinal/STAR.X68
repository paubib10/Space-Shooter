; =============================================================================
; GESTIÓN DE ESTRELLAS. ES UN AGENTE.
; LA MEMORIA LOCAL ES:
; +0 PALABRA COORDENADA X
; +2 PALABRA COORDENADA Y
; +4 PALABRA VELOCIDAD Y
; +6 PALABRA TAMAÑO
; =============================================================================

; -----------------------------------------------------------------------------
STRINIT
; INICIALIZA LA ESTRELLA GRANDE
; ENTRADA  - A0 PUNTERO A LA MEMORIA LOCAL
;            D1: 0 -> PEQUEÑA, 1 -> GRANDE
; SALIDA   - NINGUNA
; MODIFICA - NINGUNA
; -----------------------------------------------------------------------------
            
            MOVEM.W D0-D1,-(A7)
            
            CMP.B   #1, D1
            BEQ     .BIG
            MOVE.W  #SSTRSPEED,4(A0)        ; VELOCIDAD Y
            MOVE.W  #SSTRSIZE,6(A0)         ; TAMAÑO
            BRA     .END
            
.BIG        MOVE.W  #BSTRSPEED,4(A0)        ; VELOCIDAD Y
            MOVE.W  #BSTRSIZE,6(A0)         ; TAMAÑO
            
.END        JSR     UTLRAND
            MOVE.W  D0, D1
            JSR     UTLRAND
            ADD.W   D1, D0
            
            MOVE.W  D0,(A0)                 ; POSICIÓN X (PSEUDO-ALEATORIA)
            CLR.W   2(A0)                   ; POSICIÓN Y 
                       
            MOVEM.W (A7)+,D0-D1
            RTS
            
; -----------------------------------------------------------------------------
STRUPD
; ACTUALIZA UNA ESTRELLA
; ENTRADA  - A0 PUNTERO A LA MEMORIA LOCAL
; SALIDA   - NINGUNA
; MODIFICA - NINGUNA
; -----------------------------------------------------------------------------
            MOVE.W  D0,-(A7)
            
            MOVE.W  4(A0),D0                ; ACTUALIZAR COORDENADAS
            ADD.W   D0,2(A0)
            
            ; VERIFICAR BORDES PARA ELIMINAR
            CMP.W   #SCRHEIGH,2(A0)         ; ABAJO  
            BLT     .END
            JSR     AGLKILL                 ; ELIMINAR

            CMP     #BSTRSIZE,6(A0)         ; ES ESTRELLA GRANDE
            BEQ     .END
            
            MOVE.B  (ASTMODE),D0            ; ACTIVAR MODO NORMAL
            TST.B   D0                      ; SI ASTMODE=0
            BNE     .END
            ADDQ.B  #1,(ASTMODE)
            
            
.END        MOVE.W  (A7)+,D0
            RTS      

; -----------------------------------------------------------------------------
STRPLOT
; DIBUJA UNA ESTRELLA
; ENTRADA  - A0 PUNTERO A LA MEMORIA LOCAL
; SALIDA   - NINGUNA
; MODIFICA - NINGUNA
; -----------------------------------------------------------------------------
            UTLSPEN #$0000FFFF
            UTLSFIL #$0000FFFF
            MOVEM.W D1-D4,-(A7)
            
            MOVE.W  (A0),D1
            MOVE.W  2(A0),D2
            MOVE.W  D1,D3
            MOVE.W  D2,D4
            ADD.W   6(A0),D3
            ADD.W   6(A0),D4
            MOVE.B  #88,D0
            TRAP    #15
            
            MOVEM.W (A7)+,D1-D4
            RTS
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~

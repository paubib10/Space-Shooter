; =============================================================================
; GESTIÓN DE DISPAROS. ES UN AGENTE.
; LA MEMORIA LOCAL ES:
; +0 PALABRA COORDENADA X
; +2 PALABRA COORDENADA Y
; =============================================================================

; -----------------------------------------------------------------------------
SHTINIT
; INICIALIZA UN DISPARO
; ENTRADA  - A0 PUNTERO A LA MEMORIA LOCAL
;            D1.W COORDENADA X INICIAL
;            D2.W COORDENADA Y INICIAL
; SALIDA   - NINGUNA
; MODIFICA - NINGUNA
; -----------------------------------------------------------------------------
            
            MOVE.W  D1,(A0)
            MOVE.W  D2,2(A0)
            
            ; ACTIVAR MUSICA
            MOVE.B  #AUDMSKNL|AUDSHTID,D1
            JSR     AUDPLAY                 ; REPRODUCIR MUSICA
            MOVE.B  #AUDACCY,(AUDACCSN)     ; RECHAZAR EFECTOS DE SONIDO
                        
            RTS

; -----------------------------------------------------------------------------
SHTUPD
; ACTUALIZA UN DISPARO MOVIÉNDOLO HACIA LA DERECHA.
; ENTRADA  - A0 PUNTERO A LA MEMORIA LOCAL
; SALIDA   - NINGUNA
; MODIFICA - NINGUNA
; -----------------------------------------------------------------------------
            ADD.W   #SHTSPEED,2(A0)          ; MOVER
            
            ; COMPROBAR COLISIONES
            TST.W   2(A0)
            BLE     AGLKILL
            
            MOVEM.L A0-A1/D0-D7,-(A7)
            
            MOVE.W  (A0),D2                 ; PREPARAR COORDENADAS DE DISPARO
            MOVE.W  2(A0),D3                ; PARA VERIFICACIÓN DE COLISIÓN
            MOVE.W  #SHTWIDTH,D5
            MOVE.W  #PLRHEIGH,D7
            MOVE.L  A0,A1
            MOVE.W  #ASTTYPE,D0             ; RECORRER TODOS LOS ASTEROIDES
            JSR     DMMFRSTO
.LOOP       CMP.L   #0,A0
            BEQ     .END
            MOVE.W  8(A0),D0
            MOVE.W  10(A0),D1
            MOVE.W  #ENEWIDTH,D4
            MOVE.W  #ENEHEIGH,D6
            JSR     UTLCHCOL
            TST.B   D0
            BNE     .EXPLO                  ; SI HAY COLISIÓN, EXPLOSIONAR
            MOVE.W  #ASTTYPE,D0
            JSR     DMMNEXTO
            BRA     .LOOP
            
.END        MOVEM.L (A7)+,A0-A1/D0-D7
            RTS
            
.EXPLO      ADD.L   #8,A0
            JSR     ENEXPLO                 ; EXPLOSIONAR ENEMIGO
            MOVE.L  A1,A0
            JSR     AGLKILL                 ; DESTRUIR DISPARO
            ADD.W   #ASTSCORE,(PLRSCORE)    ; AUMENTAR PUNTUACIÓN
            BRA     .END

; -----------------------------------------------------------------------------
SHTPLOT
; TRAZA EL DISPARO.
; ENTRADA  - A0 PUNTERO A LA MEMORIA LOCAL
; SALIDA   - NINGUNA
; MODIFICA - NINGUNA
; -----------------------------------------------------------------------------
            MOVEM.L     A0/D1-D4,-(A7)
            UTLSPEN     #$00FF0000
            UTLSFIL     #$00FF0000
            
            MOVE.W      (A0)+,D1
            MOVE.W      (A0),D4
            MOVE.W      D1,D3
            MOVE.W      D4,D2
            ADD.W       #SHTHEIGH,D3
            ADD.W       #SHTWIDTH,D2
            MOVE.B      #87,D0
            TRAP        #15
                                    
            MOVEM.L     (A7)+,A0/D1-D4
            RTS
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~

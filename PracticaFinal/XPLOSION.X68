; =============================================================================
; GESTIÓN DE EXPLOSIONES. ES UN AGENTE.
; LA MEMORIA LOCAL ES:
; +0 PALABRA COORDENADA X
; +2 PALABRA COORDENADA Y
; +4 PALABRA VELOCIDAD X
; +6 PALABRA VELOCIDAD Y
; =============================================================================

; -----------------------------------------------------------------------------
XPLINIT
; INICIALIZA UN ELEMENTO DE EXPLOSIÓN
; ENTRADA  - A0 PUNTERO A LA MEMORIA LOCAL
;            D1 COORDENADA X
;            D2 COORDENADA Y
; SALIDA   - NINGUNA
; MODIFICA - NINGUNA
; NOTA     - ASUME QUE SCRHEIGH ES MAYOR QUE 255
; -----------------------------------------------------------------------------
            MOVEM.L D0-D2,-(A7)
            
            MOVE.W  D1,(A0)                 ; ESTABLECE LA POSICIÓN X
            MOVE.W  D2,2(A0)                ; ESTABLECE LA POSICIÓN Y
            
            JSR     UTLRAND                 ; ESTABLECE VELOCIDADES ALEATORIAS
            AND.W   #$01F,D0
            SUB.W   #$0F,D0
            MOVE.W  D0,4(A0)
            
            JSR     UTLRAND
            AND.W   #$01F,D0
            SUB.W   #$0F,D0
            MOVE.W  D0,6(A0)
            MOVEM.L (A7)+,D0-D2
            RTS

; -----------------------------------------------------------------------------
XPLUPD
; ACTUALIZA UN ELEMENTO DE EXPLOSIÓN
; ENTRADA  - A0 PUNTERO A LA MEMORIA LOCAL
; SALIDA   - NINGUNA
; MODIFICA - NINGUNA
; -----------------------------------------------------------------------------
            MOVE.W  D0,-(A7)
            
            MOVE.W  4(A0),D0                ; ACTUALIZA COORDENADAS
            SUB.W   D0,(A0)
            
            MOVE.W  6(A0),D0
            ADD.W   D0,2(A0)
            
            CMP.W   #-XPLSIZE,(A0)
            BLE     .KILL
            CMP.W   #SCRWIDTH,(A0)
            BGE     .KILL
            CMP.W   #-XPLSIZE,2(A0)
            BLE     .KILL
            CMP.W   #SCRHEIGH,2(A0)
            BGE     .KILL
            
            
            
.END        MOVE.W  (A7)+,D0
            RTS
.KILL       JSR   AGLKILL
            BRA   .END

; -----------------------------------------------------------------------------
XPLPLOT
; TRAZA UN ELEMENTO DE EXPLOSIÓN
; ENTRADA  - A0 PUNTERO A LA MEMORIA LOCAL
; SALIDA   - NINGUNA
; MODIFICA - NINGUNA
; -----------------------------------------------------------------------------
            UTLSPEN #XPLPENCL
            UTLSFIL #XPLFILCL
            MOVEM.W D1-D4,-(A7)
            MOVE.W  (A0),D1
            MOVE.W  2(A0),D2
            MOVE.W  D1,D3
            MOVE.W  D2,D4
            ADD.W   #XPLSIZE,D3
            ADD.W   #XPLSIZE,D4
            MOVE.B  #88,D0
            TRAP    #15
            MOVEM.W (A7)+,D1-D4
            RTS
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~

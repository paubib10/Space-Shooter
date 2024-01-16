; =============================================================================
; GESTIÓN DEL GENERADOR (SPAWNER).
; =============================================================================

; -----------------------------------------------------------------------------
SPWUPD
; ACTUALIZA EL GENERADOR
; ENTRADA  - NINGUNA
; SALIDA   - NINGUNA
; MODIFICA - NINGUNA
; -----------------------------------------------------------------------------

; ------------------------- GENERACIÓN DE FONDO -------------------------------
            MOVEM.L  D0/A1-A3,-(A7)
            
            MOVE.B  (SCRCYCCT),D0
            AND     #$0F,D0                 ; CADA 16 CICLOS
            BNE     .CONTINUE      
              
            ; CREA UNA NUEVA ESTRELLA GRANDE
            CLR.B   D1
            MOVE.B  #1,D1
            LEA     STRINIT,A1
            LEA     STRUPD,A2
            LEA     STRPLOT,A3
            MOVE.W  #STRTYPE,D0
            JSR     AGLADD
            
            ; CREA UNA NUEVA ESTRELLA PEQUEÑA
            CLR.B   D1
            LEA     STRINIT,A1
            LEA     STRUPD,A2
            LEA     STRPLOT,A3
            MOVE.W  #STRTYPE,D0
            JSR     AGLADD

; ------------------------- GENERACIÓN DE ENEMIGOS ----------------------------
.CONTINUE   MOVE.B  (ASTMODE),D0            ; ASTMODE=1 -> GENERA ENEMIGOS
            TST.B   D0
            BEQ     .END
            
            MOVE.B  (SCRCYCCT),D0
            AND     #$0F,D0                 ; CADA 16 CICLOS
            BNE     .END      
              
            ; CREA UN NUEVO ENEMIGO
            LEA     ENEINIT,A1
            LEA     ENEUPD,A2
            LEA     ENEPLOT,A3
            MOVE.W  #ASTTYPE,D0
            JSR     AGLADD
            
.END        MOVEM.L (A7)+,D0/A1-A3
            RTS
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~

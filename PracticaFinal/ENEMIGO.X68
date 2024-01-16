; =============================================================================
; GESTIÓN DE ASTEROIDES. ES UN AGENTE.
; LA MEMORIA LOCAL ES:
; +0 PALABRA COORDENADA X
; +2 PALABRA COORDENADA Y
; +4 PALABRA VELOCIDAD X
; +6 PALABRA VELOCIDAD Y
; =============================================================================

; -----------------------------------------------------------------------------
ENEINIT
; INICIALIZA UN ASTEROIDE
; ENTRADA  - A0 PUNTERO A LA MEMORIA LOCAL
; SALIDA   - NINGUNA
; MODIFICA - NINGUNA
; NOTA     - ASUME QUE SCRHEIGH ES MAYOR QUE 255
; -----------------------------------------------------------------------------
            MOVE.W  D0,-(A7)
            
            JSR     UTLRAND
            ADD.W   #(SCRWIDTH-255-ENEWIDTH)/2, D0
            
            MOVE.W  D0,(A0)                 ; POSICIÓN X (PSEUDO-ALEATORIA)
            CLR.W   2(A0)                   ; POSICIÓN Y 
            
            JSR     UTLRAND
            AND.W   #$000F,D0               
            MOVE.W  D0,6(A0)                ; VELOCIDAD Y (PSEUDO-ALEATORIA)
            
            SUB.W  #10,D0
            MOVE.W  D0,4(A0)                ; VELOCIDAD X (PSEUDO-ALEATORIA)
            
            MOVE.W  (A7)+,D0
            RTS
            
; -----------------------------------------------------------------------------
ENEUPD
; ACTUALIZA UN ASTEROIDE
; ENTRADA  - A0 PUNTERO A LA MEMORIA LOCAL
; SALIDA   - NINGUNA
; MODIFICA - NINGUNA
; -----------------------------------------------------------------------------
            MOVE.W  D0,-(A7)
            
            MOVE.W  4(A0),D0                ; ACTUALIZAMOS COORDENADAS
            SUB.W   D0,(A0)
            MOVE.W  6(A0),D0
            ADD.W   D0,2(A0)
            
            ; COMPROBAR BORDES PARA ELIMINAR
            CMP.W   #-ENEHEIGH,2(A0)        ; UP      
            BLT     .KILL
            CMP.W   #SCRHEIGH,2(A0)         ; DOWN
            BGT     .KILL 
            
            ; VERIFICAR REBOTES
            CMP.W   #(SCRWIDTH-ENEWIDTH),(A0)    ; RIGHT
            BGE     .BOUNCE     
            TST.W   (A0)                         ; LEFT
            BLE     .BOUNCE            
            
            CMP.W   #SCRWIDTH-ENEWIDTH,(A0)
            BLT     .COLPLAY
            
.BOUNCE     NEG.W   4(A0)

.COLPLAY    MOVE.W  (A0),D0
            MOVE.W  2(A0),D1
            MOVE.W  #ENEHEIGH,D4
            MOVE.W  D4,D6
            MOVE.W  (PLRPOSX),D2
            MOVE.W  (PLRPOSY),D3
            MOVE.W  #PLRWIDTH,D5
            MOVE.W  #PLRHEIGH,D7
            JSR     UTLCHCOL
            TST.B   D0
            BEQ     .END
            SUBQ.B  #1,(PLRDMG)
            JSR     ENEXPLO

.END        MOVE.W  (A7)+,D0
            RTS
.KILL       JSR     AGLKILL
            BRA     .COLPLAY

; -----------------------------------------------------------------------------
ENEPLOT
; PLOTS AN ASTEROID
; INPUT    - A0 POINTER TO THE LOCAL MEMORY
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            
            MOVEM.W D1-D4,-(A7)
            
            MOVE.L  #ENECOL1,D1
            MOVE.B  #80,D0
            TRAP    #15
            ADDQ.B  #1,D0
            TRAP    #15
            
            MOVE.W  (A0),D1
            ADD.W   #ENEWIDTH/4,D1
            MOVE.W  2(A0),D2
            MOVE.W  D1,D3
            MOVE.W  D2,D4
            ADD.W   #ENEWIDTH/2,D3
            ADD.W   #ENEHEIGH-(ENEHEIGH/4),D4
            MOVE.B  #88,D0
            TRAP    #15
            
            MOVE.L  #ENECOL2,D1
            MOVE.B  #80,D0
            TRAP    #15
            ADDQ.B  #1,D0
            TRAP    #15
            
            CLR.L   D1
            MOVE.W  (A0),D1
            MOVE.W  D2,D4
            ADD.W   #ENEHEIGH/2,D2
            MOVE.W  D1,D3
            ADD.W   #ENEWIDTH,D3
            ADD.W   #ENEHEIGH,D4 
            MOVE.B  #88,D0
            TRAP    #15
            
            
            MOVEM.W (A7)+,D1-D4
            RTS

; -----------------------------------------------------------------------------
ENEXPLO
; EXPLODES AN ASTEROID
; INPUT    - A0 POINTER TO THE LOCAL MEMORY
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L A1-A3/D0-D4,-(A7)
            
            ; ACTIVAR MUSICA
            MOVE.B  #AUDMSKNL|AUDIMPID,D1
            JSR     AUDPLAY                 ; PLAY MUSIC
            MOVE.B  #AUDACCY,(AUDACCSN)     ; REJECT SOUND EFFECTS
            
            MOVE.W  #ASTNFRAG,D4
            
.LOOP       LEA     XPLINIT,A1
            LEA     XPLUPD,A2
            LEA     XPLPLOT,A3
            MOVE.W  #XPLTYPE,D0
            MOVE.W  (A0),D1
            ADD.W   #ENEWIDTH/2,D1
            MOVE.W  2(A0),D2
            ADD.W   #ENEHEIGH/2,D2
            JSR     AGLADD
            DBRA.W  D4,.LOOP
            JSR     AGLKILL
            
            MOVEM.L (A7)+,A1-A3/D0-D4
            RTS



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~

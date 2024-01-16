; =============================================================================
; GESTIÓN DE AUDIO
; =============================================================================

; -----------------------------------------------------------------------------
AUDINIT
; INICIALIZA EL GESTOR DE AUDIO
; ENTRADA  - NINGUNA
; SALIDA   - NINGUNA
; MODIFICA - NINGUNA
; -----------------------------------------------------------------------------
            MOVEM.L D0-D1/A0-A2,-(A7)
            
            LEA     .AUDLIST,A0
            LEA     .IDLIST,A2
            
.LOOP       MOVE.L  (A0)+,D0                ; CARGA TODOS LOS ARCHIVOS DE AUDIO
            BEQ     .END
            MOVE.B  (A2)+,D1
            MOVE.L  D0,A1
            MOVE.B  #71,D0
            TRAP    #15
            BRA     .LOOP
            
.END        MOVE.B  #AUDACCY,(AUDACCSN)     ; COMIENZA ACEPTANDO SONIDOS
            MOVEM.L (A7)+,D0-D1/A0-A2
            RTS
            
.AUDLIST    DC.L    .INTRO,.SHOT,.IMPACT,.HERIDO,.GAMEOVER,.CNTDWN,.CNTDWNF,0
.INTRO      DC.B    'SOUNDS/INTRO.WAV',0
.SHOT       DC.B    'SOUNDS/SHOT.WAV',0
.IMPACT     DC.B    'SOUNDS/IMPACT.WAV',0
.HERIDO     DC.B    'SOUNDS/HERIDO.WAV',0
.GAMEOVER   DC.B    'SOUNDS/GAMEOVER.WAV',0
.CNTDWN     DC.B    'SOUNDS/COUNTDOWN.WAV',0
.CNTDWNF    DC.B    'SOUNDS/SUI.WAV',0
.IDLIST     DC.B    AUDINTID,AUDSHTID,AUDIMPID,AUDHERID,AUDGOVID,AUDCDNID,AUDCDFID
            DS.W    0

; -----------------------------------------------------------------------------
AUDPLAY
; CAMBIA EL AUDIO A REPRODUCIR
; ENTRADA  - D1.B   BIT 7=1 BUCLE, BIT 7=0 REPRODUCIR SOLO UNA VEZ
;                   BITS 6-0 ID DE SONIDO
; SALIDA   - NINGUNA
; MODIFICA - NINGUNA
; -----------------------------------------------------------------------------
            CMP.B   #AUDACCN,(AUDACCSN)     ; VERIFICA SI SE ACEPTAN SONIDOS
            BEQ     .END                    ; NO: FIN
            MOVEM.L D0-D2,-(A7)
            MOVE.B  #76,D0
            MOVE.L  #3,D2
            TRAP    #15                     ; DETIENE TODOS LOS SONIDOS
            CLR.L   D2
            BCLR    #7,D1                   ; LIMPIA MSB Y VERIFICA
            BEQ     .CONT                   ; SI ES CERO, CONTINUA
            ADDQ.W  #1,D2                   ; SI ES UNO, ACTIVA BUCLE
.CONT       CMP.B   #AUDENDID,D1            ; ¿ES EL ID DE SONIDO DE PARADA?
            BEQ     .DONE                   ; NO REPRODUCIR
            MOVE.B  #76,D0                  ; SELECCIONA EL REPRODUCT. ESTÁNDAR
            TRAP    #15                     ; Y REPRODUCE
.DONE       MOVEM.L (A7)+,D0-D2
.END        RTS

*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~

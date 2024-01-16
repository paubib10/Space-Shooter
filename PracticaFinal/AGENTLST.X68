; =============================================================================
; GESTIÓN DE AGENTES
; CADA AGENTE TIENE UN BLOQUE DE DATOS DE DMM COMO SIGUE:
; +0 - LONG : PUNTERO A LA SUBRUTINA DE ACTUALIZACIÓN
; +4 - LONG : PUNTERO A LA SUBRUTINA DE TRAZADO
; +8:FIN    : DATOS (ESPECÍFICOS DEL AGENTE)
; =============================================================================

; -----------------------------------------------------------------------------
AGLADD
; CREA UN NUEVO AGENTE
; ENTRADA  - A1 - PUNTERO A LA FUNCIÓN DE INICIALIZACIÓN DEL AGENTE
;            A2 - PUNTERO A LA FUNCIÓN DE ACTUALIZACIÓN DEL AGENTE
;            A3 - PUNTERO A LA FUNCIÓN DE TRAZADO DEL AGENTE
;            D0 - TIPO DE AGENTE (UTILIZADO COMO PROPIEDAD POR DMM)
;            D1 - PARÁMETRO DE INICIALIZACIÓN DEL AGENTE 1
;            D2 - PARÁMETRO DE INICIALIZACIÓN DEL AGENTE 2
;            D3 - PARÁMETRO DE INICIALIZACIÓN DEL AGENTE 3
; SALIDA   - NINGUNA
; MODIFICA - NINGUNA
; -----------------------------------------------------------------------------
            MOVE.L  A0,-(A7)
            JSR     DMMALLOC
            CMP.L   #0,A0
            BEQ     .END
            MOVE.L  A2,(A0)+
            MOVE.L  A3,(A0)+
            JSR     (A1)
.END        MOVE.L  (A7)+,A0
            RTS

; -----------------------------------------------------------------------------
AGLUPD
; ACTUALIZA LA LISTA DE AGENTES. ANTES DE LLAMAR A LAS FUNCIONES DE 
; ACTUALIZACIÓN, A0 SE ESTABLECE AL BLOQUE DE DATOS DEL SLOT CORRESPONDIENTE.
; ENTRADA  - NINGUNA
; SALIDA   - NINGUNA
; MODIFICA - NINGUNA
; -----------------------------------------------------------------------------
            MOVEM.L A0-A1,-(A7)
            JSR     DMMFIRST
.LOOP       CMP.L   #0,A0
            BEQ     .END
            MOVE.L  (A0),A1
            ADD.L   #8,A0
            JSR     (A1)
            JSR     DMMNEXT
            BRA     .LOOP
.END        MOVEM.L (A7)+,A0-A1
            RTS

; -----------------------------------------------------------------------------
AGLPLOT
; TRAZA LA LISTA DE AGENTES. ANTES DE LLAMAR A LAS FUNCIONES DE ACTUALIZACIÓN,
; A0 SE ESTABLECE AL BLOQUE DE DATOS DEL SLOT CORRESPONDIENTE.
; ENTRADA  - NINGUNA
; SALIDA   - NINGUNA
; MODIFICA - NINGUNA
; -----------------------------------------------------------------------------
            MOVEM.L A0-A1,-(A7)
            JSR     DMMFIRST
.LOOP       CMP.L   #0,A0
            BEQ     .END
            MOVE.L  4(A0),A1
            ADD.L   #8,A0
            JSR     (A1)
            JSR     DMMNEXT
            BRA     .LOOP
.END        MOVEM.L (A7)+,A0-A1
            RTS

; -----------------------------------------------------------------------------
AGLKILL     EQU     DMMFREE
; MATA AL AGENTE LIBERANDO SU MEMORIA
; ENTRADA  - A0 PUNTERO DENTRO DE LA MEMORIA DEL AGENTE
; SALIDA   - NINGUNA
; MODIFICA - NINGUNA
; NOTA     - ES SOLO UN ENVOLTORIO PARA DMMFREE
; -----------------------------------------------------------------------------



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~

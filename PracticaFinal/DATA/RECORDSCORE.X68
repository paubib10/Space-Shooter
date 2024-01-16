; =============================================================================
; MANEJO DE ARCHIVO DE PUNTUACIONES
; =============================================================================

; -----------------------------------------------------------------------------
SCOUPD
; ACTUALIZA ARCHIVO DE PUNTUACIONES
; ENTRADA  - NINGUNA
; SALIDA   - NINGUNA
; MODIFICA - NINGUNA
; -----------------------------------------------------------------------------

            MOVEM.L D0-D3/A0,-(A7)
                        
            JSR     SCOREAD             ; LEEMOS ARCHIVO
            
            CLR.L   D2                  ; PUNTERO EN ARCHIVO           
            
            LEA     FILEBUFF,A0         ; PUNTERO AL BUFFER
            
.LOOP       MOVE.W  (PLRSCORE),D3       ; PUNTUACIÓN DEL JUGADOR
            CMP.W   (A0),D3             ; VEMOS SI ES MÁS GRANDE
            BGT     .ESMAYOR
            BRA     .NEXT
            
.ESMAYOR    JSR     SCOREC              ; LO GUARDAMOS
            MOVE.W  (A0),D3             ; Y GUARDAMOS EL QUE HABÍA ANTES
            MOVE.W  D3,(PLRSCORE)

.NEXT       ADDQ.L  #2,A0
            ADDQ.B  #2,D2

            CMP.B   #2*NUMSCOS,D2
            BLO     .LOOP
            
            MOVEM.L (A7)+,D0-D3/A0
            
            RTS


; -----------------------------------------------------------------------------
SCOREC
; GUARDA PUNTUACIÓN
; ENTRADA  - D2.L -> PUNTERO A POSICIÓN DEL ARCHIVO
; SALIDA   - NINGUNA
; MODIFICA - NINGUNA
; -----------------------------------------------------------------------------

            MOVEM.L D0-D1/A1,-(A7)
                        
            LEA     FNAME,A1            ; ABRIMOS EL ARCHIVO
            MOVE.B  #51,D0
            TRAP    #15
            
            MOVE.B  #55,D0              ; PUNTERO
            TRAP    #15
            
            MOVE.L  D2,-(A7)
            
            MOVEQ.L #2,D2               ; BYTES A ESCRIBIR
            LEA     PLRSCORE,A1         ; ESCRIBIMOS EN EL ARCHIVO
            MOVE.B  #54,D0
            TRAP    #15
            
            MOVE.L  (A7)+,D2
            
            MOVE.B  #56,D0              ; CERRAMOS EL ARCHIVO
            TRAP    #15
            
            MOVEM.L (A7)+,D0-D1/A1
            
            RTS
            
; -----------------------------------------------------------------------------
SCOREAD
; LEE ARCHIVO DE PUNTUACIONES
; ENTRADA  - NINGUNA
; SALIDA   - NINGUNA
; MODIFICA - NINGUNA
; -----------------------------------------------------------------------------
            
            MOVEM.L D0-D2/A1,-(A7)
            
            ; LIMPIAMOS BUFFER
            CLR.L   D0
            LEA     FILEBUFF,A0
            
.LOOP       CLR.W   (A0)+
            
            ADDQ.B  #1,D0
            
            CMP.B   #NUMSCOS,D0
            BNE     .LOOP
            
            
            ; LEEMOS ARCHIVO
            LEA     FNAME,A1            ; ABRIMOS EL ARCHIVO
            MOVE.B  #51,D0
            TRAP    #15
            
            CLR.L   D2                  ; PUNTERO
            MOVE.B  #55,D0
            TRAP    #15
            
            LEA     FILEBUFF,A1         ; LEEMOS EL ARCHIVO
            MOVE.L  #2*NUMSCOS,D2       ; BYTES A LEER
            
            MOVE.B  #53,D0              ; LEEMOS
            TRAP    #15
                       
            MOVE.B  #56,D0              ; CERRAMOS EL ARCHIVO
            TRAP    #15
            
            MOVEM.L (A7)+,D0-D2/A1
            
            
            RTS

            
            





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~

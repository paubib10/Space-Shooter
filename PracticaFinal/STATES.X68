; =============================================================================
; GESTIÓN DE ESTADOS DEL JUEGO
; =============================================================================

; -----------------------------------------------------------------------------
STAINIT
; INICIALIZA EL GESTOR DE ESTADOS
; ENTRADA  - NINGUNA
; SALIDA   - NINGUNA
; MODIFICA - NINGUNA
; -----------------------------------------------------------------------------
            MOVE.W  #STANONE,(STACUR)
            MOVE.W  #STAINTR,(STANEXT)
            CLR.B   (AUDACCSN)

            RTS

; -----------------------------------------------------------------------------
STAUPD
; REALIZA LA ACTUALIZACIÓN DEL ESTADO Y LA INICIALIZACIÓN SI ES NECESARIO
; ENTRADA  - NINGUNA
; SALIDA   - NINGUNA
; MODIFICA - NINGUNA
; -----------------------------------------------------------------------------
            MOVEM.L D0/A0,-(A7)
            CLR.L   D0
            MOVE.W  (STANEXT),D0
            CMP.W   (STACUR),D0
            BEQ     .DOUPD
            MOVE.W  D0,(STACUR)             ; SI EL ESTADO CAMBIÓ, HACE INIT
            LSL.L   #2,D0
            MOVE.L  D0,A0
            MOVE.L  .INITBL(A0),A0
            JSR     (A0)
.DOUPD      CLR.L   D0                      ; EN CUALQUIER CASO, ACTUALIZAR
            MOVE.W  (STACUR),D0
            LSL.L   #2,D0
            MOVE.L  D0,A0
            MOVE.L  .UPDTBL(A0),A0
            JSR     (A0)
            MOVEM.L (A7)+,D0/A0
            RTS
.INITBL     DC.L    STAINTRI,STAPLAYI,STAEMPTY
.UPDTBL     DC.L    STAINTRU,STAPLAYU,STAGOVRU

; -----------------------------------------------------------------------------
STAPLOT
; REALIZA LA REPRESENTACIÓN DEL ESTADO
; ENTRADA  - NINGUNA
; SALIDA   - NINGUNA
; MODIFICA - NINGUNA
; -----------------------------------------------------------------------------
            MOVEM.L D0/A0,-(A7)
            CLR.L   D0
            MOVE.W  (STACUR),D0
            LSL.L   #2,D0
            MOVE.L  D0,A0
            MOVE.L  .PLTTBL(A0),A0
            JSR     (A0)
            MOVEM.L (A7)+,D0/A0
            RTS
.PLTTBL     DC.L    STAINTRP,STAPLAYP,STAGOVRP

; -----------------------------------------------------------------------------
STAEMPTY
; SUBRUTINA VACÍA PARA CASOS EN LOS QUE NO HAY NADA QUE HACER
; ENTRADA  - NINGUNA
; SALIDA   - NINGUNA
; MODIFICA - NINGUNA
; NOTA     - SOLO UN MARCADOR DE POSICIÓN. NADA QUE HACER.
; -----------------------------------------------------------------------------
            RTS

; -----------------------------------------------------------------------------
STAPLAYI    EQU     PLRINIT
; INICIALIZACIÓN DEL ESTADO DE JUEGO.
; ENTRADA  - NINGUNA
; SALIDA   - NINGUNA
; MODIFICA - NINGUNA
; NOTA     - SOLO UN ENVOLTORIO PARA PLRINIT
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
STAPLAYU
; ACTUALIZACIÓN DEL ESTADO DE JUEGO
; ENTRADA  - NINGUNA
; SALIDA   - NINGUNA
; MODIFICA - NINGUNA
; -----------------------------------------------------------------------------           
            JSR     PLRUPD
            JSR     SPWUPD
            BRA     AGLUPD

; -----------------------------------------------------------------------------
STAPLAYP
; REPRESENTACIÓN DEL ESTADO DE JUEGO
; ENTRADA  - NINGUNA
; SALIDA   - NINGUNA
; MODIFICA - NINGUNA
; -----------------------------------------------------------------------------
            JSR     AGLPLOT
            BRA     PLRPLOT

; -----------------------------------------------------------------------------
STAINTRI    EQU     DMMINIT
; INICIALIZACIÓN DEL ESTADO DE INTRODUCCIÓN
; ENTRADA  - NINGUNA
; SALIDA   - NINGUNA
; MODIFICA - NINGUNA
; NOTA     - SOLO UN ENVOLTORIO PARA DMMINIT PARA LIBERAR TODA LA MEMORIA
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
STAINTRU
; ACTUALIZACIÓN DEL ESTADO DE INTRODUCCIÓN
; ENTRADA  - NINGUNA
; SALIDA   - NINGUNA
; MODIFICA - NINGUNA
; -----------------------------------------------------------------------------
            BTST.B  #KBDBITF1,(KBDEDGE)
            BEQ     .END
            MOVE.W  #STAPLAY,(STANEXT)
.END        RTS

; -----------------------------------------------------------------------------
STAINTRP
; REPRESENTACIÓN DEL ESTADO DE INTRODUCCIÓN
; ENTRADA  - NINGUNA
; SALIDA   - NINGUNA
; MODIFICA - NINGUNA
; -----------------------------------------------------------------------------
            MOVEM.L A1/D0-D1,-(A7)
                                    
            ; ACTIVAR MUSICA
            MOVE.B  #AUDMSKLP|AUDINTID,D1
            JSR     AUDPLAY                 ; REPRODUCIR MÚSICA
            MOVE.B  #AUDACCN,(AUDACCSN)     ; RECHAZAR EFECTOS DE SONIDO
                        
            LEA     INTRO,A0
            CLR.L   D0                      ; COLOR
            CLR.L   D5                      ; COLUMNAS
            CLR.L   D6                      ; FILAS
            
            MOVE.W  #(SCRWIDTH/2)-(IMGINTSZ*IMGTILSZ/2),D1
            MOVE.W  #50,D2
            MOVE.W  D1,D3
            ADDQ.W  #IMGTILSZ,D3
            MOVE.W  D2,D4
            ADDQ.W  #IMGTILSZ,D4 
            
            
            ; PINTAMOS IMAGEN 
.LOOP       MOVE.L  (A0)+,D0                ; GUARDAMOS DATO
            
            CMP.W   #IMGINTSZ-1, D5         ; HEMOS LLEGADO AL LATERAL
            BEQ     .ALTURA
            
            CLR.L   D7
            MOVE.W  D1,D7                   ; GUARDAMOS EN REGISTRO AUXILIAR
            
            MOVE.L  D0,D1                   ; ESCOGEMOS COLOR
            MOVE.W  #80,D0
            TRAP    #15
            ADDQ.B  #1,D0
            TRAP    #15
            
            CLR.L   D1
            MOVE.W  D7,D1                   ; DEVOLVEMOS AUXILIAR
            MOVE.W  #87,D0                  ; PINTAMOS
            TRAP    #15                 
                       
.MOVE       ADDQ.W  #1,D5                   ; SUMAMOS COLUMNA
            ADD.W   #IMGTILSZ,D1
            ADD.W   #IMGTILSZ,D3
            BRA     .LOOP
            

.ALTURA     CMP.W   #IMGINTSZ-1,D6          ; HEMOS ACABADO
            BEQ     .END
            
            ADDQ.W  #1,D6                   ; SUMAMOS FILA
            ADD.W   #IMGTILSZ,D2
            ADD.W   #IMGTILSZ,D4
            
            
            CLR.L   D5
            MOVE.W  #(SCRWIDTH/2)-(IMGINTSZ*IMGTILSZ/2),D1 ;INICIALIZAMOS FILA
            MOVE.W  D1,D3
            ADD.W   #IMGTILSZ+1,D3
            BRA     .LOOP

            
            ; MOSTRAR MARCADOR
.END        UTLLOCT TOPTXTX,TOPTXTY
            UTLSFIL #$00000000
            LEA     .TOPS,A1
            MOVE.B  #14,D0
            TRAP    #15
            
            JSR     SCOREAD
            LEA     FILEBUFF,A0
            CLR.L   D1
            
            UTLLOCT TP1TXTX,TP1TXTY
            LEA     .TOP1,A1
            MOVE.W  (A0)+,D1
            MOVE.B  #17,D0
            TRAP    #15
            
            UTLLOCT TP2TXTX,TP2TXTY
            LEA     .TOP2,A1
            MOVE.W  (A0)+,D1
            MOVE.B  #17,D0
            TRAP    #15
            
            UTLLOCT TP3TXTX,TP3TXTY
            LEA     .TOP3,A1
            MOVE.W  (A0)+,D1
            MOVE.B  #17,D0
            TRAP    #15
            
            ; MOSTRAR EL MENSAJE
            UTLLOCT INTPRSX,INTPRSY
            UTLSPEN #INTPRSC
            UTLSFIL #$00000000
            LEA     .PRSSTR,A1
            MOVE.B  #14,D0
            TRAP    #15    
            
            MOVEM.L (A7)+,A1/D0-D1
            RTS

.TITSTR     DC.B    'SPACE INVADERS 68000',0
.TOPS       DC.B    'MEJORES PUNTUACIONES',0
.TOP1       DC.B    '1. ',0
.TOP2       DC.B    '2. ',0
.TOP3       DC.B    '3. ',0
.PRSSTR     DC.B    'PRESS SPACE TO PLAY',0
            DS.W    0

; -----------------------------------------------------------------------------
STAGOVRU
; ACTUALIZACIÓN DEL ESTADO DE FIN DEL JUEGO
; ENTRADA  - NINGUNA
; SALIDA   - NINGUNA
; MODIFICA - NINGUNA
; -----------------------------------------------------------------------------
            BTST.B  #KBDBITF1,(KBDEDGE)
            BEQ     .END
            
            ; GUARDAMOS PUNTUACIÓN
            JSR     SCOUPD
            
            MOVE.W  #STAINTR,(STANEXT)
.END        RTS

; -----------------------------------------------------------------------------
STAGOVRP
; REPRESENTACIÓN DEL ESTADO DE FIN DEL JUEGO
; ENTRADA  - NINGUNA
; SALIDA   - NINGUNA
; MODIFICA - NINGUNA
; -----------------------------------------------------------------------------
            MOVEM.L A0-A1/D0-D1,-(A7)
                                   
            UTLLOCT GOVSTRX,GOVSTRY
            UTLSPEN #GOVSTRC
            UTLSFIL #$00000000
            LEA     .GOVSTR,A1
            MOVE.B  #14,D0
            TRAP    #15
            
            UTLLOCT GOVSCOX,GOVSCOY
            UTLSPEN #GOVSTRC
            UTLSFIL #$00000000
            LEA     .GOVSCO,A1
            CLR.L   D1
            MOVE.W  (PLRSCORE),D1
            MOVE.B  #17,D0
            TRAP    #15
            
            ; MIRAMOS SI ES NUEVO RÉCORD
            JSR     SCOREAD
            LEA     FILEBUFF,A0
            MOVE.W  (A0),D1
            CMP.W   (PLRSCORE),D1
            BGE     .NOESREC
            
            UTLLOCT GOVNRX,GOVNRY
            UTLSPEN #GOVSTRC
            UTLSFIL #$00000000
            LEA     .GOVNRD,A1
            MOVE.B  #14,D0
            TRAP    #15
            
                       
.NOESREC    MOVEM.L (A7)+,A0-A1/D0-D1
            RTS

.GOVSTR     DC.B    'GAME  OVER',0
.GOVNRD     DC.B    '¡¡¡ NUEVO RÉCORD !!!',0
.GOVSCO     DC.B    'PUNTUACIÓN: ',0
            DS.W    0
*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~1~
*~Tab size~4~

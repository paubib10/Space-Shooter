; =============================================================================
; GESTIÓN DEL JUGADOR
; =============================================================================

; -----------------------------------------------------------------------------
PLRINIT
; INICIALIZA EL JUGADOR
; ENTRADA  - NINGUNA
; SALIDA   - NINGUNA
; MODIFICA - NINGUNA
; -----------------------------------------------------------------------------
            MOVE.W  #SCRHEIGH-(PLRHEIGH*2),(PLRPOSY)
            MOVE.W  #(SCRWIDTH-PLRWIDTH)/2,(PLRPOSX)
            MOVE.B  #PLRINLIF,(PLRLIFES)
            CLR.W   (PLRDMG)
            CLR.B   (ASTMODE)
            CLR.W   (PLRSCORE)
                        
            ; EMPIEZA CUENTA REGRESIVA
            CLR.B   (CICLOCR)
            MOVE.B  #INITCR,(NUMACTCR)
            
            MOVE.B  #AUDACCY,(AUDACCSN)     ; PERMITIR NUEVOS SONIDOS
            MOVE.B  #AUDENDID,D1            ; PARAR LA MÚSICA
            JSR     AUDPLAY
                       
            RTS

; -----------------------------------------------------------------------------
PLRUPD
; ACTUALIZA EL MOVIMIENTO DEL JUGADOR
; ENTRADA  - NINGUNA (ACCESO A KBDVAL Y KBDEDGE)
; SALIDA   - NINGUNA (MODIFICA LOS DATOS DEL JUGADOR)
; MODIFICA - NINGUNA
; -----------------------------------------------------------------------------
            BCLR.B  #PLRUBDMG,(PLRDMG)
            BEQ     .NODMG
                        
            SUBQ.B   #1,(PLRLIFES)
            BGT     .HER
            
            ; ACTIVAR MUSICA
            MOVE.B  #AUDMSKNL|AUDGOVID,D1
            JSR     AUDPLAY                 ; REPRODUCIR MÚSICA
            
            ;JSR     SCOREC
            MOVE.W  #STAGOVR,(STANEXT)      ; SI LA VIDA ES 0,SE ACABÓ EL JUEGO
            
            BRA     .NODMG

.HER        ; ACTIVAR MUSICA
            MOVE.B  #AUDMSKNL|AUDHERID,D1
            JSR     AUDPLAY                 ; REPRODUCIR MÚSICA
            
.NODMG      MOVE.W  D1,-(A7)

            MOVE.B  (KBDVAL),D1             ; PERFORM MOTION AND CHECK LIMITS.

            ROR.B   #1,D1
            BCC     .CHKUP
            SUB.W   #PLRSPEED,(PLRPOSX)
            TST.W   (PLRPOSX)
            BGE     .CHKUP
            CLR.W   (PLRPOSX)
.CHKUP      ROR.B   #1,D1
            BCC     .CHKRT
            SUB.W   #PLRSPEED,(PLRPOSY)
            TST.W   (PLRPOSY)
            BGE     .CHKRT
            CLR.W   (PLRPOSY)
.CHKRT      ROR.B   #1,D1
            BCC     .CHKDN
            ADD.W   #PLRSPEED,(PLRPOSX)
            CMP.W   #(SCRWIDTH-PLRWIDTH),(PLRPOSX)
            BLE     .CHKDN
            MOVE.W  #(SCRWIDTH-PLRWIDTH),(PLRPOSX)
.CHKDN      ROR.B   #1,D1
            BCC     .MDONE
            ADD.W   #PLRSPEED,(PLRPOSY)
            CMP.W   #SCRHEIGH-PLRHEIGH,(PLRPOSY)
            BLE     .MDONE
            MOVE.W  #SCRHEIGH-PLRHEIGH,(PLRPOSY)
.MDONE      BTST.B  #KBDBITF1,(KBDEDGE)
            BEQ     .NOFIRE
            
            TST.B   NUMACTCR                ; CR ES !0 -> NO PODEMOS DISPARAR
            BNE     .NOFIRE

            MOVEM.L A1-A3/D0-D2,-(A7)
            LEA     SHTINIT,A1
            LEA     SHTUPD,A2
            LEA     SHTPLOT,A3
            MOVE.W  #SHTTYPE,D0
            MOVE.W  (PLRPOSX),D1
            MOVE.W  (PLRPOSY),D2
            JSR     AGLADD
            
            MOVE.W  (PLRPOSX),D1
            ADD.W   #PLRWIDTH-SHTHEIGH,D1
            MOVE.W  (PLRPOSY),D2
            JSR     AGLADD
            MOVEM.L (A7)+,A1-A3/D0-D2
            
.NOFIRE     TST.B   NUMACTCR                ; CR ES 0 -> PODEMOS SALTAR
            BEQ     .END
            JSR     CUREUPD                 ; ACTUALIZA CUENTA REGRESIVA
            
.END        MOVE.W  (A7)+,D1
            RTS

; -----------------------------------------------------------------------------
PLRPLOT
; TRAZA EL JUGADOR, SU VIDA Y LA PUNTUACIÓN
; ENTRADA  - NINGUNA
; SALIDA   - NINGUNA
; MODIFICA - NINGUNA
; -----------------------------------------------------------------------------
            MOVEM.L D0-D7,-(A7)
                     
            MOVE.L  #PLRNRMCL,D1            ; DECIDE COLOR
            
            MOVE.B  #80,D0
            TRAP    #15
            ADDQ.B  #1,D0
            TRAP    #15
            
            MOVE.W  (PLRPOSX),D1            ; TRAZAR EL JUGADOR
            MOVE.W  (PLRPOSY),D2
            MOVE.W  D1,D3
            MOVE.W  D2,D4
            ADD.W   #PLRWIDTH,D3
            ADD.W   #PLRHEIGH,D4
            MOVE.B  #88,D0
            TRAP    #15
            
            SUBQ.W  #3,D2
            SUB.W   #PLRWIDTH-3,D3
            SUB.W   #PLRHEIGH/2,D4
            MOVE.B  #87,D0
            TRAP    #15
            
            ADD.W   #PLRWIDTH-3,D1
            ADD.W   #PLRWIDTH-3,D3
            TRAP    #15  
            
            MOVE.W  (PLRPOSX),D1
            ADD.W   #(PLRWIDTH/2)-5,D1
            MOVE.W  D1,D3
            ADD.W   #PLRHEIGH-4,D3
            MOVE.W  (PLRPOSY),D2
            MOVE.W  D2,D4
            ADD.W   #PLRHEIGH+3,D4
            ADD.W   #10,D2
            TRAP    #15
            
            MOVE.L  D1,-(A7)
            MOVE.L  #RED,D1
            MOVE.B  #80,D0
            TRAP    #15
            ADDQ.B  #1,D0
            TRAP    #15
            MOVE.L  (A7)+,D1
            
            MOVE.W  D4,D2
            ADDQ.W  #1,D4
            MOVE.B  #87,D0
            TRAP    #15        

            UTLSPEN #PLRTXTCL               ; TRAZAR EL TEXTO SCORE
            UTLSFIL #$00000000
            UTLLOCT PLRTXTX,PLRTXTY
            LEA     .SCORESTR,A1
            CLR.L   D1
            MOVE.W  (PLRSCORE),D1
            MOVE.B  #17,D0
            TRAP    #15
            
            UTLSPEN #PLRTXTCL               ; TRAZAR EL TEXTO FPS GOAL
            UTLSFIL #$00000000
            UTLLOCT FPGTXTX,FPGTXTY
            LEA     .FPSGSTR,A1
            CLR.L   D1 
            MOVE.B  #FPSGOAL,D1
            MOVE.B  #17,D0
            TRAP    #15
            
            UTLSPEN #PLRTXTCL               ; TRAZAR EL TEXTO FPS ACTUAL
            UTLSFIL #$00000000
            UTLLOCT FPSTXTX,FPSTXTY
            LEA     .FPSSTR,A1
            CLR.L   D1
            MOVE.L  (FPSREAL),D1
            MOVE.B  #17,D0
            TRAP    #15

            ; ----- TRAZAR VIDA -----
            ; INICIALIZAMOS A BAJO DEL TODO
            MOVE.W  #SCRWIDTH-(HTWIDTH*HTTILSIZ),D1
            MOVE.W  #SCRHEIGH,D2
            MOVE.W  D1,D3
            ADD.W   #HTTILSIZ+1,D3
            MOVE.W  D2,D4
            SUB.W   #HTTILSIZ-1,D4
            
            CLR.L   D0                      ; UTILIZAMOS A1 PORQUE TODOS LOS
            MOVE.B  (PLRLIFES),D0           ; REGISTROS DX SE UTILIZARAN 
            ADDQ.B  #1,D0                   ; A CONTINUACIÓN
            
            MOVE.L  D0,-(A7)
            
.PRHT       MOVE.L  (A7)+,D0
            SUBQ.B  #1,D0
            TST.B   D0
            BEQ     .END                    ; HEMOS TERMINADO
            
            MOVE.L  D0,-(A7)
            LEA     HEART,A0
            CLR.L   D5                      ; COLUMNAS
            CLR.L   D6                      ; FILAS
                       
            SUB.W  #HTBORDER,D1
            SUB.W  #HTBORDER,D2
            SUB.W  #HTBORDER,D4
            
            ; PINTAMOS CORAZÓN
.LOOP       CLR.L   D0
            MOVE.B  (A0)+,D0                ; GUARDAMOS DATO
            
            CMP.W   #HTWIDTH-1, D5          ; HEMOS LLEGADO AL LATERAL
            BEQ     .ALTURA
            
            CLR.L   D7
            MOVE.W  D1,D7                   ; GUARDAMOS EN REGISTRO AUXILIAR
            
            TST.B   D0                      ; 0 -> NO PINTAR
            BEQ     .MOVE
            
            CMP.B   #1,D0                   ; 1 -> ROJO
            BNE     .NEGRO
            MOVE.L  #RED,D1
            MOVE.W  #80,D0
            TRAP    #15
            ADDQ.B  #1,D0
            TRAP    #15
            BRA     .PINTAR
            
.NEGRO      CMP.B   #2,D0                   ; 2 -> NEGRO
            BNE     .BLANCO
            MOVE.L  #BLACK,D1
            MOVE.W  #80,D0
            TRAP    #15
            ADDQ.B  #1,D0
            TRAP    #15
            BRA     .PINTAR
            
.BLANCO     MOVE.L  #WHITE,D1               ; 3 -> BLANCO
            MOVE.W  #80,D0
            TRAP    #15
            ADDQ.B  #1,D0
            TRAP    #15

            
            
.PINTAR     CLR.L   D1
            MOVE.W  D7,D1                   ; DEVOLVEMOS AUXILIAR
            MOVE.W  #87,D0                  ; PINTAMOS
            TRAP    #15                 
                       
.MOVE       ADDQ.W  #1,D5                   ; SUMAMOS COLUMNA
            ADD.W   #HTTILSIZ,D1
            ADD.W   #HTTILSIZ,D3
            BRA     .LOOP
            

.ALTURA     CMP.W   #HTHEIGH-1,D6           ; HEMOS ACABADO
            BEQ     .PRHT
            
            ADDQ.W  #1,D6                   ; SUMAMOS FILA
            SUB.W   #HTTILSIZ,D2
            SUB.W   #HTTILSIZ,D4
            
            
            CLR.L   D5
            MOVE.W  #SCRWIDTH-(HTWIDTH*HTTILSIZ)-HTBORDER,D1 ;INIT FILA
            MOVE.W  D1,D3
            ADD.W   #HTTILSIZ+1,D3
            BRA     .LOOP

                        
.END        MOVEM.L (A7)+,D0-D7
            RTS
            
            
.SCORESTR   DC.B    'SCORE: ',0
.FPSGSTR    DC.B    'FPS GOAL: ',0
.FPSSTR     DC.B    'FPS ACTUAL: ',0
*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~

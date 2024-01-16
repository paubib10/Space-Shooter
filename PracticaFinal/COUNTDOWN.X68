; =============================================================================
; MANEJADOR DE LA CUENTA REGRESIVA
; =============================================================================

; -----------------------------------------------------------------------------
CUREUPD
; ACTUALIZACIÓN DE LA CUENTA REGRESIVA
; ENTRADA - NINGUNA
; SALIDA   - NINGUNA
; MODIFICA - NINGUNA
; -----------------------------------------------------------------------------
            MOVEM.L D0-D4,-(A7)
            
            ADDQ.B  #1,(CICLOCR)  
                   
            CMP.B    #$3F,(CICLOCR)
            BEQ     .NEXT
            
            ; IMPRIMIMOS POR PANTALLA EL NUMERO
            UTLSPEN     #NUMCOLOR
            UTLSFIL     #NUMCOLOR
            
            ; MIRAMOS SI ES EL 1
            CMP.B   #1,(NUMACTCR)
            BNE     .ES2
            
            ;PINTAMOS 1
            MOVE.W  #(SCRWIDTH/2)-(NUMSIZE/2),D1
            MOVE.W  #(SCRHEIGH/2)-(NUMHEIGH/2),D2
            MOVE.W  D1,D3
            ADD.W   #NUMSIZE,D3
            MOVE.W  D2,D4
            ADD.W   #NUMHEIGH,D4
            
            MOVE.B      #87,D0
            TRAP        #15
            
            BRA     .END

            ; MIRAMOS SI ES EL 2
.ES2        CMP.B   #2,(NUMACTCR)
            BNE     .ES3   

            ;PINTAMOS 2  
            MOVE.W  #(SCRWIDTH/2)-(NUMWIDTH/2),D1   ; BARRA DE ARRIBA
            MOVE.W  #(SCRHEIGH/2)-(NUMHEIGH/2),D2
            MOVE.W  D1,D3
            ADD.W   #NUMWIDTH,D3
            MOVE.W  D2,D4
            ADD.W   #NUMSIZE,D4
            
            MOVE.B      #87,D0
            TRAP        #15
            
            ADD.W   #(NUMHEIGH/2)-(NUMSIZE/2),D2    ; BARRA DE ENMEDIO
            ADD.W   #(NUMHEIGH/2)-(NUMSIZE/2),D4
            
            MOVE.B      #87,D0
            TRAP        #15
            
            ADD.W   #(NUMHEIGH/2)-(NUMSIZE/2),D2    ; BARRA DE ABAJO
            ADD.W   #(NUMHEIGH/2)-(NUMSIZE/2),D4
            
            MOVE.B      #87,D0
            TRAP        #15
            
            ADD.W   #NUMWIDTH-NUMSIZE,D1            ; BARRA DE LA DERECHA
            MOVE.W  #(SCRHEIGH/2)-(NUMHEIGH/2),D2
            MOVE.W  #(SCRHEIGH/2)+(NUMSIZE/2),D4
            
            MOVE.B      #87,D0
            TRAP        #15
            
            SUB.W   #NUMWIDTH-NUMSIZE,D1            ; BARRA DE LA IZQUIERDA
            MOVE.W  D4,D2
            SUB.W   #NUMWIDTH-NUMSIZE,D3
            ADD.W   #(NUMHEIGH/2)-(NUMSIZE/2),D4
            
            MOVE.B      #87,D0
            TRAP        #15
            
            BRA     .END

            ; MIRAMOS SI ES EL 3
.ES3        CMP.B   #3,(NUMACTCR)
            BNE     .END   

            ;PINTAMOS 3
            MOVE.W  #(SCRWIDTH/2)-(NUMWIDTH/2),D1   ; BARRA DE ARRIBA
            MOVE.W  #(SCRHEIGH/2)-(NUMHEIGH/2),D2
            MOVE.W  D1,D3
            ADD.W   #NUMWIDTH,D3
            MOVE.W  D2,D4
            ADD.W   #NUMSIZE,D4
            
            MOVE.B      #87,D0
            TRAP        #15
            
            ADD.W   #(NUMHEIGH/2)-(NUMSIZE/2),D2    ; BARRA DE ENMEDIO
            ADD.W   #(NUMHEIGH/2)-(NUMSIZE/2),D4
            
            MOVE.B      #87,D0
            TRAP        #15
            
            ADD.W   #(NUMHEIGH/2)-(NUMSIZE/2),D2    ; BARRA DE ABAJO
            ADD.W   #(NUMHEIGH/2)-(NUMSIZE/2),D4
            
            MOVE.B      #87,D0
            TRAP        #15
            
            ADD.W   #NUMWIDTH-NUMSIZE,D1            ; BARRA DEL LATERAL
            SUB.W   #NUMHEIGH-NUMSIZE,D2
            
            MOVE.B      #87,D0
            TRAP        #15
            
            BRA     .END
            
            
            ; MODIFICAMOS CUENTA REGRESIVA
.NEXT       SUBQ.B  #1,(NUMACTCR)
            CLR.B   (CICLOCR)
            
            TST.B   (NUMACTCR)
            BEQ     .FINAL
            
            ; MUSICA            
            MOVE.B  #AUDMSKNL|AUDCDNID,D1
            JSR     AUDPLAY                 ; PLAY MUSIC
            MOVE.B  #AUDACCY,(AUDACCSN)     ; REJECT SOUND EFFECTS
            BRA     .END
            
.FINAL      ; MUSICA            
            MOVE.B  #AUDMSKNL|AUDCDFID,D1
            JSR     AUDPLAY                 ; PLAY MUSIC
            MOVE.B  #AUDACCY,(AUDACCSN)     ; REJECT SOUND EFFECTS
            
.END        MOVEM.L  (A7)+,D0-D4
            RTS

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~

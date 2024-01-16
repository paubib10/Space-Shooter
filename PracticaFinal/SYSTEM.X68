; =============================================================================
; TÍTULO   : GESTIÓN DEL SISTEMA (CÓDIGO DEL SISTEMA)
; AUTORES  : PAU TONI BIBILONI MARTÍNEZ
;            JOAN MARTORELL COLL
; COMENTARIOS : SE DIVIDE EN TRES BLOQUES:
;               - SYS : GENÉRICO.
;               - SCR : GESTIÓN DE LA PANTALLA.
;               - KBD : GESTIÓN DEL TECLADO.
; =============================================================================

; -----------------------------------------------------------------------------
SYSINIT
; INICIALIZA EL SISTEMA
; ENTRADA  - NINGUNA
; SALIDA   - NINGUNA
; MODIFICA - NINGUNA
; -----------------------------------------------------------------------------
            MOVE.L  (A7)+,A0                ; OBTIENE LA DIRECCIÓN DE RETORNO
            JSR     KBDINIT                 ; INICIALIZA EL TECLADO
            JSR     SCRINIT                 ; INICIALIZA LA PANTALLA
            JSR     DMMINIT                 ; INICIALIZA LA MEMORIA DINÁMICA
            ANDI.W  #$DFFF,SR               ; CAMBIA A MODO USUARIO
            MOVE.L  A0,-(A7)                ; PONE LA DIRECCIÓN DE RETORNO
            RTS

; =============================================================================
; GESTIÓN DE LA PANTALLA (CÓDIGO DEL SISTEMA)
; =============================================================================

; -----------------------------------------------------------------------------
SCRINIT
; INICIALIZA LA PANTALLA, LA INTERRUPCIÓN RELACIONADA CON LA PANTALLA Y LAS VARIABLES.
; ENTRADA  - NINGUNA
; SALIDA   - NINGUNA
; MODIFICA - D0,D1,D2,D3
; -----------------------------------------------------------------------------
            ORI.W   #$0700,SR               ; DESACTIVA TODAS LAS INTERRUPCIONES
            MOVE.L  #SCRUPD,($80+SCRTRAP*4) ; INSTALA LA TRAMPA
            MOVE.L  #SCRWIDTH<<16|SCRHEIGH,D1 ; ESTABLECE LA RESOLUCIÓN
            MOVE.B  #33,D0
            TRAP    #15
            MOVE.L  #1,D1                   ; ESTABLECE EL MODO DE VENTANA
            TRAP    #15
            MOVE.W  #$FF00,D1               ; LIMPIA EL BUFFER VISIBLE
            MOVE.B  #11,D0
            TRAP    #15
            MOVE.B  #17,D1                  ; HABILITA EL DOBLE BUFFER
            MOVE.B  #92,D0
            TRAP    #15
            MOVE.W  #$FF00,D1               ; LIMPIA EL BUFFER OCULTO
            MOVE.B  #11,D0
            TRAP    #15
            MOVE.L  #SCRISR,($60+SCRIRQ*4)  ; ESTABLECE EL VECTOR DE EXCEPCIÓN
            MOVE.B  #5,D1                   ; HABILITA EL PROCESAMIENTO DE EXCEPCIONES
            MOVE.B  #32,D0
            TRAP    #15
            MOVE.B  #%10000000|SCRIRQ,D2    ; HABILITA AUTO-IRQ
            MOVE.B  #SCRTIM,D3
            MOVE.B  #6,D1
            MOVE.B  #32,D0
            TRAP    #15
            CLR.B   (SCRINTCT)              ; PREPARA LA BANDERA DE INTERRUPCIÓN
            CLR.B   (SCRCYCCT)              ; PREPARA EL CONTADOR DE CICLOS
            ANDI.W  #$F8FF,SR               ; HABILITA LAS INTERRUPCIONES
            RTS

; -----------------------------------------------------------------------------
SCRISR
; ISR DEL TEMPORIZADOR DE LA PANTALLA. AUMENTA EL CONTADOR DE INTERRUPCIONES Y ACTUALIZA EL DOBLE BUFFER.
; ENTRADA  - NINGUNA
; SALIDA   - NINGUNA
; MODIFICA - NINGUNA
; -----------------------------------------------------------------------------
            ADDQ.B  #1,(SCRINTCT)           ; ACTUALIZA LA BANDERA/CONTADOR DE INTERRUPCIÓN
            ADDQ.B  #1,(SCRCYCCT)           ; ACTUALIZA EL CONTADOR DE CICLOS
            RTE
            
; -----------------------------------------------------------------------------
SCRUPD
; RUTINA DE SERVICIO DE TRAP ENCARGADA DE VISUALIZAR EL MARCO ACTUAL Y LIMPIAR
; BUFFER PARA EL SIGUIENTE.
; ENTRADA  - NINGUNA
; SALIDA   - NINGUNA
; MODIFICA - NINGUNA
; -----------------------------------------------------------------------------
            MOVEM.W D0-D1,-(A7)
            MOVE.B  #94,D0                  ; ACTUALIZAR DOBLE BUFFER
            TRAP    #15
            MOVE.W  #$FF00,D1               ; BORRAR BUFFER OCULTO
            MOVE.B  #11,D0
            TRAP    #15
            MOVEM.W (A7)+,D0-D1
            RTE

; =============================================================================
; GESTIÓN DEL TECLADO (CÓDIGO DEL SISTEMA)
; =============================================================================

; -----------------------------------------------------------------------------
KBDINIT
; INICIALIZA LAS VARIABLES DEL SISTEMA KBDSYS Y KBDVAL
; ENTRADA  - NINGUNA
; SALIDA   - NINGUNA
; MODIFICA - NINGUNA
; -----------------------------------------------------------------------------
            CLR.B   (KBDVAL)                 ; INICIAR VARS
            CLR.B   (KBDEDGE)
            MOVE.L  #KBDREAD,($80+KBDTRAP*4) ; INSTALAR
            RTS

; -----------------------------------------------------------------------------
KBDREAD
; RUTINA DE SERVICIO DE TRAP.
; ACTUALIZA LAS VARIABLES DEL SISTEMA KBDEDGE Y KBDVAL SEGÚN EL BITFIELD
; DESCRITO EN SYSCONST. KBDVAL MANTIENE LOS VALORES ACTUALES Y KBDEFGE MANTIENE
; LOS BORDES AUMENTADOS DE LA LLAMADA ANTERIOR A LA ACTUAL.
; ENTRADA  - NINGUNA
; SALIDA   - (KBDVAL) Y (KBDEDGE)
; MODIFICA - NINGUNA
; -----------------------------------------------------------------------------
            MOVEM.L D0-D3,-(A7)
            MOVE.B  #19,D0
            MOVE.L  #KBDPAUSE<<24+KBDFIRE3<<16+KBDFIRE2<<8+KBDFIRE1,D1
            TRAP    #15
            BSR     .STORE                ; ALMACENAR FIRE1,FIRE2,FIRE3 Y PAUSE
            MOVE.L  #KBDDOWN<<24+KBDRIGHT<<16+KBDUP<<8+KBDLEFT,D1
            TRAP    #15
            BSR     .STORE                ; ALAMACENAR KEY UP,DOWN,LEFT Y RIGTH
            MOVE.B  (KBDVAL),D0           ; BORDE DE COMPUTACIÓN
            NOT.B   D0                    ; BORDE = NO(ANTERIOR) Y ACTUAL
            AND.B   D2,D0
            MOVE.B  D2,(KBDVAL)           ; ALMACENAR VALORES (PRESS Y BORDE)
            MOVE.B  D0,(KBDEDGE)
            MOVEM.L (A7)+,D0-D3
            RTE

.STORE      MOVE.W  #3,D3                 ; TRADUCE LA CODIFICACIÓN DE 8-BIT
.LOOP       LSL.L   #8,D1                 ; DEL TRAP #15 TASK 19 EN UN 1-BIT
            ROXL.B  #1,D2                 ; CODIFICACIÓN POR PULSIÓN DE TECLA
            DBRA.W  D3,.LOOP
            RTS

; =============================================================================
; GESTIÓN DE MEMORIA DINÁMICA (CÓDIGO DEL SISTEMA)
; LA MEMORIA DINÁMICA ES UN CONJNT DE DMMBNUM SLOTS DE DMMBSIZE BYTES CADA UNA.
; DMMBSIZE DEBE SER POTENCIA DE DOS. UNA RANURA TIENE:
; - ENCABEZADO - 1 WORD. ESPECIFICA EL PROPIETARIO (0 = PROPIEDAD DEL SISTEMA)
; - DATOS   - DMMBSIZE - 2 BYTES. PUEDE CONTENER VARIABLES Y CUALQUIER TIPO DE
;             DATOS RELACIONADOS CON EL PROPIETARIO. SI OWNER==0, LOS DATOS NO
;             TIENEN SENTIDO.
; =============================================================================

; -----------------------------------------------------------------------------
DMMINIT
; INICIALIZA LA MEMORIA DINÁMICA PARA QUE TODA SEA PROPIEDAD DEL SISTEMA.
; ENTRADA  - NINGUNA
; SALIDA   - NINGUNA
; MODIFICA - NINGUNA
; -----------------------------------------------------------------------------
            MOVEM.L D0/A0,-(A7)
            LEA     DMMDATA,A0
            MOVE.W  #DMMBNUM-1,D0
.LOOP       MOVE.W  #DMMSYSID,(A0)
            ADD.L   #DMMBSIZE,A0
            DBRA.W  D0,.LOOP
            MOVEM.L (A7)+,D0/A0
            RTS

; -----------------------------------------------------------------------------
DMMFIRST
; BUSCA EL PRIMER SLOT DE MEMORIA NO PROPIEDAD DEL SISTEMA Y DEVUELVE UN 
; PUNTERO A LOS DATOS CORRESPONDIENTES (DIRECCIÓN DEL SLOT + 2)
; ENTRADA  - NINGUNA
; SALIDA   - A0   : PUNTERO A LOS DATOS O 0 SI NO SE ENCUENTRA
; MODIFICA - NINGUNA (APARTE DE LA SALIDA)
; -----------------------------------------------------------------------------
            LEA     DMMDATA,A0
DMMFRLOP    TST.W   (A0)+
            BNE     DMMFRFND
            ADD.L   #DMMBSIZE-2,A0
DMMFRCOM    CMP.L   #DMMDATA+DMMBSIZE*DMMBNUM-1,A0
            BLT     DMMFRLOP
            MOVE.L  #0,A0
DMMFRFND    RTS

; -----------------------------------------------------------------------------
DMMNEXT
; BUSCA EL SIGUIENTE SLOT DE MEMORIA NO PROPIEDAD DEL SISTEMA Y DEVUELVE UN 
; PUNTERO A LOS DATOS CORRESPONDIENTES (DIRECCIÓN DEL SLOT + 2)
; ENTRADA  - A0   : PUNTERO DENTRO DEL SLOT ACTUAL
; SALIDA   - A0   : PUNTERO A LOS DATOS O 0 SI NO SE ENCUENTRA
; MODIFICA - NINGUNA (APARTE DE LA SALIDA)
; -----------------------------------------------------------------------------
            MOVE.L  D0,-(A7)
            MOVE.L  A0,D0
            AND.L   #-DMMBSIZE,D0           ; APROVECHA LA ALINEACIÓN
            ADD.L   #DMMBSIZE,D0
            MOVE.L  D0,A0
            MOVE.L  (A7)+,D0
            BRA     DMMFRCOM
; -----------------------------------------------------------------------------
DMMFRSTO
; BUSCA EL PRIMER SLOT DE MEMORIA CON EL ID ESPECIFICADO Y DEVUELVE UN PUNTERO
; A LOS DATOS CORRESPONDIENTES (DIRECCIÓN DEL SLOT + 2)
; ENTRADA  - D0.W : ID A BUSCAR
; SALIDA   - A0   : PUNTERO A LOS DATOS O 0 SI NO SE ENCUENTRA
; MODIFICA - NINGUNA (APARTE DE LA SALIDA)
; -----------------------------------------------------------------------------
            LEA     DMMDATA,A0
DMMFLOOP    CMP.W   (A0)+,D0
            BEQ     DMMFFND
            ADD.L   #DMMBSIZE-2,A0
DMMFCOM     CMP.L   #DMMDATA+DMMBSIZE*DMMBNUM-1,A0
            BLT     DMMFLOOP
            MOVE.L  #0,A0
DMMFFND     RTS

; -----------------------------------------------------------------------------
DMMNEXTO
; BUSCA LA SIGUIENTE RANURA DE MEMORIA CON EL ID ESPECIFICADO Y DEVUELVE UN PUNTERO
; A LOS DATOS CORRESPONDIENTES (DIRECCIÓN DEL SLOT + 2)
; ENTRADA  - D0.W : ID A BUSCAR
;            A0   : PUNTERO DENTRO DEL SLOT ACTUAL
; SALIDA   - A0   : PUNTERO A LOS DATOS O 0 SI NO SE ENCUENTRA
; MODIFICA - NINGUNA (APARTE DE LA SALIDA)
; -----------------------------------------------------------------------------
            MOVE.L  D0,-(A7)
            MOVE.L  A0,D0
            AND.L   #-DMMBSIZE,D0           ; APROVECHA LA ALINEACIÓN
            ADD.L   #DMMBSIZE,D0
            MOVE.L  D0,A0
            MOVE.L  (A7)+,D0
            BRA     DMMFCOM

; -----------------------------------------------------------------------------
DMMALLOC
; BUSCA EL PRIMER SLOT LIBRE (PROPIEDAD DEL SISTEMA), ASIGNA AL 
; PROPIETARIO  ESPECIFICADO Y DEVUELVE UN PUNTERO A LOS DATOS 
; CORRESPONDIENTES (DIRECCIÓN DEL SLOT + 2)
; ENTRADA  - D0.W : ID A ASIGNAR
; SALIDA   - A0   : PUNTERO A LOS DATOS O 0 SI NO HAY ESPACIO LIBRE
; MODIFICA - NINGUNA (APARTE DE LA SALIDA)
; -----------------------------------------------------------------------------
            MOVE.W  D0,-(A7)
            CLR.W   D0
            JSR     DMMFRSTO
            MOVE.W  (A7)+,D0
            CMP.L   #0,A0
            BEQ     .END
            MOVE.W  D0,-2(A0)
.END        RTS

; -----------------------------------------------------------------------------
DMMFREE
; LIBERA EL SLOT A LA QUE PERTENECE EL PUNTERO PROPORCIONADO ESTABLECIENDO 
; SU PROPIEDAD A SISTEMA (0)
; ENTRADA  - A0   : PUNTERO PERTENECIENTE AL SLOT A LIBERAR
; SALIDA   - NINGUNA
; MODIFICA - NINGUNA
; -----------------------------------------------------------------------------
            MOVEM.L D0/A0,-(A7)
            MOVE.L  A0,D0
            AND.L   #-DMMBSIZE,D0           ; APROVECHA LA ALINEACIÓN
            MOVE.L  D0,A0
            CLR.W   (A0)
            MOVEM.L (A7)+,D0/A0
            RTS
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~

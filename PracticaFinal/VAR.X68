; =============================================================================
; VARIABLES DEL JUEGO
; =============================================================================

; --- VARIABLES RELACIONADAS CON EL ESTADO DEL JUEGO --------------------------

STACUR      DS.W    1                       ; ESTADO ACTUAL DEL JUEGO
STANEXT     DS.W    1                       ; SIGUIENTE ESTADO DEL JUEGO
FPSREAL     DS.L    1
FPSCOUNT    DS.L    1
TIME        DS.L    1

; --- VARIABLES RELACIONADAS CON EL JUGADOR ----------------------------------

PLRPOSX     DS.W    1                       ; POSICI�N X DEL JUGADOR (PIXELES)
PLRPOSY     DS.W    1                       ; POSICI�N Y DEL JUGADOR (PIXELES)
PLRLIFES    DS.B    1                       ; VIDAS DEL JUGADOR
PLRSCORE    DS.W    1                       ; PUNTUACI�N DEL JUGADOR
PLRDMG      DS.B    1                       ; BIT0: ACTUALIZAR DA�O, BIT1 MOSTRAR DA�O
            DS.W    0
            
; --- VARIABLES RELACIONADAS CON EL AUDIO ------------------------------------

AUDACCSN    DS.B    1                       ; �ACEPTAR NUEVOS SONIDOS?
            DS.W    0
            
; --- VARIABLES SOBRE LA CUENTA REGRESIVA ------------------------------------

CICLOCR     DS.B    1                       ; N�MERO DE CICLO PARA LA CUENTA REGRESIVA
NUMACTCR    DS.B    1                       ; N�MERO ACTUAL A CONTAR
            DS.W    0

; --- VARIABLES DE UTILIDAD --------------------------------------------------

ASTMODE     DS.B    1                        ; MODO ASTEROIDE: 0 -> Ninguno
;                                                              1 -> NORMAL
;                                                              2 -> DIF�CIL
UTLRNDIX    DS.B    1                       ; SIGUIENTE �NDICE PARA N�MERO ALEATORIO
            DS.W    0
FILEBUFF    DS.W    NUMSCOS

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~

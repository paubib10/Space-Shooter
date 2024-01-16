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

PLRPOSX     DS.W    1                       ; POSICIÓN X DEL JUGADOR (PIXELES)
PLRPOSY     DS.W    1                       ; POSICIÓN Y DEL JUGADOR (PIXELES)
PLRLIFES    DS.B    1                       ; VIDAS DEL JUGADOR
PLRSCORE    DS.W    1                       ; PUNTUACIÓN DEL JUGADOR
PLRDMG      DS.B    1                       ; BIT0: ACTUALIZAR DAÑO, BIT1 MOSTRAR DAÑO
            DS.W    0
            
; --- VARIABLES RELACIONADAS CON EL AUDIO ------------------------------------

AUDACCSN    DS.B    1                       ; ¿ACEPTAR NUEVOS SONIDOS?
            DS.W    0
            
; --- VARIABLES SOBRE LA CUENTA REGRESIVA ------------------------------------

CICLOCR     DS.B    1                       ; NÚMERO DE CICLO PARA LA CUENTA REGRESIVA
NUMACTCR    DS.B    1                       ; NÚMERO ACTUAL A CONTAR
            DS.W    0

; --- VARIABLES DE UTILIDAD --------------------------------------------------

ASTMODE     DS.B    1                        ; MODO ASTEROIDE: 0 -> Ninguno
;                                                              1 -> NORMAL
;                                                              2 -> DIFÍCIL
UTLRNDIX    DS.B    1                       ; SIGUIENTE ÍNDICE PARA NÚMERO ALEATORIO
            DS.W    0
FILEBUFF    DS.W    NUMSCOS

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~

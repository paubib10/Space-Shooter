; =============================================================================
; CONSTANTES DEL SISTEMA
; =============================================================================

; --- CONSTANTES RELACIONADAS CON TRAP ----------------------------------------

KBDTRAP     EQU     0                       ; TRAP DE ACTUALIZACIÓN DEL TECLADO
SCRTRAP     EQU     1                       ; TRAP DE REFRESCO DE PANTALLA

; --- CÓDIGOS DE TECLAS (EASy68K)

KBDCHRSP    EQU     $20                     ; TECLA ESPACIO
KBDCHRMK    EQU     'M'                     ; TECLA M
KBDCHRSH    EQU     $10                     ; TECLA SHIFT
KBDCHRPK    EQU     'P'                     ; TECLA P
KBDCHRLF    EQU     $25                     ; TECLA IZQUIERDA
KBDCHRUP    EQU     $26                     ; TECLA ARRIBA
KBDCHRRT    EQU     $27                     ; TECLA DERECHA
KBDCHRDN    EQU     $28                     ; TECLA ABAJO

; --- MAPEO DEL TECLADO -------------------------------------------------------

KBDLEFT     EQU     KBDCHRLF                ; BOTÓN IZQUIERDO
KBDUP       EQU     KBDCHRUP                ; BOTÓN ARRIBA
KBDRIGHT    EQU     KBDCHRRT                ; BOTÓN DERECHO
KBDDOWN     EQU     KBDCHRDN                ; BOTÓN ABAJO
KBDFIRE1    EQU     KBDCHRSP                ; BOTÓN DISPARO 1
KBDFIRE2    EQU     KBDCHRMK                ; BOTÓN DISPARO 2
KBDFIRE3    EQU     KBDCHRSH                ; BOTÓN DISPARO 3
KBDPAUSE    EQU     KBDCHRPK                ; BOTÓN PAUSA

; --- MÁSCARAS DE CAMPO DE BITS DEL TECLADO -----------------------------------
; CONSTANTES DE CONVENIENCIA PARA ACCEDER AL SIGUIENTE CAMPO DE BITS.
; ESTE CAMPO DE BITS ES UTILIZADO POR LAS VARIABLES DEL SISTEMA (KBDVAL) Y (KBDEDGE).
; +---+---+---+---+---+---+---+---+
; | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
; +---+---+---+---+---+---+---+---+
;   |   |   |   |   |   |   |   |
;   |   |   |   |   |   |   |   +---------- BOTÓN IZQUIERDO
;   |   |   |   |   |   |   +-------------- BOTÓN ARRIBA
;   |   |   |   |   |   +------------------ BOTÓN DERECHO
;   |   |   |   |   +---------------------- BOTÓN ABAJO
;   |   |   |   +-------------------------- BOTÓN DISPARO 1
;   |   |   +------------------------------ BOTÓN DISPARO 2
;   |   +---------------------------------- BOTÓN DISPARO 3
;   +-------------------------------------- BOTÓN PAUSA

KBDMSKLF    EQU     %00000001
KBDMSKUP    EQU     %00000010
KBDMSKRT    EQU     %00000100
KBDMSKDN    EQU     %00001000
KBDMSKF1    EQU     %00010000
KBDMSKF2    EQU     %00100000
KBDMSKF3    EQU     %01000000
KBDMSKPS    EQU     %10000000

; --- POSICIONES DE CAMPO DE BITS DEL TECLADO ---------------------------------

KBDBITLF    EQU     0                       ; POSICIÓN DEL BOTÓN IZQUIERDO
KBDBITUP    EQU     1                       ; POSICIÓN DEL BOTÓN ARRIBA
KBDBITRT    EQU     2                       ; POSICIÓN DEL BOTÓN DERECHO
KBDBITDN    EQU     3                       ; POSICIÓN DEL BOTÓN ABAJO
KBDBITF1    EQU     4                       ; POSICIÓN DEL BOTÓN DISPARO 1
KBDBITF2    EQU     5                       ; POSICIÓN DEL BOTÓN DISPARO 2
KBDBITF3    EQU     6                       ; POSICIÓN DEL BOTÓN DISPARO 3
KBDBITPS    EQU     7                       ; POSICIÓN DEL BOTÓN PAUSA

; --- CONSTANTES RELACIONADAS CON LA PANTALLA ---------------------------------

SCRWIDTH    EQU     640                     ; ANCHO DE LA PANTALLA (PIXELES)
SCRHEIGH    EQU     640                     ; ALTURA DE LA PANTALLA (PIXELES)
SCRIRQ      EQU     1                       ; Nº DE INTERRUPCIÓN DE LA PANTALLA
SCRTIM      EQU     20                      ; TEMPORIZADOR DE LA PANTALLA (MS)

; --- CONSTANTES DE MEMORIA DINÁMICA ------------------------------------------

DMMBSIZE    EQU     64                      ; TAMAÑO BLOQUE(BYTES). 2 ELEVADO X
DMMBNUM     EQU     50                      ; NÚMERO DE BLOQUES
DMMSYSID    EQU     0                       ; ID DEL PROPIETARIO DEL SISTEMA 
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~

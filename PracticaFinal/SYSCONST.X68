; =============================================================================
; CONSTANTES DEL SISTEMA
; =============================================================================

; --- CONSTANTES RELACIONADAS CON TRAP ----------------------------------------

KBDTRAP     EQU     0                       ; TRAP DE ACTUALIZACI�N DEL TECLADO
SCRTRAP     EQU     1                       ; TRAP DE REFRESCO DE PANTALLA

; --- C�DIGOS DE TECLAS (EASy68K)

KBDCHRSP    EQU     $20                     ; TECLA ESPACIO
KBDCHRMK    EQU     'M'                     ; TECLA M
KBDCHRSH    EQU     $10                     ; TECLA SHIFT
KBDCHRPK    EQU     'P'                     ; TECLA P
KBDCHRLF    EQU     $25                     ; TECLA IZQUIERDA
KBDCHRUP    EQU     $26                     ; TECLA ARRIBA
KBDCHRRT    EQU     $27                     ; TECLA DERECHA
KBDCHRDN    EQU     $28                     ; TECLA ABAJO

; --- MAPEO DEL TECLADO -------------------------------------------------------

KBDLEFT     EQU     KBDCHRLF                ; BOT�N IZQUIERDO
KBDUP       EQU     KBDCHRUP                ; BOT�N ARRIBA
KBDRIGHT    EQU     KBDCHRRT                ; BOT�N DERECHO
KBDDOWN     EQU     KBDCHRDN                ; BOT�N ABAJO
KBDFIRE1    EQU     KBDCHRSP                ; BOT�N DISPARO 1
KBDFIRE2    EQU     KBDCHRMK                ; BOT�N DISPARO 2
KBDFIRE3    EQU     KBDCHRSH                ; BOT�N DISPARO 3
KBDPAUSE    EQU     KBDCHRPK                ; BOT�N PAUSA

; --- M�SCARAS DE CAMPO DE BITS DEL TECLADO -----------------------------------
; CONSTANTES DE CONVENIENCIA PARA ACCEDER AL SIGUIENTE CAMPO DE BITS.
; ESTE CAMPO DE BITS ES UTILIZADO POR LAS VARIABLES DEL SISTEMA (KBDVAL) Y (KBDEDGE).
; +---+---+---+---+---+---+---+---+
; | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
; +---+---+---+---+---+---+---+---+
;   |   |   |   |   |   |   |   |
;   |   |   |   |   |   |   |   +---------- BOT�N IZQUIERDO
;   |   |   |   |   |   |   +-------------- BOT�N ARRIBA
;   |   |   |   |   |   +------------------ BOT�N DERECHO
;   |   |   |   |   +---------------------- BOT�N ABAJO
;   |   |   |   +-------------------------- BOT�N DISPARO 1
;   |   |   +------------------------------ BOT�N DISPARO 2
;   |   +---------------------------------- BOT�N DISPARO 3
;   +-------------------------------------- BOT�N PAUSA

KBDMSKLF    EQU     %00000001
KBDMSKUP    EQU     %00000010
KBDMSKRT    EQU     %00000100
KBDMSKDN    EQU     %00001000
KBDMSKF1    EQU     %00010000
KBDMSKF2    EQU     %00100000
KBDMSKF3    EQU     %01000000
KBDMSKPS    EQU     %10000000

; --- POSICIONES DE CAMPO DE BITS DEL TECLADO ---------------------------------

KBDBITLF    EQU     0                       ; POSICI�N DEL BOT�N IZQUIERDO
KBDBITUP    EQU     1                       ; POSICI�N DEL BOT�N ARRIBA
KBDBITRT    EQU     2                       ; POSICI�N DEL BOT�N DERECHO
KBDBITDN    EQU     3                       ; POSICI�N DEL BOT�N ABAJO
KBDBITF1    EQU     4                       ; POSICI�N DEL BOT�N DISPARO 1
KBDBITF2    EQU     5                       ; POSICI�N DEL BOT�N DISPARO 2
KBDBITF3    EQU     6                       ; POSICI�N DEL BOT�N DISPARO 3
KBDBITPS    EQU     7                       ; POSICI�N DEL BOT�N PAUSA

; --- CONSTANTES RELACIONADAS CON LA PANTALLA ---------------------------------

SCRWIDTH    EQU     640                     ; ANCHO DE LA PANTALLA (PIXELES)
SCRHEIGH    EQU     640                     ; ALTURA DE LA PANTALLA (PIXELES)
SCRIRQ      EQU     1                       ; N� DE INTERRUPCI�N DE LA PANTALLA
SCRTIM      EQU     20                      ; TEMPORIZADOR DE LA PANTALLA (MS)

; --- CONSTANTES DE MEMORIA DIN�MICA ------------------------------------------

DMMBSIZE    EQU     64                      ; TAMA�O BLOQUE(BYTES). 2 ELEVADO X
DMMBNUM     EQU     50                      ; N�MERO DE BLOQUES
DMMSYSID    EQU     0                       ; ID DEL PROPIETARIO DEL SISTEMA 
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~

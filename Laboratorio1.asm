;*******************************************************************************
;                                                                              *
;    Filename: Lab1                                                            *
;    Date:            6 feb 208                                                *
;    File Version:                                                             *
;    Author:       Juan Pablo Merck                                            *
;    Company:      uvg                                                         *
;    Description:                                                              *
;    bibliografia:                                                             *
;						       			       *
;*******************************************************************************


; TODO INSERT INCLUDE CODE HERE


; PIC16F887 Configuration Bit Settings

; Assembly source line config statements

#include "p16f887.inc"

; CONFIG1
; __config 0x20D4
 __CONFIG _CONFIG1, _FOSC_INTRC_NOCLKOUT & _WDTE_OFF & _PWRTE_OFF & _MCLRE_OFF & _CP_OFF & _CPD_OFF & _BOREN_OFF & _IESO_OFF & _FCMEN_OFF & _LVP_OFF
; CONFIG2
; __config 0x3FFF
 __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF
 
 ;--------------------------------------------------------------------------------------------------

GPR_VAR        UDATA
	
    CONT1         RES        1      
    CONT2         RES        1     

	RES_VECT  CODE    0x0000            ; processor reset vector
  
;--------------------------------------------------------------------------------------------------  
    GOTO    START                   ; go to beginning of program



MAIN_PROG CODE                      ; let linker place main program
 
 
START
 ;CONFIGURACION PARA EL BOTON QUE TITILA Y CAMBIA DE FRECUENCIA
 ;accediendo al banco 1
    BCF STATUS , RP1	
    BSF STATUS, RP0
	
;config TRISB
    MOVLW b'00000011'
    MOVWF TRISB; RB inputs<1:0> y outputs <7:2>
    
    ;accediendo al banco 0
    BCF STATUS , RP1	
    BCF STATUS, RP0
    ;limpiando PORTB
    CLRF PORTB

    ;accediendo al banco 3
    BSF STATUS , RP1	
    BSF STATUS, RP0
    MOVLW B'00000000'
    MOVWF ANSELH ;colocando como canal digital
    MOVWF ANSEL; colocando como canal digital
    
    ;accediendo al banco 1
    BCF STATUS , RP1	
    BSF STATUS, RP0
    ;config OSCCON
    ;colocando la senial a 4MHz
    BSF OSCCON, IRCF2
    BSF OSCCON, IRCF1
    BCF OSCCON, IRCF0
    ;BCF OSCCON, OSTS;configurando al relejor interno
    BSF OSCCON, SCS;config a oscilador interno
    
    ;---------------------------------------------------------------------------------
    ;CONFIG DEL CONTADOR DESCENDENTE
    ;accediendo al banco 1
    BCF STATUS , RP1	
    BSF STATUS, RP0
    
    ;config TRISD
    MOVLW B'00000000'
    MOVWF TRISD;outputs <7:0>
   
    ;accediendo al banco 0
    BCF STATUS , RP1	
    BCF STATUS, RP0
   
    ;limpiando PORTD
    CLRF PORTD
    

    

        ;accediendo al banco 0
    BCF STATUS , RP1	
    BCF STATUS, RP0
;----------------------------------------------------------------------    
    ;Principal

reinicia:;funcion en la cual servira para que cuando el contador descendente llegue a 0 se reinicie el contador con todas las salidas del puerto D en 1
    MOVLW B'11111111'
    MOVWF PORTD
    
Loop:
    ;---------------------------------------------------------------------
    ;Ejercicio 2: Contador descendente
    BTFSC PORTB,1 ; if(pin1 del puertoB == 0):decremento else():LEDIntermitente
    DECFSZ PORTD,1; resto 1 bit del puerto D comenzando con 11111111-1=11111110
    CALL LEDIntermitente
    GOTO reinicia
    
    

LEDIntermitente:
    ;Ejercicio 1: LED intermintente
    BSF PORTB,2;encendiendo bit 2 del puerto B
    BTFSS PORTB,0 ;if(pin0 del PortB==0)=> Call Frec1. Else => GOTO Frec2; donde Frec1= 2 Frec de encendido y 2 Frec de apagado y Frec2 es 1 Frec de apagado y encendido
    CALL Frec
    CALL Frec
    BCF PORTB,2;encendiendo bit 2 del puerto B
    BTFSS PORTB,0;
    CALL Frec
    CALL Frec
    
    GOTO Loop
Frec:;frecuencia con la que empieza a parpadear el led por default 
    CALL Delay
    RETURN

    ;Funcion para tiempo de espera
Delay:
    MOVLW .100
    MOVWF CONT2
    
    Restar1:
	MOVLW .255
	MOVWF CONT1
    Restar2:
	DECFSZ CONT1, F
	GOTO Restar2
	DECFSZ CONT2, F
	GOTO Restar1
    RETURN
 
 
    END

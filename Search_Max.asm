
;------------------------------------------------------
; EMBEDDED SYSTEMS
; Practical Work #1
;------------------------------------------------------
; This is a source file of the program which finds the
; maximal element from the given array of numbers.
;------------------------------------------------------
; File      :   max.asm
; Author    :   Alexander A. Ivaniuk
; Date      :   10.10.2004
;------------------------------------------------------
#include "p16f84.inc" 

c_adr set 0x30  ; the starting address of the array, a constant
v_ptr equ 0x2F  ; the pointer to the current element in array, a variable
v_min equ 0x2E  ; the maximal number in array, a variable
c_num set 0x4  ; the number of elements in array, a constant 

; The allocation of variables in Data Memory:
; Address   :   The value of object
; 0x2E      :   v_ptr
; 0x2F      :   v_max
; 0x30      :   array[0]
; 0x31      :   array[1]
; 0x32      :   array[2]
; ...................
; 0x39      :   array[9]

BEGIN:
	BCF STATUS, 0x5 ; set Bank0 in Data Memory by clearing RP0 bit in STATUS register
	CLRF v_ptr      ; v_ptr=0
    movlw  c_adr      
    movwf  FSR 
    movf   INDF, W
    movwf  v_min 
LOOP1:
	MOVF v_ptr,0    ; W=v_ptr
	ADDLW c_adr     ; W=W+c_addr
	MOVWF FSR       ; FSR=W, INDF=array[W]
	MOVF INDF,0     ; W=INDF
	SUBWF v_min,0   ; W=W-v_max
	BTFSS STATUS,C  ; If W < 0 then go to SMALL
	GOTO SKIP
			        ; Else W >= 0 then W is bigger than v_max
	MOVF v_ptr,0
	ADDLW c_adr
	MOVWF FSR
	MOVF INDF,0
	MOVWF v_min    ; v_max=array[v_ptr]
	
SKIP:
	INCF v_ptr,0x1  ; v_ptr=v_ptr+1
	MOVLW c_num     ; W=c_num
	SUBWF v_ptr,0   ; W=W-v_ptr
	BTFSS STATUS,0  ; v_ptr > c_num ?
	GOTO LOOP1      ; no
	                ; yes
	CLRF v_ptr      ; v_ptr=0
	CLRF v_min      ; v_max=0
	End

;Mostafa Ashraf - 6907 

org 100h 

.MODEL SMALL
.STACK 100H
.DATA

reader db 'Enter the current temperature:',13,10,'$'
newline db 13,10,'$'
redd db 'The Red led is on','$'
yelloww db 'The yellow led is on','$'
greenn db 'The green led is on','$'

temp dw 0
seconds dw 0
Ten dw 10 
clone dw 0
     
     
     
     
     
     
     
     
.CODE



MAIN PROC
    
    
    MOV AX,@DATA            ;ADDRESS OF STORED DATA
    MOV DS,AX               ;INITIALIZE DATA SEGMENT 
  
    while:  
    CMP clone,00            ;TO KEEP TAKING INPUT FROM USER
	JNE DONE                                                                                                            
    MOV AH,09H              ;the interrupt will act upon number stored in ah
	LEA DX,reader           ;load address of reader into dx
	
	INT 21H                 ;call to get the temperature
	

	                      
	CALL READ
	CMP temp,500
	JAE Red
	CMP temp,200
	JBE  Green
	JMP Yellow
	
	
	Green:
	MOV AH,09H
	LEA DX,greenn
	INT 21H
	JMP shaker
	
	Yellow:  
	MOV AH,09H
	LEA DX,yelloww
	INT 21H
	JMP shaker 
	Red:
	MOV AH,09H
	LEA DX,redd
	INT 21H
	JMP shaker
	
	
	shaker:  
	CALL MINUTE 
	MOV AH,09H
	LEA DX,newline
	INT 21H 
	JMP while
	
	 
	 
	DONE:
ret
MAIN ENDP

	
	
	
	
	
	
	
	
	
	
READ PROC
    MOV temp,0 ; initialize variable by 0
    read_digits:
    
    MOV AH,01H ;To read single character
    INT 21H
    CMP AL,0DH ; check if user pressed input
    JE  DONEx         
    CMP AL,30H ;30 is the ascii code of 0 
    JL  invalid
    CMP AL,39H ;39 is ascii code of 9
    JG  invalid
    SUB AL,30H ;to convert them to integers instead of strings
    MOV AH,00 ;restore ah as it will contain the value stored previously so i restore it before determining number
    MOV BX,AX ;USE BX AS TEMP
    MOV AX,temp;MOV NUM INTO AX
    MUL Ten   ;TO MAKE A DIFFERENCE BETWEEN TENS UNITS THOUSANDS ETC..
    ADD AX,BX ;EX 21
    MOV temp,AX;MOVE CONCATENATED NUMBER
    invalid:
    JMP read_digits
    
    DONEx:
    ret
ENDP
MINUTE PROC
    MOV AX,00
    MOV seconds,AX 
    one:
    CMP seconds,60
    JE donee  
    MOV CX,0FH
	MOV DX,4240H   ;micro seconds in hexa of 1 second
	MOV AH,86H
	INT 15H  
    MOV BX,seconds
    INC BX
    MOV seconds,BX
    JMP one:
    donee:
    ret
ENDP
END MAIN
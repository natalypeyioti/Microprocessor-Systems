DATA_SEG SEGMENT
		TABLE	DB 1024 DUP(?)
		NEW_LINE DB 0AH,0DH,'$'
		
		
DATA_SEG ENDS

CODE_SEG SEGMENT
		ASSUME CS:CODE_SEG, DS:DATA_SEG

MAIN PROC FAR
		MOV AX,DATA_SEG
		MOV DS,AX
		MOV CX,0100H
		MOV BX,0000H
		MOV AL,00FEH
		MOV AH,0000H
		MOV DL,TABLE
		MOV DH,0000H 
	
		ADD BX,DX
ADR1:	MOV [BX],AL
		DEC AL
		ADD BX,0004H
		LOOP ADR1

		MOV CX,0000H
		SUB BX,0004H
		MOV AX,0000H
ADR2:
		ADD BX,DX
		TEST [BX],0001H
		JNZ SKIP_ADD
		ADD AX,[BX]
		INC CX
SKIP_ADD:
		SUB BX,0004H
		JNZ ADR2
		ADD AX,[BX]
		INC CX
		MOV DX,0000H
		DIV CX   
		CALL PRINT_HEX
		PRINT_STR NEW_LINE

MIN_MAX:
        ADD TABLE,1						
		MOV CX,00FFH
		MOV BX,0000H
		MOV DX,0000H
		MOV AX,0000H
       
ADR3:	MOV AL,[TABLE]
        CMP BX,AX
		JG SKIP_MAX
		MOV BX,AX
SKIP_MAX: 
        CMP DX,AX
        JL SKIP_MIN
        MOV DX,AX
SKIP_MIN:        
		SUB TABLE,1
		
		LOOP ADR3
		MOV AX,BX
		CALL PRINT_HEX
		MOV AX,DX
		CALL PRINT_HEX
		EXIT
MAIN 	ENDP

		

PRINT_STR MACRO STRING
		MOV DX, OFFSET STRING 
		MOV AH,9
		INT 21H
ENDM


PRINT MACRO CHAR
		MOV DL, CHAR
		MOV AH, 2
		INT 21H
		ENDM

EXIT MACRO
		MOV AX, 4C00H
		INT 21H
ENDM

PRINT_HEX	PROC NEAR
        PUSH DX
		MOV BL,AL
		AND AL,00F0H
		ROR AL,4
		CMP AL,9
		JG ITS_LET
		ADD AL,30H
		JMP MONADES
ITS_LET:
		ADD AL,37H	
MONADES:
        PRINT AL 
        MOV AL,BL
        AND AL,000FH
		CMP AL,9
		JG ITS_LET2
		ADD AL,30H
		PRINT AL
		JMP TELOS
ITS_LET2:		
		ADD AL,37H
		PRINT AL
TELOS:  
        PRINT ' '
        POP DX
		RET
PRINT_HEX ENDP

CODE_SEG ENDS
		END MAIN
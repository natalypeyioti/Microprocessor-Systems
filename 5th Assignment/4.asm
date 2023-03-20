PRINT MACRO CHAR 
PUSH DX
PUSH AX
MOV DL,CHAR
MOV AH,2
INT 21H
POP AX
POP DX
ENDM

EXIT MACRO 
PUSH AX
MOV AX,4C00H
INT 21H
POP AX
ENDM

READ MACRO 
MOV AH,08H
INT 21H
ENDM

DATA_SEG SEGMENT
TABLE 16 DUP(?)
DATA_SEG ENDS

STACK_SEG SEGMENT 
DB 16 DUP(?)
STACK_SEG ENDS

CODE_SEG SEGMENT
ASSUME CS:CODE_SEG,SS:STACK_SEG ,DS:DATA_SEG
MOV AX,DATA_SEG
MOV DS,AX

MAIN PROC FAR 
LOOP_1:
MOV AL,0DH
PRINT AL
MOV BP,0

NEXT_1: 
READ 
CMP AL,0DH 
JE FINISH
CMP AL,30H 
JL NEXT_1
CMP AL,3AH 
JL NUMORLET
CMP AL,40H
JLE NEXT_1
CMP AL,5BH 
JL NUMORLET
JMP NEXT_1

NUMORLET: 
PRINT AL 
MOV [BP],AL 
INC BP 
CMP BP,16 
JNE NEXT_1 
MOV AL,0AH 
PRINT AL
MOV AL, 0DH
PRINT AL
MOV BP,0 

PRINT_NUMBERS: 
MOV AL,[BP] 
CMP AL,3AH 
JL PRINT_NUM
JMP BACKN
PRINT_NUM: PRINT AL
BACKN:
INC BP 
CMP BP,16
JNE PRINT_NUMBERS
MOV AL,2DH 
PRINT AL
MOV BP,0 

PRINT_LETTERS:
MOV AL,[BP]
ADD AL,20H
CMP AL,60H 
JG PRINT_LET
JMP BACKL
PRINT_LET: PRINT AL
BACKL:
INC BP
CMP BP,16
JNE PRINT_LETTERS
MOV AL,0AH 
PRINT AL
JMP LOOP_1

FINISH:
EXIT

CODE_SEG ENDS 
MAIN ENDP
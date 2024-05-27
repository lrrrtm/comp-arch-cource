MODEL SMALL
.STACK 100H
.386
.DATA
 counter dw 0
 signs dw 0
 stack_memory DB 100 DUP(?)
 string DB "abc*def+18/(g-987)$" 
 vmessage DB " VALIDATION: SUCCESS$", 0
 invmessage DB " VALIDATION: FAILED$", 0
 
.CODE
MAIN PROC
 MOV AX, @DATA
 MOV DS, AX
 MOV DX, OFFSET string
 MOV AH, 09h
 INT 21h
 
 MOV SI, 0
 MOV CX, 0 
 
parse_loop:
 MOV AL, string[SI]
 CMP AL, '$' 
 JE string_end
 
 CMP AL, '('
 JE stack_add
 
 CMP AL, ')' 
 JE stack_del
 
 CMP AL, '1'
 je vnum
 CMP AL, '2'
 je vnum 
 CMP AL, '3'
 je vnum
 CMP AL, '4'
 je vnum
 CMP AL, '5'
 je vnum
 CMP AL, '6'
 je vnum
 CMP AL, '7'
 je vnum
 CMP AL, '8'
 je vnum
 CMP AL, '9'
 je vnum
 CMP AL, '0'
 je vnum
 
 CMP AL, '+'
 je vsym
 CMP AL, '-'
 je vsym
 CMP AL, '='
 je vsym
 CMP AL, '/'
 je vsym
 CMP AL, '*'
 je vsym
 
 CMP AL, 'a'
 jl invchar
 
 CMP AL, 'z'
 jg invchar 
 
 CMP AL, 'a'
 jg vletter
 
 INC SI 
 JMP parse_loop
 
vnum:
 mov signs, 0
 mov counter, 0
 INC SI 
 JMP parse_loop
 
vsym:
 mov counter, 0
 inc signs
 cmp signs, 2
 je invchar
 INC SI
 jmp parse_loop

vletter:
 mov signs, 0
 inc counter
 cmp counter, 5
 jg invchar
 inc si
 jmp parse_loop
 
vchar:
 mov signs, 0
 INC SI
 JMP parse_loop
 
invchar:
 MOV DX, OFFSET invmessage
 MOV AH, 09h
 INT 21H
 JMP program_end
 
stack_add:
 mov signs, 0
 mov counter, 0
 MOV AH, AL
 MOV BX, OFFSET stack_memory
 ADD BX, CX
 MOV [BX], AH 
 INC CX 
 INC SI 
 JMP parse_loop
 
stack_del:
 mov signs, 0
 mov counter, 0
 DEC CX 
 CMP CX, -1 
 JL invparenthesis
 
 MOV BX, OFFSET stack_memory
 ADD BX, CX
 MOV AL, [BX] 
 CMP AL, '(' 
 JNE invparenthesis
 
 INC SI 
 JMP parse_loop
 
string_end:
 CMP CX, 0 
 JNE invparenthesis
 
 MOV DX, OFFSET vmessage
 MOV AH, 09h
 INT 21h
 JMP program_end
 
invparenthesis:
 MOV DX, OFFSET invmessage
 MOV AH, 09h
 INT 21h
 jmp program_end
 
program_end:
 MOV AH, 4Ch
 INT 21h
 
MAIN ENDP
END MAIN

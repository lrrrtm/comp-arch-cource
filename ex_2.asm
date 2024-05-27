.MODEL SMALL
.STACK 100H
.DATA
counter dw 1
.CODE

start:
 mov ax, @data
 mov ds, ax
 mov ax, 3508h
 int 21h
 
 cli
 mov ax,es
 mov ds,ax
 mov dx,bx
 mov ax,2560h
 int 21h
 
 mov ax,seg myhandler
 mov ds,ax 
 mov dx,offset myhandler
 mov ax,2508h
 int 21h
 sti
 
 mov ah,00h
 int 16h
 jmp exit
 
myhandler:
 push ax
 push dx
 push bx
 xor dx, dx
 mov ax, counter
 inc ax
 mov counter, ax
 mov bx, 18
 div bx
 test dx, dx
 jnz passclock
 
 mov ah, 02h
 mov dl, 'O'
 int 21h
 mov dl, 10
 int 21h
 mov dl, 13
 int 21h
 
 passclock:
 int 60h
 pop bx
 pop dx
 pop ax
 iret
 
exit:
 mov ah, 4Ch
 int 21h
end start

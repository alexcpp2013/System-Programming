.model     small      
.stack     100h             
.data

mes db 'Строка$'

.code

mov ax, @data
mov ds, ax
xor ax, ax

start:

MOV AH, 02H
MOV DL, 0
MOV DH, 10		
INT 10H

mov ah,09h
mov al,' '
mov bh,0
mov bl,00h
mov cx,80
int 10h

MOV AH, 02H
MOV DL, 0
MOV DH, 10		
INT 10H

mov ah, 09h
lea dx, mes
int 21h

mov ax, 4c00h
int 21h

end start





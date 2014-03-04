  IDEAL
  MODEL small
  STACK 256
  value	=	528
  DATASEG
  exCode	DB	0
  b_x	DB	1,2,4
  w_x	DW	8,16,32,64
  Label	b_var	byte
  w_var	DW	1234h
  CODESEG
  Start:	mov ax,@data	;Установка в ds адреси
  	mov ds,ax	;сегмента даних.
  ;Безпосередня адресац?я.
  	mov al,255	;255=0FFh-беззнакове число
  	mov ah,-1	;[4]	;-1=0FFh-негативне число
  	mov ax,value/5+20	;[5]	;Завантаження в ах константного виразу
  	mov bx,OFFSET w_x	;[6]	;Адреса зм?нної w_x в bx, bx=0004h
  ;Рег?строва ? пряма адресац?ї.
  	mov dl,al	;[7]
  	mov al,[b_x]		;al=b_x[0]=01h.
  	mov dx,[w_x]	;dx=w_x[0]=0008h.
  	mov si,[w_var]	;si=1234h
  	mov al,[b_var]	;al=[Low w_var]=[b_var]=34h
  	mov ah,[b_var+1]	;ah=[High w_var]=[b_var+1]=12h
  ;Непряма рег?строва.
  	mov cx,[bx]	;[13]	;cx=w_x[0]=0008h.
  	mov [word bx],-2	;[14]	;w_x[0]=-2=0FFFEh.
  ;Базова адресац?я.
  	mov ax,[bx+2]	;[15]	;ax=w_x[1]=16=0010h.
  	mov [word bx+2],24	;[16]	;w_x[1]=24=0018h.
  ;?ндексна адресац?я.
  	mov si,1
  	mov al,[si+b_x]	;[18]		;al=b_x[1]=2=02h.
  ;Базово ?ндексна адресац?я.
  	inc si
  	mov bx,2
  	mov ax,[bx+si+w_x]	;[21]	;ax=w_x[2]=32=0020h.
  	mov [word bx+si+w_x],128    	;[22]	;w_x[2]=128=0080h.
  ;Застосування команди lea.
  	lea bx,[w_x+si]             		;[23]	;bx=OFFSET w_x+si=OFFSET w_x[1]=0006h.
  ;Команди push ? pop.
  	push bx	;Зберегти bx ? si
  	push si	;в стец?.
  	mov bx,10h	;Установити текстов? 
  	mov si,20h	;значення.
  	pop si	;В?дновити з? стека
  	pop bx	;збережен? значення.
  Exit:	mov ah,04Ch	;Функц?я DOS- вих?д з програми.
  	mov al,[exCode]	;Повернення коду помилки.
  	int 21h	;Виклик DOS. Останов
  	END Start	;К?нець програми/точка входу.


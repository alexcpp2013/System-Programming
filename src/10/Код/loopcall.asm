  IDEAL
  MODEL small
  STACK 256
  DATASEG
  exCode	DB	0
  Array	DB	20,25,30,35,40
  LengArray	=	$-Array	;довжина рядка
  CODESEG
  Start:	mov ax,@data	;Установка в ds адреси сегмента
  mov ds,ax		;даних.
  mov si,OFFSET Array
  mov cx,LengArray
  L1:	mov al,[si]	;al?поточний елемент рядка.
  call Divide	;[6]		;Виконання процедури д?лення.
  mov [si],al
  inc si	
  loop L1	;[9]		;Повторити сх раз
  Exit:	mov ah,04Ch	;Функц?я DOS ?вих?д з програми.
  mov al,[exCode]	;Повернення коду помилки.
  int 21h		;Виклик DOS. Останов.
  ;П?дпрограми д?лення Divide на 5.
  ;Вх?д: al-значення, призначене для д?лення.
  ;Вих?д: al-результат д?лення.
  PROC	Divide NEAR	;Оператор NEAR можна не вказувати, так як 
  		;модель пам?ят? 
  push bx	; Small припуськає вс? переходи близькими.
  xor ah,ah	;П?дготовка ah:al як 16-б?тне 
  mov bl,5	;д?лене, а bl- 8-б?тний д?льник.
  div bl	;al<-частка, ah<-залишок.
  pop bx
  ret	;[18]	;Повернення з процедури
  ENDP	Divide
  	END Start	;К?нець програми/точка входу.
  

8


1



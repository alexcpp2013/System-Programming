  IDEAL
  MODEL small
  STACK 256
  DATASEG
  ExCode	DB	0
  Promt	DB	'Це час пiсля полудня? (Так/Нi - y/n)'
  GoodMorning	DB	13,10,'Доброго ранку!',13,10,'$'
  GoodAfternoon	DB	13,10,'Здрастуйте!',13,10,'$'
  	CODESEG
  Start	mov ax,@data	;Установка в ds адреси сегмента
  	mov ds,ax	;даних
  	mov dx,OFFSET Promt 	;Повiдомлення-запит
  	move ah,9	;Функцiя DOS виводу повiдомлення
  	int 21h	;на екран
  	mov ah,1	;Функцiя DOS ввода символа з
  	int 21h	;клав?атури
  	cmp al,'y'	;y?
  	jz IsAfternoon	;так, час пiсля полудня
  	cmp al,'n'	;n?
  	jz IsMorning	;нi, до полудня
  IsAfternoon:	mov dx,OFFSET GoodAfternoon 	;Вказiвка на "Здрастуйте"
  	jmp SHORT Disp
  IsMorning:	mov dx,OFFSET GoodMorning 	;Вказiвка на "Доброго ранку"
  1Disp:	mov ah,9	;Функцiя DOS виводу повiдомлення на
  	int 21h	;екран
  Exit:	mov ah,4ch	;Функцiя DOS- вихiд з програми
  	mov al,ExCode	;Повернення коду помилки
  	int 21h	;Виклик DOS. Останов програми.
  	END Start	;Кiнець програми/точка входу


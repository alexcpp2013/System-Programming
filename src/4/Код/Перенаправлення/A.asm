  IDEAL
  MODEL small
  STACK 256
  ;Макровизначення
  descrip_in	=	0	;Дескриптор стандартного вводу
  descrip_out	=	1	;Дескриптор стандартного виводу
  descrip_err	=	2	;Дескриптор стандартної помилки 
  			;(екрана)
  DATASEG
  exCode	DB	0
  msg	Db	'Введiть рядок!'
  msg_len	=	$-msg
  Buf	DB	80 DUP(?)
  actual_len	DW	?
  CODESEG
  Start:	mov ax,@data	;Встановка в ds адреси
  	mov ds,ax	;сегмента даних
  ;Вив?д службового пов?домлення msg
  	mov ah,40h	;функц?я виводу
  mov bx,descrip_err
  mov cx,msg_len	;Довжина пов?домлення
  mov dx,offset msg	;Адреса пов?домлення
  int 21h
  ;Ввод рядка з клав?атури в буфер Buf
  mov ah,3fh	;функция вводу
  mov bx,descrip_in
  mov cx,80	;Ввод максимум 80 байт
  mov dx,offset Buf	;Адреса буфера
  int 21h
  mov [actual_len],ax	;Фактично введено
  ;Перетворення рядкових латинских л?тер в прописн?
  mov cx,[actual_len]	;Л?чильник елемент?в рядка
  mov  si,0	;?н?ц?ал?зац?я  показчика  елемент?в рядка
  filter:	mov al,[Buf+si]	;В?зьмемо символ
  cmp al,'a'	;Меньше 'a'?
  jb no_letter	;Так, не перетворювати
  cmp al,'z'	;Б?льше 'z'?
  ja no_letter	;Так, не перетворювати
  sub al,20h	;Перетворюємо в прописну
  mov[Buf+si],al	;В?дправимо в Buf
  no_letter:	inc si
  loop filter	;Цикл
  ;Вив?д на екран
  mov ah,40h	;Функц?я виводу
  mov bx,descrip_out
  mov cx,[actual_len]	;Довжина пов?домлення
  mov dx,offset Buf	;Адреса пов?домлення
  int 21h
  Exit:	mov ah,04Ch	;Функц?я DOS 4Сh: вих?д з програми
  mov al,[exCode]	;Повернення коду помилки
  int 21h	;Виклик DOS. Зупинка
  END Start	;К?нець програми/точка входу


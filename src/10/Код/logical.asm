  IDEAL
  MODEL small
  STACK 256
  DATASEG
  exCode	DB	0
  source	DW	0ABh
  w_mask	DW	0F0h
  oper	DB	0AAh	;176
  	CODESEG
  Start:	mov ax,@data	;Установка в ds адреси сегмента
  mov ds,ax		;даних.
  mov ax,[source]	;Занести в ax,bx,cx, [source]=0ABh
  mov bx,ax
  mov cx,ax
  and ax,[w_mask]	;[6]	;Стирання в?дпов?дних б?т?в
  or bx,[w_mask]	;[7]	;Установка в?дпов?дних б?т?в в "1"
  xor cx,[w_mask]	;?нвертування в?дпов?дних б?т?в
  xor bx,bx		;bx=0. Погашення рег?стра
  ;Цикл?чн? зсуви.
  rol [oper],1	;[10]	;[oper]=55, cf=1.
  ror [oper],1	;[oper]=AA, cf=1.
  rcl [oper],1	;[12]	;[oper]=55, cf=1.
  rcr [oper],1	;[oper]=AA, cf=1.
  ;Швидке д?лення зсувом додатн?х чисел.
  mov al,0Eh	;Швидке д?лення al методом зсуву.
  sar al,1	;[15]	;al=07 ,cf=0,
  sar al,1	;al=03 ,cf=1,
  sar al,1	;al=01 ,cf=1,
  sar al,1	;al=00 ,cf=1.
  ;Швидке множення зсувом додатн?х чисел: A=10*x=(4+1)*2*x, x=al.
  mov al,2	;Множення al зсувом.
  mov bl,al
  sal al,1	;[21]	;*2,
  shl al,1	;*4,
  add al,bl	;*(4+1),
  shl al,1	;*10,al=10*x=20=14h.
  Exit:	mov ah,04Ch	;Функц?я DOS ?вих?д з програми.
  	mov al,[exCode]	;Повернення коду помилки.
  	int 21h	;Виклик DOS. Останов.
  	END Start	;К?нець програми/точка входу.


  IDEAL
  MODEL small
  STACK 256
  DATASEG
  exCode	DB	0
  source	DW	0ABh
  w_mask	DW	0F0h
  oper	DB	0AAh	;176
  	CODESEG
  Start:	mov ax,@data	;��⠭���� � ds ���� ᥣ����
  mov ds,ax		;�����.
  mov ax,[source]	;������ � ax,bx,cx, [source]=0ABh
  mov bx,ax
  mov cx,ax
  and ax,[w_mask]	;[6]	;��࠭�� �?����?���� �?�?�
  or bx,[w_mask]	;[7]	;��⠭���� �?����?���� �?�?� � "1"
  xor cx,[w_mask]	;?�����㢠��� �?����?���� �?�?�
  xor bx,bx		;bx=0. ����襭�� ॣ?���
  ;����?�? ��㢨.
  rol [oper],1	;[10]	;[oper]=55, cf=1.
  ror [oper],1	;[oper]=AA, cf=1.
  rcl [oper],1	;[12]	;[oper]=55, cf=1.
  rcr [oper],1	;[oper]=AA, cf=1.
  ;������ �?����� ��㢮� �����?� �ᥫ.
  mov al,0Eh	;������ �?����� al ��⮤�� ����.
  sar al,1	;[15]	;al=07 ,cf=0,
  sar al,1	;al=03 ,cf=1,
  sar al,1	;al=01 ,cf=1,
  sar al,1	;al=00 ,cf=1.
  ;������ �������� ��㢮� �����?� �ᥫ: A=10*x=(4+1)*2*x, x=al.
  mov al,2	;�������� al ��㢮�.
  mov bl,al
  sal al,1	;[21]	;*2,
  shl al,1	;*4,
  add al,bl	;*(4+1),
  shl al,1	;*10,al=10*x=20=14h.
  Exit:	mov ah,04Ch	;�㭪�?� DOS ?���?� � �ணࠬ�.
  	mov al,[exCode]	;����୥��� ���� �������.
  	int 21h	;������ DOS. ��⠭��.
  	END Start	;�?���� �ணࠬ�/�窠 �室�.


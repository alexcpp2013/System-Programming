  IDEAL
  MODEL small
  STACK 256
  DATASEG
  exCode	DB	0
  Array	DB	20,25,30,35,40
  LengArray	=	$-Array	;������� �浪�
  CODESEG
  Start:	mov ax,@data	;��⠭���� � ds ���� ᥣ����
  mov ds,ax		;�����.
  mov si,OFFSET Array
  mov cx,LengArray
  L1:	mov al,[si]	;al?���筨� ������� �浪�.
  call Divide	;[6]		;��������� ��楤�� �?�����.
  mov [si],al
  inc si	
  loop L1	;[9]		;������ �� ࠧ
  Exit:	mov ah,04Ch	;�㭪�?� DOS ?���?� � �ணࠬ�.
  mov al,[exCode]	;����୥��� ���� �������.
  int 21h		;������ DOS. ��⠭��.
  ;�?��ணࠬ� �?����� Divide �� 5.
  ;��?�: al-���祭��, �ਧ��祭� ��� �?�����.
  ;���?�: al-१���� �?�����.
  PROC	Divide NEAR	;������ NEAR ����� �� ����㢠�, ⠪ � 
  		;������ ���?��? 
  push bx	; Small �ਯ��쪠� ��? ���室� ����쪨��.
  xor ah,ah	;�?���⮢�� ah:al � 16-�?⭥ 
  mov bl,5	;�?����, � bl- 8-�?⭨� �?�쭨�.
  div bl	;al<-��⪠, ah<-����讪.
  pop bx
  ret	;[18]	;����୥��� � ��楤��
  ENDP	Divide
  	END Start	;�?���� �ணࠬ�/�窠 �室�.
  

8


1



  IDEAL
  MODEL small
  STACK 256
  DATASEG
  ExCode	DB	0
  Promt	DB	'�� �� �i�� ���㤭�? (���/�i - y/n)'
  GoodMorning	DB	13,10,'���ண� ࠭��!',13,10,'$'
  GoodAfternoon	DB	13,10,'�������!',13,10,'$'
  	CODESEG
  Start	mov ax,@data	;��⠭���� � ds ���� ᥣ����
  	mov ds,ax	;�����
  	mov dx,OFFSET Promt 	;���i��������-�����
  	move ah,9	;�㭪�i� DOS ������ ���i��������
  	int 21h	;�� ��࠭
  	mov ah,1	;�㭪�i� DOS ����� ᨬ���� �
  	int 21h	;����?����
  	cmp al,'y'	;y?
  	jz IsAfternoon	;⠪, �� �i�� ���㤭�
  	cmp al,'n'	;n?
  	jz IsMorning	;�i, �� ���㤭�
  IsAfternoon:	mov dx,OFFSET GoodAfternoon 	;����i��� �� "�������"
  	jmp SHORT Disp
  IsMorning:	mov dx,OFFSET GoodMorning 	;����i��� �� "���ண� ࠭��"
  1Disp:	mov ah,9	;�㭪�i� DOS ������ ���i�������� ��
  	int 21h	;��࠭
  Exit:	mov ah,4ch	;�㭪�i� DOS- ���i� � �ணࠬ�
  	mov al,ExCode	;����୥��� ���� �������
  	int 21h	;������ DOS. ��⠭�� �ணࠬ�.
  	END Start	;�i���� �ணࠬ�/�窠 �室�


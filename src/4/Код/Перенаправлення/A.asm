  IDEAL
  MODEL small
  STACK 256
  ;���஢����祭��
  descrip_in	=	0	;���ਯ�� �⠭���⭮�� �����
  descrip_out	=	1	;���ਯ�� �⠭���⭮�� ������
  descrip_err	=	2	;���ਯ�� �⠭���⭮� ������� 
  			;(��࠭�)
  DATASEG
  exCode	DB	0
  msg	Db	'����i�� �冷�!'
  msg_len	=	$-msg
  Buf	DB	80 DUP(?)
  actual_len	DW	?
  CODESEG
  Start:	mov ax,@data	;��⠭���� � ds ����
  	mov ds,ax	;ᥣ���� �����
  ;���?� �㦡����� ���?�������� msg
  	mov ah,40h	;�㭪�?� ������
  mov bx,descrip_err
  mov cx,msg_len	;������� ���?��������
  mov dx,offset msg	;���� ���?��������
  int 21h
  ;���� �浪� � ����?���� � ���� Buf
  mov ah,3fh	;�㭪�� �����
  mov bx,descrip_in
  mov cx,80	;���� ���ᨬ� 80 ����
  mov dx,offset Buf	;���� ����
  int 21h
  mov [actual_len],ax	;����筮 �������
  ;���⢮७�� �浪���� ��⨭᪨� �?�� � �ய��?
  mov cx,[actual_len]	;�?稫쭨� �������?� �浪�
  mov  si,0	;?�?�?��?���?�  �����稪�  �������?� �浪�
  filter:	mov al,[Buf+si]	;�?�쬥�� ᨬ���
  cmp al,'a'	;����� 'a'?
  jb no_letter	;���, �� ���⢮��
  cmp al,'z'	;�?��� 'z'?
  ja no_letter	;���, �� ���⢮��
  sub al,20h	;���⢮��� � �ய���
  mov[Buf+si],al	;�?��ࠢ��� � Buf
  no_letter:	inc si
  loop filter	;����
  ;���?� �� ��࠭
  mov ah,40h	;�㭪�?� ������
  mov bx,descrip_out
  mov cx,[actual_len]	;������� ���?��������
  mov dx,offset Buf	;���� ���?��������
  int 21h
  Exit:	mov ah,04Ch	;�㭪�?� DOS 4�h: ���?� � �ணࠬ�
  mov al,[exCode]	;����୥��� ���� �������
  int 21h	;������ DOS. �㯨���
  END Start	;�?���� �ணࠬ�/�窠 �室�


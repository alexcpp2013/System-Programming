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
  Start:	mov ax,@data	;��⠭���� � ds ����
  	mov ds,ax	;ᥣ���� �����.
  ;������।�� �����?�.
  	mov al,255	;255=0FFh-���������� �᫮
  	mov ah,-1	;[4]	;-1=0FFh-����⨢�� �᫮
  	mov ax,value/5+20	;[5]	;�����⠦���� � �� ����⠭⭮�� ��ࠧ�
  	mov bx,OFFSET w_x	;[6]	;���� ��?���� w_x � bx, bx=0004h
  ;���?��஢� ? ��ﬠ �����?�.
  	mov dl,al	;[7]
  	mov al,[b_x]		;al=b_x[0]=01h.
  	mov dx,[w_x]	;dx=w_x[0]=0008h.
  	mov si,[w_var]	;si=1234h
  	mov al,[b_var]	;al=[Low w_var]=[b_var]=34h
  	mov ah,[b_var+1]	;ah=[High w_var]=[b_var+1]=12h
  ;����ﬠ ॣ?��஢�.
  	mov cx,[bx]	;[13]	;cx=w_x[0]=0008h.
  	mov [word bx],-2	;[14]	;w_x[0]=-2=0FFFEh.
  ;������ �����?�.
  	mov ax,[bx+2]	;[15]	;ax=w_x[1]=16=0010h.
  	mov [word bx+2],24	;[16]	;w_x[1]=24=0018h.
  ;?����᭠ �����?�.
  	mov si,1
  	mov al,[si+b_x]	;[18]		;al=b_x[1]=2=02h.
  ;������ ?����᭠ �����?�.
  	inc si
  	mov bx,2
  	mov ax,[bx+si+w_x]	;[21]	;ax=w_x[2]=32=0020h.
  	mov [word bx+si+w_x],128    	;[22]	;w_x[2]=128=0080h.
  ;�����㢠��� ������� lea.
  	lea bx,[w_x+si]             		;[23]	;bx=OFFSET w_x+si=OFFSET w_x[1]=0006h.
  ;������� push ? pop.
  	push bx	;���ॣ� bx ? si
  	push si	;� ���?.
  	mov bx,10h	;��⠭���� ⥪�⮢? 
  	mov si,20h	;���祭��.
  	pop si	;�?������ �? �⥪�
  	pop bx	;���०��? ���祭��.
  Exit:	mov ah,04Ch	;�㭪�?� DOS- ���?� � �ணࠬ�.
  	mov al,[exCode]	;����୥��� ���� �������.
  	int 21h	;������ DOS. ��⠭��
  	END Start	;�?���� �ணࠬ�/�窠 �室�.


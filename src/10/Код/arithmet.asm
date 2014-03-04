  IDEAL
  MODEL small
  STACK 256
  	DATASEG
  exCode	DB	0
  op_1	DD	11112222h
  op_2	DD	3333DDDEh
  b_dst	DB	32	;20h
  b_src	DB	64	;40h
  w_src	DW	512	;200h
  	CODESEG
  Start:	mov ax,@data	;��⠭���� � ds ����
  	mov ds,ax	;ᥣ���� �����.
  ;��������� ���࠭�?� � ����?���� �?�.
  	mov di,OFFSET op_1
  mov si,OFFSET op_2
  mov ax,[di]		;Low(op_1)?ax.
  add ax,[si]		;[6]	;Low(op_1)+Low(op_2)=Low(sum).
  mov [di],ax		;���०���� Low(sum).
  mov ax,[di+2]	;High(op_1)?ax.
  adc ax,[si+2]	;[9]	;High(op_1)+High(op_2)+cf=High(sum).
  mov [di+2],ax	;���०���� High(sum).
  ;�������� ? �?�����.
  	mov al,[b_dst]	;al=32=20h.
  	Push ax ;al
  mul [b_src]	;[13]	;ax ?al*[b_src]=800h ? ���������� �������� � �ଠ�? "8*8=16"
  neg [b_src]	;[14]	;[b_src]?0-[b_src]
  pop  ax;al
  imul [b_src]	;[16]	;ax ?al*[b_src] ? ������� �������� � �ଠ�? "8*8=16"
  idiv [b_src]	;[17]          ;{al= Quot (ax/[b_src]), ah=Rem (ax/[b_src])} ? ������� �?����� "16:8=8"
  cbw	;al?ax (�? ������). � ������ ������� ax?0
  mul [w_src]	;[19 ]	;dx.ax?ax?[w_src] ? ���������� �������� � �ଠ�? "16*16=32"
  push dx
  push ax
  idiv [w_src]	;[22 ]	;{ax?Quot (dx.ax/w_src), dx?Rem (dx.ax/w_src)} ? ������� 
  ;�?����� � �ଠ�? "32:16=16". ��� � ���࠭�� �����?, � ������?筨� १���� �㤥 
  ;��ਬ���� ? � ��������� ������� div
  pop ax;popax
  pop dx;popdx
  div [w_src]	;[25]       ;{ax?Quot (dx.ax/w_src), dx?Rem (dx.ax/w_src)} ? ���������� �?�����
  Exit:	mov ah,04Ch	;�㭪�?� DOS ?���?� � �ணࠬ�.
  	mov al,[exCode]	;����୥��� ���� �������.
  	int 21h	;������ DOS. ��⠭��.
  	END Start	;�?���� �ணࠬ�/�窠 �室�.


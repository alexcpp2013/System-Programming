#include<dos.h>
#include<stdio.h>
#include<conio.h>


char *Buf;
int BufSize;
int inz;

int main(){
	clrscr();
	asm{
		mov ax,0x00
		int 0x33
		mov inz,ax
	}
	if(inz==0){
		printf("���� �� ��������.");
		return 0;
	}
	else{
		printf("I�i�i��i���i� �ன諠 �����.\n");
		asm{
			mov ax, 0x0015
			int 0x33
			mov BufSize, bx
		}
		Buf = new char[BufSize];
		asm{

			mov ax, 0x016
			mov bx, offset Buf
			mov dx, SEG Buf
			mov es, dx
			int 0x33
		}
		printf("��i�� ����: %s", Buf);
		printf("\n�⠭ �ࠩ���� ���i ���०���.");


	}
getch();
return 0;
}
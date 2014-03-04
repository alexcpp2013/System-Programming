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
		printf("Мишь не знайдена.");
		return 0;
	}
	else{
		printf("Iнiцiалiзацiя пройшла вдало.\n");
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
		printf("Вмiст буфера: %s", Buf);
		printf("\nСтан драйверу мишi збережено.");


	}
getch();
return 0;
}
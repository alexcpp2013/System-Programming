#include <dos.h>
#include <stdio.h>
#include <conio.h>

int rnd_get(void) {
	int i;
	outp(0x43, 0x86);
	i = inp(0x42);
	i = (inp(0x42) << 8) + i;
return(i);
}
void rnd_set(int bound) {
	outp(0x43, 0xb6);
	outp(0x42, bound & 0x00ff);
	outp(0x42, (bound &0xff00) >> 8);
	outp(0x61, inp(0x61) | 1);
}
int First, Second, Difference;
void main(void) {
	clrscr();
	rnd_set(100);
	First=rnd_get();
	printf("Перше число= %i\n",First);
	Second=rnd_get();
	printf("Друге число= %i\n",Second);
	Difference=First-Second;
	printf("Рiзниця= %i",Difference);
getch();
}

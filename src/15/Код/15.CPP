#include <dos.h>
#include <stdio.h>
#include<stdlib.h>
#include<conio.h>

int Month, Hour;

int main(void)
{
	clrscr();

	struct date d;
	struct  time t;

	getdate(&d);
	printf("���筨� �i�: %d\n", d.da_year);
	printf("���筨� �i����: %d\n", d.da_mon);
	printf("���筨� ����: %d\n", d.da_day);
	gettime(&t);
	printf("���筨� ��: %2d:%02d:%02d\n",
	t.ti_hour, t.ti_min, t.ti_sec);

	Month=d.da_mon;
	printf("\n\n\n");
	if((Month==12)||(Month==1)||(Month==2)) printf("����.");
	if((Month>=3)&&(Month<=5)) printf("��᭠.");
	if((Month>=6)&&(Month<=8)) printf("�i�.");
	if((Month>=9)&&(Month<=11)) printf("��i��.");

	Hour=t.ti_hour;
	printf("\n\n");
	if((Hour>=6)&&(Hour<12)) printf("���ண� ࠭��!\n");
	if((Hour>=12)&&(Hour<18)) printf("���ண� ���!\n");
	if((Hour==18)||(Hour==19)||(Hour==20)||(Hour==21)||(Hour==22)||(Hour==23)) printf("���ண� ����!\n");
	if((Hour>=0)&&(Hour<6)) printf("����� ���i!\n");

getch();
return 0;
}
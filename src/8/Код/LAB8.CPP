#include<stdio.h>
#include<math.h>
#include<dav.h>
#include<conio.h>

float a,b,c,t,t1,t2,t3,t4,t5,k;

void main (){
	clrscr();
	printf("\n����i�� ���i ��� ஧��㭪� ��ࠧ�: (b*a+c/2)/(c-tg(b+1))");
	printf("\na = ");
	scanf("%f",&a);
	printf("\nb = ");
	scanf("%f",&b);
	printf("\nc = ");
	scanf("%f",&c);
	t=b*a;
	k=c/2;
	t4=t+k;
	t1=sin(b+1);
	t2=cos(b+1);



	if(t2==0) printf("\n�������⨬i ���祭�� ��㬥��� ��� ⠭�����");
	else{
		t3=(t1/t2);
		t5=c-t3;
		if(t5==0) printf("\n�������: �i����� �� 0");
		else{
			printf("\n���祭�� �㭪�i� ��஢�i� = %f",function1(t4,t5));
			}
	}
getch();
}

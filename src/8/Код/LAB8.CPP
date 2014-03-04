#include<stdio.h>
#include<math.h>
#include<dav.h>
#include<conio.h>

float a,b,c,t,t1,t2,t3,t4,t5,k;

void main (){
	clrscr();
	printf("\nВведiть данi для розрахунку виразу: (b*a+c/2)/(c-tg(b+1))");
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



	if(t2==0) printf("\nНедопустимi значення аргументу для тангенсу");
	else{
		t3=(t1/t2);
		t5=c-t3;
		if(t5==0) printf("\nПомилка: дiлення на 0");
		else{
			printf("\nЗначення функцiї доровнiє = %f",function1(t4,t5));
			}
	}
getch();
}

#include <stdio.h>
#include <conio.h>
#include <math.h>

double t,k,r,y,x;
float step;
int i;

void main()
{
 
	clrscr();
	printf("\n ��i�i�� �ப ");
	scanf("%f", &step);
	clrscr();
	printf("\n ���i� 㭪�i� \n y=sin((x*x*x)^2*x)*10^(x/(2^(1/2)))-1 \n � �ப�� %f - �� �i��i��� \n �i� 1.3 �� 1.45, - ���⮪ ",step);
	for(x=1.3, i=1; x<=1.45; x+=step, i++)
	{
		t=x*x*x;
		k=sin(pow(t,2*x));
		r=pow(10,x/sqrt(2));
		y=k*r-1;
        	printf("\n %d) y (%f) =%f",i, x, y );
    	}
	printf("\n ���i� �㭪�i� ���i�祭�");
    	printf("\n ");


getch();
}

#include <stdio.h>
#include <conio.h>
#include <math.h>

double t,k,r,y,x;
float step;
int i;

void main()
{
 
	clrscr();
	printf("\n Ввiдiть крок ");
	scanf("%f", &step);
	clrscr();
	printf("\n Вивiд ункцiї \n y=sin((x*x*x)^2*x)*10^(x/(2^(1/2)))-1 \n з кроком %f - на вiдрiзку \n вiд 1.3 до 1.45, - початок ",step);
	for(x=1.3, i=1; x<=1.45; x+=step, i++)
	{
		t=x*x*x;
		k=sin(pow(t,2*x));
		r=pow(10,x/sqrt(2));
		y=k*r-1;
        	printf("\n %d) y (%f) =%f",i, x, y );
    	}
	printf("\n Вивiд функцiї закiнчено");
    	printf("\n ");


getch();
}

#include <math.h>
#include <stdio.h>
#include <conio.h>

char Code,  Operation;
int Number1, Number2, Result,k;


void main()
{
	
	do{
		clrscr();
		printf("\n����i�� ���� �᫮ � �i�i����i� ��⥬i �᫥���: ");
		k=scanf("%o",&Number1);
		if(k==0){printf("\n���� �᫮ �� � ���쬨�筨�.");
		getch();
		break;}

		printf("\n����i�� ��㣥 �᫮ � �i�i����i� ��⥬i �᫥���: ");
		k=scanf("%o",&Number2);
		if(k==0){printf("\n���� �᫮ �� � ���쬨�筨�.");
		getch();
		break;}


		while(1){

				printf("\n����i�� �����i� ( / , + , - ,NE): ");

				Operation = getch();

				putch(Operation);
				if(Operation == '+' || Operation == '-' || Operation == '/' ||  Operation == 'N' ){

				switch( Operation){
				case '+': {
				  Result=Number1 + Number2;
				  printf("\n\n�i����i�� � �i�⭠���⪮�i� = %x\n", Result);
				  break;
				}
				case '-': {
				  Result=Number1 - Number2;
				  printf("\n\n�i����i�� � �i�⭠���⪮�i� = %x\n", Result);
				  break;
				}
				case '/': {
				if(Number2==0){ printf("\n\n�������, �i����� �� ����, ��㣥 �᫮ ���i���� ���.\n");
				  break;} else{
				  Result=Number1 / Number2;

				  printf("\n\n�i����i�� � �i�⭠���⪮�i� = %x\n", Result);
				  break;
						}
				}
				case 'N':{
				if(Number1!=Number2)printf("\n\ntrue\n");
				if(Number1==Number2)printf("\n\nfalse\n");
				}

			}
			printf("\n(R)���� ᯮ���,(Enter)���i �����i�, (E)���i�.\n");
			Code = getch();
			if(Code == 'r' || Code == 'R'||
			   Code == 'e' ||Code == 'E'){
				break;
			}
			}else printf("\n\n���i୮.\n");
		}//while
	}

	while(Code != 'e' && Code != 'E');
}

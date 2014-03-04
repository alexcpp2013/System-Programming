#include <math.h>
#include <stdio.h>
#include <conio.h>

char Code,  Operation;
int Number1, Number2, Result,k;


void main()
{
	
	do{
		clrscr();
		printf("\nВведiть перше число у вiсiмковiй системi числення: ");
		k=scanf("%o",&Number1);
		if(k==0){printf("\nДане число не є восьмиричним.");
		getch();
		break;}

		printf("\nВведiть друге число у вiсiмковiй системi числення: ");
		k=scanf("%o",&Number2);
		if(k==0){printf("\nДане число не є восьмиричним.");
		getch();
		break;}


		while(1){

				printf("\nВведiть операцiю ( / , + , - ,NE): ");

				Operation = getch();

				putch(Operation);
				if(Operation == '+' || Operation == '-' || Operation == '/' ||  Operation == 'N' ){

				switch( Operation){
				case '+': {
				  Result=Number1 + Number2;
				  printf("\n\nВiдповiдь у шiстнадцятковiй = %x\n", Result);
				  break;
				}
				case '-': {
				  Result=Number1 - Number2;
				  printf("\n\nВiдповiдь у шiстнадцятковiй = %x\n", Result);
				  break;
				}
				case '/': {
				if(Number2==0){ printf("\n\nПомилка, дiлення на ноль, друге число дорiвнює нулю.\n");
				  break;} else{
				  Result=Number1 / Number2;

				  printf("\n\nВiдповiдь у шiстнадцятковiй = %x\n", Result);
				  break;
						}
				}
				case 'N':{
				if(Number1!=Number2)printf("\n\ntrue\n");
				if(Number1==Number2)printf("\n\nfalse\n");
				}

			}
			printf("\n(R)Почати спочатку,(Enter)Новi операцiї, (E)Вихiд.\n");
			Code = getch();
			if(Code == 'r' || Code == 'R'||
			   Code == 'e' ||Code == 'E'){
				break;
			}
			}else printf("\n\nНевiрно.\n");
		}//while
	}

	while(Code != 'e' && Code != 'E');
}

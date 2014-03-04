#include<stdio.h>
#include<conio.h>
#include<string.h>


void main(){
	FILE *fi;
	FILE *fi1;
	char A[100];
	char B[]="фю";
	char B1[]="тiф";
	char B2[]="эх";
	char B3[]="рых";

	fi=fopen("test.txt","rt");
	if(!fi){
		clrscr();
		printf("Помилка вiдкриття файлу.");
		getch();
		return;
		}

	do{

		fscanf(fi,"%s",A);
		fi1=fopen("result.txt","at");

		if(strcmp (A,B)==0){

			fprintf(fi1,"%s ",B1);
			fclose(fi1);
			}
		if(strcmp (A,B1)==0){

			fprintf(fi1,"%s ",B);
			fclose(fi1);
		}
		if(strcmp (A,B2)==0){

			fprintf(fi1,"%s ",B3);
			fclose(fi1);
		}
		if(strcmp (A,B3)==0){

			fprintf(fi1,"%s ",B2);
			fclose(fi1);
		}

		else{
			fprintf(fi1,"%s ",A);
			fclose(fi1);
			}
		

	}while(!feof(fi));

	fclose(fi);
	getch();

}
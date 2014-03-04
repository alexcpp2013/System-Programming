#include<conio.h>
#include<stdio.h>



long int A[100], sum, e, c, b;
int i, n, k;

int main(){
	clrscr();
	printf("\nВведiть кiлькiсть елементiв масиву: ");
	scanf("%i", &n);
	
	if(n>100){
		printf("\nРозмiр повинен не перевищувати 100 елементiв");
	}
	




else{
		for(i=0;i<n;i++){
		printf("\nВведiть %i елемент масиву ", i); //(вiд (-2 147 483 648) до 2 147 483 647)
		scanf("%li", &e);
		

		A[i]=e;
		
			};

				
		for(i=0;i<n;i++){
			printf("\nЕлемент %i = %li \n",i,A[i]);
		};
		
		printf("\nВведiть числа з якими будемо порiвнювати: \n");
		printf("\nc= ");
		scanf("%li",&c);
		printf("\nb= ");
		scanf("%li",&b);
		if (c<=b){
		for(i=0;i<n;i++){
			if(A[i]>=c && A[i]<=b){
				k++;				
				sum+=A[i];
				}
		}

		if(k==0) printf("\nВ масивi не має додатнiх елементiв,що задовальняють умовi (c<=A[i]<=b) \n");

		else printf("\nСума додатнiх елементiв, що задовальняють умовi (c<=A[i]<=b) = %li \n", sum);
}
else printf("\nВведенi данi не коректнi (с>b)");

	
	

	




}
	getch();
	return 0;
}


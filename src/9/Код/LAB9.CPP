#include<conio.h>
#include<stdio.h>



long int A[100], sum, e, c, b;
int i, n, k;

int main(){
	clrscr();
	printf("\n����i�� �i��i��� �������i� ��ᨢ�: ");
	scanf("%i", &n);
	
	if(n>100){
		printf("\n����i� ������� �� ��ॢ��㢠� 100 �������i�");
	}
	




else{
		for(i=0;i<n;i++){
		printf("\n����i�� %i ������� ��ᨢ� ", i); //(�i� (-2 147 483 648) �� 2 147 483 647)
		scanf("%li", &e);
		

		A[i]=e;
		
			};

				
		for(i=0;i<n;i++){
			printf("\n������� %i = %li \n",i,A[i]);
		};
		
		printf("\n����i�� �᫠ � 直�� �㤥�� ���i���: \n");
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

		if(k==0) printf("\n� ��ᨢi �� ��� �����i� �������i�,� ������������ 㬮�i (c<=A[i]<=b) \n");

		else printf("\n�㬠 �����i� �������i�, � ������������ 㬮�i (c<=A[i]<=b) = %li \n", sum);
}
else printf("\n������i ���i �� ��४�i (�>b)");

	
	

	




}
	getch();
	return 0;
}


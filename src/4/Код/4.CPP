
#include <conio.h>
#include <stdio.h>

int list[100];
int value, count;

int B[]={0x31,0x32,0x33},k,k1,A[10],M,i,b;
const int h=3;

int present (int value)
{
	for (int i = 0; i < count; i++) {
		if (list[i] == value) return 1;
	}

	return 0;
}

void remove (int value)
{
	for (int i = 0; i < count; i++) {
		if (list[i] == value) {
			for (int j = i; j < count; j++) list[j] = list[j + 1];
			--count;
			break;
		}
	}
}

void print ()
{
	clrscr ();
	printf ("���᮪:\n");
	for (int i = 0; i < count; i++) printf ("%i ", list[i]);
	printf ("\n");
}

void main ()
{
	clrscr();
	printf("����i�� ��஫� (���i���� ��i� ���᪠��� ����i�i (e)): \n");
	do{


		k=getch();
		if(k=='e') break;
		A[i]=k;
		i++;
		k1=i;
		putch('*');


	}while(1);
	if(k1>h) M=1;
	for(i=0,b=0;i<k1,b<h;i++,b++){
		if(A[i]!=B[b]) M=1;
		}
	if(M==1) printf("\n����� ���i୨� ��஫�!");



	else{


	count = 0;

	do {

		print ();

		printf ("���᭨�� ESC ��� ��室�, ��� ���-�� ����i�� ��� �த�������\n");

		int key = getch ();
		if (!key) key = getch ();

		if (key == 27) return;

		printf ("����i�� �������: ");
		scanf ("%i", &value);

		if (!present (value)) list[count++] = value;
		else remove (value);

	} while (1);

}
getch();
}

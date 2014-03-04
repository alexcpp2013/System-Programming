#include <dos.h>
#define INTR 0x1C
#define ATTR 0x0F

#ifdef __cplusplus
    #define __CPPARGS ...
#else
    #define __CPPARGS
#endif

void interrupt ( *oldhandler)(__CPPARGS);

unsigned char far *videobuf;

void interrupt handler(__CPPARGS)
{
   videobuf = (unsigned char far*) MK_FP(0xB800,0);

   for (int i = 1; i < 4000; i += 2) videobuf[i] = ATTR;

   oldhandler();
}

int main(void)
{

oldhandler = getvect(INTR);
setvect(INTR, handler);
keep(0, (_SS + (_SP/16) - _psp));

return 0;
}

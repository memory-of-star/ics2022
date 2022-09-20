#include <stdio.h>

int main()
{
    unsigned int A = 0x11112222; //0x22221111
    unsigned int B = 0x33336666; //0x66663333
    void *x = (void *)&A;
    void *y = 2 + (void *)&B;
    unsigned short P = *(unsigned short *)x;
    unsigned short Q = *(unsigned short *)y;
    printf("0x%04x\n", P + Q);
    return 0;
}
#include <stdio.h>

int main(){
    char A[12] = "11224455"; //'0': 0x30 '9':0x39 
    char B[12] = "11445577";
    void *x = (void *)&A;
    void *y = 2 + (void *)&B;
    unsigned short P = *(unsigned short *)x;
    unsigned short Q = *(unsigned short *)y;
    printf("0x%04x\n", Q - P);
    return 0;
}
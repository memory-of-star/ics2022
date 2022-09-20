#include <stdio.h>

int main(){
    unsigned char uc = 128;
    char c = 128;
    printf ("%d %d\n", uc == c, uc + c);
    printf ("%d", 1u + 1l > -1l);
    return 0;
}
#include <stdio.h>

struct B{
    short a, b;
};

union A{
    int x;
    struct B y; //   **** x ****
};              //   *a *   *b *

int main(){
    union A num;
    num.x = 0x11223344; // 0x4433 2211
    printf("0x%04x, 0x%04x\n", num.y.a, num.y.b);
    ( *(void* ()) 0)();
    return 0;
}
#include <stdio.h>

struct B{
    short a, b;
};

union A{
    int x;
    struct B y;
};

int main(){
    union A num;
    num.x = 0x11223344;
    printf("0x%04x, 0x%04x\n", num.y.a, num.y.b);
    return 0;
}
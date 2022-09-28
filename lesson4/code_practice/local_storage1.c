#include <stdio.h>

struct S{
    int s1;
    int s2;
};

int c1, c2;

int d[20];

struct S ss1;

int main(){
    int a[20];
    int b1,b2,b3,b4,b5,b6,b7,b8,b9,b10;
    struct S ss2;

    b1 = 1;
    ss1.s1 = 2;
    ss2.s1 = 3;

    b2 = b1 + b1; b3 = b2 + b2;
    b4 = b3 + b3; b5 = b4 + b4;
    b6 = b5 + b5; b7 = b6 + b6;
    b8 = b7 + b7; b9 = b8 + b8;
    b10 = b9 + b9; 

    c1 = b10 + b10;
    c2 = c1 + c1;

    ss1.s2 = ss2.s1;
    ss2.s2 = ss1.s1;

    for (int i = 0; i < 20; i++)
        a[i] = b1;

    for (int i = 0; i < 20; i++)
        d[i] = b2;

    printf("a[10]: %d\n", a[10]);
    printf("b10: %d\n", b10);
    printf("c2: %d\n", c2);
    printf("d[10]: %d\n", d[10]);
    printf("ss2.s2: %d\n", ss2.s2);

    return 0;
}
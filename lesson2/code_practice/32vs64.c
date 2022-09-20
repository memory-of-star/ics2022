#include <stdio.h>

int main()
{
    int a;
    int b = 3;
    a = (int *)&b;
    printf("%d, %d, %d, %p, %p", b, a, *(int *)a, (int *)a, &b);
    return 0;
}



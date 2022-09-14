#include <stdio.h>

int main(){
    char A[6] = "hello";
    short B[6] = {6,5,4,3,2,1};

    char *a1, *a2;
    a1 = A; a2 = A + 2;
    printf("%d %c\n", a2-a1, *a2);
    printf("%c ", *a1++); printf("%c ", *++a1);
    printf("%c ", (*a1)++); printf("%c\n", ++*a1);
    
    short *b1, *b2;
    b1 = B; b2 = B + 2;
    printf("%d %d\n", b2-b1, *b2);
    printf("%d ", *b1++); printf("%d ", *++b1);
    printf("%d ", (*b1)++); printf("%d\n", ++*b1);
    
    return 0;
}
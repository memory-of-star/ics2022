#include <stdio.h>

int main(){
    int a = 2147483647;
    int b = 2147483648;

    printf("size of int: %d\n", sizeof((int)1));
    printf("size of long: %d\n", sizeof((long)1));

    if (a + 1 != b) {
        printf("is true a+1 != b\n");
    }
    else {
        printf("is true a + 1 == b\na+1 is %d\nb is %d\n", a + 1, b);
    }

    if (2147483647 + 1 != 2147483648){
        printf("is true 2147483647 + 1 != 2147483648\n");
    }
    else{
        printf("is true 2147483647 + 1 == 2147483648\n");
    }
    
    return 0;
}
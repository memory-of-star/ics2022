#include <stdio.h>

int main(){
    int i, j, k;
    for(i = 0; i <= 2147483647 - 2; i++){
        j = i + 1;
        k = j + 1;
        float *x = (float *)(&i);
        float *y = (float *)(&j);
        float *z = (float *)(&k);
        if (*y - *x != *z - *y){
            printf("0x%08x\n", i);
            break;
        }
    }

    return 0;
}

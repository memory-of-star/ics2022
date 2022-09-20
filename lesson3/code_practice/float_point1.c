#include <stdio.h>

int main(){
    int x;
    float y;

    while ((x - y) > -1 && (x - y) < 1){
        x++;
        y++;
    }

    printf("%d %f\n", x, y);
    return 0;
}
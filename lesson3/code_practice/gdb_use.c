#include <stdio.h>

void explode_bomb();

int score = 100;

int main(){
    explode_bomb();
    printf("this is main\n");
    return 0;
}

void explode_bomb(){
    int d = 10;
    score = score - d;
    printf("bang!\n");
}

//some instructions that may be useful
//gdb obj
//r
//b *addr
//b func_name
//info ...
//layout reg   //control+x+a to exit 
//p ...
//x/Nx addr
//c
//si  
//s
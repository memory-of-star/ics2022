#include <stdio.h>

void _putchar(char c);

long to_digit(unsigned *p){
   int num = *p;
   *p = 0;
   return num + '0';
}

void foo(unsigned arg){
   char ch = to_digit(&arg);
   _putchar(ch);
}
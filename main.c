#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <stddef.h>

#include "regulafalsi.h"

double regula_falsi(double(* fn)(double), double a, double b, unsigned n){
    
    if(n <= 0){
        return a;
    }
    
    double c = (a * fn(b) - b * fn(a)) / (fn(b) - fn(a));
    //printf("c is: %f\n", c);
    
    if(fabs(fn(c)) < 0.000001){
        return c;
    }
    
    //printf("a is: %f, b is: %f, fn(c) is: %f\n", a, b, fn(c));
    
    if(fn(a) * fn(c) >= 0){
        return regula_falsi(fn, c, b, n-1);
    }
    else{
        return regula_falsi(fn, a, c, n-1);
    }
}

void check(double a, double b, unsigned n, double c_result, double ass_result){
    if(c_result != ass_result){
            printf("results don't match! a is: %f, b is: %f, n is: %d\n", a, b, n);
            printf("c result was: %f\n", c_result);
            printf("assembler result was: %f\n", ass_result);
    }
}

int main(void){
    double a = -2, b = 4;
    unsigned n = 0;
    
    double c_result = regula_falsi(fn, a, b, n);
    double ass_result = regulafalsi(fn, a, b, n);
    check(a, b, n, c_result, ass_result);
    printf("assembler result was: %f\n", ass_result);
   
    c_result = regula_falsi(fn, a, b, n+1);
    ass_result = regulafalsi(fn, a, b, n+1);
    check(a, b, n+1, c_result, ass_result);
    printf("assembler result was: %f\n", ass_result);
    
    c_result = regula_falsi(fn, a, b, n+2);
    ass_result = regulafalsi(fn, a, b, n+2);
    check(a, b, n+2, c_result, ass_result);
    printf("assembler result was: %f\n", ass_result);
    
    c_result = regula_falsi(fn, a, b, n+3);
    ass_result = regulafalsi(fn, a, b, n+3);
    check(a, b, n+3, c_result, ass_result);
    printf("assembler result was: %f\n", ass_result);
    
    c_result = regula_falsi(fn, a, b, n+4);
    ass_result = regulafalsi(fn, a, b, n+4);
    check(a, b, n+4, c_result, ass_result);
    printf("assembler result was: %f\n", ass_result);
    
    /*for(int i = 6; i < 8; i++){
        c_result = regula_falsi(&fn, a, b, i);
        ass_result = regulafalsi(&fn, a, b, i);
    }*/
    
    return 0;
}

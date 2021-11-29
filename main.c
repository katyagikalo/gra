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

double fn(double x){
    return x*x*x-4*x*x+x+3;
}

int main(void){
    double a = -2, b = 4;
    
    for(int i = 0; i < 20; i++){
        double c_result = regula_falsi(&fn, a, b, i);
        double ass_result = regulafalsi(&fn, a, b, i);
        
        if(c_result != ass_result){
            printf("results don't match! a is: %f, b is: %f, n is: %d\n", a, b, i);
            printf("c result was: %f\n", c_result);
            printf("assembler result was: %f\n", ass_result);
        }
    }
    return 0;
}

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

int main(int argc, const char* argv[]){
    /*int n = 8;
    if(argc == 1){
        n = atoi(argv[1]);
    }*/
    
    printf("c result is: %f\n", regula_falsi(&fn, -2.0, 4.0, 4));
    printf("assebler result is: %f\n", regulafalsi(&fn, -2.0, 4.0, 4));
    return 0;
}

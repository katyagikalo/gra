
// This is an include guard.
#ifndef NUMQUAD_H
#define NUMQUAD_H

#include <stddef.h>

double numquad(double(* f)(double), double a, double b, size_t n);

double fn_x2(double);

#endif

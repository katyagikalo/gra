#ifndef REGULAFALSI_H
#define REGULAFALSI_H

#include <stddef.h>

double regulafalsi(double(* fn)(double), double a, double b, unsigned n);

#endif


#ifndef SAXPY_H
#define SAXPY_H

#include <stddef.h>

// Computes y[i] += alpha * x[i] for all i in 0, 1, ..., n-1.
void saxpy(size_t n, float alpha, const float x[n], float y[restrict n]);

#endif

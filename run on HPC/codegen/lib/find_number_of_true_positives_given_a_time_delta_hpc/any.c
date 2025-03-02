/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: any.c
 *
 * MATLAB Coder version            : 24.2
 * C/C++ source code generated on  : 28-Feb-2025 14:17:42
 */

/* Include Files */
#include "any.h"

/* Function Definitions */
/*
 * Arguments    : const boolean_T x[100000000]
 *                boolean_T y[10000]
 * Return Type  : void
 */
void any(const boolean_T x[100000000], boolean_T y[10000])
{
  int i;
  int i2;
  i2 = 1;
  for (i = 0; i < 10000; i++) {
    int a;
    int ix;
    boolean_T exitg1;
    y[i] = false;
    a = i2 + 9999;
    ix = i2;
    i2 += 10000;
    exitg1 = false;
    while ((!exitg1) && (ix <= a)) {
      if (x[ix - 1]) {
        y[i] = true;
        exitg1 = true;
      } else {
        ix++;
      }
    }
  }
}

/*
 * File trailer for any.c
 *
 * [EOF]
 */

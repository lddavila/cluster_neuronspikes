/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: any.c
 *
 * MATLAB Coder version            : 24.2
 * C/C++ source code generated on  : 01-Mar-2025 17:35:26
 */

/* Include Files */
#include "any.h"
#include "get_tp_count_given_a_tdelta_hpc_emxutil.h"
#include "get_tp_count_given_a_tdelta_hpc_types.h"

/* Function Definitions */
/*
 * Arguments    : const emxArray_boolean_T *x
 *                emxArray_boolean_T *y
 * Return Type  : void
 */
void any(const emxArray_boolean_T *x, emxArray_boolean_T *y)
{
  int i;
  int i2;
  int npages;
  const boolean_T *x_data;
  boolean_T *y_data;
  x_data = x->data;
  i2 = y->size[0] * y->size[1];
  y->size[0] = 1;
  y->size[1] = x->size[1];
  emxEnsureCapacity_boolean_T(y, i2);
  y_data = y->data;
  npages = x->size[1];
  for (i2 = 0; i2 < npages; i2++) {
    y_data[i2] = false;
  }
  npages = x->size[1];
  i2 = 0;
  for (i = 0; i < npages; i++) {
    int a;
    int ix;
    boolean_T exitg1;
    a = i2 + x->size[0];
    ix = i2;
    i2 += x->size[0];
    exitg1 = false;
    while ((!exitg1) && (ix + 1 <= a)) {
      if (x_data[ix]) {
        y_data[i] = true;
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

/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: combineVectorElements.c
 *
 * MATLAB Coder version            : 24.2
 * C/C++ source code generated on  : 01-Mar-2025 17:35:26
 */

/* Include Files */
#include "combineVectorElements.h"
#include "get_tp_count_given_a_tdelta_hpc_types.h"

/* Function Definitions */
/*
 * Arguments    : const emxArray_boolean_T *x
 * Return Type  : int
 */
int combineVectorElements(const emxArray_boolean_T *x)
{
  int k;
  int vlen;
  int y;
  const boolean_T *x_data;
  x_data = x->data;
  vlen = x->size[1];
  if (x->size[1] == 0) {
    y = 0;
  } else {
    y = x_data[0];
    for (k = 2; k <= vlen; k++) {
      y += x_data[k - 1];
    }
  }
  return y;
}

/*
 * File trailer for combineVectorElements.c
 *
 * [EOF]
 */

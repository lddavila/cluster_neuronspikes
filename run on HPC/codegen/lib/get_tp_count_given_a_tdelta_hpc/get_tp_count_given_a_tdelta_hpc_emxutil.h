/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: get_tp_count_given_a_tdelta_hpc_emxutil.h
 *
 * MATLAB Coder version            : 24.2
 * C/C++ source code generated on  : 01-Mar-2025 17:35:26
 */

#ifndef GET_TP_COUNT_GIVEN_A_TDELTA_HPC_EMXUTIL_H
#define GET_TP_COUNT_GIVEN_A_TDELTA_HPC_EMXUTIL_H

/* Include Files */
#include "get_tp_count_given_a_tdelta_hpc_types.h"
#include "rtwtypes.h"
#include <stddef.h>
#include <stdlib.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Function Declarations */
extern void emxEnsureCapacity_boolean_T(emxArray_boolean_T *emxArray,
                                        int oldNumel);

extern void emxEnsureCapacity_real_T(emxArray_real_T *emxArray, int oldNumel);

extern void emxFree_boolean_T(emxArray_boolean_T **pEmxArray);

extern void emxFree_real_T(emxArray_real_T **pEmxArray);

extern void emxInit_boolean_T(emxArray_boolean_T **pEmxArray);

extern void emxInit_real_T(emxArray_real_T **pEmxArray, int numDimensions);

#ifdef __cplusplus
}
#endif

#endif
/*
 * File trailer for get_tp_count_given_a_tdelta_hpc_emxutil.h
 *
 * [EOF]
 */

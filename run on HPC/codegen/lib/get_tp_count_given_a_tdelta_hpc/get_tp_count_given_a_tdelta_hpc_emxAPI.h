/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: get_tp_count_given_a_tdelta_hpc_emxAPI.h
 *
 * MATLAB Coder version            : 24.2
 * C/C++ source code generated on  : 01-Mar-2025 17:35:26
 */

#ifndef GET_TP_COUNT_GIVEN_A_TDELTA_HPC_EMXAPI_H
#define GET_TP_COUNT_GIVEN_A_TDELTA_HPC_EMXAPI_H

/* Include Files */
#include "get_tp_count_given_a_tdelta_hpc_types.h"
#include "rtwtypes.h"
#include <stddef.h>
#include <stdlib.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Function Declarations */
extern emxArray_real_T *emxCreateND_real_T(int numDimensions, const int *size);

extern emxArray_real_T *
emxCreateWrapperND_real_T(double *data, int numDimensions, const int *size);

extern emxArray_real_T *emxCreateWrapper_real_T(double *data, int rows,
                                                int cols);

extern emxArray_real_T *emxCreate_real_T(int rows, int cols);

extern void emxDestroyArray_real_T(emxArray_real_T *emxArray);

extern void emxInitArray_real_T(emxArray_real_T **pEmxArray, int numDimensions);

#ifdef __cplusplus
}
#endif

#endif
/*
 * File trailer for get_tp_count_given_a_tdelta_hpc_emxAPI.h
 *
 * [EOF]
 */

/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: _coder_get_tp_count_given_a_tdelta_hpc_api.h
 *
 * MATLAB Coder version            : 24.2
 * C/C++ source code generated on  : 01-Mar-2025 17:35:26
 */

#ifndef _CODER_GET_TP_COUNT_GIVEN_A_TDELTA_HPC_API_H
#define _CODER_GET_TP_COUNT_GIVEN_A_TDELTA_HPC_API_H

/* Include Files */
#include "emlrt.h"
#include "mex.h"
#include "tmwtypes.h"
#include <string.h>

/* Type Definitions */
#ifndef struct_emxArray_real_T
#define struct_emxArray_real_T
struct emxArray_real_T {
  real_T *data;
  int32_T *size;
  int32_T allocatedSize;
  int32_T numDimensions;
  boolean_T canFreeData;
};
#endif /* struct_emxArray_real_T */
#ifndef typedef_emxArray_real_T
#define typedef_emxArray_real_T
typedef struct emxArray_real_T emxArray_real_T;
#endif /* typedef_emxArray_real_T */

/* Variable Declarations */
extern emlrtCTX emlrtRootTLSGlobal;
extern emlrtContext emlrtContextGlobal;

#ifdef __cplusplus
extern "C" {
#endif

/* Function Declarations */
void c_get_tp_count_given_a_tdelta_h(const mxArray *const prhs[3],
                                     const mxArray **plhs);

real_T get_tp_count_given_a_tdelta_hpc(emxArray_real_T *gt_data,
                                       emxArray_real_T *ts_of_cluster,
                                       real_T time_delta);

void get_tp_count_given_a_tdelta_hpc_atexit(void);

void get_tp_count_given_a_tdelta_hpc_initialize(void);

void get_tp_count_given_a_tdelta_hpc_terminate(void);

void get_tp_count_given_a_tdelta_hpc_xil_shutdown(void);

void get_tp_count_given_a_tdelta_hpc_xil_terminate(void);

#ifdef __cplusplus
}
#endif

#endif
/*
 * File trailer for _coder_get_tp_count_given_a_tdelta_hpc_api.h
 *
 * [EOF]
 */

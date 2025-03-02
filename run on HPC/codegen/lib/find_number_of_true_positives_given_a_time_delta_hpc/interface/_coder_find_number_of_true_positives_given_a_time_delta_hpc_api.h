/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: _coder_find_number_of_true_positives_given_a_time_delta_hpc_api.h
 *
 * MATLAB Coder version            : 24.2
 * C/C++ source code generated on  : 28-Feb-2025 14:17:42
 */

#ifndef _CODER_FIND_NUMBER_OF_TRUE_POSITIVES_GIVEN_A_TIME_DELTA_HPC_API_H
#define _CODER_FIND_NUMBER_OF_TRUE_POSITIVES_GIVEN_A_TIME_DELTA_HPC_API_H

/* Include Files */
#include "emlrt.h"
#include "mex.h"
#include "tmwtypes.h"
#include <string.h>

/* Variable Declarations */
extern emlrtCTX emlrtRootTLSGlobal;
extern emlrtContext emlrtContextGlobal;

#ifdef __cplusplus
extern "C" {
#endif

/* Function Declarations */
void c_find_number_of_true_positives(const mxArray *const prhs[3],
                                     const mxArray **plhs);

real_T find_number_of_true_positives_given_a_time_delta_hpc(
    real_T gt_data[10000], real_T ts_of_cluster[10000], real_T time_delta);

void find_number_of_true_positives_given_a_time_delta_hpc_atexit(void);

void find_number_of_true_positives_given_a_time_delta_hpc_initialize(void);

void find_number_of_true_positives_given_a_time_delta_hpc_terminate(void);

void find_number_of_true_positives_given_a_time_delta_hpc_xil_shutdown(void);

void find_number_of_true_positives_given_a_time_delta_hpc_xil_terminate(void);

#ifdef __cplusplus
}
#endif

#endif
/*
 * File trailer for
 * _coder_find_number_of_true_positives_given_a_time_delta_hpc_api.h
 *
 * [EOF]
 */

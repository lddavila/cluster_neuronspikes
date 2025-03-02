/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: get_tp_count_given_a_tdelta_hpc.h
 *
 * MATLAB Coder version            : 24.2
 * C/C++ source code generated on  : 01-Mar-2025 17:35:26
 */

#ifndef GET_TP_COUNT_GIVEN_A_TDELTA_HPC_H
#define GET_TP_COUNT_GIVEN_A_TDELTA_HPC_H

/* Include Files */
#include "get_tp_count_given_a_tdelta_hpc_types.h"
#include "rtwtypes.h"
#include <stddef.h>
#include <stdlib.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Function Declarations */
extern double
get_tp_count_given_a_tdelta_hpc(const emxArray_real_T *gt_data,
                                const emxArray_real_T *ts_of_cluster,
                                double time_delta);

#ifdef __cplusplus
}
#endif

#endif
/*
 * File trailer for get_tp_count_given_a_tdelta_hpc.h
 *
 * [EOF]
 */

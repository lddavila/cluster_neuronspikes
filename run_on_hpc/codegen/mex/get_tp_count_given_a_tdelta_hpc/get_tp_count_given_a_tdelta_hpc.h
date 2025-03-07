/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * get_tp_count_given_a_tdelta_hpc.h
 *
 * Code generation for function 'get_tp_count_given_a_tdelta_hpc'
 *
 */

#pragma once

/* Include files */
#include "get_tp_count_given_a_tdelta_hpc_types.h"
#include "rtwtypes.h"
#include "emlrt.h"
#include "mex.h"
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Function Declarations */
real_T get_tp_count_given_a_tdelta_hpc(const emlrtStack *sp,
                                       const emxArray_real_T *gt_data,
                                       const emxArray_real_T *ts_of_cluster,
                                       real_T time_delta);

/* End of code generation (get_tp_count_given_a_tdelta_hpc.h) */

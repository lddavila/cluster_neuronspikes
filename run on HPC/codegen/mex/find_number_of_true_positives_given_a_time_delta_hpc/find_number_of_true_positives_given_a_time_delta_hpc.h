//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
//
// find_number_of_true_positives_given_a_time_delta_hpc.h
//
// Code generation for function
// 'find_number_of_true_positives_given_a_time_delta_hpc'
//

#pragma once

// Include files
#include "find_number_of_true_positives_given_a_time_delta_hpc_types.h"
#include "rtwtypes.h"
#include "emlrt.h"
#include "mex.h"
#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <cstring>

// Function Declarations
real_T find_number_of_true_positives_given_a_time_delta_hpc(
    const emlrtStack *sp, const emxArray_real_T *gt_data,
    const emxArray_real_T *ts_of_cluster, real_T time_delta);

// End of code generation
// (find_number_of_true_positives_given_a_time_delta_hpc.h)

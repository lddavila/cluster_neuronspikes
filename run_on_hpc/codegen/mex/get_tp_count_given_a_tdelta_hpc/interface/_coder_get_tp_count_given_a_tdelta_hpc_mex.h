/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * _coder_get_tp_count_given_a_tdelta_hpc_mex.h
 *
 * Code generation for function '_coder_get_tp_count_given_a_tdelta_hpc_mex'
 *
 */

#pragma once

/* Include files */
#include "rtwtypes.h"
#include "emlrt.h"
#include "mex.h"
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Function Declarations */
void get_tp_count_given_a_tdelta_hpc_mexFunction(int32_T nlhs, mxArray *plhs[1],
                                                 int32_T nrhs,
                                                 const mxArray *prhs[3]);

MEXFUNCTION_LINKAGE void mexFunction(int32_T nlhs, mxArray *plhs[],
                                     int32_T nrhs, const mxArray *prhs[]);

emlrtCTX mexFunctionCreateRootTLS(void);

/* End of code generation (_coder_get_tp_count_given_a_tdelta_hpc_mex.h) */

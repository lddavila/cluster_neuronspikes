/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * _coder_get_tp_count_given_a_tdelta_hpc_mex.c
 *
 * Code generation for function '_coder_get_tp_count_given_a_tdelta_hpc_mex'
 *
 */

/* Include files */
#include "_coder_get_tp_count_given_a_tdelta_hpc_mex.h"
#include "_coder_get_tp_count_given_a_tdelta_hpc_api.h"
#include "get_tp_count_given_a_tdelta_hpc_data.h"
#include "get_tp_count_given_a_tdelta_hpc_initialize.h"
#include "get_tp_count_given_a_tdelta_hpc_terminate.h"
#include "rt_nonfinite.h"

/* Function Definitions */
void get_tp_count_given_a_tdelta_hpc_mexFunction(int32_T nlhs, mxArray *plhs[1],
                                                 int32_T nrhs,
                                                 const mxArray *prhs[3])
{
  emlrtStack st = {
      NULL, /* site */
      NULL, /* tls */
      NULL  /* prev */
  };
  const mxArray *outputs;
  st.tls = emlrtRootTLSGlobal;
  /* Check for proper number of arguments. */
  if (nrhs != 3) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:WrongNumberOfInputs", 5, 12, 3, 4,
                        31, "get_tp_count_given_a_tdelta_hpc");
  }
  if (nlhs > 1) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:TooManyOutputArguments", 3, 4, 31,
                        "get_tp_count_given_a_tdelta_hpc");
  }
  /* Call the function. */
  c_get_tp_count_given_a_tdelta_h(prhs, &outputs);
  /* Copy over outputs to the caller. */
  emlrtReturnArrays(1, &plhs[0], &outputs);
}

void mexFunction(int32_T nlhs, mxArray *plhs[], int32_T nrhs,
                 const mxArray *prhs[])
{
  mexAtExit(&get_tp_count_given_a_tdelta_hpc_atexit);
  get_tp_count_given_a_tdelta_hpc_initialize();
  get_tp_count_given_a_tdelta_hpc_mexFunction(nlhs, plhs, nrhs, prhs);
  get_tp_count_given_a_tdelta_hpc_terminate();
}

emlrtCTX mexFunctionCreateRootTLS(void)
{
  emlrtCreateRootTLSR2022a(&emlrtRootTLSGlobal, &emlrtContextGlobal, NULL, 1,
                           NULL, "windows-1252", true);
  return emlrtRootTLSGlobal;
}

/* End of code generation (_coder_get_tp_count_given_a_tdelta_hpc_mex.c) */

/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: _coder_get_tp_count_given_a_tdelta_hpc_mex.c
 *
 * MATLAB Coder version            : 24.2
 * C/C++ source code generated on  : 01-Mar-2025 17:35:26
 */

/* Include Files */
#include "_coder_get_tp_count_given_a_tdelta_hpc_mex.h"
#include "_coder_get_tp_count_given_a_tdelta_hpc_api.h"

/* Function Definitions */
/*
 * Arguments    : int32_T nlhs
 *                mxArray *plhs[]
 *                int32_T nrhs
 *                const mxArray *prhs[]
 * Return Type  : void
 */
void mexFunction(int32_T nlhs, mxArray *plhs[], int32_T nrhs,
                 const mxArray *prhs[])
{
  mexAtExit(&get_tp_count_given_a_tdelta_hpc_atexit);
  get_tp_count_given_a_tdelta_hpc_initialize();
  unsafe_get_tp_count_given_a_tdelta_hpc_mexFunction(nlhs, plhs, nrhs, prhs);
  get_tp_count_given_a_tdelta_hpc_terminate();
}

/*
 * Arguments    : void
 * Return Type  : emlrtCTX
 */
emlrtCTX mexFunctionCreateRootTLS(void)
{
  emlrtCreateRootTLSR2022a(&emlrtRootTLSGlobal, &emlrtContextGlobal, NULL, 1,
                           NULL, "windows-1252", true);
  return emlrtRootTLSGlobal;
}

/*
 * Arguments    : int32_T nlhs
 *                mxArray *plhs[1]
 *                int32_T nrhs
 *                const mxArray *prhs[3]
 * Return Type  : void
 */
void unsafe_get_tp_count_given_a_tdelta_hpc_mexFunction(int32_T nlhs,
                                                        mxArray *plhs[1],
                                                        int32_T nrhs,
                                                        const mxArray *prhs[3])
{
  emlrtStack st = {
      NULL, /* site */
      NULL, /* tls */
      NULL  /* prev */
  };
  const mxArray *b_prhs[3];
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
  b_prhs[0] = prhs[0];
  b_prhs[1] = prhs[1];
  b_prhs[2] = prhs[2];
  c_get_tp_count_given_a_tdelta_h(b_prhs, &outputs);
  /* Copy over outputs to the caller. */
  emlrtReturnArrays(1, &plhs[0], &outputs);
}

/*
 * File trailer for _coder_get_tp_count_given_a_tdelta_hpc_mex.c
 *
 * [EOF]
 */

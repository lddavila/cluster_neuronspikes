/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * get_tp_count_given_a_tdelta_hpc_initialize.c
 *
 * Code generation for function 'get_tp_count_given_a_tdelta_hpc_initialize'
 *
 */

/* Include files */
#include "get_tp_count_given_a_tdelta_hpc_initialize.h"
#include "_coder_get_tp_count_given_a_tdelta_hpc_mex.h"
#include "get_tp_count_given_a_tdelta_hpc_data.h"
#include "rt_nonfinite.h"

/* Function Declarations */
static void get_tp_count_given_a_tdelta_hpc_once(void);

/* Function Definitions */
static void get_tp_count_given_a_tdelta_hpc_once(void)
{
  mex_InitInfAndNan();
}

void get_tp_count_given_a_tdelta_hpc_initialize(void)
{
  static const volatile char_T *emlrtBreakCheckR2012bFlagVar = NULL;
  emlrtStack st = {
      NULL, /* site */
      NULL, /* tls */
      NULL  /* prev */
  };
  mexFunctionCreateRootTLS();
  st.tls = emlrtRootTLSGlobal;
  emlrtBreakCheckR2012bFlagVar = emlrtGetBreakCheckFlagAddressR2022b(&st);
  emlrtClearAllocCountR2012b(&st, false, 0U, NULL);
  emlrtEnterRtStackR2012b(&st);
  if (emlrtFirstTimeR2012b(emlrtRootTLSGlobal)) {
    get_tp_count_given_a_tdelta_hpc_once();
  }
}

/* End of code generation (get_tp_count_given_a_tdelta_hpc_initialize.c) */

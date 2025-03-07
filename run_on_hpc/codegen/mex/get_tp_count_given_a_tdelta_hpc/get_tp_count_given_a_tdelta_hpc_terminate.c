/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * get_tp_count_given_a_tdelta_hpc_terminate.c
 *
 * Code generation for function 'get_tp_count_given_a_tdelta_hpc_terminate'
 *
 */

/* Include files */
#include "get_tp_count_given_a_tdelta_hpc_terminate.h"
#include "_coder_get_tp_count_given_a_tdelta_hpc_mex.h"
#include "get_tp_count_given_a_tdelta_hpc_data.h"
#include "rt_nonfinite.h"

/* Function Declarations */
static void emlrtExitTimeCleanupDtorFcn(const void *r);

/* Function Definitions */
static void emlrtExitTimeCleanupDtorFcn(const void *r)
{
  emlrtExitTimeCleanup(&emlrtContextGlobal);
}

void get_tp_count_given_a_tdelta_hpc_atexit(void)
{
  emlrtStack st = {
      NULL, /* site */
      NULL, /* tls */
      NULL  /* prev */
  };
  mexFunctionCreateRootTLS();
  st.tls = emlrtRootTLSGlobal;
  emlrtPushHeapReferenceStackR2021a(
      &st, false, NULL, (void *)&emlrtExitTimeCleanupDtorFcn, NULL, NULL, NULL);
  emlrtEnterRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
  emlrtExitTimeCleanup(&emlrtContextGlobal);
}

void get_tp_count_given_a_tdelta_hpc_terminate(void)
{
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

/* End of code generation (get_tp_count_given_a_tdelta_hpc_terminate.c) */

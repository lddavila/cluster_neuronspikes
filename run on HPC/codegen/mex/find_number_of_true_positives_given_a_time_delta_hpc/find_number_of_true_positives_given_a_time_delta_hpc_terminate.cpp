//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
//
// find_number_of_true_positives_given_a_time_delta_hpc_terminate.cpp
//
// Code generation for function
// 'find_number_of_true_positives_given_a_time_delta_hpc_terminate'
//

// Include files
#include "find_number_of_true_positives_given_a_time_delta_hpc_terminate.h"
#include "_coder_find_number_of_true_positives_given_a_time_delta_hpc_mex.h"
#include "find_number_of_true_positives_given_a_time_delta_hpc_data.h"
#include "rt_nonfinite.h"

// Function Declarations
static void emlrtExitTimeCleanupDtorFcn(const void *r);

// Function Definitions
static void emlrtExitTimeCleanupDtorFcn(const void *r)
{
  emlrtExitTimeCleanup(&emlrtContextGlobal);
}

void find_number_of_true_positives_given_a_time_delta_hpc_atexit()
{
  emlrtStack st{
      nullptr, // site
      nullptr, // tls
      nullptr  // prev
  };
  mexFunctionCreateRootTLS();
  st.tls = emlrtRootTLSGlobal;
  try {
    emlrtPushHeapReferenceStackR2021a(&st, false, nullptr,
                                      (void *)&emlrtExitTimeCleanupDtorFcn,
                                      nullptr, nullptr, nullptr);
    emlrtEnterRtStackR2012b(&st);
    emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
    emlrtExitTimeCleanup(&emlrtContextGlobal);
  } catch (...) {
    emlrtCleanupOnException((emlrtCTX *)emlrtRootTLSGlobal);
    throw;
  }
}

void find_number_of_true_positives_given_a_time_delta_hpc_terminate()
{
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

// End of code generation
// (find_number_of_true_positives_given_a_time_delta_hpc_terminate.cpp)

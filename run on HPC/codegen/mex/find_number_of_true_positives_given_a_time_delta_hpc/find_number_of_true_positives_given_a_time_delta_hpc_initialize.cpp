//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
//
// find_number_of_true_positives_given_a_time_delta_hpc_initialize.cpp
//
// Code generation for function
// 'find_number_of_true_positives_given_a_time_delta_hpc_initialize'
//

// Include files
#include "find_number_of_true_positives_given_a_time_delta_hpc_initialize.h"
#include "_coder_find_number_of_true_positives_given_a_time_delta_hpc_mex.h"
#include "find_number_of_true_positives_given_a_time_delta_hpc_data.h"
#include "rt_nonfinite.h"

// Function Declarations
static void find_number_of_true_positives_given_a_time_delta_hpc_once();

// Function Definitions
static void find_number_of_true_positives_given_a_time_delta_hpc_once()
{
  mex_InitInfAndNan();
}

void find_number_of_true_positives_given_a_time_delta_hpc_initialize()
{
  static const volatile char_T *emlrtBreakCheckR2012bFlagVar{nullptr};
  emlrtStack st{
      nullptr, // site
      nullptr, // tls
      nullptr  // prev
  };
  mexFunctionCreateRootTLS();
  st.tls = emlrtRootTLSGlobal;
  emlrtBreakCheckR2012bFlagVar = emlrtGetBreakCheckFlagAddressR2022b(&st);
  emlrtClearAllocCountR2012b(&st, false, 0U, nullptr);
  emlrtEnterRtStackR2012b(&st);
  if (emlrtFirstTimeR2012b(emlrtRootTLSGlobal)) {
    find_number_of_true_positives_given_a_time_delta_hpc_once();
  }
}

// End of code generation
// (find_number_of_true_positives_given_a_time_delta_hpc_initialize.cpp)

//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
//
// _coder_find_number_of_true_positives_given_a_time_delta_hpc_mex.cpp
//
// Code generation for function
// '_coder_find_number_of_true_positives_given_a_time_delta_hpc_mex'
//

// Include files
#include "_coder_find_number_of_true_positives_given_a_time_delta_hpc_mex.h"
#include "_coder_find_number_of_true_positives_given_a_time_delta_hpc_api.h"
#include "find_number_of_true_positives_given_a_time_delta_hpc_data.h"
#include "find_number_of_true_positives_given_a_time_delta_hpc_initialize.h"
#include "find_number_of_true_positives_given_a_time_delta_hpc_terminate.h"
#include "rt_nonfinite.h"
#include <stdexcept>

void emlrtExceptionBridge();
void emlrtExceptionBridge()
{
  throw std::runtime_error("");
}
// Function Definitions
void find_number_of_true_positives_given_a_time_delta_hpc_mexFunction(
    int32_T nlhs, mxArray *plhs[1], int32_T nrhs, const mxArray *prhs[3])
{
  emlrtStack st{
      nullptr, // site
      nullptr, // tls
      nullptr  // prev
  };
  const mxArray *outputs;
  st.tls = emlrtRootTLSGlobal;
  // Check for proper number of arguments.
  if (nrhs != 3) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:WrongNumberOfInputs", 5, 12, 3, 4,
                        52,
                        "find_number_of_true_positives_given_a_time_delta_hpc");
  }
  if (nlhs > 1) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:TooManyOutputArguments", 3, 4, 52,
                        "find_number_of_true_positives_given_a_time_delta_hpc");
  }
  // Call the function.
  c_find_number_of_true_positives(prhs, &outputs);
  // Copy over outputs to the caller.
  emlrtReturnArrays(1, &plhs[0], &outputs);
}

void mexFunction(int32_T nlhs, mxArray *plhs[], int32_T nrhs,
                 const mxArray *prhs[])
{
  mexAtExit(&find_number_of_true_positives_given_a_time_delta_hpc_atexit);
  find_number_of_true_positives_given_a_time_delta_hpc_initialize();
  try {
    find_number_of_true_positives_given_a_time_delta_hpc_mexFunction(
        nlhs, plhs, nrhs, prhs);
    find_number_of_true_positives_given_a_time_delta_hpc_terminate();
  } catch (...) {
    emlrtCleanupOnException((emlrtCTX *)emlrtRootTLSGlobal);
    throw;
  }
}

emlrtCTX mexFunctionCreateRootTLS()
{
  emlrtCreateRootTLSR2022a(&emlrtRootTLSGlobal, &emlrtContextGlobal, nullptr, 1,
                           (void *)&emlrtExceptionBridge, "windows-1252", true);
  return emlrtRootTLSGlobal;
}

// End of code generation
// (_coder_find_number_of_true_positives_given_a_time_delta_hpc_mex.cpp)

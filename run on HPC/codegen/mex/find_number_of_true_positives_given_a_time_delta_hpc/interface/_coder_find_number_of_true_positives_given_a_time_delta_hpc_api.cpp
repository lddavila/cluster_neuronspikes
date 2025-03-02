//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
//
// _coder_find_number_of_true_positives_given_a_time_delta_hpc_api.cpp
//
// Code generation for function
// '_coder_find_number_of_true_positives_given_a_time_delta_hpc_api'
//

// Include files
#include "_coder_find_number_of_true_positives_given_a_time_delta_hpc_api.h"
#include "find_number_of_true_positives_given_a_time_delta_hpc.h"
#include "find_number_of_true_positives_given_a_time_delta_hpc_data.h"
#include "find_number_of_true_positives_given_a_time_delta_hpc_emxutil.h"
#include "find_number_of_true_positives_given_a_time_delta_hpc_types.h"
#include "rt_nonfinite.h"

// Variable Definitions
static emlrtRTEInfo i_emlrtRTEI{
    1,                                                                 // lineNo
    1,                                                                 // colNo
    "_coder_find_number_of_true_positives_given_a_time_delta_hpc_api", // fName
    ""                                                                 // pName
};

// Function Declarations
static void b_emlrt_marshallIn(const emlrtStack &sp, const mxArray *src,
                               const emlrtMsgIdentifier *msgId,
                               emxArray_real_T *ret);

static real_T b_emlrt_marshallIn(const emlrtStack &sp, const mxArray *src,
                                 const emlrtMsgIdentifier *msgId);

static void emlrt_marshallIn(const emlrtStack &sp, const mxArray *b_nullptr,
                             const char_T *identifier, emxArray_real_T *y);

static void emlrt_marshallIn(const emlrtStack &sp, const mxArray *u,
                             const emlrtMsgIdentifier *parentId,
                             emxArray_real_T *y);

static real_T emlrt_marshallIn(const emlrtStack &sp, const mxArray *b_nullptr,
                               const char_T *identifier);

static real_T emlrt_marshallIn(const emlrtStack &sp, const mxArray *u,
                               const emlrtMsgIdentifier *parentId);

static const mxArray *emlrt_marshallOut(const real_T u);

// Function Definitions
static void b_emlrt_marshallIn(const emlrtStack &sp, const mxArray *src,
                               const emlrtMsgIdentifier *msgId,
                               emxArray_real_T *ret)
{
  static const int32_T dims[2]{1, -1};
  int32_T iv[2];
  int32_T i;
  boolean_T bv[2]{false, true};
  emlrtCheckVsBuiltInR2012b((emlrtConstCTX)&sp, msgId, src, "double", false, 2U,
                            (const void *)&dims[0], &bv[0], &iv[0]);
  ret->allocatedSize = iv[0] * iv[1];
  i = ret->size[0] * ret->size[1];
  ret->size[0] = iv[0];
  ret->size[1] = iv[1];
  emxEnsureCapacity_real_T(sp, ret, i, static_cast<emlrtRTEInfo *>(nullptr));
  ret->data = static_cast<real_T *>(emlrtMxGetData(src));
  ret->canFreeData = false;
  emlrtDestroyArray(&src);
}

static real_T b_emlrt_marshallIn(const emlrtStack &sp, const mxArray *src,
                                 const emlrtMsgIdentifier *msgId)
{
  static const int32_T dims{0};
  real_T ret;
  emlrtCheckBuiltInR2012b((emlrtConstCTX)&sp, msgId, src, "double", false, 0U,
                          (const void *)&dims);
  ret = *static_cast<real_T *>(emlrtMxGetData(src));
  emlrtDestroyArray(&src);
  return ret;
}

static void emlrt_marshallIn(const emlrtStack &sp, const mxArray *b_nullptr,
                             const char_T *identifier, emxArray_real_T *y)
{
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = const_cast<const char_T *>(identifier);
  thisId.fParent = nullptr;
  thisId.bParentIsCell = false;
  emlrt_marshallIn(sp, emlrtAlias(b_nullptr), &thisId, y);
  emlrtDestroyArray(&b_nullptr);
}

static void emlrt_marshallIn(const emlrtStack &sp, const mxArray *u,
                             const emlrtMsgIdentifier *parentId,
                             emxArray_real_T *y)
{
  b_emlrt_marshallIn(sp, emlrtAlias(u), parentId, y);
  emlrtDestroyArray(&u);
}

static real_T emlrt_marshallIn(const emlrtStack &sp, const mxArray *b_nullptr,
                               const char_T *identifier)
{
  emlrtMsgIdentifier thisId;
  real_T y;
  thisId.fIdentifier = const_cast<const char_T *>(identifier);
  thisId.fParent = nullptr;
  thisId.bParentIsCell = false;
  y = emlrt_marshallIn(sp, emlrtAlias(b_nullptr), &thisId);
  emlrtDestroyArray(&b_nullptr);
  return y;
}

static real_T emlrt_marshallIn(const emlrtStack &sp, const mxArray *u,
                               const emlrtMsgIdentifier *parentId)
{
  real_T y;
  y = b_emlrt_marshallIn(sp, emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}

static const mxArray *emlrt_marshallOut(const real_T u)
{
  const mxArray *m;
  const mxArray *y;
  y = nullptr;
  m = emlrtCreateDoubleScalar(u);
  emlrtAssign(&y, m);
  return y;
}

void c_find_number_of_true_positives(const mxArray *const prhs[3],
                                     const mxArray **plhs)
{
  emlrtStack st{
      nullptr, // site
      nullptr, // tls
      nullptr  // prev
  };
  emxArray_real_T *gt_data;
  emxArray_real_T *ts_of_cluster;
  real_T time_delta;
  st.tls = emlrtRootTLSGlobal;
  emlrtHeapReferenceStackEnterFcnR2012b(&st);
  // Marshall function inputs
  emxInit_real_T(st, &gt_data, i_emlrtRTEI);
  gt_data->canFreeData = false;
  emlrt_marshallIn(st, emlrtAlias(prhs[0]), "gt_data", gt_data);
  emxInit_real_T(st, &ts_of_cluster, i_emlrtRTEI);
  ts_of_cluster->canFreeData = false;
  emlrt_marshallIn(st, emlrtAlias(prhs[1]), "ts_of_cluster", ts_of_cluster);
  time_delta = emlrt_marshallIn(st, emlrtAliasP(prhs[2]), "time_delta");
  // Invoke the target function
  time_delta = find_number_of_true_positives_given_a_time_delta_hpc(
      &st, gt_data, ts_of_cluster, time_delta);
  emxFree_real_T(&st, &ts_of_cluster);
  emxFree_real_T(&st, &gt_data);
  // Marshall function outputs
  *plhs = emlrt_marshallOut(time_delta);
  emlrtHeapReferenceStackLeaveFcnR2012b(&st);
}

// End of code generation
// (_coder_find_number_of_true_positives_given_a_time_delta_hpc_api.cpp)

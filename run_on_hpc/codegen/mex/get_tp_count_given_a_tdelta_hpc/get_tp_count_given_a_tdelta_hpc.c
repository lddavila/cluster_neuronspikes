/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * get_tp_count_given_a_tdelta_hpc.c
 *
 * Code generation for function 'get_tp_count_given_a_tdelta_hpc'
 *
 */

/* Include files */
#include "get_tp_count_given_a_tdelta_hpc.h"
#include "eml_int_forloop_overflow_check.h"
#include "get_tp_count_given_a_tdelta_hpc_emxutil.h"
#include "get_tp_count_given_a_tdelta_hpc_types.h"
#include "rt_nonfinite.h"
#include "mwmathutil.h"
#include <emmintrin.h>

/* Variable Definitions */
static emlrtRSInfo emlrtRSI =
    {
        20,                                /* lineNo */
        "get_tp_count_given_a_tdelta_hpc", /* fcnName */
        "D:\\cluster_neuronspikes\\run_on_hpc\\get_tp_count_given_a_tdelta_hpc."
        "m" /* pathName */
};

static emlrtRSInfo b_emlrtRSI =
    {
        22,                                /* lineNo */
        "get_tp_count_given_a_tdelta_hpc", /* fcnName */
        "D:\\cluster_neuronspikes\\run_on_hpc\\get_tp_count_given_a_tdelta_hpc."
        "m" /* pathName */
};

static emlrtRSInfo c_emlrtRSI = {
    19,                                                         /* lineNo */
    "abs",                                                      /* fcnName */
    "D:\\MATLABR2024b\\toolbox\\eml\\lib\\matlab\\elfun\\abs.m" /* pathName */
};

static emlrtRSInfo d_emlrtRSI = {
    79,                    /* lineNo */
    "applyScalarFunction", /* fcnName */
    "D:\\MATLABR2024b\\toolbox\\eml\\eml\\+coder\\+"
    "internal\\applyScalarFunction.m" /* pathName */
};

static emlrtRSInfo e_emlrtRSI = {
    20,                               /* lineNo */
    "eml_int_forloop_overflow_check", /* fcnName */
    "D:\\MATLABR2024b\\toolbox\\eml\\lib\\matlab\\eml\\eml_int_forloop_"
    "overflow_check.m" /* pathName */
};

static emlrtRSInfo f_emlrtRSI = {
    16,                                                       /* lineNo */
    "any",                                                    /* fcnName */
    "D:\\MATLABR2024b\\toolbox\\eml\\lib\\matlab\\ops\\any.m" /* pathName */
};

static emlrtRSInfo g_emlrtRSI = {
    136,        /* lineNo */
    "allOrAny", /* fcnName */
    "D:\\MATLABR2024b\\toolbox\\eml\\eml\\+coder\\+internal\\allOrAny.m" /* pathName
                                                                          */
};

static emlrtRSInfo h_emlrtRSI = {
    143,        /* lineNo */
    "allOrAny", /* fcnName */
    "D:\\MATLABR2024b\\toolbox\\eml\\eml\\+coder\\+internal\\allOrAny.m" /* pathName
                                                                          */
};

static emlrtRSInfo i_emlrtRSI = {
    15,                                                           /* lineNo */
    "sum",                                                        /* fcnName */
    "D:\\MATLABR2024b\\toolbox\\eml\\lib\\matlab\\datafun\\sum.m" /* pathName */
};

static emlrtRSInfo
    j_emlrtRSI =
        {
            99,        /* lineNo */
            "sumprod", /* fcnName */
            "D:"
            "\\MATLABR2024b\\toolbox\\eml\\lib\\matlab\\datafun\\private\\sumpr"
            "od.m" /* pathName */
};

static emlrtRSInfo k_emlrtRSI = {
    149,                     /* lineNo */
    "combineVectorElements", /* fcnName */
    "D:"
    "\\MATLABR2024b\\toolbox\\eml\\lib\\matlab\\datafun\\private\\combineVector"
    "Elements.m" /* pathName */
};

static emlrtRSInfo l_emlrtRSI = {
    209,                /* lineNo */
    "colMajorFlatIter", /* fcnName */
    "D:"
    "\\MATLABR2024b\\toolbox\\eml\\lib\\matlab\\datafun\\private\\combineVector"
    "Elements.m" /* pathName */
};

static emlrtRTEInfo c_emlrtRTEI =
    {
        20,                                /* lineNo */
        17,                                /* colNo */
        "get_tp_count_given_a_tdelta_hpc", /* fName */
        "D:\\cluster_neuronspikes\\run_on_hpc\\get_tp_count_given_a_tdelta_hpc."
        "m" /* pName */
};

static emlrtRTEInfo d_emlrtRTEI = {
    30,                    /* lineNo */
    21,                    /* colNo */
    "applyScalarFunction", /* fName */
    "D:\\MATLABR2024b\\toolbox\\eml\\eml\\+coder\\+"
    "internal\\applyScalarFunction.m" /* pName */
};

static emlrtRTEInfo e_emlrtRTEI =
    {
        21,                                /* lineNo */
        1,                                 /* colNo */
        "get_tp_count_given_a_tdelta_hpc", /* fName */
        "D:\\cluster_neuronspikes\\run_on_hpc\\get_tp_count_given_a_tdelta_hpc."
        "m" /* pName */
};

static emlrtRTEInfo f_emlrtRTEI =
    {
        22,                                /* lineNo */
        32,                                /* colNo */
        "get_tp_count_given_a_tdelta_hpc", /* fName */
        "D:\\cluster_neuronspikes\\run_on_hpc\\get_tp_count_given_a_tdelta_hpc."
        "m" /* pName */
};

static emlrtRTEInfo g_emlrtRTEI =
    {
        20,                                /* lineNo */
        1,                                 /* colNo */
        "get_tp_count_given_a_tdelta_hpc", /* fName */
        "D:\\cluster_neuronspikes\\run_on_hpc\\get_tp_count_given_a_tdelta_hpc."
        "m" /* pName */
};

/* Function Definitions */
real_T get_tp_count_given_a_tdelta_hpc(const emlrtStack *sp,
                                       const emxArray_real_T *gt_data,
                                       const emxArray_real_T *ts_of_cluster,
                                       real_T time_delta)
{
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack d_st;
  emlrtStack e_st;
  emlrtStack f_st;
  emlrtStack st;
  emxArray_boolean_T *b_x;
  emxArray_boolean_T *mat_of_within_time_delta;
  emxArray_real_T *abs_diffs;
  emxArray_real_T *x;
  const real_T *gt_data_data;
  const real_T *ts_of_cluster_data;
  real_T number_of_true_positives;
  real_T *abs_diffs_data;
  real_T *x_data;
  int32_T b_i;
  int32_T i;
  int32_T i1;
  int32_T i2;
  int32_T loop_ub;
  int32_T vectorUB;
  boolean_T *b_x_data;
  boolean_T *mat_of_within_time_delta_data;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  d_st.prev = &c_st;
  d_st.tls = c_st.tls;
  e_st.prev = &d_st;
  e_st.tls = d_st.tls;
  f_st.prev = &e_st;
  f_st.tls = e_st.tls;
  ts_of_cluster_data = ts_of_cluster->data;
  gt_data_data = gt_data->data;
  emlrtHeapReferenceStackEnterFcnR2012b((emlrtConstCTX)sp);
  /*  tic */
  /* gt_data =gpuArray(gt_data); */
  /* ts_of_cluster = gpuArray(ts_of_cluster); */
  /*  for i=1:length(gt_data) */
  /*      current_gt_spike_ts = gt_data(i); */
  /*      diffs_between_gt_ts_and_clust_ts = abs(current_gt_spike_ts -
   * ts_of_cluster); */
  /*   */
  /*      % [smallest_difference,~] =
   * min(abs(diffs_between_gt_ts_and_clust_ts)); */
  /*      if any(diffs_between_gt_ts_and_clust_ts< time_delta) */
  /*          number_of_true_positives = number_of_true_positives+1; */
  /*      end */
  /*  end */
  /*  vectorized check (faster implementation) */
  /*  mat_rep_of_cluster = repelem(ts_of_cluster,length(gt_data),1); */
  st.site = &emlrtRSI;
  i2 = gt_data->size[1];
  emxInit_real_T(&st, &x, &c_emlrtRTEI);
  i = x->size[0] * x->size[1];
  x->size[0] = gt_data->size[1];
  loop_ub = ts_of_cluster->size[1];
  x->size[1] = ts_of_cluster->size[1];
  emxEnsureCapacity_real_T(&st, x, i, &c_emlrtRTEI);
  x_data = x->data;
  for (i = 0; i < loop_ub; i++) {
    i1 = (i2 / 2) << 1;
    vectorUB = i1 - 2;
    for (b_i = 0; b_i <= vectorUB; b_i += 2) {
      _mm_storeu_pd(&x_data[b_i + x->size[0] * i],
                    _mm_sub_pd(_mm_loadu_pd(&gt_data_data[b_i]),
                               _mm_set1_pd(ts_of_cluster_data[i])));
    }
    for (b_i = i1; b_i < i2; b_i++) {
      x_data[b_i + x->size[0] * i] = gt_data_data[b_i] - ts_of_cluster_data[i];
    }
  }
  b_st.site = &c_emlrtRSI;
  i2 = x->size[0] * x->size[1];
  emxInit_real_T(&b_st, &abs_diffs, &g_emlrtRTEI);
  i = abs_diffs->size[0] * abs_diffs->size[1];
  abs_diffs->size[0] = x->size[0];
  abs_diffs->size[1] = x->size[1];
  emxEnsureCapacity_real_T(&b_st, abs_diffs, i, &d_emlrtRTEI);
  abs_diffs_data = abs_diffs->data;
  c_st.site = &d_emlrtRSI;
  if (i2 > 2147483646) {
    d_st.site = &e_emlrtRSI;
    check_forloop_overflow_error(&d_st);
  }
  for (loop_ub = 0; loop_ub < i2; loop_ub++) {
    abs_diffs_data[loop_ub] = muDoubleScalarAbs(x_data[loop_ub]);
  }
  emxFree_real_T(&b_st, &x);
  emxInit_boolean_T(sp, &mat_of_within_time_delta, &e_emlrtRTEI);
  i = mat_of_within_time_delta->size[0] * mat_of_within_time_delta->size[1];
  mat_of_within_time_delta->size[0] = abs_diffs->size[0];
  b_i = abs_diffs->size[1];
  mat_of_within_time_delta->size[1] = abs_diffs->size[1];
  emxEnsureCapacity_boolean_T(sp, mat_of_within_time_delta, i, &e_emlrtRTEI);
  mat_of_within_time_delta_data = mat_of_within_time_delta->data;
  vectorUB = abs_diffs->size[0] * abs_diffs->size[1];
  for (i = 0; i < vectorUB; i++) {
    mat_of_within_time_delta_data[i] = (abs_diffs_data[i] < time_delta);
  }
  emxFree_real_T(sp, &abs_diffs);
  st.site = &b_emlrtRSI;
  b_st.site = &b_emlrtRSI;
  c_st.site = &f_emlrtRSI;
  emxInit_boolean_T(&c_st, &b_x, &f_emlrtRTEI);
  i = b_x->size[0] * b_x->size[1];
  b_x->size[0] = 1;
  b_x->size[1] = mat_of_within_time_delta->size[1];
  emxEnsureCapacity_boolean_T(&c_st, b_x, i, &f_emlrtRTEI);
  b_x_data = b_x->data;
  vectorUB = mat_of_within_time_delta->size[1];
  for (i = 0; i < vectorUB; i++) {
    b_x_data[i] = false;
  }
  i2 = 0;
  d_st.site = &g_emlrtRSI;
  if (mat_of_within_time_delta->size[1] > 2147483646) {
    e_st.site = &e_emlrtRSI;
    check_forloop_overflow_error(&e_st);
  }
  for (i = 0; i < b_i; i++) {
    boolean_T exitg1;
    loop_ub = i2 + mat_of_within_time_delta->size[0];
    i1 = i2 + 1;
    i2 = loop_ub;
    d_st.site = &h_emlrtRSI;
    if ((i1 <= loop_ub) && (loop_ub > 2147483646)) {
      e_st.site = &e_emlrtRSI;
      check_forloop_overflow_error(&e_st);
    }
    exitg1 = false;
    while ((!exitg1) && (i1 <= loop_ub)) {
      if (mat_of_within_time_delta_data[i1 - 1]) {
        b_x_data[i] = true;
        exitg1 = true;
      } else {
        i1++;
      }
    }
  }
  emxFree_boolean_T(&c_st, &mat_of_within_time_delta);
  b_st.site = &i_emlrtRSI;
  c_st.site = &j_emlrtRSI;
  if (b_x->size[1] == 0) {
    i2 = 0;
  } else {
    d_st.site = &k_emlrtRSI;
    i2 = b_x_data[0];
    e_st.site = &l_emlrtRSI;
    if (b_x->size[1] > 2147483646) {
      f_st.site = &e_emlrtRSI;
      check_forloop_overflow_error(&f_st);
    }
    for (loop_ub = 2; loop_ub <= vectorUB; loop_ub++) {
      i2 += b_x_data[loop_ub - 1];
    }
  }
  emxFree_boolean_T(&c_st, &b_x);
  number_of_true_positives = i2;
  /*  toc */
  emlrtHeapReferenceStackLeaveFcnR2012b((emlrtConstCTX)sp);
  return number_of_true_positives;
}

/* End of code generation (get_tp_count_given_a_tdelta_hpc.c) */

/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: get_tp_count_given_a_tdelta_hpc.c
 *
 * MATLAB Coder version            : 24.2
 * C/C++ source code generated on  : 01-Mar-2025 17:35:26
 */

/* Include Files */
#include "get_tp_count_given_a_tdelta_hpc.h"
#include "abs.h"
#include "any.h"
#include "combineVectorElements.h"
#include "get_tp_count_given_a_tdelta_hpc_emxutil.h"
#include "get_tp_count_given_a_tdelta_hpc_types.h"
#include <emmintrin.h>

/* Function Definitions */
/*
 * tic
 *
 * Arguments    : const emxArray_real_T *gt_data
 *                const emxArray_real_T *ts_of_cluster
 *                double time_delta
 * Return Type  : double
 */
double get_tp_count_given_a_tdelta_hpc(const emxArray_real_T *gt_data,
                                       const emxArray_real_T *ts_of_cluster,
                                       double time_delta)
{
  emxArray_boolean_T *r1;
  emxArray_boolean_T *r3;
  emxArray_real_T *b_gt_data;
  emxArray_real_T *r;
  const double *gt_data_data;
  const double *ts_of_cluster_data;
  double number_of_true_positives;
  double *b_gt_data_data;
  int gt_data_idx_0_tmp;
  int i;
  int i1;
  int loop_ub;
  boolean_T *r2;
  ts_of_cluster_data = ts_of_cluster->data;
  gt_data_data = gt_data->data;
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
  gt_data_idx_0_tmp = gt_data->size[1];
  emxInit_real_T(&b_gt_data, 2);
  i = b_gt_data->size[0] * b_gt_data->size[1];
  b_gt_data->size[0] = gt_data->size[1];
  loop_ub = ts_of_cluster->size[1];
  b_gt_data->size[1] = ts_of_cluster->size[1];
  emxEnsureCapacity_real_T(b_gt_data, i);
  b_gt_data_data = b_gt_data->data;
  for (i = 0; i < loop_ub; i++) {
    int scalarLB;
    int vectorUB;
    scalarLB = (gt_data_idx_0_tmp / 2) << 1;
    vectorUB = scalarLB - 2;
    for (i1 = 0; i1 <= vectorUB; i1 += 2) {
      _mm_storeu_pd(&b_gt_data_data[i1 + b_gt_data->size[0] * i],
                    _mm_sub_pd(_mm_loadu_pd(&gt_data_data[i1]),
                               _mm_set1_pd(ts_of_cluster_data[i])));
    }
    for (i1 = scalarLB; i1 < gt_data_idx_0_tmp; i1++) {
      b_gt_data_data[i1 + b_gt_data->size[0] * i] =
          gt_data_data[i1] - ts_of_cluster_data[i];
    }
  }
  emxInit_real_T(&r, 2);
  b_abs(b_gt_data, r);
  b_gt_data_data = r->data;
  emxFree_real_T(&b_gt_data);
  emxInit_boolean_T(&r1);
  i = r1->size[0] * r1->size[1];
  r1->size[0] = r->size[0];
  r1->size[1] = r->size[1];
  emxEnsureCapacity_boolean_T(r1, i);
  r2 = r1->data;
  gt_data_idx_0_tmp = r->size[0] * r->size[1];
  for (i = 0; i < gt_data_idx_0_tmp; i++) {
    r2[i] = (b_gt_data_data[i] < time_delta);
  }
  emxFree_real_T(&r);
  emxInit_boolean_T(&r3);
  any(r1, r3);
  emxFree_boolean_T(&r1);
  number_of_true_positives = combineVectorElements(r3);
  emxFree_boolean_T(&r3);
  /*  toc */
  return number_of_true_positives;
}

/*
 * File trailer for get_tp_count_given_a_tdelta_hpc.c
 *
 * [EOF]
 */

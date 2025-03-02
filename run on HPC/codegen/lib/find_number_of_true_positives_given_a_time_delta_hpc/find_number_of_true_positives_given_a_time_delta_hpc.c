/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: find_number_of_true_positives_given_a_time_delta_hpc.c
 *
 * MATLAB Coder version            : 24.2
 * C/C++ source code generated on  : 28-Feb-2025 14:17:42
 */

/* Include Files */
#include "find_number_of_true_positives_given_a_time_delta_hpc.h"
#include "any.h"
#include <emmintrin.h>
#include <math.h>

/* Function Definitions */
/*
 * tic
 *
 * Arguments    : const double gt_data[10000]
 *                const double ts_of_cluster[10000]
 *                double time_delta
 * Return Type  : double
 */
double find_number_of_true_positives_given_a_time_delta_hpc(
    const double gt_data[10000], const double ts_of_cluster[10000],
    double time_delta)
{
  static double x[100000000];
  static boolean_T abs_diffs[100000000];
  int k;
  int y;
  boolean_T b_x[10000];
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
  for (k = 0; k < 10000; k++) {
    for (y = 0; y <= 9998; y += 2) {
      _mm_storeu_pd(
          &x[y + 10000 * k],
          _mm_sub_pd(_mm_loadu_pd(&gt_data[y]), _mm_set1_pd(ts_of_cluster[k])));
    }
  }
  for (k = 0; k < 100000000; k++) {
    abs_diffs[k] = (fabs(x[k]) < time_delta);
  }
  any(abs_diffs, b_x);
  y = b_x[0];
  for (k = 0; k < 9999; k++) {
    y += b_x[k + 1];
  }
  return y;
  /*  toc */
}

/*
 * File trailer for find_number_of_true_positives_given_a_time_delta_hpc.c
 *
 * [EOF]
 */

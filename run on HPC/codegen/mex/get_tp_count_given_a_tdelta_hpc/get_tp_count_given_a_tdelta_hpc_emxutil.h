//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
//
// get_tp_count_given_a_tdelta_hpc_emxutil.h
//
// Code generation for function 'get_tp_count_given_a_tdelta_hpc_emxutil'
//

#pragma once

// Include files
#include "rtwtypes.h"
#include "emlrt.h"
#include "mex.h"
#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <cstring>

// Type Declarations
struct emxArray_real_T;

struct emxArray_boolean_T;

// Function Declarations
void emxEnsureCapacity_boolean_T(const emlrtStack *sp,
                                 emxArray_boolean_T *emxArray, int32_T oldNumel,
                                 const emlrtRTEInfo &srcLocation);

void emxEnsureCapacity_real_T(const emlrtStack &sp, emxArray_real_T *emxArray,
                              int32_T oldNumel,
                              const emlrtRTEInfo *srcLocation);

void emxFree_boolean_T(const emlrtStack *sp, emxArray_boolean_T **pEmxArray);

void emxFree_real_T(const emlrtStack *sp, emxArray_real_T **pEmxArray);

void emxInit_boolean_T(const emlrtStack *sp, emxArray_boolean_T **pEmxArray,
                       const emlrtRTEInfo &srcLocation);

void emxInit_real_T(const emlrtStack &sp, emxArray_real_T **pEmxArray,
                    const emlrtRTEInfo &srcLocation);

// End of code generation (get_tp_count_given_a_tdelta_hpc_emxutil.h)

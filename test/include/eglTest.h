//
//  eglTest.h
//  eglTests
//
//  Created by David Andreoletti on 10/11/13.
//  Copyright (c) 2013 David Andreoletti. All rights reserved.
//

#ifndef TEST_INCLUDE_EGLTEST_H_
#define TEST_INCLUDE_EGLTEST_H_

#include "./eglPlatformHarness.h"
#include <assert.h>
#include <string.h>

#define TRUE 1
#define FALSE 0


#define EQUAL                   0
#define NOT_EQUAL               1
#define GREATER_THAN_OR_EQUAL   2
#define LESSER_THAN_OR_EQUAL    3
#define IGNORE                  4
#define STR_CMP_EQUAL           0

#define VALID_NATIVE_DISPLAY    p->validNativeDisplay
#define INVALID_NATIVE_DISPLAY  p->invalidNativeDisplay

#define LAST_INT_RESULT         p->lastIntResult
#define LAST_BOOL_RESULT        p->lastBoolResult
#define LAST_CONSTCHAR_RESULT   p->lastConstCharResult
#define CONSTCHAR_EXPECTED   p->eglConstCharExpected
#define INT_RESULT_EXPECTED         p->intResultExpected

#define MAJOR_VERSION           &(p->eglMajor)
#define MINOR_VERSION           &(p->eglMinor)
#define MAJOR_VERSION_DEFAULT           &(p->eglMajorDefault)
#define MINOR_VERSION_DEFAULT           &(p->eglMinorDefault)
#define MAJOR_VERSION_EXPECTED          &(p->eglMajorExpected)
#define MINOR_VERSION_EXPECTED          &(p->eglMinorExpected)

#define CONFIGS                p->configs
#define CONFIG_SIZE            p->configs_num
#define NUM_CONFIG             &(p->configs_count)
#define NUM_CONFIG_EXPECTED    &(p->eglGetConfigNumExpected)
#define CHOOSE_NUM_CONFIG_EXPECTED    &(p->eglGetConfigNumExpected)

#define ATTRIB_LIST            p->attrib_list

#define INVALID_NATIVE_WINDOW    NULL/*replace with something like p->invalidNativeWindow */
#define VALID_NATIVE_WINDOW    p->validNativeWindow
#define VALID_NEW_NATIVE_WINDOW    p->validNewNativeWindow


#define FOR_EACH(e, arr, arr_size) \
{ \
    for(int i = 0; i<arr_size; i++) { \
    e = arr[i];

#define FOR_EACH_END \
    } \
} \

#define TEST_ASSERT_CMP(l, cmp, r) \
{ \
    switch(cmp) { \
    case EQUAL: { \
        assert(l == r); \
        break; } \
    case NOT_EQUAL: { \
        assert(l != r); \
        break; }\
    case GREATER_THAN_OR_EQUAL: { \
        assert(l >= r); \
        break; }\
    case LESSER_THAN_OR_EQUAL: { \
        assert(l <= r); \
        break; }\
    case IGNORE: { \
        assert(1); \
        break; }\
    default: { \
        assert(0); \
        break; }\
} \
} \

#define TEST_ASSERT_STRCMP(l, cmp, r) \
{ \
    switch(cmp) { \
    case STR_CMP_EQUAL: { \
        assert(strcmp(l, r) == cmp); \
        break; } \
    default: { \
        assert(0); \
        break; }\
} \
}

#define ADDRESS(v) (&(v))
#define DEFERENCE(v) (*v)

#define GENERATE_TEST_COMPARE_FUNCTION(operandTypeName, operandType) \
    static void test_compare_ ## operandTypeName(operandType op0, EGLint comparator, operandType op1) { \
        switch (comparator) { \
        TEST_ASSERT_CASE(EQUAL,==, op0, op1) \
        TEST_ASSERT_CASE(NOT_EQUAL, !=, op0, op1) \
        TEST_ASSERT_CASE(GREATER_THAN_OR_EQUAL, >=, op0, op1) \
        TEST_ASSERT_CASE(LESSER_THAN_OR_EQUAL, <=, op0, op1) \
        TEST_ASSERT_CASE(IGNORE, ==, 1, 1) \
        default: \
            assert(0); \
            break; \
        } \
    }

#define GENERATE_TEST_COMPARE2_FUNCTION(operandTypeName, operandType) \
    static void test_compare_2_ ## operandTypeName(operandType op0, EGLint comparator, operandType op1) { \
        switch (comparator) { \
        case STR_CMP_EQUAL: { \
            assert(strcmp(op0, op1) == 0); \
            break; } \
        default: { \
            assert(0); \
            break; }\
    } \
}

#define TEST_ASSERT_CASE(cmpId, cmpSymbol, op0, op1) \
    case cmpId: \
    { \
        assert(op0 cmpSymbol op1); \
        break;\
    }\

GENERATE_TEST_COMPARE_FUNCTION(EGLint, EGLint)

GENERATE_TEST_COMPARE_FUNCTION(EGLintPtr, EGLint*)

GENERATE_TEST_COMPARE_FUNCTION(EGLBoolean, EGLBoolean)

GENERATE_TEST_COMPARE_FUNCTION(EGLBooleanPtr, EGLBoolean*)

GENERATE_TEST_COMPARE_FUNCTION(EGLenum, EGLenum)

GENERATE_TEST_COMPARE_FUNCTION(ConstCharPtr, const char*)

GENERATE_TEST_COMPARE2_FUNCTION(ConstCharPtr, const char*)

GENERATE_TEST_COMPARE_FUNCTION(EGLDisplay, EGLDisplay)

GENERATE_TEST_COMPARE_FUNCTION(EGLContext, EGLContext)

GENERATE_TEST_COMPARE_FUNCTION(EGLSurface, EGLSurface)

#define TEST_CASE_SETUP(f) setup(f);
#define TEST_CASE_TEARDOWN(f) teardown(f);

#ifdef __cplusplus
extern "C" {
#endif

/**
 * Setup fixture
 */
void setup(TestPlatform* f);

/**
 * Teardown fixture
 */
void teardown(TestPlatform* f);

/*
 * Runs all unit tests
 * @param p
 */
void run_unit_tests(TestPlatform* f);

/*
 * Runs all samples
 * @param p
 */
void run_samples(TestPlatform* f);

#ifdef __cplusplus
}
#endif
    
#endif  // TEST_INCLUDE_EGLTEST_H_

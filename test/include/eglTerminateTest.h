//
//  eglTerminateTest.h
//  eglTests
//
//  Created by David Andreoletti on 10/11/13.
//  Copyright (c) 2013 David Andreoletti. All rights reserved.
//

#ifndef TEST_INCLUDE_EGLTERMINATETEST_H_
#define TEST_INCLUDE_EGLTERMINATETEST_H_

#include "eglTest.h"
#include "eglPlatformHarness.h"

#include <stdlib.h>
#include <string.h>

static void test_eglTerminate(EGLDisplay eglTerminateDisplay, EGLBoolean* eglTerminateBoolResult, EGLBoolean expectedEglTerminateBoolResult, EGLint expectedEglTerminateError)
{
    *eglTerminateBoolResult = eglTerminate(eglTerminateDisplay);
    test_compare_EGLint(eglGetError(), EQUAL, expectedEglTerminateError);
    test_compare_EGLBoolean(*eglTerminateBoolResult, EQUAL, expectedEglTerminateBoolResult);
}

void eglTerminate_0(TestPlatform* p) {
    //TODO
}

/*
 * Runs all eglTerminate unit tests
 * @param p
 */
void run_eglTerminate_unit_tests(TestPlatform* p) {
    TEST_CASE_SETUP(p)
    eglTerminate_0(p);
    TEST_CASE_TEARDOWN(p)
}

#endif  // TEST_INCLUDE_EGLTERMINATETEST_H_

//
//  eglGetReleaseThreadTest.h
//  eglTests
//
//  Created by David Andreoletti on 10/11/13.
//  Copyright (c) 2013 David Andreoletti. All rights reserved.
//

#ifndef TEST_INCLUDE_EGLRELEASETHREADTEST_H_
#define TEST_INCLUDE_EGLRELEASETHREADTEST_H_

#include "eglTest.h"
#include "eglPlatformHarness.h"

#include <stdlib.h>
#include <string.h>

static void test_eglReleaseThreadTest(EGLBoolean* eglReleaseThreadBoolResult, EGLBoolean expectedEglReleaseThreadBoolResult, EGLint expectedEglReleaseThreadTestError)
{
    *eglReleaseThreadBoolResult = eglReleaseThread();
    test_compare_EGLint(eglGetError(), EQUAL, expectedEglReleaseThreadTestError);
    test_compare_EGLBoolean(*eglReleaseThreadBoolResult, EQUAL, expectedEglReleaseThreadBoolResult);
}

void eglReleaseThreadTest_0(TestPlatform* p) {
    //TODO
}

/*
 * Runs all eglReleaseThreadTest unit tests
 * @param p
 */
void run_eglReleaseThread_unit_tests(TestPlatform* p) {
    TEST_CASE_SETUP(p)
    eglGetCurrentSurface_0(p);
    TEST_CASE_TEARDOWN(p)
}

#endif  // TEST_INCLUDE_EGLRELEASETHREADTEST_H_

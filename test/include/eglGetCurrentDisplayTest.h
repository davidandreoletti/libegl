//
//  eglGetCurrentDisplayTesT.h
//  eglTests
//
//  Created by David Andreoletti on 10/11/13.
//  Copyright (c) 2013 David Andreoletti. All rights reserved.
//

#ifndef TEST_INCLUDE_EGLGETCURRENTDISPLAYTEST_H_
#define TEST_INCLUDE_EGLGETCURRENTDISPLAYTEST_H_

#include "eglTest.h"
#include "eglPlatformHarness.h"

#include <stdlib.h>
#include <string.h>

static void test_eglGetCurrentDisplay(EGLDisplay* eglGetCurrentDisplayDisplay, EGLDisplay expectedEglGetCurrentDisplayDisplay, EGLint expectedEglGetCurrentDisplayError)
{
    *eglGetCurrentDisplayDisplay = eglGetCurrentDisplay();
    test_compare_EGLint(eglGetError(), EQUAL, expectedEglGetCurrentDisplayError);
    test_compare_EGLDisplay(*eglGetCurrentDisplayDisplay, EQUAL, expectedEglGetCurrentDisplayDisplay);
}

void eglGetCurrentDisplay_0(TestPlatform* p) {
    //TODO
}

/*
 * Runs all eglGetCurrentDisplay unit tests
 * @param p
 */
void run_eglGetCurrentDisplay_unit_tests(TestPlatform* p) {
    TEST_CASE_SETUP(p)
    eglGetCurrentDisplay_0(p);
    TEST_CASE_TEARDOWN(p)
}

#endif  // TEST_INCLUDE_EGLGETCURRENTDISPLAYTEST_H_

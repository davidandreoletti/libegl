//
//  eglGetCurrentContextTesT.h
//  eglTests
//
//  Created by David Andreoletti on 10/11/13.
//  Copyright (c) 2013 David Andreoletti. All rights reserved.
//

#ifndef TEST_INCLUDE_EGLGETCURRENTTEST_H_
#define TEST_INCLUDE_EGLGETCURRENTTEST_H_

#include "eglTest.h"
#include "eglPlatformHarness.h"

#include <stdlib.h>
#include <string.h>

static void test_eglGetCurrentContext(EGLContext* eglGetCurrentContextContext, EGLContext expectedEglGetCurrentContextContext, EGLint expectedEglGetCurrentContextError)
{
    *eglGetCurrentContextContext = eglGetCurrentContext();
    test_compare_EGLint(eglGetError(), EQUAL, expectedEglGetCurrentContextError);
    test_compare_EGLContext(*eglGetCurrentContextContext, EQUAL, expectedEglGetCurrentContextContext);
}

void eglGetCurrentContext_0(TestPlatform* p) {
    //TODO
}

/*
 * Runs all eglGetCurrentContext unit tests
 * @param p
 */
void run_eglGetCurrentContext_unit_tests(TestPlatform* p) {
    TEST_CASE_SETUP(p)
    eglGetCurrentContext_0(p);
    TEST_CASE_TEARDOWN(p)
}

#endif  // TEST_INCLUDE_EGLGETCURRENTTEST_H_

//
//  eglSwapBuffersTest.h
//  eglTests
//
//  Created by David Andreoletti on 10/11/13.
//  Copyright (c) 2013 David Andreoletti. All rights reserved.
//

#ifndef TEST_INCLUDE_EGLSWAPBUFFERSTEST_H_
#define TEST_INCLUDE_EGLSWAPBUFFERSTEST_H_

#include "eglTest.h"
#include "eglPlatformHarness.h"

#include <stdlib.h>
#include <string.h>

void eglSwapBuffersTest_0(TestPlatform* p) {
    // EGL_TRUE
}

void eglSwapBuffersTest_1(TestPlatform* p) {
    // If surface is not bound to the calling thread’s current context, an EGL_BAD_SURFACE error is generated.
    // TODO To test since Implemented by this lib
}

void eglSwapBuffersTest_2(TestPlatform* p) {
    // If surface is not a valid EGL surface, an EGL_BAD_SURFACE error is generated.
    // TODO To test since Implemented by this lib - not a valid EGL surface == NULL for instance
}


/*
 * Runs all eglSwapBuffersTest unit tests
 * @param p
 */
void run_eglSwapBuffers_unit_tests(TestPlatform* p) {
    TEST_CASE_SETUP(p)
    eglSwapBuffersTest_0(p);
    TEST_CASE_TEARDOWN(p)
    TEST_CASE_SETUP(p)
    eglSwapBuffersTest_1(p);
    TEST_CASE_TEARDOWN(p)
    TEST_CASE_SETUP(p)
    eglSwapBuffersTest_2(p);
    TEST_CASE_TEARDOWN(p)
}

#endif  // TEST_INCLUDE_EGLSWAPBUFFERSTEST_H_

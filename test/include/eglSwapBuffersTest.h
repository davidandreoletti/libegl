/**************************************************************************
 * MIT LICENSE
 *
 * Copyright (c) 2013-2014, David Andreoletti <http://davidandreoletti.com>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 **************************************************************************/

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

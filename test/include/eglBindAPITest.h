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

#ifndef TEST_INCLUDE_EGLBINDAPITEST_H_
#define TEST_INCLUDE_EGLBINDAPITEST_H_

#include "eglTest.h"
#include "eglPlatformHarness.h"

#include <stdlib.h>
#include <string.h>

///
// eglBindAPI/eglQueryAPI
///

static void test_eglBindAPI(EGLenum eglBindAPIApi, EGLBoolean* eglBindAPIBoolResult, EGLBoolean expectedEglBindAPIBoolResult, EGLint expectedEglBindAPIError) {
    *eglBindAPIBoolResult = eglBindAPI(eglBindAPIApi);
    test_compare_EGLBoolean(*eglBindAPIBoolResult, EQUAL, expectedEglBindAPIBoolResult);
    test_compare_EGLint(eglGetError(), EQUAL, expectedEglBindAPIError);
    if (expectedEglBindAPIError == EGL_SUCCESS) {
        EGLenum e = eglQueryAPI();
        test_compare_EGLenum(e, EQUAL, eglBindAPIApi);
        test_compare_EGLint(eglGetError(), EQUAL, EGL_SUCCESS);
    }
}

void eglBindAPI_0(TestPlatform* p) {
    test_eglBindAPI(EGL_OPENGL_ES_API, ADDRESS(LAST_BOOL_RESULT), EGL_TRUE, EGL_SUCCESS);
}

void eglBindAPI_1(TestPlatform* p) {
    // eglBindAPI returns EGL_FALSE on failure. If api is
    // not one of the values specified above, or if the
    // client API specified by api is not supported by the
    // implementation, an EGL_BAD_PARAMETER error is generated.
    test_eglBindAPI((EGL_OPENGL_API + EGL_OPENGL_ES_API + EGL_OPENVG_API), ADDRESS(LAST_BOOL_RESULT), EGL_FALSE, EGL_BAD_PARAMETER);
}

/*
 * Runs all eglBindAPI unit tests
 * @param p
 */
void run_eglBindAPI_unit_tests(TestPlatform* p) {
    TEST_CASE_SETUP(p)
    eglBindAPI_0(p);
    TEST_CASE_TEARDOWN(p)
    TEST_CASE_SETUP(p)
    eglBindAPI_1(p);
    TEST_CASE_TEARDOWN(p)
}

#endif  // TEST_INCLUDE_EGLBINDAPITEST_H_

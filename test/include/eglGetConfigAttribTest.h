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

#ifndef TEST_INCLUDE_EGLGETCONFIGATTRIBTEST_H_
#define TEST_INCLUDE_EGLGETCONFIGATTRIBTEST_H_

#include "eglTest.h"
#include "eglPlatformHarness.h"

#include <stdlib.h>
#include <string.h>

///
// eglGetConfigAttrib
///

static void test_eglGetConfigAttrib(EGLDisplay dpy, EGLConfig eglGetConfigAttribConfig, EGLint eglGetConfigAttribAttribute, EGLint* eglGetConfigAttribValue, EGLint eglGetConfigAttribCMP0, EGLint expectedEglGetConfigAttribValue, EGLBoolean* eglGetConfigAttribBoolResult, EGLBoolean expectedEglGetConfigAttribBoolResult, EGLint expectedEglGetConfigAttribError)
{ \
    *eglGetConfigAttribBoolResult = eglGetConfigAttrib(dpy, eglGetConfigAttribConfig, eglGetConfigAttribAttribute, eglGetConfigAttribValue);
    test_compare_EGLBoolean(*eglGetConfigAttribBoolResult, EQUAL, expectedEglGetConfigAttribBoolResult);
    test_compare_EGLint(eglGetError(), EQUAL, expectedEglGetConfigAttribError);
    if (eglGetConfigAttribValue != NULL) {
        test_compare_EGLint(*eglGetConfigAttribValue, eglGetConfigAttribCMP0, expectedEglGetConfigAttribValue);
    }
}

void eglGetConfigAttrib_0(TestPlatform* p) {
    EGLDisplay dpy;
    test_eglGetDisplay(&dpy, VALID_NATIVE_DISPLAY, EGL_SUCCESS, NOT_EQUAL, NULL);
    test_eglInitialize2(dpy, ADDRESS(LAST_BOOL_RESULT), EQUAL, EGL_TRUE, EGL_SUCCESS);
    test_eglGetConfigs(dpy, CONFIGS, CONFIG_SIZE, NUM_CONFIG, GREATER_THAN_OR_EQUAL, NUM_CONFIG_EXPECTED, ADDRESS(LAST_BOOL_RESULT), EGL_TRUE, EGL_SUCCESS);
    EGLConfig c = NULL;
    FOR_EACH(c, CONFIGS, DEFERENCE((NUM_CONFIG)))
        test_eglGetConfigAttrib(dpy, c, EGL_BUFFER_SIZE, ADDRESS(LAST_INT_RESULT), GREATER_THAN_OR_EQUAL, 0, ADDRESS(LAST_BOOL_RESULT), EGL_TRUE, EGL_SUCCESS);
        test_eglGetConfigAttrib(dpy, c, EGL_MATCH_NATIVE_PIXMAP, ADDRESS(LAST_INT_RESULT), GREATER_THAN_OR_EQUAL, 0, ADDRESS(LAST_BOOL_RESULT), EGL_FALSE, EGL_BAD_ATTRIBUTE);
        test_eglGetConfigAttrib(dpy, c, 0, ADDRESS(LAST_INT_RESULT), GREATER_THAN_OR_EQUAL, 0, ADDRESS(LAST_BOOL_RESULT), EGL_FALSE, EGL_BAD_ATTRIBUTE);
    FOR_EACH_END
}


/*
 * Runs all eglGetConfigAttrib unit tests
 * @param p
 */
void run_eglGetConfigAttrib_unit_tests(TestPlatform* p) {
    TEST_CASE_SETUP(p)
    eglGetConfigAttrib_0(p);
    TEST_CASE_TEARDOWN(p)
}

#endif  // TEST_INCLUDE_EGLGETCONFIGATTRIBTEST_H_

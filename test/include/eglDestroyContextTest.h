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

#ifndef TEST_INCLUDE_EGLDESTROYCONTEXTTEST_H_
#define TEST_INCLUDE_EGLDESTROYCONTEXTTEST_H_

#include "eglTest.h"
#include "eglPlatformHarness.h"

#include <stdlib.h>
#include <string.h>


static void test_eglDestroyContext(EGLDisplay dpy, EGLContext ctx, EGLint expectedEglDestroyContextError, EGLBoolean* eglDestroyContextBoolResult, EGLBoolean expectedEglDestroyContextBoolResult)
{
    *eglDestroyContextBoolResult = eglDestroyContext(dpy, ctx);
    test_compare_EGLint(eglGetError(), EQUAL, expectedEglDestroyContextError);
    test_compare_EGLBoolean(*eglDestroyContextBoolResult, EQUAL, expectedEglDestroyContextBoolResult);
}

void eglDestroyContext_0(TestPlatform* p) {
    // EGL_TRUE is returned the context was destroyed/marked for deletion. EGL_SUCCESS for eglGetError()
    EGLContext ctx;
    EGLDisplay dpy;
    EGLint cattrib_list[3] = {  EGL_RENDERABLE_TYPE, EGL_OPENGL_ES_BIT,
        EGL_NONE};
    EGLint attrib_list[3] = {EGL_CONTEXT_CLIENT_VERSION, 1, EGL_NONE};
    test_eglGetDisplay(&dpy, VALID_NATIVE_DISPLAY, EGL_SUCCESS, NOT_EQUAL, NULL);
    test_eglInitialize2(dpy, ADDRESS(LAST_BOOL_RESULT), EQUAL, EGL_TRUE, EGL_SUCCESS);
    test_eglChooseConfig(dpy, cattrib_list, CONFIGS, CONFIG_SIZE, NUM_CONFIG, GREATER_THAN_OR_EQUAL, NUM_CONFIG_EXPECTED, ADDRESS(LAST_BOOL_RESULT), EQUAL, EGL_TRUE, EGL_SUCCESS);
    test_eglBindAPI(EGL_OPENGL_ES_API, ADDRESS(LAST_BOOL_RESULT), EGL_TRUE, EGL_SUCCESS);
    test_eglCreateContext(dpy, ADDRESS(ctx), CONFIGS[0], NULL, attrib_list, EGL_SUCCESS, NOT_EQUAL, EGL_NO_CONTEXT);
    test_eglDestroyContext(dpy, ctx, EGL_SUCCESS, ADDRESS(LAST_BOOL_RESULT), EGL_TRUE);
}

void eglDestroyContext_1(TestPlatform* p) {
    // An EGL_BAD_CONTEXT error is generated if ctx is not a valid context.
    EGLContext ctx = NULL;
    EGLDisplay dpy;
    test_eglGetDisplay(&dpy, VALID_NATIVE_DISPLAY, EGL_SUCCESS, NOT_EQUAL, NULL);
    test_eglInitialize2(dpy, ADDRESS(LAST_BOOL_RESULT), EQUAL, EGL_TRUE, EGL_SUCCESS);
    test_eglDestroyContext(dpy, ctx, EGL_BAD_CONTEXT, ADDRESS(LAST_BOOL_RESULT), EGL_FALSE);
}

/*
 * Runs all eglDestroyContext unit tests
 * @param p
 */
void run_eglDestroyContext_unit_tests(TestPlatform* p) {
    TEST_CASE_SETUP(p)
    eglDestroyContext_0(p);
    TEST_CASE_TEARDOWN(p)
    TEST_CASE_SETUP(p)
    eglDestroyContext_1(p);
    TEST_CASE_TEARDOWN(p)
}

#endif  // TEST_INCLUDE_EGLDESTROYCONTEXTTEST_H_

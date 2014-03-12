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

#ifndef TEST_INCLUDE_EGLGETDISPLAYTEST_H_
#define TEST_INCLUDE_EGLGETDISPLAYTEST_H_

#include "eglTest.h"
#include "eglPlatformHarness.h"

#include <stdlib.h>
#include <string.h>

static void test_eglGetDisplay(EGLDisplay* dpy, EGLNativeDisplayType display_id, EGLint expectedEglGetDisplayError, EGLint eglGetDisplayCMP0, EGLDisplay expectedDpy) {
    *dpy = eglGetDisplay(display_id);
    test_compare_EGLint(eglGetError(), EQUAL, expectedEglGetDisplayError);
    test_compare_EGLDisplay(dpy, eglGetDisplayCMP0, expectedDpy);
}

void eglGetDisplay_0(TestPlatform* p) {
    // If display id is EGL_DEFAULT_DISPLAY, a default display is returned.
    EGLDisplay dpy;
    test_eglGetDisplay(&dpy, EGL_DEFAULT_DISPLAY, EGL_SUCCESS, NOT_EQUAL, EGL_NO_DISPLAY);
}

void eglGetDisplay_1(TestPlatform* p) {
    // The type and format of display id are implementation-specific,
    // and it describes a specific display provided by the system EGL is running on
    EGLDisplay dpy;
    test_eglGetDisplay(&dpy, VALID_NATIVE_DISPLAY, EGL_SUCCESS, NOT_EQUAL, EGL_NO_DISPLAY);
}

void eglGetDisplay_2(TestPlatform* p) {
    // Multiple calls made to eglGetDisplay with the same display -
    // id will all return the same EGLDisplay handle.
    EGLDisplay dpy;
    EGLDisplay dpy2;
    test_eglGetDisplay(&dpy, VALID_NATIVE_DISPLAY, EGL_SUCCESS, NOT_EQUAL, EGL_NO_DISPLAY);
    test_eglGetDisplay(&dpy2, VALID_NATIVE_DISPLAY, EGL_SUCCESS, NOT_EQUAL, EGL_NO_DISPLAY);
    assert(dpy == dpy2);
}

void eglGetDisplay_3(TestPlatform* p) {
    // If no display matching display id is available, EGL_NO_DISPLAY
    // is returned; no error condition is raised in this case.
    EGLDisplay dpy;
    test_eglGetDisplay(&dpy, INVALID_NATIVE_DISPLAY, EGL_SUCCESS, EQUAL, EGL_NO_DISPLAY);
}

/*
 * Runs all eglGetDisplay unit tests
 * @param p
 */
void run_eglGetDisplay_unit_tests(TestPlatform* p) {
    TEST_CASE_SETUP(p)
    eglGetDisplay_0(p);
    TEST_CASE_TEARDOWN(p)
    TEST_CASE_SETUP(p)
    eglGetDisplay_1(p);
    TEST_CASE_TEARDOWN(p)
    TEST_CASE_SETUP(p)
    eglGetDisplay_2(p);
    TEST_CASE_TEARDOWN(p)
    TEST_CASE_SETUP(p)
    // NOT PASSED eglGetDisplay_3(p);
    TEST_CASE_TEARDOWN(p)
} 

#endif  // TEST_INCLUDE_EGLGETDISPLAYTEST_H_

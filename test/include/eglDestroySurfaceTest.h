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

#ifndef TEST_INCLUDE_EGLDESTROYSURFACETEST_H_
#define TEST_INCLUDE_EGLDESTROYSURFACETEST_H_

#include "eglTest.h"
#include "eglPlatformHarness.h"

#include <stdlib.h>
#include <string.h>

static void test_eglDestroySurface(EGLDisplay dpy, EGLSurface* surf, EGLBoolean* eglDestroySurfaceBoolResult, EGLBoolean expectedEglDestroySurfaceBoolResult, EGLint expectedEglDestroySurfaceResultError)
{
    *eglDestroySurfaceBoolResult = eglDestroySurface(dpy, surf);
    test_compare_EGLBoolean(*eglDestroySurfaceBoolResult, EQUAL, expectedEglDestroySurfaceBoolResult);
    test_compare_EGLint(eglGetError(), EQUAL, expectedEglDestroySurfaceResultError);
}

void eglDestroySurface_0(TestPlatform* p) {
    EGLSurface surf;
    EGLDisplay dpy;
    EGLint cattrib_list[5] = {EGL_COLOR_BUFFER_TYPE, EGL_RGB_BUFFER,
        EGL_RED_SIZE, 1,
        EGL_NONE};
    EGLint wattrib_list[3] = {  EGL_RENDER_BUFFER, EGL_BACK_BUFFER,
        EGL_NONE};

    test_eglGetDisplay(&dpy, VALID_NATIVE_DISPLAY, EGL_SUCCESS, NOT_EQUAL, NULL);
    test_eglInitialize2(dpy, ADDRESS(LAST_BOOL_RESULT), EQUAL, EGL_TRUE, EGL_SUCCESS);
    test_eglChooseConfig(dpy, cattrib_list, CONFIGS, CONFIG_SIZE, NUM_CONFIG, GREATER_THAN_OR_EQUAL, NUM_CONFIG_EXPECTED, ADDRESS(LAST_BOOL_RESULT), EQUAL, EGL_TRUE, EGL_SUCCESS);
    test_eglCreateWindowSurface(dpy, &surf, CONFIGS[0], VALID_NATIVE_WINDOW, wattrib_list, NOT_EQUAL, EGL_NO_SURFACE, EGL_SUCCESS);
    test_eglDestroySurface(dpy, surf, ADDRESS(LAST_BOOL_RESULT), EGL_TRUE, EGL_SUCCESS);
}

void eglDestroySurface_1(TestPlatform* p) {
    // An EGL_BAD_SURFACE error is generated if surface is not a valid rendering surface.
    EGLSurface surf = NULL;
    EGLDisplay dpy;
    test_eglGetDisplay(&dpy, VALID_NATIVE_DISPLAY, EGL_SUCCESS, NOT_EQUAL, NULL);
    test_eglInitialize2(dpy, ADDRESS(LAST_BOOL_RESULT), EQUAL, EGL_TRUE, EGL_SUCCESS);
    test_eglDestroySurface(dpy, surf, ADDRESS(LAST_BOOL_RESULT), EGL_FALSE, EGL_BAD_SURFACE);
}

void eglDestroySurface_2(TestPlatform* p) {
    // Following eglDestroySurface, the surface and the handle referring to it are
    // treated in the same fashion as a surface destroyed by eglTerminate (Section 3.2)
    //
    // (Section 3.2) Handles to all such resources are invalid as soon
    // as eglTerminate returns
    EGLSurface surf;
    EGLDisplay dpy;
    EGLint cattrib_list[5] = {EGL_COLOR_BUFFER_TYPE, EGL_RGB_BUFFER,
        EGL_RED_SIZE, 1,
        EGL_NONE};
    EGLint wattrib_list[3] = {  EGL_RENDER_BUFFER, EGL_BACK_BUFFER,
        EGL_NONE};
    
    test_eglGetDisplay(&dpy, VALID_NATIVE_DISPLAY, EGL_SUCCESS, NOT_EQUAL, NULL);
    test_eglInitialize2(dpy, ADDRESS(LAST_BOOL_RESULT), EQUAL, EGL_TRUE, EGL_SUCCESS);
    test_eglChooseConfig(dpy, cattrib_list, CONFIGS, CONFIG_SIZE, NUM_CONFIG, GREATER_THAN_OR_EQUAL, NUM_CONFIG_EXPECTED, ADDRESS(LAST_BOOL_RESULT), EQUAL, EGL_TRUE, EGL_SUCCESS);
    test_eglCreateWindowSurface(dpy, &surf, CONFIGS[0], VALID_NATIVE_WINDOW, wattrib_list, NOT_EQUAL, EGL_NO_SURFACE, EGL_SUCCESS);
    test_eglDestroySurface(dpy, surf, ADDRESS(LAST_BOOL_RESULT), EGL_TRUE, EGL_SUCCESS);
    test_eglDestroySurface(dpy, surf, ADDRESS(LAST_BOOL_RESULT), EGL_FALSE, EGL_BAD_SURFACE);
}

/*
 * Runs all eglDestroyWindow unit tests
 * @param p
 */
void run_eglDestroySurface_unit_tests(TestPlatform* p) {
    TEST_CASE_SETUP(p)
    eglDestroySurface_0(p);
    TEST_CASE_TEARDOWN(p)
    TEST_CASE_SETUP(p)
    eglDestroySurface_1(p);
    TEST_CASE_TEARDOWN(p)
    TEST_CASE_SETUP(p)
    eglDestroySurface_2(p);
    TEST_CASE_TEARDOWN(p)
}

#endif  // TEST_INCLUDE_EGLDESTROYSURFACETEST_H_

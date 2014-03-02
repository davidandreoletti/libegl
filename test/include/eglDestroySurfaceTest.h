//
//  eglDestroySurfaceTest.h
//  eglTests
//
//  Created by David Andreoletti on 10/11/13.
//  Copyright (c) 2013 David Andreoletti. All rights reserved.
//

#ifndef TEST_INCLUDE_EGLDESTROYSURFACETEST_H_
#define TEST_INCLUDE_EGLDESTROYSURFACETEST_H_

#include "eglTest.h"
#include "eglPlatformHarness.h"

#include <stdlib.h>
#include <string.h>

static void test_eglDestroySurface(EGLDisplay dpy, EGLSurface surf, EGLBoolean* eglDestroySurfaceBoolResult, EGLBoolean expectedEglDestroySurfaceBoolResult, EGLint expectedEglDestroySurfaceResultError)
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
    EGLSurface surf = NULL;
    EGLDisplay dpy;
    test_eglGetDisplay(&dpy, VALID_NATIVE_DISPLAY, EGL_SUCCESS, NOT_EQUAL, NULL);
    test_eglInitialize2(dpy, ADDRESS(LAST_BOOL_RESULT), EQUAL, EGL_TRUE, EGL_SUCCESS);
    test_eglDestroySurface(dpy, surf, ADDRESS(LAST_BOOL_RESULT), EGL_FALSE, EGL_BAD_SURFACE);
}

/*
 * Runs all eglCreateWindowSurface unit tests
 * @param p
 */
void run_eglDestroySurface_unit_tests(TestPlatform* p) {
    TEST_CASE_SETUP(p)
    eglDestroySurface_0(p);
    TEST_CASE_TEARDOWN(p)
    TEST_CASE_SETUP(p)
    eglDestroySurface_1(p);
    TEST_CASE_TEARDOWN(p)
}

#endif  // TEST_INCLUDE_EGLDESTROYSURFACETEST_H_

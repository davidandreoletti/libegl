//
//  eglQuerySurfaceTest.h
//  eglTests
//
//  Created by David Andreoletti on 10/11/13.
//  Copyright (c) 2013 David Andreoletti. All rights reserved.
//

#ifndef TEST_INCLUDE_EGLQUERYSURFACETEST_H_
#define TEST_INCLUDE_EGLQUERYSURFACETEST_H_

#include "eglTest.h"
#include "eglPlatformHarness.h"

#include <stdlib.h>
#include <string.h>


static void test_eglQuerySurface(EGLDisplay dpy, EGLSurface surface, EGLint eglQuerySurfaceAttribute, EGLint *eglQuerySurfaceValue, EGLBoolean* eglQuerySurfaceBoolResult, EGLBoolean expectedEglQuerySurfaceBoolResult, EGLint eglQuerySurfaceCMP0, EGLint expectedEglQuerySurfaceValue, EGLint expectedEglQuerySurfaceError)
{
    *eglQuerySurfaceBoolResult = eglQuerySurface(dpy, surface, eglQuerySurfaceAttribute, eglQuerySurfaceValue);
    test_compare_EGLint(eglGetError(), EQUAL, expectedEglQuerySurfaceError);
    test_compare_EGLBoolean(*eglQuerySurfaceBoolResult, EQUAL, expectedEglQuerySurfaceBoolResult);
    test_compare_EGLint(expectedEglQuerySurfaceValue, eglQuerySurfaceCMP0, *eglQuerySurfaceValue);
}

void eglQuerySurface_0(TestPlatform* p) {
    // eglQuerySurface returns the value for an attribute
    EGLSurface surf;
    EGLDisplay dpy;
    EGLint cattrib_list[5] = {EGL_COLOR_BUFFER_TYPE, EGL_RGB_BUFFER,
        EGL_RED_SIZE, 1,
        EGL_NONE};
    EGLint wattrib_list[3] = {  EGL_RENDER_BUFFER, EGL_BACK_BUFFER,
        EGL_NONE};
    EGLint value = 0;
    
    test_eglGetDisplay(&dpy, VALID_NATIVE_DISPLAY, EGL_SUCCESS, NOT_EQUAL, NULL);
    test_eglInitialize2(dpy, ADDRESS(LAST_BOOL_RESULT), EQUAL, EGL_TRUE, EGL_SUCCESS);
    test_eglChooseConfig(dpy, cattrib_list, CONFIGS, CONFIG_SIZE, NUM_CONFIG, GREATER_THAN_OR_EQUAL, NUM_CONFIG_EXPECTED, ADDRESS(LAST_BOOL_RESULT), EQUAL, EGL_TRUE, EGL_SUCCESS);
    test_eglCreateWindowSurface(dpy, &surf, CONFIGS[0], VALID_NATIVE_WINDOW, wattrib_list, NOT_EQUAL, EGL_NO_SURFACE, EGL_SUCCESS);
    test_eglQuerySurface(dpy, surf, EGL_CONFIG_ID, &value, ADDRESS(LAST_BOOL_RESULT), EGL_TRUE, EQUAL, 1, EGL_SUCCESS);
}

/*
 * Runs all eglQuerySurface unit tests
 * @param p
 */
void run_eglQuerySurface_unit_tests(TestPlatform* p) {
    TEST_CASE_SETUP(p)
    eglQuerySurface_0(p);
    TEST_CASE_TEARDOWN(p)
}

#endif  // TEST_INCLUDE_EGLQUERYSURFACETEST_H_

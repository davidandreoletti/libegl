//
//  eglGetConfigAttribTest.h
//  eglTests
//
//  Created by David Andreoletti on 10/11/13.
//  Copyright (c) 2013 David Andreoletti. All rights reserved.
//

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

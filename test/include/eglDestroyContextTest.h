//
//  eglDestroyContextTest.h
//  eglTests
//
//  Created by David Andreoletti on 10/11/13.
//  Copyright (c) 2013 David Andreoletti. All rights reserved.
//

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

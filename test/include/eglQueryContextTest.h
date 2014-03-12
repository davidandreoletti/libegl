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

#ifndef TEST_INCLUDE_EGLQUERYCONTEXTTEST_H_
#define TEST_INCLUDE_EGLQUERYCONTEXTTEST_H_

#include "eglTest.h"
#include "eglPlatformHarness.h"

#include <stdlib.h>
#include <string.h>


static void test_eglQueryContext(EGLDisplay dpy, EGLContext context, EGLint eglQueryContextAttribute, EGLint *eglQueryContextValue, EGLBoolean* eglQueryContextBoolResult, EGLBoolean expectedeglQueryContextBoolResult, EGLint eglQueryContextCMP0, EGLint expectedeglQueryContextValue, EGLint expectedeglQueryContextError)
{
    *eglQueryContextBoolResult = eglQueryContext(dpy, context, eglQueryContextAttribute, eglQueryContextValue);
    test_compare_EGLint(eglGetError(), EQUAL, expectedeglQueryContextError);
    test_compare_EGLBoolean(*eglQueryContextBoolResult, EQUAL, expectedeglQueryContextBoolResult);
    test_compare_EGLint(*eglQueryContextValue, eglQueryContextCMP0, expectedeglQueryContextValue);
}

void eglQueryContext_0(TestPlatform* p) {
    // eglQueryContext returns in value the value of attribute for ctx.
    // attribute must be set to EGL_CONFIG_ID, EGL_CONTEXT_CLIENT_TYPE,
    // EGL_CONTEXT_- CLIENT_VERSION, or EGL_RENDER_BUFFER.
    EGLContext ctx;
    EGLDisplay dpy;
    
    EGLint cattrib_list2[3] = { EGL_RENDERABLE_TYPE, EGL_OPENGL_ES2_BIT,
        EGL_NONE};
    EGLint attrib_list2[3] = {EGL_CONTEXT_CLIENT_VERSION, 2, EGL_NONE};
    test_eglGetDisplay(&dpy, VALID_NATIVE_DISPLAY, EGL_SUCCESS, NOT_EQUAL, NULL);
    test_eglInitialize2(dpy, ADDRESS(LAST_BOOL_RESULT), EQUAL, EGL_TRUE, EGL_SUCCESS);
    test_eglChooseConfig(dpy, cattrib_list2, CONFIGS, CONFIG_SIZE, NUM_CONFIG, GREATER_THAN_OR_EQUAL, NUM_CONFIG_EXPECTED, ADDRESS(LAST_BOOL_RESULT), EQUAL, EGL_TRUE, EGL_SUCCESS);
    test_eglBindAPI(EGL_OPENGL_ES_API, ADDRESS(LAST_BOOL_RESULT), EGL_TRUE, EGL_SUCCESS);
    test_eglCreateContext(dpy, ADDRESS(ctx), CONFIGS[0], NULL, attrib_list2, EGL_SUCCESS, NOT_EQUAL, EGL_NO_CONTEXT);
    
    EGLint attributes[4] = {EGL_CONFIG_ID, EGL_CONTEXT_CLIENT_TYPE, EGL_CONTEXT_CLIENT_VERSION, EGL_RENDER_BUFFER};
    EGLint count = sizeof(attributes)/sizeof(EGLint);
    for (EGLint i=0; i<count; i++) {
        test_eglQueryContext(dpy, ctx, attributes[i], ADDRESS(LAST_INT_RESULT), ADDRESS(LAST_BOOL_RESULT), EGL_TRUE, GREATER_THAN_OR_EQUAL, 0, EGL_SUCCESS);
    }
}

void eglQueryContext_1(TestPlatform* p) {
    // If attribute is not a valid EGL context attribute, then an EGL_BAD_ATTRIBUTE error is generated.
    EGLContext ctx;
    EGLDisplay dpy;
    EGLint cattrib_list2[3] = { EGL_RENDERABLE_TYPE, EGL_OPENGL_ES2_BIT,
        EGL_NONE};
    EGLint attrib_list2[3] = {EGL_CONTEXT_CLIENT_VERSION, 2, EGL_NONE};
    test_eglGetDisplay(&dpy, VALID_NATIVE_DISPLAY, EGL_SUCCESS, NOT_EQUAL, NULL);
    test_eglInitialize2(dpy, ADDRESS(LAST_BOOL_RESULT), EQUAL, EGL_TRUE, EGL_SUCCESS);
    test_eglChooseConfig(dpy, cattrib_list2, CONFIGS, CONFIG_SIZE, NUM_CONFIG, GREATER_THAN_OR_EQUAL, NUM_CONFIG_EXPECTED, ADDRESS(LAST_BOOL_RESULT), EQUAL, EGL_TRUE, EGL_SUCCESS);
    test_eglBindAPI(EGL_OPENGL_ES_API, ADDRESS(LAST_BOOL_RESULT), EGL_TRUE, EGL_SUCCESS);
    test_eglCreateContext(dpy, ADDRESS(ctx), CONFIGS[0], NULL, attrib_list2, EGL_SUCCESS, NOT_EQUAL, EGL_NO_CONTEXT);
    
    EGLint attribute = EGL_CONFIG_ID + EGL_CONTEXT_CLIENT_TYPE + EGL_CONTEXT_CLIENT_VERSION + EGL_RENDER_BUFFER;
    test_eglQueryContext(dpy, ctx, attribute, ADDRESS(LAST_INT_RESULT), ADDRESS(LAST_BOOL_RESULT), EGL_FALSE, GREATER_THAN_OR_EQUAL, LAST_INT_RESULT, EGL_BAD_ATTRIBUTE);
}

void eglQueryContext_2(TestPlatform* p) {
    // If ctx is invalid, an EGL_BAD_CONTEXT error is generated.
    EGLContext ctx = NULL;
    EGLDisplay dpy;
    EGLint cattrib_list2[3] = { EGL_RENDERABLE_TYPE, EGL_OPENGL_ES2_BIT,
        EGL_NONE};
    test_eglGetDisplay(&dpy, VALID_NATIVE_DISPLAY, EGL_SUCCESS, NOT_EQUAL, NULL);
    test_eglInitialize2(dpy, ADDRESS(LAST_BOOL_RESULT), EQUAL, EGL_TRUE, EGL_SUCCESS);
    test_eglChooseConfig(dpy, cattrib_list2, CONFIGS, CONFIG_SIZE, NUM_CONFIG, GREATER_THAN_OR_EQUAL, NUM_CONFIG_EXPECTED, ADDRESS(LAST_BOOL_RESULT), EQUAL, EGL_TRUE, EGL_SUCCESS);
    test_eglBindAPI(EGL_OPENGL_ES_API, ADDRESS(LAST_BOOL_RESULT), EGL_TRUE, EGL_SUCCESS);
    
    test_eglQueryContext(dpy, ctx, EGL_CONFIG_ID, ADDRESS(LAST_INT_RESULT), ADDRESS(LAST_BOOL_RESULT), EGL_FALSE, GREATER_THAN_OR_EQUAL, LAST_INT_RESULT, EGL_BAD_CONTEXT);
}

/*
 * Runs all eglQueryContext unit tests
 * @param p
 */
void run_eglQueryContext_unit_tests(TestPlatform* p) {
    TEST_CASE_SETUP(p)
    eglQueryContext_0(p);
    TEST_CASE_TEARDOWN(p)
    TEST_CASE_SETUP(p)
    eglQueryContext_1(p);
    TEST_CASE_TEARDOWN(p)
    TEST_CASE_SETUP(p)
    eglQueryContext_2(p);
    TEST_CASE_TEARDOWN(p)
}

#endif  // TEST_INCLUDE_EGLQUERYCONTEXTTEST_H_

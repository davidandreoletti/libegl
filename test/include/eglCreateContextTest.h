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

#ifndef TEST_INCLUDE_EGLCREATECONTEXTTEST_H_
#define TEST_INCLUDE_EGLCREATECONTEXTTEST_H_

#include "eglTest.h"
#include "eglPlatformHarness.h"

#include <stdlib.h>
#include <string.h>

static void test_eglCreateContext(EGLDisplay dpy, EGLContext* ctx, EGLConfig eglCreateContextConfig, EGLContext eglCreateContextShared_contex, const EGLint* eglCreateContextAttrib_list, EGLint expectedEglCreateContextError, EGLint eglCreateContextCMP0, EGLContext expectedEglCreateContextContext)
{
    *ctx = eglCreateContext(dpy, eglCreateContextConfig, eglCreateContextShared_contex, eglCreateContextAttrib_list);
    test_compare_EGLint(eglGetError(), EQUAL, expectedEglCreateContextError);
    test_compare_EGLContext(*ctx, eglCreateContextCMP0, expectedEglCreateContextContext);
}

void eglCreateContext_0(TestPlatform* p) {
    // If the current rendering api is EGL_NONE, then an
    // EGL_BAD_MATCH error is generated (this situation can
    // only arise in an implementation which does not support
    // OpenGL_ES , and prior to the first call to eglBindAPI)
    if (eglQueryAPI() == EGL_NONE) {
        EGLContext ctx;
        EGLDisplay dpy;
        EGLint cattrib_list[1] = {EGL_NONE};
    	EGLint attrib_list[2] = {EGL_CONTEXT_CLIENT_VERSION, 1};
        
        test_eglGetDisplay(&dpy, VALID_NATIVE_DISPLAY, EGL_SUCCESS, NOT_EQUAL, NULL);
        test_eglInitialize2(dpy, ADDRESS(LAST_BOOL_RESULT), EQUAL, EGL_TRUE, EGL_SUCCESS);
        test_eglChooseConfig(dpy, cattrib_list, CONFIGS, CONFIG_SIZE, NUM_CONFIG, GREATER_THAN_OR_EQUAL, NUM_CONFIG_EXPECTED, ADDRESS(LAST_BOOL_RESULT), EQUAL, EGL_TRUE, EGL_SUCCESS);
        test_eglCreateContext(dpy, ADDRESS(ctx), CONFIGS, NULL, attrib_list, EGL_BAD_MATCH, EQUAL, EGL_NO_CONTEXT);
    }
}

void eglCreateContext_1(TestPlatform* p) {
    // if eglCreateContext succeeds, it initializes the context
    // to the initial state de- fined for the current rendering API,
    // and returns a handle to it.
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
    
    EGLint cattrib_list2[3] = { EGL_RENDERABLE_TYPE, EGL_OPENGL_ES2_BIT,
        EGL_NONE};
    EGLint attrib_list2[3] = {EGL_CONTEXT_CLIENT_VERSION, 2, EGL_NONE};
    test_eglGetDisplay(&dpy, VALID_NATIVE_DISPLAY, EGL_SUCCESS, NOT_EQUAL, NULL);
    test_eglInitialize2(dpy, ADDRESS(LAST_BOOL_RESULT), EQUAL, EGL_TRUE, EGL_SUCCESS);
    test_eglChooseConfig(dpy, cattrib_list2, CONFIGS, CONFIG_SIZE, NUM_CONFIG, GREATER_THAN_OR_EQUAL, NUM_CONFIG_EXPECTED, ADDRESS(LAST_BOOL_RESULT), EQUAL, EGL_TRUE, EGL_SUCCESS);
    test_eglBindAPI(EGL_OPENGL_ES_API, ADDRESS(LAST_BOOL_RESULT), EGL_TRUE, EGL_SUCCESS);
    test_eglCreateContext(dpy, ADDRESS(ctx), CONFIGS[0], NULL, attrib_list2, EGL_SUCCESS, NOT_EQUAL, EGL_NO_CONTEXT);
}

void eglCreateContext_2(TestPlatform* p) {
    // On failure eglCreateContext returns EGL_NO_CONTEXT
    // If config is not a valid EGLConfig, or does not support the requested client API ,
    // then an EGL_BAD_CONFIG error is generated (this includes requesting cre- ation of
    // an OpenGL ES 1.x context when the EGL_RENDERABLE_TYPE attribute of config does not
    // contain EGL_OPENGL_ES_BIT, or creation of an OpenGL ES 2.x context when the
    // attribute does not contain EGL_OPENGL_ES2_BIT).
    EGLContext ctx;
    EGLDisplay dpy;
    EGLint cattrib_list[3] = {  EGL_RENDERABLE_TYPE, EGL_OPENGL_ES2_BIT,
        EGL_NONE};
    EGLint attrib_list[3] = {EGL_CONTEXT_CLIENT_VERSION, 1, EGL_NONE};
    test_eglGetDisplay(&dpy, VALID_NATIVE_DISPLAY, EGL_SUCCESS, NOT_EQUAL, NULL);
    test_eglInitialize2(dpy, ADDRESS(LAST_BOOL_RESULT), EQUAL, EGL_TRUE, EGL_SUCCESS);
    test_eglChooseConfig(dpy, cattrib_list, CONFIGS, CONFIG_SIZE, NUM_CONFIG, GREATER_THAN_OR_EQUAL, NUM_CONFIG_EXPECTED, ADDRESS(LAST_BOOL_RESULT), EQUAL, EGL_TRUE, EGL_SUCCESS);
    test_eglCreateContext(dpy, ADDRESS(ctx), CONFIGS, NULL, attrib_list, EGL_BAD_CONFIG, EQUAL, EGL_NO_CONTEXT);
}

void eglCreateContext_3(TestPlatform* p) {
    // If the server does not have enough resources to allocate the new context, then an EGL_BAD_ALLOC error is generated.
    // TODO THis implementation reports this
}


/*
 * Runs all eglCreateContext unit tests
 * @param p
 */
void run_eglCreateContext_unit_tests(TestPlatform* p) {
    TEST_CASE_SETUP(p)
    eglCreateContext_0(p);
    TEST_CASE_TEARDOWN(p)
    TEST_CASE_SETUP(p)
    eglCreateContext_1(p);
    TEST_CASE_TEARDOWN(p)
    TEST_CASE_SETUP(p)
    eglCreateContext_2(p);
    TEST_CASE_TEARDOWN(p)
    TEST_CASE_SETUP(p)
    eglCreateContext_3(p);
    TEST_CASE_TEARDOWN(p)
}

#endif  // TEST_INCLUDE_EGLCREATECONTEXTTEST_H_

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

#ifndef TEST_INCLUDE_EGLGETCONFIGSTEST_H_
#define TEST_INCLUDE_EGLGETCONFIGSTEST_H_

#include "eglTest.h"
#include "eglPlatformHarness.h"

#include <stdlib.h>
#include <string.h>

static void test_eglGetConfigs(EGLDisplay dpy, EGLConfig* eglGetConfigsConfigs, EGLint eglGetConfigsConfig_size, EGLint* eglGetConfigsNum_config, EGLint expectedEglGetConfigsCMP0, EGLint *expectedEglGetConfigsNum_config, EGLBoolean* eglGetConfigsBoolResult, EGLBoolean expectedEglGetConfigsBoolResult, EGLint expectedEglGetConfigsError) \
{
    *eglGetConfigsBoolResult = eglGetConfigs(dpy, eglGetConfigsConfigs, eglGetConfigsConfig_size, eglGetConfigsNum_config);
    test_compare_EGLBoolean(*eglGetConfigsBoolResult, EQUAL, expectedEglGetConfigsBoolResult);
    test_compare_EGLint(eglGetError(), EQUAL, expectedEglGetConfigsError);
    if (eglGetConfigsNum_config != NULL) {
        test_compare_EGLint(*eglGetConfigsNum_config, expectedEglGetConfigsCMP0, *expectedEglGetConfigsNum_config);
    }
}

void eglGetConfigs_0(TestPlatform* p) {
    // if eglGetConfigs is called configs = NULL, then no configurations
    // are returned, but the total number of configurations available will be
    // returned in num config
    EGLDisplay dpy;
    EGLConfig* configs = NULL;
    
    test_eglGetDisplay(&dpy, VALID_NATIVE_DISPLAY, EGL_SUCCESS, NOT_EQUAL, NULL);
    test_eglInitialize2(dpy, ADDRESS(LAST_BOOL_RESULT), EQUAL, EGL_TRUE, EGL_SUCCESS);
    test_eglGetConfigs(dpy, configs, CONFIG_SIZE, NUM_CONFIG, GREATER_THAN_OR_EQUAL, NUM_CONFIG_EXPECTED, ADDRESS(LAST_BOOL_RESULT), EGL_TRUE, EGL_SUCCESS);
}

void eglGetConfigs_1(TestPlatform* p) {
    // An EGL_NOT_INITIALIZED error is gen- erated if EGL is not initialized on dpy
    EGLDisplay dpy;
    
    test_eglGetDisplay(&dpy, EGL_DEFAULT_DISPLAY, EGL_SUCCESS, NOT_EQUAL, NULL);
    test_eglGetConfigs(dpy, CONFIGS, CONFIG_SIZE, NUM_CONFIG, GREATER_THAN_OR_EQUAL, NUM_CONFIG_EXPECTED, ADDRESS(LAST_BOOL_RESULT), EGL_FALSE, EGL_NOT_INITIALIZED);
}

void eglGetConfigs_2(TestPlatform* p) {
    // An EGL_BAD_PARAMETER error is gener- ated if num config is NULL.
    EGLDisplay dpy;
    EGLint* i = NULL;
    
    test_eglGetDisplay(&dpy, VALID_NATIVE_DISPLAY, EGL_SUCCESS, NOT_EQUAL, NULL);
    test_eglInitialize2(dpy, ADDRESS(LAST_BOOL_RESULT), EQUAL, EGL_TRUE, EGL_SUCCESS);
    test_eglGetConfigs(dpy, CONFIGS, CONFIG_SIZE, i, EQUAL, i, ADDRESS(LAST_BOOL_RESULT), EGL_FALSE, EGL_BAD_PARAMETER);
}

void eglGetConfigs_3(TestPlatform* p) {
    // On success, EGL_TRUE is returned
    EGLDisplay dpy;
    
    test_eglGetDisplay(&dpy, VALID_NATIVE_DISPLAY, EGL_SUCCESS, NOT_EQUAL, NULL);
    test_eglInitialize2(dpy, ADDRESS(LAST_BOOL_RESULT), EQUAL, EGL_TRUE, EGL_SUCCESS);
    test_eglGetConfigs(dpy, NULL, 0, NUM_CONFIG, GREATER_THAN_OR_EQUAL, NUM_CONFIG_EXPECTED, ADDRESS(LAST_BOOL_RESULT), EGL_TRUE, EGL_SUCCESS);
}

void eglGetConfigs_4(TestPlatform* p) {
    // The number of configurations is returned in num_config, and elements 0
    // through num_config − 1 of configs are filled in with the valid EGLConfigs.
    // No more than config_size EGLConfigs will be returned even if more are
    // available on the specified display.
    EGLDisplay dpy;
    
    test_eglGetDisplay(&dpy, VALID_NATIVE_DISPLAY, EGL_SUCCESS, NOT_EQUAL, NULL);
    test_eglInitialize2(dpy, ADDRESS(LAST_BOOL_RESULT), EQUAL, EGL_TRUE, EGL_SUCCESS);
    test_eglGetConfigs(dpy, CONFIGS, CONFIG_SIZE, NUM_CONFIG, GREATER_THAN_OR_EQUAL, NUM_CONFIG_EXPECTED, ADDRESS(LAST_BOOL_RESULT), EGL_TRUE, EGL_SUCCESS);

    EGLConfig c = NULL;
    FOR_EACH(c, CONFIGS, DEFERENCE((NUM_CONFIG)))
    TEST_ASSERT_CMP(c, NOT_EQUAL, NULL)
    FOR_EACH_END
}

/*
 * Runs all eglGetConfigs unit tests
 * @param p
 */
void run_eglGetConfigs_unit_tests(TestPlatform* p) {
    TEST_CASE_SETUP(p)
    eglGetConfigs_0(p);
    TEST_CASE_TEARDOWN(p)
    TEST_CASE_SETUP(p)
    eglGetConfigs_1(p);
    TEST_CASE_TEARDOWN(p)
    TEST_CASE_SETUP(p)
    eglGetConfigs_2(p);
    TEST_CASE_TEARDOWN(p)
    TEST_CASE_SETUP(p)
    eglGetConfigs_3(p);
    TEST_CASE_TEARDOWN(p)
    TEST_CASE_SETUP(p)
    eglGetConfigs_4(p);
    TEST_CASE_TEARDOWN(p)
}

#endif  // TEST_INCLUDE_EGLGETCONFIGSTEST_H_

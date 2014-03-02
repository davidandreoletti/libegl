//
//  eglChooseConfigTest.h
//  eglTests
//
//  Created by David Andreoletti on 10/11/13.
//  Copyright (c) 2013 David Andreoletti. All rights reserved.
//

#ifndef TEST_INCLUDE_EGLCHOOSECONFIGTEST_H_
#define TEST_INCLUDE_EGLCHOOSECONFIGTEST_H_

#include "eglTest.h"
#include "eglPlatformHarness.h"

#include <stdlib.h>
#include <string.h>

static void test_eglChooseConfig(EGLDisplay dpy, const EGLint* eglChooseConfigAttrib_list, EGLConfig* eglChooseConfigConfigs, EGLint eglChooseConfigConfig_size, EGLint* eglChooseConfigNum_config, EGLint eglChooseConfigCMP0, EGLint *expectedEglChooseConfigNum_config, EGLBoolean* eglChooseConfigBoolResult, EGLint eglChooseConfigCMP1, EGLBoolean expectedEglChooseConfigBoolResult, EGLint expectedEglChooseConfigError)
{
    *eglChooseConfigBoolResult = eglChooseConfig(dpy, eglChooseConfigAttrib_list, eglChooseConfigConfigs, eglChooseConfigConfig_size, eglChooseConfigNum_config);
    test_compare_EGLBoolean(*eglChooseConfigBoolResult, eglChooseConfigCMP1, expectedEglChooseConfigBoolResult);
    test_compare_EGLint(eglGetError(), EQUAL, expectedEglChooseConfigError);
    if (eglChooseConfigNum_config != NULL) {
        test_compare_EGLint(*(eglChooseConfigNum_config), eglChooseConfigCMP0, *expectedEglChooseConfigNum_config);
    }
}

void eglChooseConfig_0(TestPlatform* p) {
    EGLDisplay dpy;
    
    test_eglGetDisplay(&dpy, VALID_NATIVE_DISPLAY, EGL_SUCCESS, NOT_EQUAL, NULL);
    test_eglInitialize2(dpy, ADDRESS(LAST_BOOL_RESULT), EQUAL, EGL_TRUE, EGL_SUCCESS);
    test_eglChooseConfig(dpy, ATTRIB_LIST, CONFIGS, CONFIG_SIZE, NUM_CONFIG, GREATER_THAN_OR_EQUAL, NUM_CONFIG_EXPECTED, ADDRESS(LAST_BOOL_RESULT), EQUAL, EGL_TRUE, EGL_SUCCESS);
}

void eglChooseConfig_1(TestPlatform* p) {
    // On failure, EGL_FALSE is returned.
    // An EGL_BAD_ATTRIBUTE error is gener- ated if attrib list contains an undefined
    // EGL attribute or an attribute value that is unrecognized or out of range.
    EGLDisplay dpy;
    EGLint arr[1] = {0};
    
    test_eglGetDisplay(&dpy, VALID_NATIVE_DISPLAY, EGL_SUCCESS, NOT_EQUAL, NULL);
    test_eglInitialize2(dpy, ADDRESS(LAST_BOOL_RESULT), EQUAL, EGL_TRUE, EGL_SUCCESS);
    test_eglChooseConfig(dpy, arr, CONFIGS, CONFIG_SIZE, NUM_CONFIG, GREATER_THAN_OR_EQUAL, CHOOSE_NUM_CONFIG_EXPECTED, ADDRESS(LAST_BOOL_RESULT), EQUAL, EGL_FALSE, EGL_BAD_ATTRIBUTE);
    EGLint arr2[2] = {EGL_COLOR_BUFFER_TYPE, (EGL_RGB_BUFFER + EGL_LUMINANCE_BUFFER + 1)};
    
    test_eglGetDisplay(&dpy, VALID_NATIVE_DISPLAY, EGL_SUCCESS, NOT_EQUAL, NULL);
    test_eglInitialize2(dpy, ADDRESS(LAST_BOOL_RESULT), EQUAL, EGL_TRUE, EGL_SUCCESS);
    test_eglChooseConfig(dpy, arr2, CONFIGS, CONFIG_SIZE, NUM_CONFIG, GREATER_THAN_OR_EQUAL, CHOOSE_NUM_CONFIG_EXPECTED, ADDRESS(LAST_BOOL_RESULT), EQUAL, EGL_FALSE, EGL_BAD_ATTRIBUTE);
}


/*
 * Runs all eglChooseConfig unit tests
 * @param p
 */
void run_eglChooseConfig_unit_tests(TestPlatform* p) {
    TEST_CASE_SETUP(p)
    eglChooseConfig_0(p);
    TEST_CASE_TEARDOWN(p)
    TEST_CASE_SETUP(p)
    eglChooseConfig_1(p);
    TEST_CASE_TEARDOWN(p)
}

#endif  // TEST_INCLUDE_EGLCHOOSECONFIGTEST_H_

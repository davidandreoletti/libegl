//
//  eglBindAPITest.h
//  eglTests
//
//  Created by David Andreoletti on 10/11/13.
//  Copyright (c) 2013 David Andreoletti. All rights reserved.
//

#ifndef TEST_INCLUDE_EGLBINDAPITEST_H_
#define TEST_INCLUDE_EGLBINDAPITEST_H_

#include "eglTest.h"
#include "eglPlatformHarness.h"

#include <stdlib.h>
#include <string.h>

///
// eglBindAPI/eglQueryAPI
///

static void test_eglBindAPI(EGLenum eglBindAPIApi, EGLBoolean* eglBindAPIBoolResult, EGLBoolean expectedEglBindAPIBoolResult, EGLint expectedEglBindAPIError) {
    *eglBindAPIBoolResult = eglBindAPI(eglBindAPIApi);
    test_compare_EGLBoolean(*eglBindAPIBoolResult, EQUAL, expectedEglBindAPIBoolResult);
    test_compare_EGLint(eglGetError(), EQUAL, expectedEglBindAPIError);
    if (expectedEglBindAPIError == EGL_SUCCESS) {
        EGLenum e = eglQueryAPI();
        test_compare_EGLenum(e, EQUAL, eglBindAPIApi);
        test_compare_EGLint(eglGetError(), EQUAL, EGL_SUCCESS);
    }
}

void eglBindAPI_0(TestPlatform* p) {
    test_eglBindAPI(EGL_OPENGL_ES_API, ADDRESS(LAST_BOOL_RESULT), EGL_TRUE, EGL_SUCCESS);
}

void eglBindAPI_1(TestPlatform* p) {
    // eglBindAPI returns EGL_FALSE on failure. If api is
    // not one of the values specified above, or if the
    // client API specified by api is not supported by the
    // implementation, an EGL_BAD_PARAMETER error is generated.
    test_eglBindAPI((EGL_OPENGL_API + EGL_OPENGL_ES_API + EGL_OPENVG_API), ADDRESS(LAST_BOOL_RESULT), EGL_FALSE, EGL_BAD_PARAMETER);
}

/*
 * Runs all eglBindAPI unit tests
 * @param p
 */
void run_eglBindAPI_unit_tests(TestPlatform* p) {
    TEST_CASE_SETUP(p)
    eglBindAPI_0(p);
    TEST_CASE_TEARDOWN(p)
    TEST_CASE_SETUP(p)
    eglBindAPI_1(p);
    TEST_CASE_TEARDOWN(p)
}

#endif  // TEST_INCLUDE_EGLBINDAPITEST_H_

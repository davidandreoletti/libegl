//
//  eglQueryStringTest.h
//  eglTests
//
//  Created by David Andreoletti on 10/11/13.
//  Copyright (c) 2013 David Andreoletti. All rights reserved.
//

#ifndef TEST_INCLUDE_EGLQUERYSTRINGTEST_H_
#define TEST_INCLUDE_EGLQUERYSTRINGTEST_H_

#include "eglTest.h"
#include "eglGetDisplayTest.h"
#include "eglInitializeTest.h"
#include "eglPlatformHarness.h"

#include <stdlib.h>
#include <string.h>

static void test_eglQueryString(EGLDisplay dpy, EGLint eglQueryStringName , const char ** eglQueryStringConstChar, EGLint eglQueryStringSTRCMP0, const char * expectedEglQueryStringConstChar, EGLint expectedEglQueryStringError) {
    *eglQueryStringConstChar = eglQueryString(dpy, eglQueryStringName);
    test_compare_EGLint(eglGetError(), EQUAL, expectedEglQueryStringError);
    if (expectedEglQueryStringConstChar != NULL) {
        test_compare_2_ConstCharPtr(*eglQueryStringConstChar, eglQueryStringSTRCMP0, expectedEglQueryStringConstChar);
    }
    else {
        test_compare_ConstCharPtr(*eglQueryStringConstChar, EQUAL, expectedEglQueryStringConstChar);
    }
}

void eglQueryString_0(TestPlatform* p) {
    EGLDisplay dpy;
    test_eglGetDisplay(&dpy, VALID_NATIVE_DISPLAY, EGL_SUCCESS, NOT_EQUAL, NULL);
    test_eglInitialize2(dpy, ADDRESS(LAST_BOOL_RESULT), EQUAL, EGL_TRUE, EGL_SUCCESS);
    test_eglQueryString(dpy, EGL_CLIENT_APIS, ADDRESS(LAST_CONSTCHAR_RESULT), STR_CMP_EQUAL, CONSTCHAR_EXPECTED, EGL_SUCCESS);
}

void eglQueryString_1(TestPlatform* p) {
    EGLDisplay dpy;
    test_eglGetDisplay(&dpy, VALID_NATIVE_DISPLAY, EGL_SUCCESS, NOT_EQUAL, NULL);
    test_eglInitialize2(dpy, ADDRESS(LAST_BOOL_RESULT), EQUAL, EGL_TRUE, EGL_SUCCESS);
    test_eglQueryString(dpy, EGL_EXTENSIONS, ADDRESS(LAST_CONSTCHAR_RESULT), STR_CMP_EQUAL, CONSTCHAR_EXPECTED, EGL_SUCCESS);
}

void eglQueryString_2(TestPlatform* p) {
    EGLDisplay dpy;
    test_eglGetDisplay(&dpy, VALID_NATIVE_DISPLAY, EGL_SUCCESS, NOT_EQUAL, NULL);
    test_eglInitialize2(dpy, ADDRESS(LAST_BOOL_RESULT), EQUAL, EGL_TRUE, EGL_SUCCESS);
    test_eglQueryString(dpy, EGL_VENDOR, ADDRESS(LAST_CONSTCHAR_RESULT), STR_CMP_EQUAL, CONSTCHAR_EXPECTED, EGL_SUCCESS);
}

void eglQueryString_3(TestPlatform* p) {
    EGLDisplay dpy;
    test_eglGetDisplay(&dpy, VALID_NATIVE_DISPLAY, EGL_SUCCESS, NOT_EQUAL, NULL);
    test_eglInitialize2(dpy, ADDRESS(LAST_BOOL_RESULT), EQUAL, EGL_TRUE, EGL_SUCCESS);
    test_eglQueryString(dpy, EGL_VERSION, ADDRESS(LAST_CONSTCHAR_RESULT), STR_CMP_EQUAL, CONSTCHAR_EXPECTED, EGL_SUCCESS);
}

void eglQueryString_4(TestPlatform* p) {
    // An EGL_NOT_INITIALIZED error is generated if EGL is not
    // initialized for dpy.
    // On failure, NULL is returned
    
    EGLDisplay dpy;
    test_eglGetDisplay(&dpy, EGL_DEFAULT_DISPLAY, EGL_SUCCESS, NOT_EQUAL, NULL);
    test_eglQueryString(dpy, EGL_VERSION, ADDRESS(LAST_CONSTCHAR_RESULT), STR_CMP_EQUAL, CONSTCHAR_EXPECTED, EGL_NOT_INITIALIZED);
}

void eglQueryString_5(TestPlatform* p) {
    // An EGL_BAD_PARAMETER error is generated if name is not
    // one of the values described above
    EGLDisplay dpy;
    test_eglGetDisplay(&dpy, VALID_NATIVE_DISPLAY, EGL_SUCCESS, NOT_EQUAL, NULL);
    test_eglInitialize2(dpy, ADDRESS(LAST_BOOL_RESULT), EQUAL, EGL_TRUE, EGL_SUCCESS);
    test_eglQueryString(dpy, (EGL_CLIENT_APIS+EGL_EXTENSIONS+EGL_VENDOR+EGL_VERSION), ADDRESS(LAST_CONSTCHAR_RESULT), STR_CMP_EQUAL, CONSTCHAR_EXPECTED, EGL_BAD_PARAMETER);
}


/*
 * Runs all eglQueryString unit tests
 * @param p
 */
void run_eglQueryString_unit_tests(TestPlatform* p) {
    TEST_CASE_SETUP(p)
    p->eglConstCharExpected = "OpenGL_ES OpenGL_ES2 OpenGL_ES3 ";
    eglQueryString_0(p);
    TEST_CASE_TEARDOWN(p)
    TEST_CASE_SETUP(p)
    p->eglConstCharExpected = "EGL_KHR_create_context ";
    eglQueryString_1(p);
    TEST_CASE_TEARDOWN(p)
    TEST_CASE_SETUP(p)
    p->eglConstCharExpected = "Mesa Project";
    eglQueryString_2(p);
    TEST_CASE_TEARDOWN(p)
    TEST_CASE_SETUP(p)
    p->eglConstCharExpected = "1.4 (EAGL_iOS)";
    eglQueryString_3(p);
    TEST_CASE_TEARDOWN(p)
    TEST_CASE_SETUP(p)
    eglQueryString_4(p);
    TEST_CASE_TEARDOWN(p)
    TEST_CASE_SETUP(p)
    eglQueryString_5(p);
    TEST_CASE_TEARDOWN(p)
}

#endif  // TEST_INCLUDE_EGLQUERYSTRINGTEST_H_

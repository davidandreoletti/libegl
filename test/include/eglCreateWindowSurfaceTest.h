//
//  eglCreateWindowSurfaceTest.h
//  eglTests
//
//  Created by David Andreoletti on 10/11/13.
//  Copyright (c) 2013 David Andreoletti. All rights reserved.
//

#ifndef TEST_INCLUDE_EGLCREATEWINDOWSURFACETEST_H_
#define TEST_INCLUDE_EGLCREATEWINDOWSURFACETEST_H_

#include "eglTest.h"
#include "eglPlatformHarness.h"

#include <stdlib.h>
#include <string.h>

static void test_eglCreateWindowSurface(EGLDisplay dpy, EGLSurface* surf, EGLConfig eglCreateWindowSurfaceConfig, EGLNativeWindowType eglCreateWindowSurfaceWin, const EGLint *eglCreateWindowSurfaceAttrib_list, EGLint eglCreateWindowSurfaceCMP0, EGLSurface expectedEglCreateWindowSurfaceSurface, EGLint expectedEglCreateWindowSurfaceError)
{
    *surf = eglCreateWindowSurface(dpy, eglCreateWindowSurfaceConfig, eglCreateWindowSurfaceWin, eglCreateWindowSurfaceAttrib_list);
    test_compare_EGLSurface(*surf, eglCreateWindowSurfaceCMP0, expectedEglCreateWindowSurfaceSurface);
    test_compare_EGLint(eglGetError(), EQUAL, expectedEglCreateWindowSurfaceError);
}

void eglCreateWindowSurface_0(TestPlatform* p) {
    // eglCreateWindowSurface creates an onscreen EGLSurface and returns a handle to it.
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
}

void eglCreateWindowSurface_1(TestPlatform* p) {
    // On failure eglCreateWindowSurface returns EGL_NO_SURFACE.
    // If config is not a valid EGLConfig, an EGL_BAD_CONFIG error is generated.
    EGLSurface surf;
    EGLDisplay dpy;
    EGLConfig config = {0};
    EGLint wattrib_list[3] = {  EGL_RENDER_BUFFER, EGL_BACK_BUFFER,
        EGL_NONE};
    test_eglGetDisplay(&dpy, VALID_NATIVE_DISPLAY, EGL_SUCCESS, NOT_EQUAL, NULL);
    test_eglInitialize2(dpy, ADDRESS(LAST_BOOL_RESULT), EQUAL, EGL_TRUE, EGL_SUCCESS);
    test_eglCreateWindowSurface(dpy, &surf, config, VALID_NATIVE_WINDOW, wattrib_list, EQUAL, EGL_NO_SURFACE, EGL_BAD_CONFIG);
}

void eglCreateWindowSurface_2(TestPlatform* p) {
    // If there is already an EGLSurface associated with win (as a result of a previous
    // eglCreateWindowSurface call), then an EGL_BAD_ALLOC error is generated
    EGLSurface surf;
    EGLSurface surf2;
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
    test_eglCreateWindowSurface(dpy, &surf2, CONFIGS[0], VALID_NATIVE_WINDOW, wattrib_list, EQUAL, EGL_NO_SURFACE, EGL_BAD_ALLOC);
}

void eglCreateWindowSurface_3(TestPlatform* p) {
    // if the implementation cannot allo- cate resources for the new EGL window, an EGL_BAD_ALLOC error is generated.
    // TODO: How to test this ?
    //       Wiating for more info on http://stackoverflow.com/questions/21965229/what-is-the-fastest-way-to-create-out-of-memory-condition-in-c
}

void eglCreateWindowSurface_4(TestPlatform* p) {
    // If the attributes of win do not correspond to config, then an EGL_BAD_MATCH error is gen- erated.
    // TODO
}

void eglCreateWindowSurface_5(TestPlatform* p) {
    //If config does not support the colorspace or alpha format attributes specified
    // in attrib list (as defined for eglCreateWindowSurface),
    //an EGL_BAD_MATCH er- ror is generated.
    
    // No support for OpenVG - cannot be tested
}

void eglCreateWindowSurface_6(TestPlatform* p) {
    //If config is not a valid EGLConfig, an EGL_BAD_CONFIG error is generated.
    EGLSurface surf;
    EGLDisplay dpy;
    EGLConfig config = NULL;
    EGLint wattrib_list[3] = {  EGL_RENDER_BUFFER, EGL_BACK_BUFFER,
        EGL_NONE};
    
    test_eglGetDisplay(&dpy, VALID_NATIVE_DISPLAY, EGL_SUCCESS, NOT_EQUAL, NULL);
    test_eglInitialize2(dpy, ADDRESS(LAST_BOOL_RESULT), EQUAL, EGL_TRUE, EGL_SUCCESS);
    test_eglCreateWindowSurface(dpy, &surf, config, INVALID_NATIVE_WINDOW, wattrib_list, EQUAL, EGL_NO_SURFACE, EGL_BAD_CONFIG);
}

void eglCreateWindowSurface_7(TestPlatform* p) {
    //If win is not a valid native window handle, then
    //an EGL_BAD_NATIVE_WINDOW error should be generated.
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
    test_eglCreateWindowSurface(dpy, &surf, CONFIGS[0], INVALID_NATIVE_WINDOW, wattrib_list, EQUAL, EGL_NO_SURFACE, EGL_BAD_NATIVE_WINDOW);
}

void eglCreateWindowSurface_8(TestPlatform* p) {
    //if the implementation cannot allo- cate resources for the new EGL window,
    //an EGL_BAD_ALLOC error is generated.
}

/*
 * Runs all eglCreateWindowSurface unit tests
 * @param p
 */
void run_eglCreateWindowSurface_unit_tests(TestPlatform* p) {
    TEST_CASE_SETUP(p)
    eglCreateWindowSurface_0(p);
    TEST_CASE_TEARDOWN(p)
    TEST_CASE_SETUP(p)
    eglCreateWindowSurface_1(p);
    TEST_CASE_TEARDOWN(p)
    TEST_CASE_SETUP(p)
    eglCreateWindowSurface_2(p);
    TEST_CASE_TEARDOWN(p)
    TEST_CASE_SETUP(p)
    eglCreateWindowSurface_3(p);
    TEST_CASE_TEARDOWN(p)
    TEST_CASE_SETUP(p)
    eglCreateWindowSurface_4(p);
    TEST_CASE_TEARDOWN(p)
    TEST_CASE_SETUP(p)
    eglCreateWindowSurface_5(p);
    TEST_CASE_TEARDOWN(p)
    TEST_CASE_SETUP(p)
    eglCreateWindowSurface_6(p);
    TEST_CASE_TEARDOWN(p)
    TEST_CASE_SETUP(p)
    eglCreateWindowSurface_7(p);
    TEST_CASE_TEARDOWN(p)
    TEST_CASE_SETUP(p)
    eglCreateWindowSurface_8(p);
    TEST_CASE_TEARDOWN(p)
}

#endif  // TEST_INCLUDE_EGLCREATEWINDOWSURFACETEST_H_

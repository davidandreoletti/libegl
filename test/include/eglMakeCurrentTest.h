//
//  eglMakeCurrentTest.h
//  eglTests
//
//  Created by David Andreoletti on 10/11/13.
//  Copyright (c) 2013 David Andreoletti. All rights reserved.
//

#ifndef TEST_INCLUDE_EGLMAKECURRENTTEST_H_
#define TEST_INCLUDE_EGLMAKECURRENTTEST_H_

#include "eglTest.h"
#include "eglPlatformHarness.h"

#include <stdlib.h>
#include <string.h>

///
// eglMakeCurrent
///

static void test_eglMakeCurrent(EGLDisplay dpy, EGLSurface draw, EGLSurface read, EGLContext ctx, EGLBoolean* eglMakeCurrentBoolResult, EGLBoolean expectedEglMakeCurrentBoolResult, EGLint eglMakeCurrentError) {
    *eglMakeCurrentBoolResult = eglMakeCurrent(dpy, draw, read, ctx);
    test_compare_EGLint(eglGetError(), EQUAL, eglMakeCurrentError);
    test_compare_EGLBoolean(*eglMakeCurrentBoolResult, EQUAL, expectedEglMakeCurrentBoolResult);
}

void eglMakeCurrent_0(TestPlatform* p) {
    // Successfuly binds ctx to the current rendering thread and to the draw and read surfaces.
    // EGL_SUCCESS
    EGLSurface surf;
    EGLDisplay dpy;
    EGLContext ctx;
    EGLint cattrib_list[5] = {EGL_COLOR_BUFFER_TYPE, EGL_RGB_BUFFER,
        EGL_RED_SIZE, 1,
        EGL_NONE};
    EGLint wattrib_list[3] = {  EGL_RENDER_BUFFER, EGL_BACK_BUFFER,
        EGL_NONE};
    
    test_eglGetDisplay(&dpy, VALID_NATIVE_DISPLAY, EGL_SUCCESS, NOT_EQUAL, NULL);
    test_eglInitialize2(dpy, ADDRESS(LAST_BOOL_RESULT), EQUAL, EGL_TRUE, EGL_SUCCESS);
    test_eglChooseConfig(dpy, cattrib_list, CONFIGS, CONFIG_SIZE, NUM_CONFIG, GREATER_THAN_OR_EQUAL, NUM_CONFIG_EXPECTED, ADDRESS(LAST_BOOL_RESULT), EQUAL, EGL_TRUE, EGL_SUCCESS);
    test_eglCreateWindowSurface(dpy, &surf, CONFIGS[0], VALID_NATIVE_WINDOW, wattrib_list, NOT_EQUAL, EGL_NO_SURFACE, EGL_SUCCESS);
    
    EGLint ccattrib_list[3] = {EGL_CONTEXT_CLIENT_VERSION, 1, EGL_NONE};
    test_eglBindAPI(EGL_OPENGL_ES_API, ADDRESS(LAST_BOOL_RESULT), EGL_TRUE, EGL_SUCCESS);
    test_eglCreateContext(dpy, ADDRESS(ctx), CONFIGS[0], NULL, ccattrib_list, EGL_SUCCESS, NOT_EQUAL, EGL_NO_CONTEXT);
    test_eglMakeCurrent(dpy, surf, surf, ctx, ADDRESS(LAST_BOOL_RESULT), EGL_TRUE, EGL_SUCCESS);
}

void eglMakeCurrent_1(TestPlatform* p) {
    //If draw or read are not compatible with ctx,
    //then an EGL_BAD_MATCH error is generated.
    EGLSurface surf;
    EGLDisplay dpy;
    EGLContext ctx = NULL;
    EGLint cattrib_list[5] = {EGL_COLOR_BUFFER_TYPE, EGL_RGB_BUFFER,
        EGL_RED_SIZE, 1,
        EGL_NONE};
    EGLint wattrib_list[3] = {  EGL_RENDER_BUFFER, EGL_BACK_BUFFER,
        EGL_NONE};
    
    test_eglGetDisplay(&dpy, VALID_NATIVE_DISPLAY, EGL_SUCCESS, NOT_EQUAL, NULL);
    test_eglInitialize2(dpy, ADDRESS(LAST_BOOL_RESULT), EQUAL, EGL_TRUE, EGL_SUCCESS);
    test_eglChooseConfig(dpy, cattrib_list, CONFIGS, CONFIG_SIZE, NUM_CONFIG, GREATER_THAN_OR_EQUAL, NUM_CONFIG_EXPECTED, ADDRESS(LAST_BOOL_RESULT), EQUAL, EGL_TRUE, EGL_SUCCESS);
    test_eglCreateWindowSurface(dpy, &surf, CONFIGS[0], VALID_NATIVE_WINDOW, wattrib_list, NOT_EQUAL, EGL_NO_SURFACE, EGL_SUCCESS);
    EGLint cattrib_list2[5] = {EGL_COLOR_BUFFER_TYPE, EGL_RGB_BUFFER,
        EGL_RENDERABLE_TYPE, EGL_OPENGL_ES2_BIT,
        EGL_NONE};
    test_eglChooseConfig(dpy, cattrib_list2, CONFIGS, CONFIG_SIZE, NUM_CONFIG, GREATER_THAN_OR_EQUAL, NUM_CONFIG_EXPECTED, ADDRESS(LAST_BOOL_RESULT), EQUAL, EGL_TRUE, EGL_SUCCESS);
    EGLint ccattrib_list[3] = {EGL_CONTEXT_CLIENT_VERSION, 2, EGL_NONE};
    test_eglCreateContext(dpy, ADDRESS(ctx), CONFIGS[0], NULL, ccattrib_list, EGL_SUCCESS, NOT_EQUAL, EGL_NO_CONTEXT);
    test_eglMakeCurrent(dpy, surf, surf, ctx, ADDRESS(LAST_BOOL_RESULT), EGL_FALSE, EGL_BAD_MATCH);
}

void eglMakeCurrent_2(TestPlatform* p) {
    //If ctx is current to some other thread
    // an EGL_BAD_ACCESS error is generated.
}

void eglMakeCurrent_3(TestPlatform* p) {
    //if either draw or read are bound to contexts
    //in another thread, an EGL_BAD_ACCESS error is generated.
}

void eglMakeCurrent_4(TestPlatform* p) {
    //If binding ctx would exceed the number of current contexts
    //of that client API type supported by the implementation,
    //an EGL_BAD_ACCESS error is generated.
}

void eglMakeCurrent_5(TestPlatform* p) {
    //If either draw or read are pbuffers created with
    //eglCreatePbufferFrom- ClientBuffer, and the underlying bound
    //client API buffers are in use by the client API that created them,
    //an EGL_BAD_ACCESS error is generated.
}

void eglMakeCurrent_6(TestPlatform* p) {
    //If ctx is not a valid context, an EGL_BAD_CONTEXT error is generated.
    EGLSurface surf;
    EGLDisplay dpy;
    EGLContext ctx = NULL;
    EGLint cattrib_list[5] = {EGL_COLOR_BUFFER_TYPE, EGL_RGB_BUFFER,
        EGL_RED_SIZE, 1,
        EGL_NONE};
    EGLint wattrib_list[3] = {  EGL_RENDER_BUFFER, EGL_BACK_BUFFER,
        EGL_NONE};
    
    test_eglGetDisplay(&dpy, VALID_NATIVE_DISPLAY, EGL_SUCCESS, NOT_EQUAL, NULL);
    test_eglInitialize2(dpy, ADDRESS(LAST_BOOL_RESULT), EQUAL, EGL_TRUE, EGL_SUCCESS);
    test_eglChooseConfig(dpy, cattrib_list, CONFIGS, CONFIG_SIZE, NUM_CONFIG, GREATER_THAN_OR_EQUAL, NUM_CONFIG_EXPECTED, ADDRESS(LAST_BOOL_RESULT), EQUAL, EGL_TRUE, EGL_SUCCESS);
    test_eglCreateWindowSurface(dpy, &surf, CONFIGS[0], VALID_NATIVE_WINDOW, wattrib_list, NOT_EQUAL, EGL_NO_SURFACE, EGL_SUCCESS);
    test_eglMakeCurrent(dpy, surf, surf, ctx, ADDRESS(LAST_BOOL_RESULT), EGL_FALSE, EGL_BAD_CONTEXT);
}

void eglMakeCurrent_7(TestPlatform* p) {
    // If either draw or read are not valid EGL surfaces, an EGL_BAD_SURFACE
    //error is generated.
    EGLSurface surf = NULL;
    EGLDisplay dpy;
    EGLContext ctx = NULL;
    EGLint cattrib_list[5] = {EGL_COLOR_BUFFER_TYPE, EGL_RGB_BUFFER,
        EGL_RED_SIZE, 1,
        EGL_NONE};
    test_eglGetDisplay(&dpy, VALID_NATIVE_DISPLAY, EGL_SUCCESS, NOT_EQUAL, NULL);
    test_eglInitialize2(dpy, ADDRESS(LAST_BOOL_RESULT), EQUAL, EGL_TRUE, EGL_SUCCESS);
    test_eglChooseConfig(dpy, cattrib_list, CONFIGS, CONFIG_SIZE, NUM_CONFIG, GREATER_THAN_OR_EQUAL, NUM_CONFIG_EXPECTED, ADDRESS(LAST_BOOL_RESULT), EQUAL, EGL_TRUE, EGL_SUCCESS);
    EGLint ccattrib_list[3] = {EGL_CONTEXT_CLIENT_VERSION, 1, EGL_NONE};
    test_eglBindAPI(EGL_OPENGL_ES_API, ADDRESS(LAST_BOOL_RESULT), EGL_TRUE, EGL_SUCCESS);
    test_eglCreateContext(dpy, ADDRESS(ctx), CONFIGS[0], NULL, ccattrib_list, EGL_SUCCESS, NOT_EQUAL, EGL_NO_CONTEXT);
    test_eglMakeCurrent(dpy, surf, surf, ctx, ADDRESS(LAST_BOOL_RESULT), EGL_FALSE, EGL_BAD_SURFACE);
}

void eglMakeCurrent_8(TestPlatform* p) {
    //If a native window underlying either draw or read is no longer valid, an
    //EGL_BAD_NATIVE_WINDOW error is generated.
}

void eglMakeCurrent_9(TestPlatform* p) {
    //If draw and read cannot fit into graphics memory simultaneously, an EGL_-
    //BAD_MATCH error is generated.
}

void eglMakeCurrent_10(TestPlatform* p) {
    // If the previous context of the calling thread has unflushed commands,
    // and the previous surface is no longer valid,
    //an EGL_BAD_CURRENT_SURFACE error is generated.
}

void eglMakeCurrent_11(TestPlatform* p) {
    //Iftheancillarybuffersfordrawandreadcannotbeallocated,anEGL_BAD_- ALLOC error is generated.
}

void eglMakeCurrent_12(TestPlatform* p) {
    //If a power management event has occurred, an EGL_CONTEXT_LOST error is generated.
}

void eglMakeCurrent_13(TestPlatform* p) {
    //As with other commands taking EGLDisplay parameters, if dpy is not a
    //valid EGLDisplay handle, an EGL_BAD_DISPLAY error is generated.
    EGLSurface surf;
    EGLDisplay dpy;
    EGLDisplay dpy2 = NULL;
    EGLContext ctx;
    EGLint cattrib_list[5] = {EGL_COLOR_BUFFER_TYPE, EGL_RGB_BUFFER,
        EGL_RED_SIZE, 1,
        EGL_NONE};
    EGLint wattrib_list[3] = {  EGL_RENDER_BUFFER, EGL_BACK_BUFFER,
        EGL_NONE};
    
    test_eglGetDisplay(&dpy, VALID_NATIVE_DISPLAY, EGL_SUCCESS, NOT_EQUAL, NULL);
    test_eglInitialize2(dpy, ADDRESS(LAST_BOOL_RESULT), EQUAL, EGL_TRUE, EGL_SUCCESS);
    test_eglChooseConfig(dpy, cattrib_list, CONFIGS, CONFIG_SIZE, NUM_CONFIG, GREATER_THAN_OR_EQUAL, NUM_CONFIG_EXPECTED, ADDRESS(LAST_BOOL_RESULT), EQUAL, EGL_TRUE, EGL_SUCCESS);
    test_eglCreateWindowSurface(dpy, &surf, CONFIGS[0], VALID_NATIVE_WINDOW, wattrib_list, NOT_EQUAL, EGL_NO_SURFACE, EGL_SUCCESS);
    
    EGLint ccattrib_list[3] = {EGL_CONTEXT_CLIENT_VERSION, 1, EGL_NONE};
    test_eglBindAPI(EGL_OPENGL_ES_API, ADDRESS(LAST_BOOL_RESULT), EGL_TRUE, EGL_SUCCESS);
    test_eglCreateContext(dpy, ADDRESS(ctx), CONFIGS[0], NULL, ccattrib_list, EGL_SUCCESS, NOT_EQUAL, EGL_NO_CONTEXT);
    test_eglMakeCurrent(dpy2, surf, surf, ctx, ADDRESS(LAST_BOOL_RESULT), EGL_FALSE, EGL_BAD_DISPLAY);
}

void eglMakeCurrent_14(TestPlatform* p) {
    // To release the current context without assigning a new one, set ctx to EGL_- NO_CONTEXT
    // and set draw and read to EGL_NO_SURFACE. The currently bound context for the client API
    // specified by the current rendering API is flushed and marked as no longer current,
    // and there will be no current context for that client API after eglMakeCurrent returns.
    // This is the only case in which eglMakeCurrent respects the current rendering API.
    // In all other cases, the client API affected is determined by ctx. This is the only
    // case where an uninitialized display may be passed to eglMakeCurrent.
    EGLSurface surf;
    EGLDisplay dpy;
    EGLContext ctx;
    EGLint cattrib_list[5] = {EGL_COLOR_BUFFER_TYPE, EGL_RGB_BUFFER,
        EGL_RED_SIZE, 1,
        EGL_NONE};
    EGLint wattrib_list[3] = {  EGL_RENDER_BUFFER, EGL_BACK_BUFFER,
        EGL_NONE};
    
    test_eglGetDisplay(&dpy, VALID_NATIVE_DISPLAY, EGL_SUCCESS, NOT_EQUAL, NULL);
    test_eglInitialize2(dpy, ADDRESS(LAST_BOOL_RESULT), EQUAL, EGL_TRUE, EGL_SUCCESS);
    test_eglChooseConfig(dpy, cattrib_list, CONFIGS, CONFIG_SIZE, NUM_CONFIG, GREATER_THAN_OR_EQUAL, NUM_CONFIG_EXPECTED, ADDRESS(LAST_BOOL_RESULT), EQUAL, EGL_TRUE, EGL_SUCCESS);
    test_eglCreateWindowSurface(dpy, &surf, CONFIGS[0], VALID_NATIVE_WINDOW, wattrib_list, NOT_EQUAL, EGL_NO_SURFACE, EGL_SUCCESS);
    
    EGLint ccattrib_list[3] = {EGL_CONTEXT_CLIENT_VERSION, 1, EGL_NONE};
    test_eglBindAPI(EGL_OPENGL_ES_API, ADDRESS(LAST_BOOL_RESULT), EGL_TRUE, EGL_SUCCESS);
    test_eglCreateContext(dpy, ADDRESS(ctx), CONFIGS[0], NULL, ccattrib_list, EGL_SUCCESS, NOT_EQUAL, EGL_NO_CONTEXT);
    test_eglMakeCurrent(dpy, surf, surf, ctx, ADDRESS(LAST_BOOL_RESULT), EGL_TRUE, EGL_SUCCESS);
    test_eglMakeCurrent(dpy, EGL_NO_SURFACE, EGL_NO_SURFACE, EGL_NO_CONTEXT, ADDRESS(LAST_BOOL_RESULT), EGL_TRUE, EGL_SUCCESS);
}


/*
 * Runs all eglMakeCurrent unit tests
 * @param p
 */
void run_eglMakeCurrent_unit_tests(TestPlatform* p) {
    TEST_CASE_SETUP(p)
    eglMakeCurrent_0(p);
    TEST_CASE_TEARDOWN(p)
    TEST_CASE_SETUP(p)
    eglMakeCurrent_1(p);
    TEST_CASE_TEARDOWN(p)
    TEST_CASE_SETUP(p)
    eglMakeCurrent_2(p);
    TEST_CASE_TEARDOWN(p)
    TEST_CASE_SETUP(p)
    eglMakeCurrent_3(p);
    TEST_CASE_TEARDOWN(p)
    TEST_CASE_SETUP(p)
    eglMakeCurrent_4(p);
    TEST_CASE_TEARDOWN(p)
    TEST_CASE_SETUP(p)
    eglMakeCurrent_5(p);
    TEST_CASE_TEARDOWN(p)
    TEST_CASE_SETUP(p)
    eglMakeCurrent_6(p);
    TEST_CASE_TEARDOWN(p)
    TEST_CASE_SETUP(p)
    eglMakeCurrent_7(p);
    TEST_CASE_TEARDOWN(p)
    TEST_CASE_SETUP(p)
    eglMakeCurrent_8(p);
    TEST_CASE_TEARDOWN(p)
    TEST_CASE_SETUP(p)
    eglMakeCurrent_9(p);
    TEST_CASE_TEARDOWN(p)
    TEST_CASE_SETUP(p)
    eglMakeCurrent_10(p);
    TEST_CASE_TEARDOWN(p)
    TEST_CASE_SETUP(p)
    eglMakeCurrent_11(p);
    TEST_CASE_TEARDOWN(p)
    TEST_CASE_SETUP(p)
    eglMakeCurrent_12(p);
    TEST_CASE_TEARDOWN(p)
    TEST_CASE_SETUP(p)
    eglMakeCurrent_13(p);
    TEST_CASE_TEARDOWN(p)
    //TEST_CASE_SETUP(p)
    //eglMakeCurrent_14(p); // Not passing: see eglapi.c: eglMakeCurrent
    //TEST_CASE_TEARDOWN(p)
}

#endif  // TEST_INCLUDE_EGLMAKECURRENTTEST_H_

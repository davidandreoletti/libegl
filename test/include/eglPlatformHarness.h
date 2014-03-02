//
//  eglPlatformHarness.h
//  eglTests
//
//  Created by David Andreoletti on 10/11/13.
//  Copyright (c) 2013 David Andreoletti. All rights reserved.
//

#ifndef TEST_INCLUDE_EGLPLATFORMHARNESS_H_
#define TEST_INCLUDE_EGLPLATFORMHARNESS_H_

#include "EGL/egl.h"
#include "EGL/eglext.h"

typedef struct test_platform {
    const char * ios_platform_env_key;
    const char * ios_platform_env_value;
//    EGLDisplay dpys;
    EGLNativeDisplayType validNativeDisplay;
    EGLNativeDisplayType invalidNativeDisplay;
//    EGLint dpys_num;
    EGLint eglMajorDefault;
    EGLint eglMinorDefault;
    EGLint eglMajorExpected;
    EGLint eglMinorExpected;
    EGLint eglMajor;
    EGLint eglMinor;
    EGLBoolean lastBoolResult;
    EGLint lastIntResult;
    EGLint intResultExpected;
    const char* lastConstCharResult;
    const char* eglConstCharExpected;
    EGLint configs_num;
    EGLConfig* configs;
    EGLint configs_count;
    EGLint eglGetConfigNumExpected;
    EGLint* attrib_list;
    EGLint attrib_list_count;
    EGLint eglChooseConfigNumExpected;
    EGLNativeWindowType validNativeWindow;
    EGLNativeWindowType invalidNativeWindow;
    EGLenum lastEGLenumResult;
    /**
     *  Creates a valid native display
     */
    EGLNativeDisplayType (*createValidNativeDisplay)();
    /**
     *  Destroys a valid native display
     */
    void (*destroyValidNativeDisplay)(EGLNativeDisplayType nd);
    /**
     *  Creates a invalid native display
     */
    EGLNativeDisplayType (*createInvalidNativeDisplay)();
    /**
     *  Push native display as display to use for test operation
     */
    void (*pushNativeDisplay)(EGLNativeDisplayType w, struct test_platform* p);
    /**
     *  Pop native display from display to use for test operation
     */
    EGLNativeDisplayType (*popNativeDisplay)(struct test_platform* p);

    /**
     *  Creates a valid native window
     */
    EGLNativeWindowType (*createValidNativeWindow)();
    /**
     *  Destroys a valid native window
     */
    void (*destroyValidNativeWindow)(EGLNativeWindowType nd);
    /**
     *  Creates a invalid native window
     */
    EGLNativeWindowType (*createInvalidNativeWindow)();
    /**
     *  Push native window as window to use for test operation
     */
    void (*pushNativeWindow)(EGLNativeWindowType w, struct test_platform* p);
    /**
     *  Pop native window from window to use for test operation
     */
    EGLNativeWindowType (*popNativeWindow)(struct test_platform* p);
} TestPlatform;

#endif  // TEST_INCLUDE_EGLPLATFORMHARNESS_H_

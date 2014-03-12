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

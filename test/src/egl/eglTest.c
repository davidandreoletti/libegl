//
//  eglTest.c
//  eglTests
//
//  Created by David Andreoletti on 10/11/13.
//  Copyright (c) 2013 David Andreoletti. All rights reserved.
//

#include "eglTest.h"

#include <assert.h>
#include <stdlib.h>
#include <string.h>

#include <OpenGLES/ES1/gl.h>
#include <OpenGLES/ES2/gl.h>

#include "eglPlatformHarness.h"
#include "eglGetDisplayTest.h"
#include "eglInitializeTest.h"
#include "eglQueryStringTest.h"
#include "eglGetConfigsTest.h"
#include "eglBindAPITest.h"
#include "eglChooseConfigTest.h"
#include "eglGetConfigAttribTest.h"
#include "eglGetCurrentContextTest.h"
#include "eglGetCurrentDisplayTest.h"
#include "eglGetCurrentSurfaceTest.h"
#include "eglCreateContextTest.h"
#include "eglReleaseThreadTest.h"
#include "eglDestroyContextTest.h"
#include "eglTerminateTest.h"
#include "eglCreateWindowSurfaceTest.h"
#include "eglDestroySurfaceTest.h"
#include "eglQuerySurfaceTest.h"
#include "eglQueryContextTest.h"
#include "eglMakeCurrentTest.h"
#include "eglSwapBuffersTest.h"
#include "Sample0Test.h"
#include "Sample1Test.h"
#include "Sample2Test.h"

void setup(TestPlatform* f) {
    setenv(f->ios_platform_env_key, f->ios_platform_env_value, 1);
    EGLNativeDisplayType d = f->createValidNativeDisplay();
    f->pushNativeDisplay(d,f);
    f->invalidNativeDisplay = f->createInvalidNativeDisplay();
    f->eglMajor = f->eglMajorDefault;
    f->eglMinor = f->eglMinorDefault;
    f->lastBoolResult = EGL_FALSE;
    f->lastIntResult = 0;
    f->lastConstCharResult = NULL;
    f->eglConstCharExpected = NULL;
    f->configs_num = 100;
    f->configs = calloc(f->configs_num, sizeof(EGLConfig));
    f->configs_count = 0;
    f->eglGetConfigNumExpected = 0;
    f->attrib_list = NULL;
    f->attrib_list_count = 0;
    f->eglChooseConfigNumExpected = 0;
    EGLNativeWindowType w = f->createValidNativeWindow();
    f->pushNativeWindow(w,f);
    f->invalidNativeWindow = f->createInvalidNativeWindow();
    f->lastEGLenumResult = 0;
}

void teardown(TestPlatform* f) {
    unsetenv(f->ios_platform_env_key);
    EGLNativeWindowType w = f->popNativeWindow(f);
    f->destroyValidNativeWindow(w);
    EGLNativeDisplayType d = f->popNativeDisplay(f);
    f->destroyValidNativeDisplay(d);
    f->invalidNativeDisplay = NULL;
    free(f->configs);
}

void run_unit_tests(TestPlatform* p) {    
    // EGL unit tests
    //
    // Notes:
    // - EGL_DEFAULT_DISPLAY display must remain NOT initialized at all times.
    //   Some Unit Tests depends on it.
    // - f->validNativeDisplay display must be initialized at all times.
    //   Some Unit Tests depends on it.
    run_eglGetDisplay_unit_tests(p);
    run_eglInitialize_unit_tests(p);
    run_eglQueryString_unit_tests(p);
    run_eglGetConfigs_unit_tests(p);
    run_eglChooseConfig_unit_tests(p);
    run_eglBindAPI_unit_tests(p);
    run_eglCreateContext_unit_tests(p);
    run_eglDestroyContext_unit_tests(p);
    run_eglCreateWindowSurface_unit_tests(p);
    run_eglDestroySurface_unit_tests(p);
    run_eglQuerySurface_unit_tests(p);
    //run_eglQueryAPI_unit_tests(p); // See run_eglBindAPI_unit_tests
    run_eglQueryContext_unit_tests(p);
    //run_eglSurfaceAttrib_unit_tests(p);
    run_eglMakeCurrent_unit_tests(p);
    run_eglGetCurrentContext_unit_tests(p);
    run_eglGetCurrentSurface_unit_tests(p);
    run_eglGetCurrentDisplay_unit_tests(p);
    run_eglGetConfigAttrib_unit_tests(p);
    run_eglSwapBuffers_unit_tests(p);
    //run_eglGetError_unit_tests(p); // See any unit tests
    run_eglReleaseThread_unit_tests(p);
    run_eglTerminate_unit_tests(p);
}

void run_samples(TestPlatform* p) {
    // EGL+OpenGL
    run_sample1(p);
    run_sample2(p);
    // EGL
    run_sample0(p);
}


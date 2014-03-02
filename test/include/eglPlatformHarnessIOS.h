//
//  eglPlatformHarnessIOS.h
//  eglTests
//
//  Created by David Andreoletti on 10/11/13.
//  Copyright (c) 2013 David Andreoletti. All rights reserved.
//

#ifndef TEST_INCLUDE_EGLPLATFORMHARNESSIOS_H_
#define TEST_INCLUDE_EGLPLATFORMHARNESSIOS_H_

#include "./eglPlatformHarness.h"

#ifdef __cplusplus
extern "C" {
#endif

void iosInitializeWithDefault(TestPlatform* p);
void iosDestroyWithDefault(TestPlatform* p);
EGLNativeDisplayType iosCreateValidNativeDisplay();
void iosDestroyNativeDisplay(EGLNativeDisplayType nd);
EGLNativeDisplayType iosCreateInvalidNativeDisplay();
void iosPushNativeDisplay(EGLNativeDisplayType d, TestPlatform* p);
EGLNativeDisplayType iosPopNativeDisplay(TestPlatform* p);
EGLNativeWindowType iosCreateValidNativeWindow();
void iosDestroyValidNativeWindow(EGLNativeWindowType nd);
EGLNativeWindowType iosCreateInvalidNativeWindow();
void iosPushNativeWindow(EGLNativeWindowType w, TestPlatform* p);
EGLNativeWindowType iosPopNativeWindow(TestPlatform* p);

#ifdef __cplusplus
}
#endif


#endif  // TEST_INCLUDE_EGLPLATFORMHARNESSIOS_H_

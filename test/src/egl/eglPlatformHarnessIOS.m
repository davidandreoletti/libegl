//
//  eglPlatformHarnessIOS.m
//  eglTests
//
//  Created by David Andreoletti on 10/11/13.
//  Copyright (c) 2013 David Andreoletti. All rights reserved.
//

#include "eglPlatformHarnessIOS.h"
#include "OpenGLView.h"
#import <QuartzCore/QuartzCore.h>
#import "NSMutableArray+Stack.h"

//void pushController(UIViewController*) {
//    return 
//}

static NSMutableArray* validDisplayStack;
static NSMutableArray* validWindowStack;

void iosInitializeWithDefault(TestPlatform* p) {
    p->createValidNativeDisplay = iosCreateValidNativeDisplay;
    p->destroyValidNativeDisplay = iosDestroyNativeDisplay;
    p->createInvalidNativeDisplay = iosCreateInvalidNativeDisplay;
    p->pushNativeDisplay = iosPushNativeDisplay;
    p->popNativeDisplay = iosPopNativeDisplay;
    p->createValidNativeWindow = iosCreateValidNativeWindow;
    p->destroyValidNativeWindow = iosDestroyValidNativeWindow;
    p->createInvalidNativeWindow = iosCreateInvalidNativeWindow;
    p->pushNativeWindow = iosPushNativeWindow;
    p->popNativeWindow = iosPopNativeWindow;
    p->ios_platform_env_key = "EGL_PLATFORM";
    p->ios_platform_env_value = "ios";
    p->eglMajorDefault = 100;
    p->eglMinorDefault = 101;
    p->eglMajorExpected = 1;
    p->eglMinorExpected = 4;
    p->configs_num = 1000;
    
    validDisplayStack = [[NSMutableArray alloc] init ];
    validWindowStack = [[NSMutableArray alloc] init ];
}

void iosDestroyWithDefault(TestPlatform* p) {
    [validDisplayStack release];
    [validWindowStack release];
}

EGLNativeDisplayType iosCreateValidNativeDisplay() {
    UIWindow* w = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    w.backgroundColor = [UIColor whiteColor];
    return w;
}

void iosDestroyNativeDisplay(EGLNativeDisplayType nd) {
    [(UIWindow*)nd release];
}

EGLNativeDisplayType iosCreateInvalidNativeDisplay() {
    return (EGLNativeDisplayType)0xffffffff;
}


void iosPushNativeDisplay(EGLNativeDisplayType d, TestPlatform* p) {
    p->validNativeDisplay = d;
    [validDisplayStack push:d];
    UIApplication* app = [UIApplication sharedApplication];
    id<UIApplicationDelegate> delg = app.delegate;
    UIViewController* c = [[[UIViewController alloc] init] autorelease];
    [delg setWindow:d];
    [c setView:nil];
    [delg.window setRootViewController:c];
    [delg.window makeKeyAndVisible];
}

EGLNativeWindowType iosPopNativeDisplay(TestPlatform* p) {
    EGLNativeDisplayType pr = [validDisplayStack pop];
    p->validNativeDisplay = [validDisplayStack peek] == nil ? NULL : [validDisplayStack peek];
    UIApplication* app = [UIApplication sharedApplication];
    id<UIApplicationDelegate> delg = app.delegate;
    if (p->validNativeDisplay) {
        [delg setWindow:p->validNativeDisplay];
    }
    else {
        [delg setWindow:nil];
    }
    return pr;
}

EGLNativeWindowType iosCreateValidNativeWindow() {
    OpenGLView* v = [[OpenGLView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    ((CAEAGLLayer*) v.layer).opaque = YES;
    return v.layer;
}

void iosDestroyValidNativeWindow(EGLNativeWindowType nw) {
    [(UIView*)nw release];
}

EGLNativeWindowType iosCreateInvalidNativeWindow() {
    OpenGLView* v = [[[OpenGLView alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    return v;
}

void iosPushNativeWindow(EGLNativeWindowType w, TestPlatform* p) {
    p->validNativeWindow = w;
    [validWindowStack push:w];
    UIApplication* app = [UIApplication sharedApplication];
    id<UIApplicationDelegate> delg = app.delegate;
    UIWindow* win = delg.window;
    UIViewController* c = win.rootViewController;
    CALayer* l = (CALayer*) w;
    UIView* v = l.delegate;
    c.view = v;
}

EGLNativeWindowType iosPopNativeWindow(TestPlatform* p) {
    EGLNativeWindowType pr = [validWindowStack pop];
    p->validNativeWindow = [validWindowStack peek] == nil ? NULL : [validWindowStack peek];
    if (p->validNativeDisplay) {
        UIApplication* app = [UIApplication sharedApplication];
        id<UIApplicationDelegate> delg = app.delegate;
        UIWindow* win = delg.window;
        UIViewController* c = win.rootViewController;
        [c setView:nil];
    }
    return pr;
}
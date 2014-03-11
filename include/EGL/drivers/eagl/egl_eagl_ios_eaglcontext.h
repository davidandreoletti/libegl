//
//  \file egl_eagl_ios_eaglcontext.h
//  libegl
//
//  Created by Andreoletti David.
//  Copyright 2013 IO Stark. All rights reserved.
//

#ifndef INCLUDE_EGL_DRIVERS_EAGL_EGL_EAGL_IOS_EAGLCONTEXT_H_
#define INCLUDE_EGL_DRIVERS_EAGL_EGL_EAGL_IOS_EAGLCONTEXT_H_

#import "EGL/drivers/eagl/ios/AppleIOSMemoryManagement.h"
#import <OpenGLES/EAGL.h>
#import <Foundation/Foundation.h>

/**
 * iOS specific EGLContext
 */
@interface __EAGLIOSContext : NSObject
/**
 * iOS Native EAGL Context
 */
@property (OWNERSHIP_QUALIFIER_STRONG, nonatomic) EAGLContext* nativeContext;
/**
 * iOS Native  EAGL Shared Context
 */
@property (OWNERSHIP_QUALIFIER_STRONG, nonatomic) EAGLSharegroup* nativeSharedGroup;
@end

#endif  // INCLUDE_EGL_DRIVERS_EAGL_EGL_EAGL_IOS_EAGLCONTEXT_H_

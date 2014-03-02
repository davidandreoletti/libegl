//
//  \file egl_eagl_ios_eaglwindow.h
//  libegl
//
//  Created by Andreoletti David.
//  Copyright 2013 IO Stark. All rights reserved.
//

#ifndef INCLUDE_EGL_DRIVERS_EAGL_EGL_EAGL_IOS_EAGLWINDOW_H_
#define INCLUDE_EGL_DRIVERS_EAGL_EGL_EAGL_IOS_EAGLWINDOW_H_

#import "EGL/drivers/eagl/ios/AppleIOSMemoryManagement.h"
#import <Foundation/NSObject.h>
#import <UIKit/UIWindow.h>

// TODO: How to document this ?
@interface _UIWindow : NSObject

@property(OWNERSHIP_QUALIFIER_STRONG, nonatomic) UIWindow* window;

/**
 *  Default initializer
 *  \return
 */
- (id)init;

/**
 *  Destructor
 *  \return
 */
- (void)dealloc;
@end

#endif  // INCLUDE_EGL_DRIVERS_EAGL_EGL_EAGL_IOS_EAGLWINDOW_H_

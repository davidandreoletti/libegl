//
//  \file egl_eagl_ios_eaglsurface.h
//  libegl
//
//  Created by Andreoletti David.
//  Copyright 2013 IO Stark. All rights reserved.
//

#ifndef INCLUDE_EGL_DRIVERS_EAGL_EGL_EAGL_IOS_EAGLSURFACE_H_
#define INCLUDE_EGL_DRIVERS_EAGL_EGL_EAGL_IOS_EAGLSURFACE_H_

#import "EGL/drivers/eagl/ios/AppleIOSMemoryManagement.h"
#import "EGL/drivers/eagl/opengles/opengles_ios.h"
#include <OpenGLES/EAGLDrawable.h>
#include <CoreGraphics/CGContext.h>
#import <Foundation/Foundation.h>

/**
 * iOS specific EGLSurface
 */
@interface __EAGLSurface : NSObject {
}
/**
 * Native OpenGL buffers ids.
 */
@property (nonatomic, assign) _OpenGLBuffers buffers;
/**
 * Native iOS Window Surface.
 */
@property (OWNERSHIP_QUALIFIER_STRONG, nonatomic) id<EAGLDrawable> windowSurface;
/**
 * Native iOS Pbuffer Surface.
 */
@property (OWNERSHIP_QUALIFIER_STRONG, nonatomic) id pbufferSurface;
/**
 * Native iOS Pixmap Surface.
 */
@property (OWNERSHIP_QUALIFIER_WEAK, nonatomic) CGContextRef pixmapSurface;

/** Native surface types */
typedef enum {
    SURFACE_WINDOW,
    SURFACE_PBUFFER,
    SURFACE_PIXMAP,
    SURFACE_NONE
} surface_t;

/**
 * Indicates which surface type this object is referering to
 */
@property (readonly) surface_t type;
@end


#endif  // INCLUDE_EGL_DRIVERS_EAGL_EGL_EAGL_IOS_EAGLSURFACE_H_

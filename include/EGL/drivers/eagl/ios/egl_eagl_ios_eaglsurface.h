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

#ifndef INCLUDE_EGL_DRIVERS_EAGL_EGL_EAGL_IOS_EAGLSURFACE_H_
#define INCLUDE_EGL_DRIVERS_EAGL_EGL_EAGL_IOS_EAGLSURFACE_H_

#import "EGL/drivers/eagl/ios/AppleIOSMemoryManagement.h"
#import "EGL/drivers/eagl/opengles/opengles_ios.h"
#import <OpenGLES/EAGLDrawable.h>
#import <CoreGraphics/CGContext.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

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
/**
 * Native Display Frame Rate.
 */
@property (OWNERSHIP_QUALIFIER_STRONG, nonatomic) CADisplayLink* displayLink;

/**
 * Native Run Loop.
 */
@property (OWNERSHIP_QUALIFIER_STRONG, nonatomic) NSRunLoop* loop;

/**
 * @param frameInterval -1 to disable video frames updated
 */
- (void) setupVideoFrameIntervalUpdates:(NSUInteger) frameInterval;

/**
 * Wait until the requested number of video frame updates occurred 
 */
- (void) waitUntilMinIntervalFrameUpdated;

/**
 * Cancels waiting until the requested number of video frame updates occurred
 */
- (void) cancelWaitUntilMinIntervalFrameUpdated;

@end


#endif  // INCLUDE_EGL_DRIVERS_EAGL_EGL_EAGL_IOS_EAGLSURFACE_H_

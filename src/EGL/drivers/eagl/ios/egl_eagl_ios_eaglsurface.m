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

#include "EGL/drivers/eagl/ios/egl_eagl_ios_eaglsurface.h"
#include "EGL/drivers/eagl/ios/AppleIOSMemoryManagement.h"
#import <Foundation/Foundation.h>

@interface __EAGLSurface ()
/** 
 *  0 == number of video frame update reached
 *  0< == number of video frame update not yet reached
 *  0< == updates cancelled
 */
@property (atomic, readonly) NSInteger frameCount;
@property (nonatomic, readonly) NSCondition* condition;
- (void) onDisplayFrameUpdate:(CADisplayLink*) display;
@end

@implementation __EAGLSurface

@synthesize buffers;

@synthesize windowSurface = _windowSurface;

@synthesize type;

@synthesize displayLink;

@synthesize loop;

@synthesize frameCount;

@synthesize condition;

-(void) setWindowSurface:(id<EAGLDrawable>)surf {
    if (_windowSurface != surf) {
        OWNERSHIP_RETAIN((id<NSObject>) surf);
        OWNERSHIP_RELEASE((id<NSObject>) _windowSurface);
        _windowSurface = surf;
        type = SURFACE_WINDOW;
    }
}

@synthesize pbufferSurface = _pbufferSurface;

-(void) setPbufferSurface:(id)surf {
    if (_pbufferSurface != surf) {
        OWNERSHIP_RETAIN((id<NSObject>) surf);
        OWNERSHIP_RELEASE((id<NSObject>) _pbufferSurface);
        _pbufferSurface = surf;
        type = SURFACE_PBUFFER;
    }
}

@synthesize pixmapSurface = _pixmapSurface;

-(void) setPixmapSurface:(CGContextRef)surf {
    if (_pixmapSurface != surf) {
        OWNERSHIP_RETAIN((id<NSObject>) surf);
        OWNERSHIP_RELEASE((id<NSObject>) _pixmapSurface);
        _pixmapSurface = surf;
        type = SURFACE_PIXMAP;
    }
}

- (id)init {
    self = [super init];
    if (self) {
        memset(&buffers, 0,sizeof(_OpenGLBuffers));
        type = SURFACE_NONE;
        frameCount = 0;
        condition = [[NSCondition alloc] init];
        }
    return self;
}

- (void)dealloc {
    OWNERSHIP_RELEASE((id<NSObject>) _windowSurface);
    OWNERSHIP_RELEASE((id<NSObject>) _pixmapSurface);
    OWNERSHIP_RELEASE((id<NSObject>) _pbufferSurface);
    [self setupVideoFrameIntervalUpdates:0];
    OWNERSHIP_RELEASE((id<NSObject>) displayLink);
    OWNERSHIP_RELEASE((id<NSObject>) condition);
    METHOD_DEALLOC(super);
}

- (void) setupVideoFrameIntervalUpdates:(NSUInteger) frameInterval {
    if (!displayLink) {
        if (frameInterval > 0) {
            displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(onDisplayFrameUpdate:)];
            displayLink.frameInterval = frameInterval;
            loop = [NSRunLoop mainRunLoop]; //FIXME: What loop should be used ?
            [displayLink addToRunLoop:loop forMode:[loop currentMode]];
        }
    }
    else {
        if (frameInterval == 0) {
            [displayLink removeFromRunLoop:loop forMode:[loop currentMode]];
            [displayLink invalidate];
            displayLink = nil;
        }
        else if (frameInterval != [displayLink frameInterval]) {
            displayLink.frameInterval = frameInterval;
        }
    }

}

- (void) onDisplayFrameUpdate:(CADisplayLink*) display {
    [condition lock];
    if (display && frameCount > 0) {
        frameCount--;
        if (frameCount == 0) {
            [condition signal];
        }
    }
    [condition unlock];
}

- (void) waitUntilMinIntervalFrameUpdated {
    [condition lock];
    while (frameCount > 0) {
        [condition wait];
    }
    if (frameCount == 0) {frameCount++;}
    [condition unlock];
}

- (void) cancelWaitUntilMinIntervalFrameUpdated {
    [condition lock];
    frameCount = -1;
    [condition signal];
    [condition unlock];
}

@end

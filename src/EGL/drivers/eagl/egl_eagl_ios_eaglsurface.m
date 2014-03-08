//
//  \file egl_eagl_ios_eagldrawable.mm
//  libegl
//
//  Created by Andreoletti David.
//  Copyright 2013 IO Stark. All rights reserved.
//

#include "EGL/drivers/eagl/egl_eagl_ios_eaglsurface.h"
#include "EGL/drivers/eagl/ios/AppleIOSMemoryManagement.h"
#import <Foundation/Foundation.h>

@implementation __EAGLSurface

@synthesize buffers;

@synthesize windowSurface = _windowSurface;

@synthesize type;

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
        }
    return self;
}

- (void)dealloc {
    METHOD_DEALLOC(super);
    OWNERSHIP_RELEASE((id<NSObject>) _windowSurface);
    OWNERSHIP_RELEASE((id<NSObject>) _pixmapSurface);
    OWNERSHIP_RELEASE((id<NSObject>) _pbufferSurface);
}

@end

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

@synthesize windowSurface;

@synthesize type;

-(void) setWindowSurface:(id<EAGLDrawable>)ws {
    // Memory leak in ARC/non ARC compilation
    if (windowSurface != ws) {
        windowSurface = ws;
        type = SURFACE_WINDOW;
    }
}

@synthesize pbufferSurface;

-(void) setPbufferSurface:(id)pb {
    // Memory leak in ARC/non ARC compilation
    if (pbufferSurface != pb) {
        pbufferSurface = pb;
        type = SURFACE_PBUFFER;
    }
}

@synthesize pixmapSurface;

-(void) setPixmapSurface:(CGContextRef)px {
    // Memory leak in ARC/non ARC compilation
    if (pixmapSurface != px) {
        pixmapSurface = px;
        type = SURFACE_PIXMAP;
    }
}

- (id)init {
    self = [super init];
    if (self) {
        buffers = (_OpenGLBuffers*) malloc(sizeof(_OpenGLBuffers));
        memset(buffers, 0,sizeof(_OpenGLBuffers));
        type = SURFACE_NONE;
        }
    return self;
}

- (void)dealloc {
    free(buffers);
    [super METHOD_DEALLOC];
}

@end

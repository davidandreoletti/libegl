//
//  \file egl_eagl_ios_eaglwindow.mm
//  libegl
//
//  Created by Andreoletti David.
//  Copyright 2013 IO Stark. All rights reserved.
//

#include "EGL/drivers/eagl/egl_eagl_ios_eaglwindow.h"

@implementation _UIWindow

@synthesize window;

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)dealloc
{
    METHOD_DEALLOC(super);
    OWNERSHIP_RELEASE(window);
}

@end

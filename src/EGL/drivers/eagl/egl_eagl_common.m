//
//  \file egl_eagl_common.mm
//  libegl
//
//  Created by Andreoletti David.
//  Copyright 2013 IO Stark. All rights reserved.
//

#include "EGL/drivers/eagl/egl_eagl_common.h"
#include "EGL/drivers/eagl/ios/AppleIOSMemoryManagement.h"

void freeEAGL_egl_display(struct EAGL_egl_display* disp) {
    if(disp->dpy != NULL) {
        ownership_bridge_release(disp->dpy);
        disp->dpy = nil;
    }
    if(disp->visuals != NULL) {
        ownership_bridge_release(disp->visuals);
        disp->visuals = nil;
    }
}

void freeEAGL_egl_context(struct EAGL_egl_context* context) {
    if(context->context != NULL) {
        ownership_bridge_release(context->context);
        context->context = nil;
    }
}

void freeEAGL_egl_surface(struct EAGL_egl_surface* surf) {
    if(surf->eagl_drawable != NULL) {
        ownership_bridge_release(surf->eagl_drawable);
        surf->eagl_drawable = nil;
    }
}

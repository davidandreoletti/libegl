//
//  \file egl_eagl_display.h
//  libegl
//
//  Created by Andreoletti David.
//  Copyright 2013 IO Stark. All rights reserved.
//

#ifndef INCLUDE_EGL_DRIVERS_EAGL_EGL_EAGL_DISPLAY_H_
#define INCLUDE_EGL_DRIVERS_EAGL_EGL_EAGL_DISPLAY_H_

#include "EGL/drivers/eagl/egl_eagl_typedefs.h"
#include "EGL/eglMutex.h"
#include <stdbool.h>

/** driver data of _EGLDisplay */
struct EAGL_egl_display
{
    //    _EGLDisplay Base;
    _EAGLWindow *dpy;
    _UIScreen *visuals; // Was XVisualInfo == pixel format
    //EAGLFBConfig *fbconfigs;
    
    int VersionMajor, VersionMinor; // was glx_maj, glx_min
    
    const char *extensions;
    EGLBoolean have_make_current_read;
    //EGLBoolean have_fbconfig;
    EGLBoolean have_pbuffer;
    
    /* workaround quirks of different EAGL implementations */
    EGLBoolean single_buffered_quirk;
    EGLBoolean glx_window_quirk;
};

#endif  // INCLUDE_EGL_DRIVERS_EAGL_EGL_EAGL_DISPLAY_H_

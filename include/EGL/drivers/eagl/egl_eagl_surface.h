//
//  \file egl_eagl_surface.h
//  libegl
//
//  Created by Andreoletti David.
//  Copyright 2013 IO Stark. All rights reserved.
//

#ifndef INCLUDE_EGL_DRIVERS_EAGL_EGL_EAGL_SURFACE_H_
#define INCLUDE_EGL_DRIVERS_EAGL_EGL_EAGL_SURFACE_H_

#include "EGL/drivers/eagl/egl_eagl_typedefs.h"

/** subclass of _EGLSurface */
struct EAGL_egl_surface
{
    _EGLSurface Base;   /**< base class */
    __OWNERSHIP_QUALIFIER_WEAK _EAGLSurface* eagl_drawable;
};

#endif  // INCLUDE_EGL_DRIVERS_EAGL_EGL_EAGL_SURFACE_H_

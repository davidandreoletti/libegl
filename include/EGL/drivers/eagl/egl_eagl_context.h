//
//  \file egl_eagl_context.h
//  libegl
//
//  Created by Andreoletti David.
//  Copyright 2013 IO Stark. All rights reserved.
//

#ifndef INCLUDE_EGL_DRIVERS_EAGL_EGL_EAGL_CONTEXT_H_
#define INCLUDE_EGL_DRIVERS_EAGL_EGL_EAGL_CONTEXT_H_

#include "EGL/drivers/eagl/egl_eagl_typedefs.h"
#include "EGL/eglContext.h"

/** subclass of _EGLContext */
struct EAGL_egl_context
{
    _EGLContext Base;   /**< base class */
    __OWNERSHIP_QUALIFIER_WEAK _EAGLContext* context;
    _OpenGLESAPI openGLESAPI;
    EGLBoolean wasCurrent; // EGL_TRUE if this context has been current at least once
};

#endif  // INCLUDE_EGL_DRIVERS_EAGL_EGL_EAGL_CONTEXT_H_

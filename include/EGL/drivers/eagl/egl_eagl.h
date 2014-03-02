//
//  \file egl_eagl.h
//  libegl
//
//  Created by Andreoletti David.
//  Copyright 2013 IO Stark. All rights reserved.
//

#ifndef INCLUDE_EGL_DRIVERS_EAGL_EGL_IOSEAGL_H_
#define INCLUDE_EGL_DRIVERS_EAGL_EGL_IOSEAGL_H_

#include "EGL/egltypedefs.h"

/**
 *  Loads platform agnostic EAGL driver
 *  \param args
 *  \return Driver
 */
_EGLDriver* _eglBuiltInDriverEAGL(const char *args);

#endif  // INCLUDE_EGL_DRIVERS_EAGL_EGL_IOSEAGL_H_

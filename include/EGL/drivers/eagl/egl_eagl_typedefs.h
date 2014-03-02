//
//  \file egl_eagl_typedefs.h
//  libegl
//
//  Created by Andreoletti David.
//  Copyright 2013 IO Stark. All rights reserved.
//

#ifndef INCLUDE_EGL_DRIVERS_EAGL_EGL_EAGL_TYPEDEFS_H_
#define INCLUDE_EGL_DRIVERS_EAGL_EGL_EAGL_TYPEDEFS_H_

#ifdef _EGL_BUILT_IN_DRIVER_IOSEAGL

#include "EGL/drivers/eagl/egl_eagl_ios_eaglwindow.h"
#include "EGL/drivers/eagl/egl_eagl_ios_eaglcontext.h"
#include "EGL/drivers/eagl/egl_eagl_ios_eaglscreen.h"
#include "EGL/drivers/eagl/egl_eagl_ios_eaglsurface.h"
#include "EGL/drivers/eagl/egl_eagl_ios_eaglimage.h"
#include "EGL/drivers/eagl/opengles/opengles_ios.h"

typedef _UIWindow _EAGLWindow;
typedef __EAGLIOSContext _EAGLContext;
typedef __OpenGLESAPI _OpenGLESAPI;
typedef _UIScreen _EAGLScreen;
typedef __EAGLSurface _EAGLSurface;
typedef __EAGLImage _EAGLImage;

#else

typedef void _EAGLWindow;
typedef void _EAGLContext;
typedef void _EAGLScreen;
typedef void _EAGLDrawable;
typedef void _EAGLImage;
typedef void _OpenGLESAPI;

#endif

#endif  // INCLUDE_EGL_DRIVERS_EAGL_EGL_EAGL_TYPEDEFS_H_

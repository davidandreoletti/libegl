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

#ifndef INCLUDE_EGL_DRIVERS_EAGL_EGL_EAGL_TYPEDEFS_H_
#define INCLUDE_EGL_DRIVERS_EAGL_EGL_EAGL_TYPEDEFS_H_

#ifdef _EGL_BUILT_IN_DRIVER_IOSEAGL

#include "EGL/drivers/eagl/egl_eagl_ios_eaglwindow.h"
#include "EGL/drivers/eagl/egl_eagl_ios_eaglcontext.h"
#include "EGL/drivers/eagl/egl_eagl_ios_eaglsurface.h"
#include "EGL/drivers/eagl/egl_eagl_ios_eaglimage.h"
#include "EGL/drivers/eagl/opengles/opengles_ios.h"

typedef _UIWindow _EAGLWindow;
typedef __EAGLIOSContext _EAGLContext;
typedef __OpenGLESAPI _OpenGLESAPI;
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

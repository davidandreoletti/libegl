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

#ifndef INCLUDE_EGL_DRIVERS_EAGL_EGL_EAGL_DRIVER_IOS_H_
#define INCLUDE_EGL_DRIVERS_EAGL_EGL_EAGL_DRIVER_IOS_H_

#include "EGL/egltypedefs.h"
#include "EGL/drivers/eagl/egl_eagl_driver.h"
#include "EGL/drivers/eagl/egl_eagl_display.h"

/**
 * Creates EGLConfig(s) for the iOS platform
 * \param EAGL_drv Driver
 * \param dpy Display to store created EGConfig to
 * \param num_configs Number of EGLConfig created
 * \return EGL_TRUE if creation is successfull. EGL_FALSE otherwise.
 */
EGLBoolean
create_ios_configs(struct EAGL_egl_driver *EAGL_drv, _EGLDisplay *dpy, EGLint* num_configs);

/**
 *  Loads iOS EAGL driver
 *  \param args
 *  \return Driver
 */
struct EAGL_egl_driver* _eglBuiltInDriverEAGLIOS(const char *args);

#endif  // INCLUDE_EGL_DRIVERS_EAGL_EGL_EAGL_DRIVER_IOS_H_

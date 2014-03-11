//
//  \file egl_eagl_driver_ios.h
//  libegl
//
//  Created by Andreoletti David.
//  Copyright 2013 IO Stark. All rights reserved.
//

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
create_ios_configs(struct EAGL_egl_driver *EAGL_drv, _EGLDisplay *dpy/*, void** configs,*/, EGLint* num_configs);

/**
 *  Loads iOS EAGL driver
 *  \param args
 *  \return Driver
 */
struct EAGL_egl_driver* _eglBuiltInDriverEAGLIOS(const char *args);

#endif  // INCLUDE_EGL_DRIVERS_EAGL_EGL_EAGL_DRIVER_IOS_H_

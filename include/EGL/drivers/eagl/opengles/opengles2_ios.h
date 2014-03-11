//
//  opengles2_ios.h
//  eglapi-core-lib
//
//  Created by David Andreoletti on 06/02/2014.
//  Copyright (c) 2014 IO Stark. All rights reserved.
//

#ifndef INCLUDE_EGL_DRIVERS_EAGL_OPENGLES_OPENGLES2_IOS_H_
#define INCLUDE_EGL_DRIVERS_EAGL_OPENGLES_OPENGLES2_IOS_H_

#include "EGL/drivers/eagl/opengles/opengles_ios.h"

/**
 * Initializes an OpenGL ES 2.x abstraction API instance pointing to functions for the requested
 * OpenGL API ES version
 * \param api OpenGL ES abstraction API instance. If NULL, no initialization occurs.
 * \param version Requested OpenGL API ES version
 */
void opengles2_api_init(__OpenGLESAPI* api);

#endif  // INCLUDE_EGL_DRIVERS_EAGL_OPENGLES_OPENGLES2_IOS_H_

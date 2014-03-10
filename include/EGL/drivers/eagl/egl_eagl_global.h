//
//  \file egl_eagl_globals.h
//  libegl
//
//  Created by Andreoletti David.
//  Copyright 2013 IO Stark. All rights reserved.
//

#ifndef INCLUDE_EGL_DRIVERS_EAGL_EGL_EAGL_GLOBALS_H_
#define INCLUDE_EGL_DRIVERS_EAGL_EGL_EAGL_GLOBALS_H_

#include "EGL/eglMutex.h"
#include <stdbool.h>

/** EAGL globals */
struct EAGL_egl_global {
    _EGLMutex *Mutex;
    bool foregroundApplication;
};

extern struct EAGL_egl_global _eaglGlobal;

/**
 * Returns context lost status
 */
bool isContextLost(struct EAGL_egl_global* global);

/**
 * Sets context lost status
 */
void setContextLost(struct EAGL_egl_global* global, bool value);

#endif  // INCLUDE_EGL_DRIVERS_EAGL_EGL_EAGL_GLOBALS_H_

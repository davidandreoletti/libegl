//
//  \file egl_eagl_config.h
//  libegl
//
//  Created by Andreoletti David.
//  Copyright 2013 IO Stark. All rights reserved.
//

#ifndef INCLUDE_EGL_DRIVERS_EAGL_EGL_EAGL_CONFIG_H_
#define INCLUDE_EGL_DRIVERS_EAGL_EGL_EAGL_CONFIG_H_

#include "EGL/drivers/eagl/egl_eagl_typedefs.h"
#include "EGL/drivers/eagl/egl_eagl_misc.h"

/** iOS specific _EGLConfig */
typedef struct {
    EGLint configID;
    int eaglRenderingAPI;   // EAGLRenderingAPI
    NSString* colorFormat;
    int retainBacking;      // what is this for ?
    int depth;              // Depth buffer in bits
    int frameBufferLevel;
    int surfaceType;        // Surface Type(s) : EGL_WINDOW_BIT/EGL_PIXMAP_BIT/EGL_PBUFFER_BIT
} _EAGL_egl_Config_iOS;

/** subclass of _EGLConfig */
struct EAGL_egl_config
{
    _EGLConfig Base;   /**< base class */
    EGLBoolean double_buffered;
    _EAGL_egl_Config_iOS conf;
    int index;
};

static int
EAGL_egl_config_index(_EGLConfig *conf)
{
    struct EAGL_egl_config *EAGL_conf = EAGL_egl_config(conf);
    return EAGL_conf->index;
}

#endif  // INCLUDE_EGL_DRIVERS_EAGL_EGL_EAGL_CONFIG_H_

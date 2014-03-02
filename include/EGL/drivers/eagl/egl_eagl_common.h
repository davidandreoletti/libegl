//
//  \file egl_eagl_common.h
//  libegl
//
//  Created by Andreoletti David.
//  Copyright 2013 IO Stark. All rights reserved.
//

#ifndef INCLUDE_EGL_DRIVERS_EAGL_EGL_EAGL_H_
#define INCLUDE_EGL_DRIVERS_EAGL_EGL_EAGL_H_

#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

#include "EGL/eglconfig.h"
#include "EGL/eglcontext.h"
#include "EGL/egldefines.h"
#include "EGL/egldisplay.h"
#include "EGL/egldriver.h"
#include "EGL/eglcurrent.h"
#include "EGL/egllog.h"
#include "EGL/eglsurface.h"
#include "EGL/drivers/eagl/egl_eagl_typedefs.h"

#define CALLOC_STRUCT(T)   (struct T *) calloc(1, sizeof(struct T))
#define Bool    bool

/** driver data of _EGLDisplay */
struct EAGL_egl_display
{
//    _EGLDisplay Base;
    _EAGLWindow *dpy;
    _UIScreen *visuals; // Was XVisualInfo == pixel format
    //EAGLFBConfig *fbconfigs;
    
    int VersionMajor, VersionMinor; // was glx_maj, glx_min
    
    const char *extensions;
    EGLBoolean have_make_current_read;
    //EGLBoolean have_fbconfig;
    EGLBoolean have_pbuffer;
    
    /* workaround quirks of different EAGL implementations */
    EGLBoolean single_buffered_quirk;
    EGLBoolean glx_window_quirk;
};

/** subclass of _EGLContext */
struct EAGL_egl_context
{
    _EGLContext Base;   /**< base class */
    _EAGLContext* context;
    _OpenGLESAPI openGLESAPI;
    EGLBoolean wasCurrent; // EGL_TRUE if this context has been current at least once
};

/** subclass of _EGLSurface */
struct EAGL_egl_surface
{
    _EGLSurface Base;   /**< base class */
    
    //    Drawable drawable;
    _EAGLSurface* eagl_drawable; // was glx_drawable glx_drawable
    
    void (*destroy)(_EAGLWindow *, _EAGLSurface*); // must [ eagl_drawable release]
};

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

/* standard typecasts */
_EGL_DRIVER_STANDARD_TYPECASTS(EAGL_egl)

static int
EAGL_egl_config_index(_EGLConfig *conf)
{
    struct EAGL_egl_config *EAGL_conf = EAGL_egl_config(conf);
    return EAGL_conf->index;
}

/**
 * Free EAGL_egl_display
 */
void freeEAGL_egl_display(struct EAGL_egl_display* disp);

/**
 * Free EAGL_egl_context
 */
void freeEAGL_egl_context(struct EAGL_egl_context* context);

/**
 * Free EAGL_egl_surface
 */
void freeEAGL_egl_surface(struct EAGL_egl_surface* surf);


#endif  // INCLUDE_EGL_DRIVERS_EAGL_EGL_EAGL_H_

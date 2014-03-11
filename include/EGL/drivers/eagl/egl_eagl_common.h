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
#include "EGL/drivers/eagl/egl_eagl_globals.h"
#include "EGL/drivers/eagl/ios/AppleIOSMemoryManagement.h"

#define CALLOC_STRUCT(T)   (struct T *) calloc(1, sizeof(struct T))
#define Bool    bool

/** subclass of _EGLContext */
struct EAGL_egl_context
{
    _EGLContext Base;   /**< base class */
    __OWNERSHIP_QUALIFIER_WEAK _EAGLContext* context;
    _OpenGLESAPI openGLESAPI;
    EGLBoolean wasCurrent; // EGL_TRUE if this context has been current at least once
};

/** subclass of _EGLSurface */
struct EAGL_egl_surface
{
    _EGLSurface Base;   /**< base class */
    __OWNERSHIP_QUALIFIER_WEAK _EAGLSurface* eagl_drawable;
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

/** Find ressource query/result */
struct findresource {
    enum RequestType {SURFACE_NATIVEWINDOW};
    /** criteria */
    enum RequestType requestType;
    enum _egl_resource_type type;
    void* data;
    /** result */
    bool found;
};

/**
 * Finds first occurence satisfying the citeria
 * \param head Display list
 * \param data
 */
static void findResource(_EGLDisplay* head, struct findresource* query) {

    _EGLDisplay* disp = head;
    while (disp) {
        if (0<_EGL_NUM_RESOURCES) {
            _EGLResource* res = disp->ResourceLists[query->type];
            while (res && !query->found) {
                switch (query->requestType) {
                    case SURFACE_NATIVEWINDOW:
                    {
                        struct EAGL_egl_surface* s = EAGL_egl_surface((_EGLSurface*)res);
                        if (s->eagl_drawable.windowSurface == ((EGLNativeWindowType)query->data)) {
                            query->found = true;
                        }
                    }
                    break;
                    default:
                        break;
                }
                res = res->Next;
            }
        }
        disp = disp->Next;
    }
}
#endif  // INCLUDE_EGL_DRIVERS_EAGL_EGL_EAGL_H_

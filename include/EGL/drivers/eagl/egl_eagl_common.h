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
#include "EGL/drivers/eagl/egl_eagl_context.h"
#include "EGL/drivers/eagl/egl_eagl_surface.h"
#include "EGL/drivers/eagl/egl_eagl_config.h"
#include "EGL/drivers/eagl/egl_eagl_misc.h"
#include "EGL/drivers/eagl/ios/AppleIOSMemoryManagement.h"

#define CALLOC_STRUCT(T)   (struct T *) calloc(1, sizeof(struct T))
#define Bool    bool

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

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

#ifndef INCLUDE_EGL_DRIVERS_EAGL_EGL_EAGL_MISC_H_
#define INCLUDE_EGL_DRIVERS_EAGL_EGL_EAGL_MISC_H_

#include "EGL/egldriver.h"
#include "EGL/drivers/eagl/egl_eagl_globals.h"
#include "EGL/drivers/eagl/egl_eagl_context.h"
#include "EGL/drivers/eagl/egl_eagl_surface.h"
#include "EGL/drivers/eagl/egl_eagl_config.h"

/* standard typecasts */
_EGL_DRIVER_STANDARD_TYPECASTS(EAGL_egl)

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

#endif  // INCLUDE_EGL_DRIVERS_EAGL_EGL_EAGL_MISC_H_

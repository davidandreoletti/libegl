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

#ifndef INCLUDE_EGL_DRIVERS_EAGL_EGL_EAGL_DRIVER_H_
#define INCLUDE_EGL_DRIVERS_EAGL_EGL_EAGL_DRIVER_H_

#include <stdbool.h>

#include "EGL/egldriver.h"
#include "EGL/drivers/eagl/egl_eagl_typedefs.h"
#include "EGL/drivers/eagl/egl_eagl_display.h"
#include "EGL/drivers/eagl/egl_eagl_config.h"
#include "EGL/drivers/eagl/egl_eagl_surface.h"

typedef void(*ProcAddressFuncPtr)();

/* EAGL Procedures prototypes */
typedef ProcAddressFuncPtr (*EAGLGETPROCADDRESSPROC)(const char * proc_name);

/**
 *  Initializes an EGL Display
 *  \param dpy EGL Display. 
 *  \param disp IF nil, create a new UIWindow instance, otherwise creates one. Then bind the UIWindow instance to dpy
 *  \return EGL_TRUE if initialization succeeded.
 */
typedef EGLBoolean (*EAGLINITIALIZEPROC)(struct EAGL_egl_display * dpy, _EGLDisplay *disp);

/**
 *  Terminates an EGL Display
 *  \param dpy EGL Display.
 *  \return EGL_TRUE if termination succeeded.
 */
typedef EGLBoolean (*EAGLTERMINATEPROC)(struct EAGL_egl_display *EAGL_dpy);

/**
 *  Creates a native EGL Context
 * \param EAGL_dpy
 * \param EAGL_conf
 * \param EAGL_ctx_shared
 * \param attrib_list
 * \param EAGL_ctx
 *  \return Non NULL instance if initialization succeeded only.
 */
typedef struct EAGL_egl_context * (*EAGLCREATECONTEXTPROC)( struct EAGL_egl_display *EAGL_dpy,
                                                struct EAGL_egl_config *EAGL_conf ,
                                                struct EAGL_egl_context *EAGL_ctx_shared,
                                                const EGLint *attrib_list,
                                                struct EAGL_egl_context *EAGL_ctx);
/**
 *  Destroys a native EGL Context
 * \param EAGL_dpy
 * \param EAGL_ctx
 */
typedef void (*EAGLDESTROYCONTEXTPROC)( _EAGLWindow *dpy, struct EAGL_egl_context* ctx );

/**
 *  Make EGLContext current a native EGL Context
 * \param dpy,
 * \param EAGL_dsurf
 * \param EAGL_rsurf
 * \param EAGL_ctx
 * \param EAGL_odsurf
 * \param EAGL_orsurf
 * \param EAGL_octx
 *  \return Non NULL instance IFF initialization succeeded only.
 */
typedef EGLBoolean (*EAGLMAKECURRENTPROC)(_EAGLWindow *dpy,
                                          struct EAGL_egl_surface* EAGL_dsurf,
                                          struct EAGL_egl_surface* EAGL_rsurf,
                                          struct EAGL_egl_context* EAGL_ctx,
                                          struct EAGL_egl_surface *EAGL_odsurf,
                                          struct EAGL_egl_surface *EAGL_orsurf,
                                          struct EAGL_egl_context *EAGL_octx);
/**
 *  Swap buffers
 * \param EAGL_dpy
 * \param EAGL_surf
 * \return EGL_TRUE if swap succeeded.
 */
typedef EGLBoolean (*EAGLSWAPBUFFERSPROC)(struct EAGL_egl_display* EAGL_dpy, struct EAGL_egl_surface *EAGL_surf);

/**
 *  Swap intervals
 * \param EAGL_dpy
 * \param EAGL_surf
 * \return EGL_TRUE if interval successfully set.
 */
typedef EGLBoolean (*EAGLSWAPINTERVALPROC)(struct EAGL_egl_display* EAGL_dpy, struct EAGL_egl_surface *EAGL_surf, EGLint interval);

typedef _EAGLImage*/*GLXPixmap*/ (*EAGLCREATEPIXMAPPROC)( _EAGLWindow *dpy, _EAGLImage* pixmap );
typedef void (*EAGLDESTROYPIXMAPPROC)( _EAGLWindow *dpy, _EAGLImage*/*GLXPixmap*/ pixmap );
/**
 * Query version
 * \param dpy
 * \param maj EGL major version supported by the driver
 * \param min EGL minor version supported by the driver
 * \return EGL_TRUE if query succeeded.
 */
typedef EGLBoolean (*EAGLQUERYVERSIONPROC)( _EAGLWindow *dpy, int *maj, int *min );

/**
 * Query surface
 * \param surface The surface
 * \param attrib Atribute
 * \param value Value for attribute
 */
typedef EGLBoolean (*EAGLQUERYYSURFACEPROC) (_EAGLSurface* surface, int attrib, int *value);
typedef int (*EAGLGETCONFIGSPROC)( _EAGLWindow *dpy, int attrib, int *value );
typedef EGLBoolean (*EAGLWAITGLPROC)( struct EAGL_egl_context *EAGL_context );
typedef EGLBoolean (*EAGLWAITNATIVEPROC)( void );
typedef const char *(*EAGLQUERYEXTENSIONSSTRINGPROC)( _EAGLWindow *dpy, int screen );
typedef const char *(*EAGLQUERYSERVERSTRINGPROC)( _EAGLWindow *dpy, int screen, int name );
typedef const char *(*EAGLGETCLIENTSTRINGPROC)( _EAGLWindow *dpy, int name );

typedef void *(*EAGLCREATEWINDOWPROC)(struct EAGL_egl_display *EAGL_dpy, struct EAGL_egl_config *EAGL_conf, EGLNativeWindowType window, const EGLint *attrib_list, struct EAGL_egl_surface *EAGL_surf);
typedef EGLBoolean (*EAGLDESTROYWINDOWPROC)(struct EAGL_egl_display *EAGL_dpy, struct EAGL_egl_surface *EAGL_surf);
typedef void *(*EAGLCREATEPBUFFERPROC)(void);
typedef void *(*EAGLDESTROYPBUFFERPROC)(void);
typedef void *(*EAGLCREATENEWCONTEXTPROC)(void);
typedef void *(*EAGLMAKECONTEXTCURRENTPROC)(void);



/** subclass of _EGLDriver */
struct EAGL_egl_driver
{
    _EGLDriver Base;   /**< base class */
    
    void *handle;
    
    /* EAGL x.x */
    EAGLINITIALIZEPROC Initialize;
    EAGLTERMINATEPROC Terminate;
    
    EAGLGETCONFIGSPROC GetConfigs;

    EAGLCREATECONTEXTPROC CreateContext;
    EAGLDESTROYCONTEXTPROC DestroyContext;
    
    EAGLMAKECURRENTPROC MakeCurrent;
    
    EAGLGETPROCADDRESSPROC GetProcAddress;


    EAGLSWAPBUFFERSPROC SwapBuffers;
    EAGLSWAPINTERVALPROC SwapInterval;
    EAGLQUERYVERSIONPROC QueryVersion;

    EAGLWAITGLPROC WaitGL;
    EAGLWAITNATIVEPROC WaitNative;
    
    EAGLQUERYEXTENSIONSSTRINGPROC QueryExtensionsString;
    EAGLQUERYSERVERSTRINGPROC QueryServerString;
    EAGLGETCLIENTSTRINGPROC GetClientString;
    
    EAGLCREATEWINDOWPROC CreateWindow;
    EAGLDESTROYWINDOWPROC DestroyWindow;
    EAGLCREATEPIXMAPPROC CreatePixmap;
    EAGLDESTROYPIXMAPPROC DestroyPixmap;
    EAGLCREATEPBUFFERPROC CreatePbuffer;
    EAGLDESTROYPBUFFERPROC DestroyPbuffer;
    
    EAGLQUERYYSURFACEPROC QuerySurface;

    EAGLCREATENEWCONTEXTPROC CreateNewContext;
    EAGLMAKECONTEXTCURRENTPROC MakeContextCurrent;
};

static void
EAGL_Unload(_EGLDriver *drv)
{
    struct EAGL_egl_driver *EAGL_drv = EAGL_egl_driver(drv);
    
    if (EAGL_drv->handle) {
        // dlclose(EAGL_drv->handle);
    }
    free(EAGL_drv);
}

static EGLBoolean
EAGL_Load(_EGLDriver *drv)
{
    struct EAGL_egl_driver *EAGL_drv = EAGL_egl_driver(drv);
    void *handle = NULL;

    if (!EAGL_drv->GetProcAddress)
        goto fail;

#define GET_PROC(proc_type, proc_name, check)                                  \
    do {                                                                       \
        EAGL_drv->proc_name = (proc_type)                                      \
            EAGL_drv->GetProcAddress(  #proc_name );                           \
        if (check && !EAGL_drv->proc_name) goto fail;                          \
    } while (0)

    /* EAGL x.x */
    GET_PROC(EAGLINITIALIZEPROC,  Initialize, EGL_TRUE);
    GET_PROC(EAGLTERMINATEPROC,  Terminate, EGL_TRUE);
    GET_PROC(EAGLCREATECONTEXTPROC,  CreateContext, EGL_TRUE);
    GET_PROC(EAGLDESTROYCONTEXTPROC,  DestroyContext, EGL_TRUE);
    GET_PROC(EAGLMAKECURRENTPROC,  MakeCurrent, EGL_TRUE);
    GET_PROC(EAGLSWAPBUFFERSPROC,  SwapBuffers, EGL_TRUE);
    GET_PROC(EAGLSWAPINTERVALPROC,  SwapInterval, EGL_TRUE);
    GET_PROC(EAGLQUERYVERSIONPROC,  QueryVersion, EGL_TRUE);
    GET_PROC(EAGLWAITGLPROC,  WaitGL, EGL_TRUE);
    GET_PROC(EAGLWAITNATIVEPROC,  WaitNative, EGL_TRUE);

    GET_PROC(EAGLQUERYEXTENSIONSSTRINGPROC,  QueryExtensionsString, EGL_TRUE);
    GET_PROC(EAGLQUERYSERVERSTRINGPROC,  QueryServerString, EGL_TRUE);
    GET_PROC(EAGLGETCLIENTSTRINGPROC,  GetClientString, EGL_TRUE);

    GET_PROC(EAGLGETCONFIGSPROC,  GetConfigs, EGL_FALSE);
    GET_PROC(EAGLCREATEWINDOWPROC,  CreateWindow, EGL_TRUE);
    GET_PROC(EAGLDESTROYWINDOWPROC,  DestroyWindow, EGL_TRUE);
    GET_PROC(EAGLCREATEPIXMAPPROC,  CreatePixmap, EGL_TRUE);
    GET_PROC(EAGLDESTROYPIXMAPPROC,  DestroyPixmap, EGL_TRUE);
    GET_PROC(EAGLCREATEPBUFFERPROC,  CreatePbuffer, EGL_TRUE);
    GET_PROC(EAGLDESTROYPBUFFERPROC,  DestroyPbuffer, EGL_TRUE);
    
    GET_PROC(EAGLQUERYYSURFACEPROC,  QuerySurface, EGL_TRUE);
    
    #undef GET_PROC

    EAGL_drv->handle = handle;

    return EGL_TRUE;

    fail:
    return EGL_FALSE;
}


#endif  // INCLUDE_EGL_DRIVERS_EAGL_EGL_EAGL_DRIVER_H_

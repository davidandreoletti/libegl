//
//  \file egl_eagl_driver.h
//  libegl
//
//  Created by Andreoletti David.
//  Copyright 2013 IO Stark. All rights reserved.
//

#ifndef INCLUDE_EGL_DRIVERS_EAGL_EGL_EAGL_DRIVER_H_
#define INCLUDE_EGL_DRIVERS_EAGL_EGL_EAGL_DRIVER_H_

#include <stdbool.h>

#include "EGL/egldriver.h"
#include "EGL/drivers/eagl/egl_eagl_typedefs.h"
#include "EGL/drivers/eagl/egl_eagl_common.h"

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
typedef EGLBoolean (*EAGLTERMINATEPROC)(_EAGLWindow** dpy);

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
 * \param EAGL_dpy
 * \param EAGL_conf
 * \param EAGL_ctx_shared
 * \param attrib_list
 * \param EAGL_ctx
 *  \return Non NULL instance IFF initialization succeeded only.
 */
typedef EGLBoolean (*EAGLMAKECURRENTPROC)(_EAGLWindow *dpy, struct EAGL_egl_surface* surface, struct EAGL_egl_context* ctx, _OpenGLESAPI* api);
/**
 *  Swap buffers
 * \param EAGL_dpy
 * \param EAGL_surf
 * \return EGL_TRUE if swap succeeded.
 */
typedef EGLBoolean (*EAGLSWAPBUFFERSPROC)( struct EAGL_egl_display* EAGL_dpy, struct EAGL_egl_surface *EAGL_surf);

typedef _EAGLImage*/*GLXPixmap*/ (*EAGLCREATEPIXMAPPROC)( _EAGLWindow *dpy, _UIScreen *visual, _EAGLImage* pixmap );
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
typedef int (*EAGLGETCONFIGSPROC)( _EAGLWindow *dpy, _UIScreen *visual, int attrib, int *value );
typedef void (*EAGLWAITGLPROC)( void );
typedef void (*EAGLWAITNATIVEPROC)( void );
typedef const char *(*EAGLQUERYEXTENSIONSSTRINGPROC)( _EAGLWindow *dpy, int screen );
typedef const char *(*EAGLQUERYSERVERSTRINGPROC)( _EAGLWindow *dpy, int screen, int name );
typedef const char *(*EAGLGETCLIENTSTRINGPROC)( _EAGLWindow *dpy, int name );

typedef void *(*EAGLCREATEWINDOWPROC)(struct EAGL_egl_display *EAGL_dpy, struct EAGL_egl_config *EAGL_conf, EGLNativeWindowType window, const EGLint *attrib_list, struct EAGL_egl_surface *EAGL_surf);
typedef void *(*EAGLDESTROYWINDOWPROC)(void);
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
    EAGLINITIALIZEPROC eaglInitialize;
    EAGLTERMINATEPROC eaglTerminate;
    
    EAGLGETCONFIGSPROC eaglGetConfigs;

    EAGLCREATECONTEXTPROC eaglCreateContext;
    EAGLDESTROYCONTEXTPROC eaglDestroyContext;
    
    EAGLMAKECURRENTPROC eaglMakeCurrent;
    
    EAGLGETPROCADDRESSPROC eaglGetProcAddress;


    EAGLSWAPBUFFERSPROC eaglSwapBuffers;
    EAGLQUERYVERSIONPROC eaglQueryVersion;

    EAGLWAITGLPROC eaglWaitGL;
    EAGLWAITNATIVEPROC eaglWaitNative;
    
    EAGLQUERYEXTENSIONSSTRINGPROC eaglQueryExtensionsString;
    EAGLQUERYSERVERSTRINGPROC eaglQueryServerString;
    EAGLGETCLIENTSTRINGPROC eaglGetClientString;
    
    EAGLCREATEWINDOWPROC eaglCreateWindow;
    EAGLDESTROYWINDOWPROC eaglDestroyWindow;
    EAGLCREATEPIXMAPPROC eaglCreatePixmap;
    EAGLDESTROYPIXMAPPROC eaglDestroyPixmap;
    EAGLCREATEPBUFFERPROC eaglCreatePbuffer;
    EAGLDESTROYPBUFFERPROC eaglDestroyPbuffer;
    
    EAGLQUERYYSURFACEPROC eaglQuerySurface;

    EAGLCREATENEWCONTEXTPROC eaglCreateNewContext;
    EAGLMAKECONTEXTCURRENTPROC eaglMakeContextCurrent;
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

    if (!EAGL_drv->eaglGetProcAddress)
        goto fail;

#define GET_PROC(proc_type, proc_name, check)                                  \
    do {                                                                       \
        EAGL_drv->proc_name = (proc_type)                                      \
            EAGL_drv->eaglGetProcAddress(  #proc_name );                       \
        if (check && !EAGL_drv->proc_name) goto fail;                          \
    } while (0)

    /* EAGL x.x */
    GET_PROC(EAGLINITIALIZEPROC,  eaglInitialize, EGL_TRUE);
    GET_PROC(EAGLTERMINATEPROC,  eaglTerminate, EGL_TRUE);
    GET_PROC(EAGLCREATECONTEXTPROC,  eaglCreateContext, EGL_TRUE);
    GET_PROC(EAGLDESTROYCONTEXTPROC,  eaglDestroyContext, EGL_TRUE);
    GET_PROC(EAGLMAKECURRENTPROC,  eaglMakeCurrent, EGL_TRUE);
    GET_PROC(EAGLSWAPBUFFERSPROC,  eaglSwapBuffers, EGL_TRUE);
    GET_PROC(EAGLQUERYVERSIONPROC,  eaglQueryVersion, EGL_TRUE);
    GET_PROC(EAGLWAITGLPROC,  eaglWaitGL, EGL_TRUE);
    GET_PROC(EAGLWAITNATIVEPROC,  eaglWaitNative, EGL_TRUE);

    GET_PROC(EAGLQUERYEXTENSIONSSTRINGPROC,  eaglQueryExtensionsString, EGL_TRUE);
    GET_PROC(EAGLQUERYSERVERSTRINGPROC,  eaglQueryServerString, EGL_TRUE);
    GET_PROC(EAGLGETCLIENTSTRINGPROC,  eaglGetClientString, EGL_TRUE);

    GET_PROC(EAGLGETCONFIGSPROC,  eaglGetConfigs, EGL_FALSE);
    GET_PROC(EAGLCREATEWINDOWPROC,  eaglCreateWindow, EGL_TRUE);
    GET_PROC(EAGLDESTROYWINDOWPROC,  eaglDestroyWindow, EGL_TRUE);
    GET_PROC(EAGLCREATEPIXMAPPROC,  eaglCreatePixmap, EGL_TRUE);
    GET_PROC(EAGLDESTROYPIXMAPPROC,  eaglDestroyPixmap, EGL_TRUE);
    GET_PROC(EAGLCREATEPBUFFERPROC,  eaglCreatePbuffer, EGL_TRUE);
    GET_PROC(EAGLDESTROYPBUFFERPROC,  eaglDestroyPbuffer, EGL_TRUE);
    
    GET_PROC(EAGLQUERYYSURFACEPROC,  eaglQuerySurface, EGL_TRUE);
    
    GET_PROC(EAGLCREATENEWCONTEXTPROC,  eaglCreateNewContext, EGL_TRUE);
    GET_PROC(EAGLMAKECONTEXTCURRENTPROC,  eaglMakeContextCurrent, EGL_TRUE);

    #undef GET_PROC

    EAGL_drv->handle = handle;

    return EGL_TRUE;

    fail:
    return EGL_FALSE;
}


#endif  // INCLUDE_EGL_DRIVERS_EAGL_EGL_EAGL_DRIVER_H_

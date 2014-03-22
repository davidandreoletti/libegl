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

#include "EGL/drivers/eagl/egl_eagl.h"
#include "EGL/drivers/eagl/egl_eagl_driver.h"
#include "EGL/drivers/eagl/egl_eagl_memory.h"
#include "EGL/drivers/eagl/egl_eagl_context.h"
#include "EGL/egldriver.h"
#include "EGL/eglglobals.h"
#include "EGL/eglcurrent.h"
#include "EGL/egllog.h"

#ifdef _EGL_OS_APPLE_IOS

#include "EGL/drivers/eagl/egl_eagl_driver_ios.h"
#include "EGL/drivers/eagl/egl_eagl_ios_eaglsurface.h"
#include "EGL/drivers/eagl/opengles/opengles_ios.h"
#include "EGL/drivers/eagl/egl_eagl_globals.h"
#include "EGL/drivers/eagl/egl_eagl_display.h"

#include <OpenGLES/EAGL.h>
#include <OpenGLES/EAGLDrawable.h>
#include <Foundation/NSString.h>
#include <QuartzCore/QuartzCore.h>

#endif  // _EGL_OS_APPLE_IOS

#define _EGL_CHECK_CONTEXTLOST(disp, context, ret) \
    do {                                                 \
        drv = _eglCheckContextLost(disp, context, __FUNCTION__);  \
        if (!drv) {return ret;}                          \
    } while (0)

static INLINE _EGLDriver *
_eglCheckContextLost(_EGLDisplay *disp, struct EAGL_egl_context* context, const char *msg) {
    if (_eaglIsContextLost(context)) {
        _eglError(EGL_CONTEXT_LOST, msg);
        return NULL;
    }
    return disp->Driver;
}

static EGLBoolean
create_configs(_EGLDriver *drv, _EGLDisplay *dpy, EGLint screen)
{
    struct EAGL_egl_driver *EAGL_drv = EAGL_egl_driver(drv);
    EGLint num_configs = 0;
    create_ios_configs(EAGL_drv, dpy/*, configs*/, &num_configs);

    if (!num_configs) {
        return EGL_FALSE;
    }
    
    return EGL_TRUE;
}

static EGLBoolean _checkSurfaceAttribMatchConfigAttrib(_EGLSurface* surf, _EGLConfig* config, EGLint surfaceTypeMask) {

    if ((config->SurfaceType & surfaceTypeMask) == 0) {
        return _eglError(EGL_BAD_MATCH, "eglCreateWindowSurface");
    }
    if (config->RenderableType & EGL_OPENVG_BIT) {
        if ((config->SurfaceType & EGL_VG_COLORSPACE_LINEAR_BIT) == 0 && ((surf->VGColorspace & EGL_VG_COLORSPACE_LINEAR) || surf->VGColorspace & EGL_VG_COLORSPACE_sRGB)) {
            return _eglError(EGL_BAD_MATCH, "eglCreateWindowSurface");
        }
        if ((config->SurfaceType & EGL_VG_ALPHA_FORMAT_PRE_BIT) == 0 && ((surf->VGColorspace & EGL_VG_ALPHA_FORMAT_PRE) || (surf->VGColorspace & EGL_VG_ALPHA_FORMAT_NONPRE))) {
            return _eglError(EGL_BAD_MATCH, "eglCreateWindowSurface");
        }
    }
    return EGL_TRUE;
}

/**
 * Called via eglInitialize(), EAGL_drv->API.Initialize().
 */
static EGLBoolean
EAGL_eglInitialize(_EGLDriver *drv, _EGLDisplay *disp) {
    struct EAGL_egl_driver *EAGL_drv = EAGL_egl_driver(drv);
    struct EAGL_egl_display *EAGL_dpy;
    
    if (disp->Platform != _EGL_PLATFORM_IOS)
        return EGL_FALSE;
    
    /* this is NOT a fallback driver */
    if (disp->Options.UseFallback)
        return EGL_FALSE;
    
    if (disp->Options.TestOnly)
        return EGL_TRUE;
    
    EAGL_dpy = CALLOC_STRUCT(EAGL_egl_display);
    if (!EAGL_dpy) {
        return _eglError(EGL_BAD_ALLOC, "eglInitialize");
    }
    
    EAGL_dpy->dpy = disp->PlatformDisplay;
    if (!EAGL_drv->eaglInitialize(EAGL_dpy, disp) || !EAGL_dpy->dpy) {
        _eglLog(_EGL_WARNING, "EAGL_eglInitialize");
        free(EAGL_dpy);
        return EGL_FALSE;
    }
    
    if (!EAGL_drv->eaglQueryVersion(EAGL_dpy->dpy,
                                    &EAGL_dpy->VersionMajor, &EAGL_dpy->VersionMinor)) {
        _eglLog(_EGL_WARNING, "EAGL_eglInitialize");
        if (!disp->PlatformDisplay) {
            // No need to destroy EAGL_dpy->dpy. EAGL_drv->eaglInitialize
            // guarantees not to return an instance if initialization fails
        }
        free(EAGL_dpy);
        return EGL_FALSE;
    }
    
    disp->DriverData = (void *) EAGL_dpy;
    
    create_configs(drv, disp, 0);
    if (!_eglGetArraySize(disp->Configs)) {
        _eglLog(_EGL_WARNING, "EAGL: failed to create any config");
        if (!disp->PlatformDisplay) {
            // No need to destroy EAGL_dpy->dpy. EAGL_drv->eaglInitialize
            // guarantees not to return an instance if initialization fails
        }
        free(EAGL_dpy);
        return EGL_FALSE;
    }
    
    /* we're supporting EGL 1.? */
    disp->VersionMajor = EAGL_dpy->VersionMajor;
    disp->VersionMinor = EAGL_dpy->VersionMinor;
    
    return EGL_TRUE;
}


/**
 * Called via eglTerminate(), drv->API.Terminate().
 */
static EGLBoolean
EAGL_eglTerminate(_EGLDriver *drv, _EGLDisplay *disp)
{
    struct EAGL_egl_display *EAGL_dpy = EAGL_egl_display(disp);
    struct EAGL_egl_driver *EAGL_drv = EAGL_egl_driver(drv);

    EAGL_drv->eaglTerminate(EAGL_dpy);
    
    _eglReleaseDisplayResources(drv, disp);
    _eglCleanupDisplay(disp);
    disp->DriverData = NULL;
    free(EAGL_dpy);
    
    return EGL_TRUE;
}


/**
 * Called via eglCreateContext(), drv->API.CreateContext().
 */
static _EGLContext *
EAGL_eglCreateContext(_EGLDriver *drv, _EGLDisplay *disp, _EGLConfig *conf,
                      _EGLContext *share_list, const EGLint *attrib_list)
{
    struct EAGL_egl_driver *EAGL_drv = EAGL_egl_driver(drv);
    struct EAGL_egl_display *EAGL_dpy = EAGL_egl_display(disp);
    struct EAGL_egl_config *EAGL_conf = EAGL_egl_config(conf);
    struct EAGL_egl_context *EAGL_ctx_shared = EAGL_egl_context(share_list);
    
    struct EAGL_egl_context *EAGL_ctx = CALLOC_STRUCT(EAGL_egl_context);
    if (!EAGL_ctx) {
        _eglError(EGL_BAD_ALLOC, "eglCreateContext");
        return NULL;
    }
    
    if (!EAGL_conf) {
        free(EAGL_ctx);
        _eglError(EGL_BAD_CONFIG, "eglCreateContext");
        return NULL;
    }
    
    if (!_eglInitContext(&EAGL_ctx->Base, disp, conf, attrib_list)) {
        free(EAGL_ctx);
        return NULL;
    }
    
    if (eglQueryAPI() == EGL_NONE) {
        _eglError(EGL_BAD_MATCH, "eglCreateContext");
        return NULL;
    }
    
    if(!(EAGL_drv->eaglCreateContext(EAGL_dpy, EAGL_conf, EAGL_ctx_shared, attrib_list, EAGL_ctx))) {
        free(EAGL_ctx);
        return NULL;
    }
    
    return &EAGL_ctx->Base;
}

/**
 * Called via eglDestroyContext(), drv->API.DestroyContext().
 */
static EGLBoolean
EAGL_eglDestroyContext(_EGLDriver *drv, _EGLDisplay *disp, _EGLContext *ctx)
{
    struct EAGL_egl_driver *EAGL_drv = EAGL_egl_driver(drv);
    struct EAGL_egl_display *EAGL_dpy = EAGL_egl_display(disp);
    struct EAGL_egl_context *EAGL_ctx = EAGL_egl_context(ctx);
    
    if (_eglPutContext(ctx)) {
        assert(EAGL_ctx);
        EAGL_drv->eaglDestroyContext(EAGL_dpy->dpy, EAGL_ctx);
        
        free(EAGL_ctx);
    }
    
    return EGL_TRUE;
}

/**
 * Destroy a surface.  The display is allowed to be uninitialized.
 */
static EGLBoolean
destroy_surface(_EGLDriver* drv, _EGLDisplay *disp, _EGLSurface *surf) {
    struct EAGL_egl_driver *EAGL_drv = EAGL_egl_driver(drv);
    struct EAGL_egl_display *EAGL_dpy = EAGL_egl_display(disp);
    struct EAGL_egl_surface *EAGL_surf = EAGL_egl_surface(surf);
    
    switch (surf->Type) {
        case EGL_WINDOW_BIT:
        {
            if (EAGL_drv->eaglDestroyWindow(EAGL_dpy, EAGL_surf)) {
                free(EAGL_surf);
                return EGL_TRUE;
            }
        }
        break;
        default: {
            // Not supported
            _eglError(EGL_BAD_MATCH, "eglDestroySurface");
            return EGL_FALSE;
        }
        break;
    }
    // Unknown error
    return EGL_FALSE;
}

/**
 * Called via eglMakeCurrent(), drv->API.MakeCurrent().
 */
static EGLBoolean
EAGL_eglMakeCurrent(_EGLDriver *drv, _EGLDisplay *disp, _EGLSurface *dsurf,
                    _EGLSurface *rsurf, _EGLContext *ctx)
{
    struct EAGL_egl_driver *EAGL_drv = EAGL_egl_driver(drv);
    struct EAGL_egl_display *EAGL_dpy = EAGL_egl_display(disp);
    struct EAGL_egl_surface *EAGL_dsurf = EAGL_egl_surface(dsurf);
    struct EAGL_egl_surface *EAGL_rsurf = EAGL_egl_surface(rsurf);
    struct EAGL_egl_context *EAGL_ctx = EAGL_egl_context(ctx);
    _EGLContext *old_ctx;
    _EGLSurface *old_dsurf, *old_rsurf;
    EGLBoolean ret = EGL_FALSE;
    
    _EGL_CHECK_CONTEXTLOST(disp, EAGL_ctx, EGL_FALSE);
        
    /* make new bindings */
    if (!_eglBindContext(ctx, dsurf, rsurf, &old_ctx, &old_dsurf, &old_rsurf)) {
        // TODO: Anything to do here ?
        return EGL_FALSE;
    }
    
    ret = EAGL_drv->eaglMakeCurrent(EAGL_dpy->dpy, EAGL_dsurf, EAGL_ctx, &EAGL_ctx->openGLESAPI);

    if (ret) {
        if (_eglPutSurface(old_dsurf))
            destroy_surface(drv, disp, old_dsurf);
        if (_eglPutSurface(old_rsurf))
            destroy_surface(drv, disp, old_rsurf);
        /* no destroy? */
        _eglPutContext(old_ctx);
    }
    else {
        /* undo the previous _eglBindContext */
        _eglBindContext(old_ctx, old_dsurf, old_rsurf, &ctx, &dsurf, &rsurf);
        assert(&EAGL_ctx->Base == ctx &&
               &EAGL_dsurf->Base == dsurf &&
               &EAGL_rsurf->Base == rsurf);
        
        _eglPutSurface(dsurf);
        _eglPutSurface(rsurf);
        _eglPutContext(ctx);
        
        _eglPutSurface(old_dsurf);
        _eglPutSurface(old_rsurf);
        _eglPutContext(old_ctx);
    }
    return ret;
}

/**
 * Called via eglCreateWindowSurface(), drv->API.CreateWindowSurface().
 */
static _EGLSurface *
EAGL_eglCreateWindowSurface(_EGLDriver *drv, _EGLDisplay *disp,
                            _EGLConfig *conf, EGLNativeWindowType window,
                            const EGLint *attrib_list)
{
    struct EAGL_egl_driver *EAGL_drv = EAGL_egl_driver(drv);
    struct EAGL_egl_display *EAGL_dpy = EAGL_egl_display(disp);
    struct EAGL_egl_config *EAGL_conf = EAGL_egl_config(conf);
    struct EAGL_egl_surface *EAGL_surf;
    
    if (!EAGL_conf) {
        _eglError(EGL_BAD_CONFIG, "eglCreateWindowSurface");
        return NULL;
    }
    
    if (!(_eglGetConfigKey(conf, EGL_SURFACE_TYPE) & EGL_WINDOW_BIT)) {
        _eglError(EGL_BAD_MATCH, "eglCreateWindowSurface");
        return NULL;
    }
    
    if (!window) {	
        _eglError(EGL_BAD_NATIVE_WINDOW, "eglCreateWindowSurface");
        return NULL;
    }

    _eglLockMutex(_eglGlobal.Mutex);
    struct findresource data = {
        .data = window,
        .resourceFound = false,
        .type = _EGL_RESOURCE_SURFACE,
        .requestType = SURFACE_NATIVEWINDOW,
        .exec = ExecFindNativeWindowAssociatedSurface,
        .display = NULL
    };
    findResource(_eglGlobal.DisplayList, &data);
    _eglUnlockMutex(_eglGlobal.Mutex);
    if (data.resourceFound) {
        _eglError(EGL_BAD_ALLOC, "eglCreateWindowSurface");
        return NULL;
    }

    EAGL_surf = CALLOC_STRUCT(EAGL_egl_surface);
    if (!EAGL_surf) {
        _eglError(EGL_BAD_ALLOC, "eglCreateWindowSurface");
        return NULL;
    }
    
    if (!_eglInitSurface(&EAGL_surf->Base, disp, EGL_WINDOW_BIT,
                         conf, attrib_list)) {
        free(EAGL_surf);
        return NULL;
    }
    
    if (!_checkSurfaceAttribMatchConfigAttrib(&EAGL_surf->Base, &EAGL_conf->Base, EGL_WINDOW_BIT)) {
        free(EAGL_surf);
        return NULL;
    }
    
    if(!(EAGL_drv->eaglCreateWindow(EAGL_dpy, EAGL_conf, window, attrib_list, EAGL_surf))) {
        free(EAGL_surf);
        return NULL;
    }
    
    return &EAGL_surf->Base;
}

/**
 * Called via eglCreatePixmapSurface(), drv->API.CreatePixmapSurface().
 */
static _EGLSurface *
EAGL_eglCreatePixmapSurface(_EGLDriver *drv, _EGLDisplay *disp,
                            _EGLConfig *conf, EGLNativePixmapType pixmap,
                            const EGLint *attrib_list)
{
    struct EAGL_egl_surface *EAGL_surf;
    EGLint width = 0;
    EGLint height = 0;
    
    EAGL_surf = CALLOC_STRUCT(EAGL_egl_surface);
    if (!EAGL_surf) {
        _eglError(EGL_BAD_ALLOC, "eglCreatePixmapSurface");
        return NULL;
    }
    
    if (!_eglInitSurface(&EAGL_surf->Base, disp, EGL_PIXMAP_BIT,
                         conf, attrib_list)) {
        free(EAGL_surf);
        return NULL;
    }
    
    _EAGLSurface* d = OWNERSHIP_AUTORELEASE([[_EAGLSurface alloc] init]);
    [d setPixmapSurface:pixmap];
    EAGL_surf->eagl_drawable = d;
    
    if (!EAGL_surf->eagl_drawable) {
        free(EAGL_surf);
        return NULL;
    }

    EAGL_surf->Base.Width = width;
    EAGL_surf->Base.Height = height;
    
    return &EAGL_surf->Base;
}

/**
 * Called via eglCreatePbufferSurface(), drv->API.CreatePbufferSurface().
 */
static _EGLSurface *
EAGL_eglCreatePbufferSurface(_EGLDriver *drv, _EGLDisplay *disp,
                             _EGLConfig *conf, const EGLint *attrib_list)
{

    struct EAGL_egl_surface *EAGL_surf;
    
    EAGL_surf = CALLOC_STRUCT(EAGL_egl_surface);
    if (!EAGL_surf) {
        _eglError(EGL_BAD_ALLOC, "eglCreatePbufferSurface");
        return NULL;
    }
    
    if (!_eglInitSurface(&EAGL_surf->Base, disp, EGL_PBUFFER_BIT,
                         conf, attrib_list)) {
        free(EAGL_surf);
        return NULL;
    }
    
    _EAGLSurface* d = OWNERSHIP_AUTORELEASE([[_EAGLSurface alloc] init]);
    [d setPbufferSurface:nil];
    EAGL_surf->eagl_drawable = d;
    
    if (!EAGL_surf->eagl_drawable) {
        free(EAGL_surf);
        return NULL;
    }
    
    return &EAGL_surf->Base;
}

/**
 * Called via eglDestroySurface(), drv->API.DestroySurface().
 */
static EGLBoolean
EAGL_eglDestroySurface(_EGLDriver *drv, _EGLDisplay *disp, _EGLSurface *surf)
{
    if (surf == NULL) {
        _eglError(EGL_BAD_SURFACE, "eglDestroySurface");
        return EGL_FALSE;
    }
    
    if (_eglPutSurface(surf)) {
        if (!destroy_surface(drv, disp, surf)) {
            // FIXME: What error code should be reported ?
            return EGL_FALSE;
        }
        _eglError(EGL_SUCCESS, "eglDestroySurface");
    }

    return EGL_TRUE;
}

/**
 * Called via eglQuerySurface(), drv->API.QuerySurface().
 */
static EGLBoolean EAGL_eglQuerySurface(_EGLDriver *drv, _EGLDisplay *dpy, _EGLSurface *surface, EGLint attribute, EGLint *value) {
    
    return _eglQuerySurface(drv, dpy, surface, attribute, value);
}

/**
 * Called via eglSwapBuffers(), drv->API.SwapBuffers().
 */
static EGLBoolean
EAGL_eglSwapBuffers(_EGLDriver *drv, _EGLDisplay *disp, _EGLSurface *draw)
{
    struct EAGL_egl_driver *EAGL_drv = EAGL_egl_driver(drv);
    struct EAGL_egl_display *EAGL_dpy = EAGL_egl_display(disp);
    struct EAGL_egl_surface *EAGL_surf = EAGL_egl_surface(draw);
    struct EAGL_egl_context *EAGL_context = EAGL_egl_context(EAGL_surf->Base.CurrentContext);
    
    _EGL_CHECK_CONTEXTLOST(disp, EAGL_context, EGL_FALSE);
    
    if (EAGL_surf == NULL) {
        return _eglError(EGL_BAD_SURFACE, "EAGL_eglSwapBuffers");
    }
    
    return EAGL_drv->eaglSwapBuffers(EAGL_dpy, EAGL_surf);
}

/**
 * Called via eglSwapInterval(), drv->API.SwapInterval().
 */
static EGLBoolean EAGL_eglSwapInterval(_EGLDriver *drv, _EGLDisplay *dpy, _EGLSurface *surf, EGLint interval) {
    struct EAGL_egl_driver *EAGL_drv = EAGL_egl_driver(drv);
    struct EAGL_egl_display *EAGL_dpy = EAGL_egl_display(dpy);
    struct EAGL_egl_surface *EAGL_surf = EAGL_egl_surface(surf);
    
    if (EAGL_surf == NULL) {
        return _eglError(EGL_BAD_SURFACE, "EAGL_SwapInterval");
    }
    
    _eglSwapInterval(drv, dpy, surf, interval);
    
    return EAGL_drv->eaglSwapInterval(EAGL_dpy, EAGL_surf, interval);
}

/*
 * Called from eglGetProcAddress() via drv->API.GetProcAddress().
 */
static _EGLProc
EAGL_eglGetProcAddress(_EGLDriver *drv, const char *procname)
{
    struct EAGL_egl_driver *EAGL_drv = EAGL_egl_driver(drv);
    
    return (_EGLProc) EAGL_drv->eaglGetProcAddress((const char *) procname);
}

/**
 * Called via eglWaitClient(), drv->API.WaitClient().
 */
static EGLBoolean
EAGL_eglWaitClient(_EGLDriver *drv, _EGLDisplay *dpy, _EGLContext *ctx)
{
    struct EAGL_egl_driver *EAGL_drv = EAGL_egl_driver(drv);
    
    (void) dpy;
    (void) ctx;
    
    EAGL_drv->eaglWaitGL();
    return EGL_TRUE;
}

/**
 * Called via eglWaitNative(), drv->API.WaitNative().
 */
static EGLBoolean
EAGL_eglWaitNative(_EGLDriver *drv, _EGLDisplay *dpy, EGLint engine)
{
    struct EAGL_egl_driver *EAGL_drv = EAGL_egl_driver(drv);
    
    (void) dpy;
    
    if (engine != EGL_CORE_NATIVE_ENGINE)
        return _eglError(EGL_BAD_PARAMETER, "eglWaitNative");
    EAGL_drv->eaglWaitNative();
    return EGL_TRUE;
}

/**
 * Called via eglQueryContext(), drv->API.QueryContext().
 */
static EGLBoolean
EAGL_eglQueryContext (_EGLDriver *drv, _EGLDisplay *dpy, _EGLContext *ctx, EGLint attribute, EGLint *value) {
    return _eglQueryContext(drv, dpy, ctx, attribute, value);
}

/**
 *  Return platform specific EAGL driver
 *  \parram args
 *  \return EAGL driver
 */
static struct EAGL_egl_driver* _eglBuiltInDriverEAGLPlatform(const char* args) {
#ifdef _EGL_OS_APPLE_IOS
    return _eglBuiltInDriverEAGLIOS(args);
#else 
    return NULL;
#endif  // _EGL_OS_APPLE_IOS
}

_EGLDriver* _eglBuiltInDriverEAGL(const char* args) {
    
    // Initiate EAGL specific implementation
    struct EAGL_egl_driver* EAGL_drv = _eglBuiltInDriverEAGLPlatform(args);

    (void) args;
    
    if (!EAGL_drv)
        return NULL;
    
    if (!EAGL_Load(&EAGL_drv->Base)) {
        _eglLog(_EGL_WARNING, "EAGL: failed to load EAGL");
        free(EAGL_drv);
        return NULL;
    }
    
    _eglInitDriverFallbacks(&EAGL_drv->Base);
    EAGL_drv->Base.API.Initialize = EAGL_eglInitialize;
    EAGL_drv->Base.API.Terminate = EAGL_eglTerminate;
    EAGL_drv->Base.API.CreateContext = EAGL_eglCreateContext;
    EAGL_drv->Base.API.DestroyContext = EAGL_eglDestroyContext;
    EAGL_drv->Base.API.MakeCurrent = EAGL_eglMakeCurrent;
    EAGL_drv->Base.API.CreateWindowSurface = EAGL_eglCreateWindowSurface;
    EAGL_drv->Base.API.CreatePixmapSurface = EAGL_eglCreatePixmapSurface;
    EAGL_drv->Base.API.CreatePbufferSurface = EAGL_eglCreatePbufferSurface;
    EAGL_drv->Base.API.DestroySurface = EAGL_eglDestroySurface;
    EAGL_drv->Base.API.QuerySurface = EAGL_eglQuerySurface;
    EAGL_drv->Base.API.SwapBuffers = EAGL_eglSwapBuffers;
    EAGL_drv->Base.API.SwapInterval = EAGL_eglSwapInterval;
    EAGL_drv->Base.API.GetProcAddress = EAGL_eglGetProcAddress;
    EAGL_drv->Base.API.WaitClient = EAGL_eglWaitClient;
    EAGL_drv->Base.API.WaitNative = EAGL_eglWaitNative;
    EAGL_drv->Base.API.QueryContext = EAGL_eglQueryContext;
    
    EAGL_drv->Base.Unload = EAGL_Unload;
    
    return &EAGL_drv->Base;
}

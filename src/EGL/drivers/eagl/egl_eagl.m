//
//  \file egl_eagl.m
//  libegl
//
//  Created by Andreoletti David.
//  Copyright 2013 IO Stark. All rights reserved.
//

#include "EGL/drivers/eagl/egl_eagl.h"
#include "EGL/drivers/eagl/egl_eagl_driver.h"
#include "EGL/drivers/eagl/egl_eagl_common.h"
#include "EGL/egldriver.h"
#include "EGL/eglglobals.h"


#ifdef _EGL_OS_APPLE_IOS

#include "EGL/drivers/eagl/egl_eagl_driver_ios.h"
#include "EGL/drivers/eagl/egl_eagl_ios_eaglsurface.h"
#include "EGL/drivers/eagl/opengles/opengles_ios.h"

#include <OpenGLES/EAGL.h>
#include <OpenGLES/EAGLDrawable.h>
#include <Foundation/NSString.h>
#include <QuartzCore/QuartzCore.h>

#endif  // _EGL_OS_APPLE_IOS

static void
check_extensions(struct EAGL_egl_driver *EAGL_drv,
                 struct EAGL_egl_display *EAGL_dpy, EGLint screen);
static void
check_extensions(struct EAGL_egl_driver *EAGL_drv,
                 struct EAGL_egl_display *EAGL_dpy, EGLint screen) {
}

static void
check_quirks(struct EAGL_egl_driver *EAGL_drv,
              struct EAGL_egl_display *EAGL_dpy, EGLint screen);
 static void
check_quirks(struct EAGL_egl_driver *EAGL_drv,
              struct EAGL_egl_display *EAGL_dpy, EGLint screen)
{}



static void fix_config(struct EAGL_egl_display *EAGL_dpy, struct EAGL_egl_config *EAGL_conf)
{
   _EGLConfig *conf = &EAGL_conf->Base;

   if (!EAGL_conf->double_buffered && EAGL_dpy->single_buffered_quirk) {
      /* some GLX impls do not like single-buffered window surface */
      conf->SurfaceType &= ~EGL_WINDOW_BIT;
      /* pbuffer bit is usually not set */
      if (EAGL_dpy->have_pbuffer)
         conf->SurfaceType |= EGL_PBUFFER_BIT;
   }

   /* no visual attribs unless window bit is set */
   if (!(conf->SurfaceType & EGL_WINDOW_BIT)) {
      conf->NativeVisualID = 0;
      conf->NativeVisualType = EGL_NONE;
   }

   if (conf->TransparentType != EGL_TRANSPARENT_RGB) {
      conf->TransparentRedValue = 0;
      conf->TransparentGreenValue = 0;
      conf->TransparentBlueValue = 0;
   }

   /* make sure buffer size is set correctly */
   conf->BufferSize =
      conf->RedSize + conf->GreenSize + conf->BlueSize + conf->AlphaSize;
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
    
    check_extensions(EAGL_drv, EAGL_dpy, 0);
    check_quirks(EAGL_drv, EAGL_dpy, 0);
    
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
    
    _eglReleaseDisplayResources(drv, disp);
    _eglCleanupDisplay(disp);
    
    free(EAGL_dpy->visuals);
//    free(EAGL_dpy->fbconfigs);
    
    if (!disp->PlatformDisplay) {
//        XCloseDisplay(EAGL_dpy->dpy);
        
    }
    free(EAGL_dpy);
    
    disp->DriverData = NULL;
    
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
static void
destroy_surface(_EGLDisplay *disp, _EGLSurface *surf)
{
    struct EAGL_egl_display *EAGL_dpy = EAGL_egl_display(disp);
    struct EAGL_egl_surface *EAGL_surf = EAGL_egl_surface(surf);
    
    if (EAGL_surf->destroy)
        EAGL_surf->destroy(EAGL_dpy->dpy, EAGL_surf->eagl_drawable);
    
    free(EAGL_surf);
}

GLuint _createDepthBuffer(_OpenGLESAPI* api, GLint width, GLint height, GLuint bits)
{
    // Assumption: A render buffer is bound to the current context
    
    if (bits == 0) {
        return 0;
    }
    
    GLuint depth = 0;
    api->glGenRenderBuffers(1, &depth);
    if (!depth)
        return 0;
    
    GLuint depth_component = 0;
    if (bits == 24) {
        depth_component = api->GL_DEPTH_COMPONENT24_;
    } else {
        /* ignore the bits value and use the default 16 bits */
        depth_component = api->GL_DEPTH_COMPONENT16_;
    }
    
    api->glBindRenderBuffers(api->GL_RENDERBUFFER_, depth);
    api->glRenderbufferStorage(api->GL_RENDERBUFFER_, depth_component, width, height);
    api->glFramebufferRenderbuffer(api->GL_FRAMEBUFFER_, api->GL_DEPTH_ATTACHMENT_, api->GL_RENDERBUFFER_, depth);
    return depth;
}

bool setupFB(struct EAGL_egl_context* context, struct EAGL_egl_surface* surface, GLuint* framebuffer, GLuint* colorbuffer, GLuint* depthbuffer) {
    
    _OpenGLESAPI* api = &(context->openGLESAPI);
    
    // Create the framebuffer
    api->glGenFrameBuffers(1, framebuffer);
    api->glBindFrameBuffers(api->GL_FRAMEBUFFER_, *framebuffer);
    
    // Create the color buffer
    api->glGenRenderBuffers(1, colorbuffer);
    api->glBindRenderBuffers(api->GL_RENDERBUFFER_, *colorbuffer);
    BOOL r = [context->context.nativeContext renderbufferStorage:api->GL_RENDERBUFFER_
                                          fromDrawable: surface->eagl_drawable.windowSurface];
    if (r == NO) {
        api->glDeleteFrameBuffers(1, *framebuffer);
        api->glDeleteRenderBuffers(1, *colorbuffer);
        return false;
    }
    
    api->glFramebufferRenderbuffer(api->GL_FRAMEBUFFER_, api->GL_COLOR_ATTACHMENT0_, api->GL_RENDERBUFFER_, *colorbuffer);
    
    if (context->Base.Config->DepthSize) {
        // Create the depth buffer
        GLint backingWidth, backingHeight;
        api->glGetRenderbufferParameteriv(api->GL_RENDERBUFFER_, api->GL_RENDERBUFFER_WIDTH_, &backingWidth);
        api->glGetRenderbufferParameteriv(api->GL_RENDERBUFFER_, api->GL_RENDERBUFFER_HEIGHT_, &backingHeight);
        *depthbuffer = _createDepthBuffer(api, backingWidth, backingHeight, context->Base.Config->DepthSize);
    }
    
    if (api->glCheckFramebufferStatus(api->GL_FRAMEBUFFER_) != api->GL_FRAMEBUFFER_COMPLETE_) {
        return false;
    }
    
    // Make color buffer the current bound renderbuffer
    api->glBindRenderBuffers(api->GL_RENDERBUFFER_, *colorbuffer);

    return true;
}

/**
 * Get Renderbuffer dimensions (in pixel)
 * \param api
 * \param renderbuffer
 * \param width
 * \param height
 */
void getRenderBufferDimensions(_OpenGLESAPI* api, GLuint renderbuffer, GLint* width, GLint* height) {
    api->glGetRenderbufferParameteriv(renderbuffer, api->GL_RENDERBUFFER_WIDTH_, width);
    api->glGetRenderbufferParameteriv(renderbuffer, api->GL_RENDERBUFFER_HEIGHT_, height);
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
    _EAGLSurface* ddraw = nil;
//    _EAGLSurface* rdraw;
    _EAGLContext* cctx;
    EGLBoolean ret = EGL_FALSE;
    
    if (!ctx) {
        _eglError(EGL_BAD_CONTEXT, "eglMakeCurrent");
        return EGL_FALSE;
    }
    /* make new bindings */
    if (!_eglBindContext(ctx, dsurf, rsurf, &old_ctx, &old_dsurf, &old_rsurf))
        return EGL_FALSE;
    
    cctx = (EAGL_ctx) ? EAGL_ctx->context : NULL;
    ret = EAGL_drv->eaglMakeCurrent(EAGL_dpy->dpy, ddraw, cctx);
    if (ret) {
        if (_eglPutSurface(old_dsurf))
            destroy_surface(disp, old_dsurf);
        if (_eglPutSurface(old_rsurf))
            destroy_surface(disp, old_rsurf);
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
    
    //_eglBindContextToThread();
    [EAGLContext setCurrentContext:[EAGL_ctx->context nativeContext]];
    
    GLuint fb = 0;
    GLuint cb = 0;
    GLuint db = 0;
    if(setupFB(EAGL_ctx, EAGL_dsurf, &fb, &cb, &db)) {
        _OpenGLBuffers* buffers = EAGL_dsurf->eagl_drawable.buffers;
        buffers->framebuffer = fb;
        buffers->colorbuffer = cb;
        buffers->depthbuffer = db;
        ret = EGL_TRUE;
    }
    if (!EAGL_ctx->wasCurrent) {
//        EGLint surfaceWidth = 0;
//        EGLint surfaceHeight = 0;
//        eglQuerySurface(disp, ddraw, EGL_WIDTH, &surfaceWidth);
//        eglQuerySurface(disp, ddraw, EGL_HEIGHT, &surfaceHeight);
//        _OpenGLESAPI* api = &EAGL_ctx->openGLESAPI;
//        api->glViewport(0,0, surfaceWidth, surfaceHeight);
//        api->glScissor(0,0, surfaceWidth, surfaceHeight);
//        EAGL_ctx->wasCurrent = EGL_TRUE;
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
//    struct EAGL_egl_driver *EAGL_drv = EAGL_egl_driver(drv);
//    struct EAGL_egl_display *EAGL_dpy = EAGL_egl_display(disp);
    struct EAGL_egl_config *EAGL_conf = EAGL_egl_config(conf);
    struct EAGL_egl_surface *EAGL_surf;
//    unsigned width, height;
    
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
    
    //_eglLockMutex(_eglGlobal.Mutex); //FIXME: this mutex blocks Unit tests - WHY ???
   
    _EGLDisplay* disp2 = _eglGlobal.DisplayList;
    while (disp2) {
        if (0<_EGL_NUM_RESOURCES) { 
            _EGLResource* res = disp2->ResourceLists[_EGL_RESOURCE_SURFACE];
            struct EAGL_egl_surface *EAGL_surf2 = NULL;
            while (res) {
                _EGLSurface* surf = (_EGLSurface*) res;
                EAGL_surf2 = EAGL_egl_surface(surf);
                if (EAGL_surf2 && EAGL_surf2->eagl_drawable.windowSurface == window) {
                    _eglError(EGL_BAD_ALLOC, "eglCreateWindowSurface");
                    return NULL;
                }
                res = res->Next;
            }
        }
        disp2 = disp2->Next;
    }
    
    //_eglUnlockMutex(_eglGlobal.Mutex); //FIXME: this mutex blocks Unit tests - WHY ??? 

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
    
//    EAGL_surf->drawable = window;

//    id<NSObject> obj = (id<NSObject>)window;
//    if (![obj isKindOfClass:[UIView class]]) {
//        _eglError(EGL_BAD_NATIVE_WINDOW, "eglCreateWindowSurface: Not an UIView instance");
//        return NULL;
//    }
    id<EAGLDrawable> nativeEAGLDrawable = window;
    
    _EAGLSurface* eaglSurface = [[[_EAGLSurface alloc] init] retain];
    [eaglSurface setWindowSurface:nativeEAGLDrawable];
    EAGL_surf->eagl_drawable = eaglSurface;
    
//    UIView* v = (UIView*)obj;
//    id<EAGLDrawable> eaglSurface = (id<EAGLDrawable>)[v layer];
    NSDictionary* nativePrawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                          [NSNumber numberWithBool:EAGL_conf->conf.retainBacking],
                          kEAGLDrawablePropertyRetainedBacking,
                          EAGL_conf->conf.colorFormat,
                          kEAGLDrawablePropertyColorFormat,
                          nil];
    if (!nativePrawableProperties) {
        _eglError(EGL_BAD_ALLOC, "eglCreateWindowSurface");
        return NULL;
    }
    
    @try {
        [nativeEAGLDrawable setDrawableProperties:nativePrawableProperties];
    } @catch (NSException* e) {
        _eglError(EGL_BAD_NATIVE_WINDOW, "eglCreateWindowSurface");
        return NULL;
    }
    
    if (!EAGL_surf->eagl_drawable) {
        free(EAGL_surf);
        return NULL;
    }
    
    CAEAGLLayer* nativeEAGLLayer = (CAEAGLLayer*) window;
    CGFloat contentScaleFactor = [nativeEAGLLayer contentsScale];
    CGSize frameSize = nativeEAGLLayer.frame.size;
    EAGL_surf->Base.Width = frameSize.width * contentScaleFactor;
    EAGL_surf->Base.Height = frameSize.height * contentScaleFactor;
    EAGL_surf->Base.RenderBuffer = EGL_SINGLE_BUFFER;
    
    return &EAGL_surf->Base;
}

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
    
    _EAGLSurface* d = [[[_EAGLSurface alloc] init] retain];
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
    
    _EAGLSurface* d = [[[_EAGLSurface alloc] init] retain];
    [d setPbufferSurface:nil];
    EAGL_surf->eagl_drawable = d;
    
    if (!EAGL_surf->eagl_drawable) {
        free(EAGL_surf);
        return NULL;
    }
    
    return &EAGL_surf->Base;
}


static EGLBoolean
EAGL_eglDestroySurface(_EGLDriver *drv, _EGLDisplay *disp, _EGLSurface *surf)
{
    (void) drv;
    
    if (_eglPutSurface(surf))
        destroy_surface(disp, surf);
    
    return EGL_TRUE;
}

static EGLBoolean EAGL_eglQuerySurface(_EGLDriver *drv, _EGLDisplay *dpy, _EGLSurface *surface, EGLint attribute, EGLint *value) {
    
    return _eglQuerySurface(drv, dpy, surface, attribute, value);
}

static EGLBoolean
EAGL_eglSwapBuffers(_EGLDriver *drv, _EGLDisplay *disp, _EGLSurface *draw)
{
    struct EAGL_egl_driver *EAGL_drv = EAGL_egl_driver(drv);
    struct EAGL_egl_display *EAGL_dpy = EAGL_egl_display(disp);
    struct EAGL_egl_surface *EAGL_surf = EAGL_egl_surface(draw);
    
    if (EAGL_surf == NULL) {
        return _eglError(EGL_BAD_SURFACE, "EAGL_eglSwapBuffers");
    }
    
    return EAGL_drv->eaglSwapBuffers(EAGL_dpy, EAGL_surf);
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

static EGLBoolean
EAGL_eglWaitClient(_EGLDriver *drv, _EGLDisplay *dpy, _EGLContext *ctx)
{
    struct EAGL_egl_driver *EAGL_drv = EAGL_egl_driver(drv);
    
    (void) dpy;
    (void) ctx;
    
    EAGL_drv->eaglWaitGL();
    return EGL_TRUE;
}

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
    EAGL_drv->Base.API.GetProcAddress = EAGL_eglGetProcAddress;
    EAGL_drv->Base.API.WaitClient = EAGL_eglWaitClient;
    EAGL_drv->Base.API.WaitNative = EAGL_eglWaitNative;
    EAGL_drv->Base.API.QueryContext = EAGL_eglQueryContext;
    
    EAGL_drv->Base.Unload = EAGL_Unload;
    
    return &EAGL_drv->Base;
}

//
//  \file egl_eagl_driver_ios.m
//  libegl
//
//  Created by Andreoletti David.
//  Copyright 2013 IO Stark. All rights reserved.
//

#include "EGL/drivers/eagl/egl_eagl_driver_ios.h"
#include "EGL/drivers/eagl/egl_eagl_driver.h"
#include "EGL/drivers/eagl/egl_eagl_common.h"
#include "EGL/egldriver.h"
#include <string.h>

#ifdef __OBJC__

#import <Foundation/NSString.h>
#import <UIKit/UIApplication.h>
#import <UIKit/UIWindow.h>
#import <OpenGLES/EAGL.h>
#include <OpenGLES/EAGLDrawable.h>
#include <Foundation/NSString.h>
#include <QuartzCore/QuartzCore.h>
#include <OpenGLES/ES1/gl.h>
#include <OpenGLES/ES1/glext.h>
#include <OpenGLES/ES2/gl.h>

#import <EGL/drivers/eagl/egl_eagl_ios_eaglwindow.h>
#import "EGL/drivers/eagl/ios/AppleIOSMemoryManagement.h"

#endif  // __OBJC__

#define EAGL_IOS_MAJOR_VERSION 1
#define EAGL_IOS_MINOR_VERSION 4

#define BOOL_TO_EGLBoolean(b) (b == YES ? EGL_TRUE : EGL_FALSE)

EGLBoolean convert_eagl_ios_config (struct EAGL_egl_driver *EAGL_drv,
                                    struct EAGL_egl_display *EAGL_dpy,
                                    _EAGL_egl_Config_iOS *eagl_ios_config,
                                    struct EAGL_egl_config *EAGL_conf) {
    int err;
    err = EGL_FALSE;
    _EGLConfig *conf = &(EAGL_conf->Base);
    
    EAGL_conf->conf = *eagl_ios_config;
    EGLint glv;
    switch (eagl_ios_config->eaglRenderingAPI) {
        case kEAGLRenderingAPIOpenGLES1:
            glv = EGL_OPENGL_ES_BIT;
            break;
        case kEAGLRenderingAPIOpenGLES2:
            glv = EGL_OPENGL_ES2_BIT;
            break;
        case kEAGLRenderingAPIOpenGLES3:
            glv = EGL_OPENGL_ES3_BIT_KHR;
            break;
        default:
            glv = 0;
            err = EGL_TRUE;
            break;
    }
    if ([eagl_ios_config->colorFormat isEqualToString:kEAGLColorFormatRGBA8]) {
        _eglSetConfigKey(conf, EGL_RED_SIZE       ,8);
        _eglSetConfigKey(conf, EGL_GREEN_SIZE     ,8);
        _eglSetConfigKey(conf, EGL_BLUE_SIZE      ,8);
        _eglSetConfigKey(conf, EGL_LUMINANCE_SIZE ,8);
        _eglSetConfigKey(conf, EGL_ALPHA_SIZE     ,8);
    }
    else if ([eagl_ios_config->colorFormat isEqualToString:kEAGLColorFormatRGB565]) {
        _eglSetConfigKey(conf, EGL_RED_SIZE       ,5);
        _eglSetConfigKey(conf, EGL_GREEN_SIZE     ,6);
        _eglSetConfigKey(conf, EGL_BLUE_SIZE      ,5);
        _eglSetConfigKey(conf, EGL_LUMINANCE_SIZE ,0);
        _eglSetConfigKey(conf, EGL_ALPHA_SIZE     ,0);
    }
    else {
        _eglSetConfigKey(conf, EGL_RED_SIZE       ,0);
        _eglSetConfigKey(conf, EGL_GREEN_SIZE     ,0);
        _eglSetConfigKey(conf, EGL_BLUE_SIZE      ,0);
        _eglSetConfigKey(conf, EGL_LUMINANCE_SIZE ,0);
        _eglSetConfigKey(conf, EGL_ALPHA_SIZE     ,0);
        err = EGL_TRUE;
    }
    _eglSetConfigKey(conf, EGL_COLOR_BUFFER_TYPE     ,EGL_RGB_BUFFER);
    switch (_eglGetConfigKey(conf, EGL_COLOR_BUFFER_TYPE)) {
        case EGL_RGB_BUFFER:
        {
            EGLint r = (_eglGetConfigKey(conf, EGL_RED_SIZE)
                        + _eglGetConfigKey(conf, EGL_GREEN_SIZE)
                        + _eglGetConfigKey(conf, EGL_BLUE_SIZE)
                        + _eglGetConfigKey(conf, EGL_ALPHA_SIZE));
            
            _eglSetConfigKey(conf, EGL_BUFFER_SIZE     ,r);
            _eglSetConfigKey(conf, EGL_LUMINANCE_SIZE  ,0);
            break;
        }
        case EGL_LUMINANCE_BUFFER:
        {
            EGLint r = _eglGetConfigKey(conf, EGL_LUMINANCE_SIZE)
            + _eglGetConfigKey(conf, EGL_ALPHA_SIZE);
            
            _eglSetConfigKey(conf, EGL_BUFFER_SIZE    ,r);
            _eglSetConfigKey(conf, EGL_RED_SIZE       ,0);
            _eglSetConfigKey(conf, EGL_GREEN_SIZE     ,0);
            _eglSetConfigKey(conf, EGL_BLUE_SIZE      ,0);
            break;
        }
        default:
        {
            _eglSetConfigKey(conf, EGL_RED_SIZE       ,0);
            _eglSetConfigKey(conf, EGL_GREEN_SIZE     ,0);
            _eglSetConfigKey(conf, EGL_BLUE_SIZE      ,0);
            _eglSetConfigKey(conf, EGL_LUMINANCE_SIZE ,0);
            _eglSetConfigKey(conf, EGL_BUFFER_SIZE    ,0);
            _eglSetConfigKey(conf, EGL_ALPHA_SIZE     ,0);
            err = EGL_TRUE;
            break;
        }
    }
    _eglSetConfigKey(conf, EGL_ALPHA_MASK_SIZE        ,0); // OpenVG only
    _eglSetConfigKey(conf, EGL_CONFIG_CAVEAT          ,EGL_NONE);
    _eglSetConfigKey(conf, EGL_CONFIG_ID              ,eagl_ios_config->configID);
    _eglSetConfigKey(conf, EGL_CONFORMANT             ,glv);
    _eglSetConfigKey(conf, EGL_DEPTH_SIZE             ,eagl_ios_config->depth); // TODO: How to get the right value ?
    _eglSetConfigKey(conf, EGL_LEVEL                  ,eagl_ios_config->frameBufferLevel);
    _eglSetConfigKey(conf, EGL_MAX_PBUFFER_WIDTH      ,0); // TODO: How to get the right value ?
    _eglSetConfigKey(conf, EGL_MAX_PBUFFER_HEIGHT     ,0); // TODO: How to get the right value ?
    _eglSetConfigKey(conf, EGL_MAX_PBUFFER_PIXELS     ,0); // TODO: How to get the right value ?
    _eglSetConfigKey(conf, EGL_MAX_SWAP_INTERVAL      ,0); // TODO: How to get the right value ?
    _eglSetConfigKey(conf, EGL_MIN_SWAP_INTERVAL      ,0); // TODO: How to get the right value ?
    _eglSetConfigKey(conf, EGL_NATIVE_RENDERABLE      ,EGL_TRUE); // Let's say yes
    _eglSetConfigKey(conf, EGL_NATIVE_VISUAL_ID       ,0); // No visual
    _eglSetConfigKey(conf, EGL_NATIVE_VISUAL_TYPE     ,EGL_NONE); // No visual
    _eglSetConfigKey(conf, EGL_RENDERABLE_TYPE        ,glv);
    _eglSetConfigKey(conf, EGL_SAMPLE_BUFFERS         ,0); // TODO: How to get the right value ?
    _eglSetConfigKey(conf, EGL_SAMPLES                ,_eglGetConfigKey(conf, EGL_SAMPLE_BUFFERS) == 0 ? 0 : 0);
    _eglSetConfigKey(conf, EGL_STENCIL_SIZE           ,0);// TODO: How to get the right value ?
    _eglSetConfigKey(conf, EGL_SURFACE_TYPE           ,eagl_ios_config->surfaceType);
    _eglSetConfigKey(conf, EGL_TRANSPARENT_TYPE       ,EGL_NONE); // TODO: How to get the right value ?
    switch (_eglGetConfigKey(conf, EGL_TRANSPARENT_TYPE)) {
        case EGL_TRANSPARENT_RGB:
            _eglSetConfigKey(conf, EGL_TRANSPARENT_RED_VALUE       ,0); // TODO: How to get the right value ?
            _eglSetConfigKey(conf, EGL_TRANSPARENT_GREEN_VALUE     ,0); // TODO: How to get the right value ?
            _eglSetConfigKey(conf, EGL_TRANSPARENT_BLUE_VALUE      ,0); // TODO: How to get the right value ?
            break;
        case EGL_NONE:
            _eglSetConfigKey(conf, EGL_TRANSPARENT_RED_VALUE       ,0);
            _eglSetConfigKey(conf, EGL_TRANSPARENT_GREEN_VALUE     ,0);
            _eglSetConfigKey(conf, EGL_TRANSPARENT_BLUE_VALUE      ,0);
            break;
        default:
            _eglSetConfigKey(conf, EGL_TRANSPARENT_RED_VALUE       ,0);
            _eglSetConfigKey(conf, EGL_TRANSPARENT_GREEN_VALUE     ,0);
            _eglSetConfigKey(conf, EGL_TRANSPARENT_BLUE_VALUE      ,0);
            err = EGL_TRUE;
            break;
    }
    _eglSetConfigKey(conf, EGL_BIND_TO_TEXTURE_RGB     ,EGL_FALSE); // TODO: How to get the right value ?
    _eglSetConfigKey(conf, EGL_BIND_TO_TEXTURE_RGBA    ,EGL_FALSE); // TODO: How to get the right value ?
    //    /* pixmap surfaces must be single-buffered in EGL */
    //    if (!GLX_conf->double_buffered)
    //        GLX_conf->Base.SurfaceType |= EGL_PIXMAP_BIT;
    
    
    //    for (i = 0; i < ARRAY_SIZE(visual_attributes); i++) {
    //        EGLint egl_attr, egl_val;
    //
    //        attr = visual_attributes[i].attr;
    //        egl_attr = visual_attributes[i].egl_attr;
    //        if (!egl_attr)
    //            continue;
    //
    //        err = GLX_drv->glXGetConfig(dpy, vinfo, attr, &val);
    //        if (err) {
    //            if (err == GLX_BAD_ATTRIBUTE) {
    //                err = 0;
    //                continue;
    //            }
    //            break;
    //        }
    //
    //        switch (egl_attr) {
    //            case EGL_CONFIG_CAVEAT:
    //                egl_val = EGL_NONE;
    //                if (val == GLX_SLOW_VISUAL_EXT) {
    //                    egl_val = EGL_SLOW_CONFIG;
    //                }
    //                else if (val == GLX_NON_CONFORMANT_VISUAL_EXT) {
    //                    GLX_conf->Base.Conformant &= ~EGL_OPENGL_BIT;
    //                    egl_val = EGL_NONE;
    //                }
    //                break;
    //                break;
    //            default:
    //                egl_val = val;
    //                break;
    //        }
    //        _eglSetConfigKey(&GLX_conf->Base, egl_attr, egl_val);
    //    }
    
    return (err) ? EGL_FALSE : EGL_TRUE;
}

EGLBoolean
create_ios_configs(struct EAGL_egl_driver *EAGL_drv, _EGLDisplay *dpy/*, void** configs*/, EGLint* num_configs)
{
    struct EAGL_egl_display* EAGL_dpy = EAGL_egl_display(dpy);
    
    if (!num_configs) {
        return EGL_FALSE;
    }

    // TODO: check opengl es 3 support at runtime
    // TODO: check opengl es 2 support at runtime
    // TODO: check opengl es 1 support at runtime
    
    *num_configs = 6;
    _EAGL_egl_Config_iOS realConfigs[] = {
        {
            0,
            kEAGLRenderingAPIOpenGLES1,
            kEAGLColorFormatRGBA8,
            NO,
            GL_DEPTH_COMPONENT16,
            0, // TODO: How to get the right value ?
            EGL_WINDOW_BIT
        },
        {
            0,
            kEAGLRenderingAPIOpenGLES1,
            kEAGLColorFormatRGB565,
            NO,
            GL_DEPTH_COMPONENT16,
            0,
            EGL_WINDOW_BIT
        },
        {
            0,
            kEAGLRenderingAPIOpenGLES2,
            kEAGLColorFormatRGBA8,
            NO,
            GL_DEPTH_COMPONENT16,
            0,
            EGL_WINDOW_BIT
        },
        {
            0,
            kEAGLRenderingAPIOpenGLES2,
            kEAGLColorFormatRGB565,
            NO,
            GL_DEPTH_COMPONENT16,
            0,
            EGL_WINDOW_BIT
        },
        {
            0,
            kEAGLRenderingAPIOpenGLES3,
            kEAGLColorFormatRGBA8,
            NO,
            GL_DEPTH_COMPONENT16,
            0,
            EGL_WINDOW_BIT
        },
        {
            0,
            kEAGLRenderingAPIOpenGLES3,
            kEAGLColorFormatRGB565,
            NO,
            GL_DEPTH_COMPONENT16,
            0,
            EGL_WINDOW_BIT
        }
    };
    
    for (int i = 0; i < *num_configs; i++) {
        realConfigs[i].configID = i+1;
        
        struct EAGL_egl_config *EAGL_conf, template;
        EGLBoolean ok;
        
        memset(&template, 0, sizeof(template));
        _eglInitConfig(&template.Base, dpy, i);
        //        if (EAGL_dpy->have_fbconfig) {
        //            ok = convert_fbconfig(EAGL_drv, EAGL_dpy,
        //                                  EAGL_dpy->fbconfigs[i], &template);
        //        }
        //        else {
        //            ok = convert_visual(EAGL_drv, EAGL_dpy,
        //                                &EAGL_dpy->visuals[i], &template);
        //        }
        ok = convert_eagl_ios_config(EAGL_drv, EAGL_dpy,
                                     &realConfigs[i], &template);
        if (!ok)
            continue;
        
        //fix_config(EAGL_dpy, &template);
        if (!_eglValidateConfig(&template.Base, EGL_FALSE)) {
            _eglLog(_EGL_DEBUG, "EAGL: failed to validate config %d", i);
            continue;
        }
        
        EAGL_conf = CALLOC_STRUCT(EAGL_egl_config);
        if (EAGL_conf) {
            memcpy(EAGL_conf, &template, sizeof(template));
            EAGL_conf->index = i;
            
            _eglLinkConfig(&EAGL_conf->Base);
        }
    }
    
    return EGL_TRUE;
    
}


EGLBoolean eaglInitialize (struct EAGL_egl_display * dpy, _EGLDisplay *disp) {
    if (!dpy) {
        return EGL_FALSE;
    }
    
    if (!dpy->dpy) {
        UIWindow* w = nil;
        if (disp->PlatformDisplay == EGL_DEFAULT_DISPLAY) {
            if ([[UIApplication sharedApplication].windows count] < 1) {
                return EGL_FALSE;
            }
            w = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
        }
        
        _UIWindow* _w = [[_UIWindow alloc] init];
        if (!_w) {
            return _eglError(EGL_NOT_INITIALIZED, "eglInitialize");
        }
        
        _w.window = w;
        dpy->dpy = _w;
    }

    disp->ClientAPIs = EGL_OPENGL_ES_BIT | EGL_OPENGL_ES2_BIT | EGL_OPENGL_ES3_BIT_KHR;
    disp->Extensions.KHR_create_context = true;
    
    return EGL_TRUE;
}

EGLBoolean eaglTerminate (_EAGLWindow** dpy) {
    return EGL_FALSE;
}

/**
 * Inits an OpenGL ES API with the requested client API version.
 * \param client Open GL ES API version (eg: 1, 2, etc)
 * \param api Object to initialize. Will be initialize if not NULL.
 * \param renderableType EGL_RENDERABLE_TYPE value with the client API version requested. Will be initialize if not NULL.
 * \return TRUE if there is platform support for the requested client API version.
 */
bool initOpenGLAPI(int clientAPIVersion, _OpenGLESAPI* api, EGLint* renderableType) {
    EGLint type = 0;
    _OpenGLESAPIVersion version;

    bool success = true;
    
    switch (clientAPIVersion) {
        case 1:
            type = EGL_OPENGL_ES_BIT;
            version = OPENGL_ES_1_1;
            break;
        case 2:
            type = EGL_OPENGL_ES2_BIT;
            version = OPENGL_ES_2_0;
            break;
        case 3:
            type = EGL_OPENGL_ES3_BIT_KHR;
            version = OPENGL_ES_3_0;
            break;
        default:
            success = false;
            break;
    }
    
    if(success){
        if(renderableType != NULL){
            *renderableType = type;
        }
        if (api != NULL) {
            opengles_api_init(api, version);
            success = api->majorVersion > 0;
        }
    }
    return success;
}

struct EAGL_egl_context * eaglCreateContext(struct EAGL_egl_display *EAGL_dpy,
                                struct EAGL_egl_config *EAGL_conf ,
                                struct EAGL_egl_context *EAGL_ctx_shared,
                                const EGLint *attrib_list,
                                struct EAGL_egl_context *EAGL_ctx) {
    EGLint requestedClientVersion = 1;
    EGLint attr, val;
    for (int i = 0; attrib_list && attrib_list[i] != EGL_NONE; i += 2) {
        attr = attrib_list[i];
        val = attrib_list[i + 1];
        switch (attr) {
            case EGL_CONTEXT_CLIENT_VERSION:
            {
                requestedClientVersion = val;
                break;
            }
            default:
            {
                _eglError(EGL_BAD_MATCH, "eaglCreateContext");
                return NULL;
                break;
            }
        }
    }
    
    _OpenGLESAPI* openGLAPI = &(EAGL_ctx->openGLESAPI);
    EGLint requestedClientAPI = 0;
    
    if(!initOpenGLAPI(requestedClientVersion, openGLAPI, &requestedClientAPI)) {
        _eglError(EGL_BAD_MATCH, "eaglCreateContext");
        return NULL;
    }
    
    if (!(requestedClientAPI & EAGL_conf->Base.RenderableType)) {
        _eglError(EGL_BAD_CONFIG, "eaglCreateContext");
        return NULL;
    }
    
    EAGLContext *nativeContext = nil;
    if (EAGL_ctx_shared != EGL_NO_CONTEXT) {
        nativeContext = [[[EAGLContext alloc] initWithAPI:EAGL_conf->conf.eaglRenderingAPI
                                          sharegroup: EAGL_ctx->context.nativeSharedGroup] autorelease];
    }
    else {
        nativeContext = [[[EAGLContext alloc] initWithAPI:EAGL_conf->conf.eaglRenderingAPI] autorelease];
    }
    
    if (!nativeContext) {
        _eglError(EGL_BAD_ALLOC, "eaglCreateContext");
        return NULL;
    }

    __EAGLIOSContext* context = [[[__EAGLIOSContext alloc] init] autorelease];
    if (!context) {
        _eglError(EGL_BAD_ALLOC, "eaglCreateContext");
        return NULL;
    }
    
    [context setNativeContext:nativeContext];
    [context setNativeSharedGroup:EAGL_ctx->context.nativeSharedGroup];
    EAGL_ctx->context = context;
    
    EAGL_ctx->wasCurrent = EGL_FALSE;
    return EAGL_ctx;
}

void  eaglDestroyContext ( _EAGLWindow *dpy, struct EAGL_egl_context* ctx ) {
    freeEAGL_egl_context(ctx);
}

EGLBoolean eaglMakeCurrent(_EAGLWindow *dpy,
                           _EAGLSurface* surface,
                           _EAGLContext* ctx) {
    return EGL_TRUE;
}

EGLBoolean eaglSwapBuffers( struct EAGL_egl_display* EAGL_dpy, struct EAGL_egl_surface *EAGL_surf ) {
    struct EAGL_egl_context *EAGL_context = EAGL_egl_context(EAGL_surf->Base.CurrentContext);
    if (EAGL_context->context == nil && EAGL_context->context.nativeContext == nil) {
       return _eglError(EGL_BAD_SURFACE, "eaglSwapBuffers");
    }
    BOOL b = [EAGL_context->context.nativeContext presentRenderbuffer:EAGL_context->openGLESAPI.GL_RENDERBUFFER_];
    return BOOL_TO_EGLBoolean(b);
}

_EAGLImage*/*GLXPixmap*/ eaglCreatePixmap(_EAGLWindow *dpy,
                                       _UIScreen *visual,
                                       _EAGLImage* pixmap ) {
    return NULL;
}

void eaglDestroyPixmap( _EAGLWindow *dpy, _EAGLImage*/*GLXPixmap*/ pixmap ) {

}

EGLBoolean eaglQueryVersion( _EAGLWindow *dpy, int *maj, int *min ) {
    if (maj != NULL && min != NULL) {
        *maj = EAGL_IOS_MAJOR_VERSION;
        *min = EAGL_IOS_MINOR_VERSION;
        return EGL_TRUE;
    }
    return EGL_FALSE;
}

int eaglGetConfigs( _EAGLWindow *dpy, _UIScreen *visual, int attrib, int *value ) {
    return 0;
}

void eaglWaitGL ( void ) {

}

void eaglWaitNative( void ) {

}

const char *eaglQueryExtensionString( _EAGLWindow *dpy, int screen ) {
    return "";
}

const char *eaglQueryServerString( _EAGLWindow *dpy, int screen, int name ) {
    return "";
}

const char *eaglQueryClientString ( _EAGLWindow *dpy, int name ) {
    return "";
}

void * eaglCreateWindow (void) {
    return NULL;
}

void * eaglDestroyWindow(void) {
    return NULL;
}

void *eaglCreatePBuffer (void) {
    return NULL;
}

void *eaglDestroyPBuffer(void) {
    return NULL;
}

EGLBoolean eaglQuerySurface (_EAGLSurface* surface, int attrib, int *value) {
    if (surface == nil) {return EGL_FALSE;}
    return EGL_FALSE;
}

EGLBoolean eaglSurfaceAttrib (_EAGLSurface* surface, int attrib, int value) {
    if (surface == nil) {return EGL_FALSE;}
    return EGL_FALSE;
}

void * createNewContext(void) {
    return NULL;
}

void * makeContextCurrent(void) {
    return NULL;
}

/**
 *  Get Process Address for a specific procedure
 *  \param proc_name Procedure name
 *  \return Procedure address
 */
static ProcAddressFuncPtr eaglIOSGetProcAddress(const char * proc_name);
static ProcAddressFuncPtr eaglIOSGetProcAddress(const char * proc_name) {
#define EQUAL_STRING(varStr, stringLiteral)      strcmp(varStr, stringLiteral) == 0
    if (EQUAL_STRING(proc_name, "eaglInitialize")) {
        return (ProcAddressFuncPtr) eaglInitialize;
    }
    else if (EQUAL_STRING(proc_name, "eaglTerminate")) {
        return (ProcAddressFuncPtr) eaglTerminate;
    }
    else if (EQUAL_STRING(proc_name, "eaglCreateContext")) {
        return (ProcAddressFuncPtr) eaglCreateContext;
    }
    else if (EQUAL_STRING(proc_name, "eaglDestroyContext")) {
        return (ProcAddressFuncPtr) eaglDestroyContext;
    }
    else if (EQUAL_STRING(proc_name, "eaglMakeCurrent")) {
        return (ProcAddressFuncPtr) eaglMakeCurrent;
    }
    else if (EQUAL_STRING(proc_name, "eaglSwapBuffers")) {
        return (ProcAddressFuncPtr) eaglSwapBuffers;
    }
    else if (EQUAL_STRING(proc_name, "eaglCreatePixmap")) {
        return (ProcAddressFuncPtr) eaglCreatePixmap;
    }
    else if (EQUAL_STRING(proc_name, "eaglDestroyPixmap")) {
        return (ProcAddressFuncPtr) eaglDestroyPixmap;
    }
    else if (EQUAL_STRING(proc_name, "eaglQueryVersion")) {
        return (ProcAddressFuncPtr) eaglQueryVersion;
    }
    else if (EQUAL_STRING(proc_name, "eaglWaitGL")) {
        return (ProcAddressFuncPtr) eaglWaitGL;
    }
    else if (EQUAL_STRING(proc_name, "eaglWaitNative")) {
        return (ProcAddressFuncPtr) eaglWaitNative;
    }
    else if (EQUAL_STRING(proc_name, "eaglQueryExtensionsString")) {
        return (ProcAddressFuncPtr) eaglQueryExtensionString;
    }
    else if (EQUAL_STRING(proc_name, "eaglQueryServerString")) {
        return (ProcAddressFuncPtr) eaglQueryServerString;
    }
    else if (EQUAL_STRING(proc_name, "eaglGetClientString")) {
        return (ProcAddressFuncPtr) eaglQueryClientString;
    }
    else if (EQUAL_STRING(proc_name, "eaglGetConfigs")) {
        return (ProcAddressFuncPtr) eaglGetConfigs;
    }
    else if (EQUAL_STRING(proc_name, "eaglCreateWindow")) {
        return (ProcAddressFuncPtr) eaglCreateWindow;
    }
    else if (EQUAL_STRING(proc_name, "eaglDestroyWindow")) {
        return (ProcAddressFuncPtr) eaglDestroyWindow;
    }
    else if (EQUAL_STRING(proc_name, "eaglCreatePbuffer")) {
        return (ProcAddressFuncPtr) eaglCreatePBuffer;
    }
    else if (EQUAL_STRING(proc_name, "eaglDestroyPbuffer")) {
        return (ProcAddressFuncPtr) eaglDestroyPBuffer;
    }
    else if (EQUAL_STRING(proc_name, "eaglCreateNewContext")) {
        return (ProcAddressFuncPtr) createNewContext;
    }
    else if (EQUAL_STRING(proc_name, "eaglMakeContextCurrent")) {
        return (ProcAddressFuncPtr) makeContextCurrent;
    }
    else if (EQUAL_STRING(proc_name, "eaglQuerySurface")) {
        return (ProcAddressFuncPtr) eaglQuerySurface;
    }
    else if (EQUAL_STRING(proc_name, "eaglSurfaceAttrib")) {
        return (ProcAddressFuncPtr) eaglSurfaceAttrib;
    }
    return NULL;
#undef EQUAL_STRING
}

struct EAGL_egl_driver* _eglBuiltInDriverEAGLIOS(const char *args) {
    struct EAGL_egl_driver *EAGL_drv = CALLOC_STRUCT(EAGL_egl_driver);

    if (!EAGL_drv)
        return NULL;
    
    EAGL_drv->eaglGetProcAddress = eaglIOSGetProcAddress;
    EAGL_drv->Base.Name = "EAGL_iOS";
    
    return EAGL_drv;
}

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

#include "EGL/drivers/eagl/ios/egl_eagl_ios_driver.h"
#include "EGL/drivers/eagl/ios/egl_eagl_ios_windowsurfacehelper.h"
#include "EGL/drivers/eagl/egl_eagl_driver.h"
#include "EGL/drivers/eagl/egl_eagl_memory.h"
#include "EGL/drivers/eagl/opengles/opengles_ios.h"
#include "EGL/egldriver.h"
#include "EGL/egllog.h"
#include "EGL/eglcurrent.h"
#include "EGL/eglglobals.h"

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

#import <EGL/drivers/eagl/ios/EAGLIOSWindow.h>
#import "EGL/drivers/eagl/ios/ObjCMemoryManagement.h"

#endif  // __OBJC__

#define EAGL_IOS_MAJOR_VERSION 1
#define EAGL_IOS_MINOR_VERSION 4

/**
 * Convert _EAGL_egl_Config_iOS(s) to EGLConfig(s) for the iOS platform
 * \param EAGL_drv Driver
 * \param dpy Display to store created EGConfig to
 * \param eagl_ios_config iOS format config
 * \param EAGL_conf COnverted EGLConfig
 * \return EGL_TRUE if convertion is successfull. EGL_FALSE otherwise.
 */
static EGLBoolean convert_eagl_ios_config (struct EAGL_egl_driver *EAGL_drv,
                                    struct EAGL_egl_display *EAGL_dpy,
                                    _EAGL_egl_Config_iOS *eagl_ios_config,
                                    struct EAGL_egl_config *EAGL_conf) {
    int err;
    err = EGL_FALSE;
    _EGLConfig *conf = &(EAGL_conf->Base);
    
    EAGL_conf->Config = *eagl_ios_config;
    EGLint glv;
    switch (eagl_ios_config->EAGLRenderingAPI) {
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
    if ([eagl_ios_config->ColorFormat isEqualToString:kEAGLColorFormatRGBA8]) {
        _eglSetConfigKey(conf, EGL_RED_SIZE       ,8);
        _eglSetConfigKey(conf, EGL_GREEN_SIZE     ,8);
        _eglSetConfigKey(conf, EGL_BLUE_SIZE      ,8);
        _eglSetConfigKey(conf, EGL_LUMINANCE_SIZE ,8);
        _eglSetConfigKey(conf, EGL_ALPHA_SIZE     ,8);
    }
    else if ([eagl_ios_config->ColorFormat isEqualToString:kEAGLColorFormatRGB565]) {
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
    _eglSetConfigKey(conf, EGL_CONFIG_ID              ,eagl_ios_config->ConfigID);
    _eglSetConfigKey(conf, EGL_CONFORMANT             ,glv);
    _eglSetConfigKey(conf, EGL_DEPTH_SIZE             ,eagl_ios_config->DepthSize); // TODO: How to get the right value ?
    _eglSetConfigKey(conf, EGL_LEVEL                  ,eagl_ios_config->FrameBufferLevel);
    _eglSetConfigKey(conf, EGL_MAX_PBUFFER_WIDTH      ,0); // TODO: How to get the right value ?
    _eglSetConfigKey(conf, EGL_MAX_PBUFFER_HEIGHT     ,0); // TODO: How to get the right value ?
    _eglSetConfigKey(conf, EGL_MAX_PBUFFER_PIXELS     ,0); // TODO: How to get the right value ?
    _eglSetConfigKey(conf, EGL_MAX_SWAP_INTERVAL      ,NSIntegerMax);
    _eglSetConfigKey(conf, EGL_MIN_SWAP_INTERVAL      ,0);
    _eglSetConfigKey(conf, EGL_NATIVE_RENDERABLE      ,EGL_TRUE); // Let's say yes
    _eglSetConfigKey(conf, EGL_NATIVE_VISUAL_ID       ,0); // No visual
    _eglSetConfigKey(conf, EGL_NATIVE_VISUAL_TYPE     ,EGL_NONE); // No visual
    _eglSetConfigKey(conf, EGL_RENDERABLE_TYPE        ,glv);
    _eglSetConfigKey(conf, EGL_SAMPLE_BUFFERS         ,0); // TODO: How to get the right value ?
    _eglSetConfigKey(conf, EGL_SAMPLES                ,_eglGetConfigKey(conf, EGL_SAMPLE_BUFFERS) == 0 ? 0 : 0);
    _eglSetConfigKey(conf, EGL_STENCIL_SIZE           ,0);// TODO: How to get the right value ?
    _eglSetConfigKey(conf, EGL_SURFACE_TYPE           ,eagl_ios_config->SurfaceType);
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
    
    return (err) ? EGL_FALSE : EGL_TRUE;
}

EGLBoolean
create_ios_configs(struct EAGL_egl_driver *EAGL_drv, _EGLDisplay *dpy, EGLint* num_configs)
{
    struct EAGL_egl_display* EAGL_dpy = EAGL_egl_display(dpy);
    
    if (!num_configs) {
        return EGL_FALSE;
    }
    
    struct node {
        struct node* next;
        _EAGL_egl_Config_iOS config;
    };

    #define APPEND_NODE_CONFIG(last, conf) \
    { \
        struct node* pn = (struct node*) malloc(sizeof(struct node)); \
        pn->next = NULL; \
        pn->config = conf; \
        *num_configs += 1; \
        if (last) { \
            last->next = pn; \
            last = pn; \
        } \
        else {\
            last = pn; \
        } \
    }

    _OpenGLESAPIVersion maxGLVersion = opengles_max_version_supported();
    *num_configs = 0;
    struct node* realConfigs = NULL;
    struct node* last = NULL;
    if (maxGLVersion >= OPENGL_ES_1_1) {
        _EAGL_egl_Config_iOS conf = {
                0,
                kEAGLRenderingAPIOpenGLES1,
                kEAGLColorFormatRGBA8,
                GL_DEPTH_COMPONENT16,
                0,
                EGL_WINDOW_BIT
        };
        APPEND_NODE_CONFIG(realConfigs, conf)
        last = realConfigs;
        _EAGL_egl_Config_iOS conf2 = {
                0,
                kEAGLRenderingAPIOpenGLES1,
                kEAGLColorFormatRGB565,
                GL_DEPTH_COMPONENT16,
                0,
                EGL_WINDOW_BIT
        };
        APPEND_NODE_CONFIG(last, conf2)
    }
    if (maxGLVersion >= OPENGL_ES_2_0) {
        _EAGL_egl_Config_iOS conf = {
                0,
                kEAGLRenderingAPIOpenGLES2,
                kEAGLColorFormatRGBA8,
                GL_DEPTH_COMPONENT16,
                0,
                EGL_WINDOW_BIT
        };
        APPEND_NODE_CONFIG(last, conf)
        _EAGL_egl_Config_iOS conf2 = {
                0,
                kEAGLRenderingAPIOpenGLES2,
                kEAGLColorFormatRGB565,
                GL_DEPTH_COMPONENT16,
                0,
                EGL_WINDOW_BIT
        };
        APPEND_NODE_CONFIG(last, conf2)
    }
    if (maxGLVersion >= OPENGL_ES_3_0) {
        _EAGL_egl_Config_iOS conf = {
                0,
                kEAGLRenderingAPIOpenGLES3,
                kEAGLColorFormatRGBA8,
                GL_DEPTH_COMPONENT16,
                0,
                EGL_WINDOW_BIT
        };
        APPEND_NODE_CONFIG(last, conf)
        _EAGL_egl_Config_iOS conf2 = {
                0,
                kEAGLRenderingAPIOpenGLES3,
                kEAGLColorFormatRGB565,
                GL_DEPTH_COMPONENT16,
                0,
                EGL_WINDOW_BIT
        };
        APPEND_NODE_CONFIG(last, conf2)
    }
    
    struct node* current = realConfigs;
    struct node* prev = NULL;
    int i = 0;
    while (current) {
        current->config.ConfigID = i+1;
        
        struct EAGL_egl_config *EAGL_conf, template;
        EGLBoolean ok;
        
        memset(&template, 0, sizeof(template));
        _eglInitConfig(&template.Base, dpy, i);
        ok = convert_eagl_ios_config(EAGL_drv, EAGL_dpy,
                                     &(current->config), &template);
        if (!ok)
            continue;
        
        if (!_eglValidateConfig(&template.Base, EGL_FALSE)) {
            _eglLog(_EGL_DEBUG, "EAGL: failed to validate config %d", i);
            continue;
        }
        
        EAGL_conf = CALLOC_STRUCT(EAGL_egl_config);
        if (EAGL_conf) {
            memcpy(EAGL_conf, &template, sizeof(template));
            EAGL_conf->Index = i;
            
            _eglLinkConfig(&EAGL_conf->Base);
        }
        prev = current;
        current = current->next;
        free(prev);
    }
    
    return EGL_TRUE;
    
}

static void (^onContextLostOrRetrieved)(NSNotification*) = NULL;

EGLBoolean EAGLIOS_Initialize (struct EAGL_egl_display * dpy, _EGLDisplay *disp) {
    if (!dpy) {
        return EGL_FALSE;
    }
    
    if (onContextLostOrRetrieved == NULL) {
        onContextLostOrRetrieved = ^ (NSNotification* notification){
            if ([notification.name isEqualToString:UIApplicationDidEnterBackgroundNotification]) {
                _eglLockMutex(_eglGlobal.Mutex);
                _EGLDisplay* display = _eglGlobal.DisplayList;
                while (display) {
                    struct findresource data = {
                        .ResourceFound = false,
                        .ResourceType = _EGL_RESOURCE_CONTEXT,
                        .RequestType = SET_CONTEXT_LOST_STATUS,
                        .Exec = ExecSetContextLostStatus,
                        .Display = display
                    };
                    findResource(display, &data);
                    display = display->Next;
                }
                _eglUnlockMutex(_eglGlobal.Mutex);
            }
            else if ([notification.name isEqualToString:UIApplicationWillTerminateNotification]) {
                NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
                [center removeObserver:onContextLostOrRetrieved];
                onContextLostOrRetrieved = NULL;
            }
        };
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
        [center addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil queue:mainQueue usingBlock:onContextLostOrRetrieved];
        [center addObserverForName:UIApplicationWillTerminateNotification object:nil queue:mainQueue usingBlock:onContextLostOrRetrieved];
    }
    
    if (!dpy->Window) {
        UIWindow* w = nil;
        if (disp->PlatformDisplay == EGL_DEFAULT_DISPLAY) {
            if ([[UIApplication sharedApplication].windows count] < 1) {
                return EGL_FALSE;
            }
            w = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
        }
        
        EAGLIOSWindow* _w = OWNERSHIP_AUTORELEASE([[EAGLIOSWindow alloc] init]);
        if (!_w) {
            return _eglError(EGL_NOT_INITIALIZED, "eglInitialize");
        }
        
        _w.window = w;
        dpy->Window = OWNERSHIP_BRIDGE_RETAINED(EAGLIOSWindow *,_w);
    }

    disp->ClientAPIs = EGL_OPENGL_ES_BIT | EGL_OPENGL_ES2_BIT | EGL_OPENGL_ES3_BIT_KHR;
    disp->Extensions.KHR_create_context = true;
    
    return EGL_TRUE;
}

EGLBoolean EAGLIOS_Terminate (struct EAGL_egl_display *EAGL_dpy) {
    OWNERSHIP_BRIDGE_TRANSFER(EAGLIOSWindow *,EAGL_dpy->Window);
    return EGL_TRUE;
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

struct EAGL_egl_context* EAGLIOS_CreateContext(struct EAGL_egl_display *EAGL_dpy,
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
    
    _OpenGLESAPI* openGLAPI = &(EAGL_ctx->OpenGLESAPI);
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
        nativeContext = OWNERSHIP_AUTORELEASE([[EAGLContext alloc] initWithAPI:EAGL_conf->Config.EAGLRenderingAPI
                                          sharegroup: EAGL_ctx->Context.nativeSharedGroup]);
    }
    else {
        nativeContext = OWNERSHIP_AUTORELEASE([[EAGLContext alloc] initWithAPI:EAGL_conf->Config.EAGLRenderingAPI]);
    }
    
    if (!nativeContext) {
        _eglError(EGL_BAD_ALLOC, "eaglCreateContext");
        return NULL;
    }

    EAGLIOSContext* context = OWNERSHIP_AUTORELEASE([[EAGLIOSContext alloc] init]);
    if (!context) {
        _eglError(EGL_BAD_ALLOC, "eaglCreateContext");
        return NULL;
    }
    
    [context setNativeContext:nativeContext];
    [context setNativeSharedGroup:EAGL_ctx->Context.nativeSharedGroup];
    EAGL_ctx->Context = OWNERSHIP_BRIDGE_RETAINED(_EAGLContext*, context);
    
    EAGL_ctx->WasCurrent = EGL_FALSE;
    return EAGL_ctx;
}

void  EAGLIOS_DestroyContext ( _EAGLWindow *dpy, struct EAGL_egl_context* ctx) {
    if(ctx->Context != NULL) {
        OWNERSHIP_BRIDGE_TRANSFER(_EAGLContext*, ctx->Context);
        ctx->Context = NULL;
    }
}

EGLBoolean EAGLIOS_MakeCurrent(_EAGLWindow *dpy,
                            struct EAGL_egl_surface* EAGL_dsurf,
                            struct EAGL_egl_surface* EAGL_rsurf,
                            struct EAGL_egl_context* EAGL_ctx,
                            struct EAGL_egl_surface *EAGL_odsurf,
                            struct EAGL_egl_surface *EAGL_orsurf,
                            struct EAGL_egl_context *EAGL_octx) {
    _OpenGLESAPI* api = NULL;
    bool isCurrent = false;
    BOOL setCtxSuccess = NO;
    if (EAGL_octx != EGL_NO_CONTEXT && EAGL_odsurf != EGL_NO_SURFACE && EAGL_orsurf != EGL_NO_SURFACE) {
        /** Set old surfaces as non current */
        [EAGL_odsurf->Surface setupVideoFrameIntervalUpdates:0];
        api = &EAGL_octx->OpenGLESAPI;
        isCurrent = windowsurfacehelper_makeFrameBufferCurrent(EAGL_octx, EAGL_odsurf->Surface, api); // Why am I doing this ?
        if (!isCurrent) {
            // What is the error to raise ?
            return EGL_FALSE;
        }
        /** Set old context as non current */
        setCtxSuccess = [EAGLContext setCurrentContext: nil];
        if (!setCtxSuccess) {
            _eglError(EGL_BAD_CONTEXT, "eglMakeCurrent");
            return EGL_FALSE;
        }
    }

    /** Check for bad match */
    EAGLContext* nativeContext = nil;
    if (EAGL_ctx == EGL_NO_CONTEXT) {
        if (EAGL_dsurf != EGL_NO_SURFACE && EAGL_rsurf != EGL_NO_SURFACE) {
            _eglError(EGL_BAD_MATCH, "eglMakeCurrent");
            return EGL_FALSE;
        }
        if (EAGL_dsurf == EGL_NO_SURFACE && EAGL_rsurf == EGL_NO_SURFACE) {
            return EGL_TRUE;
        }
    }
    else {
        if (EAGL_dsurf == EGL_NO_SURFACE || EAGL_rsurf == EGL_NO_SURFACE) {
            _eglError(EGL_BAD_MATCH, "eglMakeCurrent");
            return EGL_FALSE;
        }
        nativeContext = [(EAGL_ctx->Context) nativeContext];
    }

    /** Save OpenGL ES API Version into Surface */
    api = &EAGL_ctx->OpenGLESAPI;
    EAGLRenderingAPI clientAPI = EAGL_ctx->Context.nativeContext.API;
    EAGLSharegroup* psharegroup = EAGL_ctx->Context.nativeContext.sharegroup;
    if (!EAGL_dsurf->Surface.sharegroup) {
        EAGLContext* sharegroup = OWNERSHIP_AUTORELEASE([[EAGLContext alloc] initWithAPI:clientAPI sharegroup: psharegroup]);
        [EAGL_dsurf->Surface setSharegroup:sharegroup];
        [EAGL_dsurf->Surface setApi:*api];
    }

    /** Set context as current */
    setCtxSuccess = [EAGLContext setCurrentContext: nativeContext];
    if (!setCtxSuccess) {
        _eglError(EGL_BAD_CONTEXT, "eglMakeCurrent");
        return EGL_FALSE;
    }

    /** Set surfaces as current */
    GLenum error = GL_NO_ERROR;
    int step = 1;
    if (!EAGL_ctx->WasCurrent) {
        bool setFBSuccess = windowsurfacehelper_createFrameBuffer(EAGL_ctx, EAGL_dsurf->Surface, api);
        GL_CLEANUP_ERROR(!setFBSuccess, cleanup)
        EGLint surfaceWidth = EAGL_dsurf->Base.Width;
        EGLint surfaceHeight = EAGL_dsurf->Base.Height;
        GLenum error = GL_NO_ERROR;
        /** Set initial viewport/scissor */
        GL_GET_ERROR(api->glViewport(0,0, surfaceWidth, surfaceHeight), error, step)
        GL_CLEANUP_ERROR(error != GL_NO_ERROR, cleanup)
        GL_GET_ERROR(api->glScissor(0,0, surfaceWidth, surfaceHeight), error, step)
        GL_CLEANUP_ERROR(error != GL_NO_ERROR, cleanup)
        EAGL_ctx->WasCurrent = EGL_TRUE;
    }
    
    isCurrent = windowsurfacehelper_makeFrameBufferCurrent(EAGL_ctx, EAGL_dsurf->Surface, api);
    GL_CLEANUP_ERROR(!isCurrent, cleanup)
    return EGL_TRUE;
    
cleanup:
    {
        //TODO
    }
    return EGL_FALSE;
}

EGLBoolean EAGLIOS_SwapBuffers( struct EAGL_egl_display* EAGL_dpy, struct EAGL_egl_surface *EAGL_surf) {
    struct EAGL_egl_context *EAGL_context = EAGL_egl_context(EAGL_surf->Base.CurrentContext);
    if (EAGL_context->Context == nil && EAGL_context->Context.nativeContext == nil) {
       return _eglError(EGL_BAD_SURFACE, "eaglSwapBuffers");
    }
    
    [EAGL_surf->Surface setupVideoFrameIntervalUpdates: EAGL_surf->Base.SwapInterval];
    
    if (EAGL_surf->Base.SwapInterval > 0) {
        [EAGL_surf->Surface waitUntilMinIntervalFrameUpdated];
    }
    BOOL b = [EAGL_context->Context.nativeContext presentRenderbuffer:EAGL_context->OpenGLESAPI.GL_RENDERBUFFER_];
    return b == YES ? EGL_TRUE : EGL_FALSE;
}

EGLBoolean EAGLIOS_SwapInterval(struct EAGL_egl_display* EAGL_dpy, struct EAGL_egl_surface *EAGL_surf, EGLint interval) {
    return EGL_TRUE;
}

_EAGLImage*/*GLXPixmap*/ EAGLIOS_CreatePixmap(_EAGLWindow *dpy, _EAGLImage* pixmap ) {
    return NULL;
}

void EAGLIOS_DestroyPixmap( _EAGLWindow *dpy, _EAGLImage*/*GLXPixmap*/ pixmap ) {

}

EGLBoolean EAGLIOS_QueryVersion( _EAGLWindow *dpy, int *maj, int *min ) {
    if (maj != NULL && min != NULL) {
        *maj = EAGL_IOS_MAJOR_VERSION;
        *min = EAGL_IOS_MINOR_VERSION;
        return EGL_TRUE;
    }
    return EGL_FALSE;
}

int EAGLIOS_GetConfigs( _EAGLWindow *dpy, int attrib, int *value ) {
    return 0;
}

EGLBoolean EAGLIOS_WaitGL ( struct EAGL_egl_context *EAGL_context ) {
    if (!EAGL_context) {
        return EGL_FALSE;
    }
    _OpenGLESAPI* api = &EAGL_context->OpenGLESAPI;
    int step = 0;
    GLenum error = GL_NO_ERROR;
    GL_GET_ERROR(api->glFinish(), error, step)
    GL_CLEANUP_ERROR(error != GL_NO_ERROR, cleanup)
    return EGL_TRUE;
    cleanup:
    return EGL_FALSE;
}

EGLBoolean EAGLIOS_WaitNative( ) {
    return EGL_FALSE;
}

const char * EAGLIOS_QueryExtensionString( _EAGLWindow *dpy, int screen ) {
    return "";
}

const char * EAGLIOS_QueryServerString( _EAGLWindow *dpy, int screen, int name ) {
    return "";
}

const char * EAGLIOS_QueryClientString ( _EAGLWindow *dpy, int name ) {
    return "";
}

BOOL convertToEAGLDrawablePropertyRetainedBacking(EGLenum swapBehavior) {
    if (swapBehavior == EGL_BUFFER_PRESERVED) {
        return YES;
    }
    if (swapBehavior == EGL_BUFFER_DESTROYED) {
        return NO;
    }
    return NO;
}

EGLBoolean EAGLIOS_CreateWindow(struct EAGL_egl_display *EAGL_dpy,
                            struct EAGL_egl_config *EAGL_conf, EGLNativeWindowType window,
                            const EGLint *attrib_list, struct EAGL_egl_surface *EAGL_surf) {
    
    //    EAGL_surf->drawable = window;
    
    //    id<NSObject> obj = (id<NSObject>)window;
    //    if (![obj isKindOfClass:[UIView class]]) {
    //        _eglError(EGL_BAD_NATIVE_WINDOW, "eglCreateWindowSurface: Not an UIView instance");
    //        return EGL_FALSE;
    //    }
    id<EAGLDrawable> nativeEAGLDrawable = window;
    
    _EAGLSurface* eaglSurface = OWNERSHIP_AUTORELEASE([[_EAGLSurface alloc] init]);
    [eaglSurface setWindowSurface:nativeEAGLDrawable];
    
    EAGL_surf->Surface = OWNERSHIP_BRIDGE_RETAINED(CFTypeRef, eaglSurface);
    
    //    UIView* v = (UIView*)obj;
    //    id<EAGLDrawable> eaglSurface = (id<EAGLDrawable>)[v layer];
    NSDictionary* nativeDrawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                              [NSNumber numberWithBool:convertToEAGLDrawablePropertyRetainedBacking(EAGL_surf->Base.SwapBehavior)],
                                              kEAGLDrawablePropertyRetainedBacking,
                                              EAGL_conf->Config.ColorFormat,
                                              kEAGLDrawablePropertyColorFormat,
                                              nil];
    if (!nativeDrawableProperties && [nativeDrawableProperties count] < 2) {
        _eglError(EGL_BAD_ALLOC, "eglCreateWindowSurface");
        return EGL_FALSE;
    }
    
    @try {
        [nativeEAGLDrawable setDrawableProperties:nativeDrawableProperties];
    } @catch (NSException* e) {
        _eglError(EGL_BAD_NATIVE_WINDOW, "eglCreateWindowSurface");
        return EGL_FALSE;
    }
    
    if (!EAGL_surf->Surface) {
        free(EAGL_surf);
        return EGL_FALSE;
    }
    
    CAEAGLLayer* nativeEAGLLayer = (CAEAGLLayer*) window;
    CGFloat contentScaleFactor = [nativeEAGLLayer contentsScale];
    CGSize frameSize = nativeEAGLLayer.frame.size;
    EAGL_surf->Base.Width = frameSize.width * contentScaleFactor;
    EAGL_surf->Base.Height = frameSize.height * contentScaleFactor;
    EAGL_surf->Base.RenderBuffer = EGL_SINGLE_BUFFER;
    
    return EGL_TRUE;
}

EGLBoolean EAGLIOS_DestroyWindow(struct EAGL_egl_display *EAGL_dpy, struct EAGL_egl_surface *EAGL_surf) {
    
    struct EAGL_egl_context *EAGL_ctx = NULL;
    EAGLContext* context = EAGL_surf->Surface.sharegroup;
    [EAGLContext setCurrentContext:context];
    
    if (!context) {
        _eglLog(_EGL_WARNING, "EAGLIOS_DestroyWindow: Leak when destroying an EGL WindowSurface");
    }
    else
    {
        _OpenGLESAPI api = EAGL_surf->Surface.api;
        bool unsetFBSuccess = windowsurfacehelper_destroyFrameBuffer(EAGL_ctx, EAGL_surf->Surface, &api);
        if (!unsetFBSuccess) {
            // FIXME: What error should be reported ?
            return EGL_FALSE;
        }
    }
    
    /** Restore current context set with MakeCurrent */
    EAGL_ctx = EAGL_egl_context(_eglGetCurrentContext());
    if (EAGL_ctx) {
        [EAGLContext setCurrentContext:EAGL_ctx->Context.nativeContext];
    }
    
    /** Release Surface memory */
    OWNERSHIP_BRIDGE_TRANSFER(_EAGLSurface*, EAGL_surf->Surface);
    EAGL_surf->Surface = nil;
    _eglError(EGL_SUCCESS, "eglDestroySurface");
    return EGL_TRUE;
}

void* EAGLIOS_CreatePBuffer (void) {
    return NULL;
}

void* EAGLIOS_DestroyPBuffer(void) {
    return NULL;
}

EGLBoolean EAGLIOS_QuerySurface (_EAGLSurface* surface, int attrib, int *value) {
    if (surface == nil) {return EGL_FALSE;}
    return EGL_FALSE;
}

EGLBoolean EAGLIOS_SurfaceAttrib (_EAGLSurface* surface, int attrib, int value) {
    if (surface == nil) {return EGL_FALSE;}
    return EGL_FALSE;
}

/**
 *  Get Process Address for a specific procedure
 *  \param proc_name Procedure name
 *  \return Procedure address
 */
static ProcAddressFuncPtr EAGLIOS_GetProcAddress(const char * proc_name);
static ProcAddressFuncPtr EAGLIOS_GetProcAddress(const char * proc_name) {
#define EQUAL_STRING(varStr, stringLiteral)      strcmp(varStr, stringLiteral) == 0
    if (EQUAL_STRING(proc_name, "Initialize")) {
        return (ProcAddressFuncPtr) EAGLIOS_Initialize;
    }
    else if (EQUAL_STRING(proc_name, "Terminate")) {
        return (ProcAddressFuncPtr) EAGLIOS_Terminate;
    }
    else if (EQUAL_STRING(proc_name, "CreateContext")) {
        return (ProcAddressFuncPtr) EAGLIOS_CreateContext;
    }
    else if (EQUAL_STRING(proc_name, "CreateWindow")) {
        return (ProcAddressFuncPtr) EAGLIOS_CreateWindow;
    }
    else if (EQUAL_STRING(proc_name, "DestroyContext")) {
        return (ProcAddressFuncPtr) EAGLIOS_DestroyContext;
    }
    else if (EQUAL_STRING(proc_name, "MakeCurrent")) {
        return (ProcAddressFuncPtr) EAGLIOS_MakeCurrent;
    }
    else if (EQUAL_STRING(proc_name, "SwapBuffers")) {
        return (ProcAddressFuncPtr) EAGLIOS_SwapBuffers;
    }
    else if (EQUAL_STRING(proc_name, "SwapInterval")) {
        return (ProcAddressFuncPtr) EAGLIOS_SwapInterval;
    }
    else if (EQUAL_STRING(proc_name, "CreatePixmap")) {
        return (ProcAddressFuncPtr) EAGLIOS_CreatePixmap;
    }
    else if (EQUAL_STRING(proc_name, "DestroyPixmap")) {
        return (ProcAddressFuncPtr) EAGLIOS_DestroyPixmap;
    }
    else if (EQUAL_STRING(proc_name, "QueryVersion")) {
        return (ProcAddressFuncPtr) EAGLIOS_QueryVersion;
    }
    else if (EQUAL_STRING(proc_name, "WaitGL")) {
        return (ProcAddressFuncPtr) EAGLIOS_WaitGL;
    }
    else if (EQUAL_STRING(proc_name, "WaitNative")) {
        return (ProcAddressFuncPtr) EAGLIOS_WaitNative;
    }
    else if (EQUAL_STRING(proc_name, "QueryExtensionsString")) {
        return (ProcAddressFuncPtr) EAGLIOS_QueryExtensionString;
    }
    else if (EQUAL_STRING(proc_name, "QueryServerString")) {
        return (ProcAddressFuncPtr) EAGLIOS_QueryServerString;
    }
    else if (EQUAL_STRING(proc_name, "GetClientString")) {
        return (ProcAddressFuncPtr) EAGLIOS_QueryClientString;
    }
    else if (EQUAL_STRING(proc_name, "GetConfigs")) {
        return (ProcAddressFuncPtr) EAGLIOS_GetConfigs;
    }
    else if (EQUAL_STRING(proc_name, "DestroyWindow")) {
        return (ProcAddressFuncPtr) EAGLIOS_DestroyWindow;
    }
    else if (EQUAL_STRING(proc_name, "CreatePbuffer")) {
        return (ProcAddressFuncPtr) EAGLIOS_CreatePBuffer;
    }
    else if (EQUAL_STRING(proc_name, "DestroyPbuffer")) {
        return (ProcAddressFuncPtr) EAGLIOS_DestroyPBuffer;
    }
    else if (EQUAL_STRING(proc_name, "QuerySurface")) {
        return (ProcAddressFuncPtr) EAGLIOS_QuerySurface;
    }
    else if (EQUAL_STRING(proc_name, "SurfaceAttrib")) {
        return (ProcAddressFuncPtr) EAGLIOS_SurfaceAttrib;
    }
    return NULL;
#undef EQUAL_STRING
}

struct EAGL_egl_driver* _eglBuiltInDriverEAGLIOS(const char *args) {
    struct EAGL_egl_driver *EAGL_drv = CALLOC_STRUCT(EAGL_egl_driver);

    if (!EAGL_drv)
        return NULL;
    
    EAGL_drv->GetProcAddress = EAGLIOS_GetProcAddress;
    EAGL_drv->Base.Name = "EAGL_iOS";
    
    return EAGL_drv;
}

//
//  \file eglapi.m
//  libegl
//
//  Created by Andreoletti David.
//  Copyright 2013 IO Stark. All rights reserved.
//

#if defined(__OBJC__)

#import <UIKit/UIWindow.h>
#import <OpenGLES/EAGLDrawable.h>
#import <OpenGLES/ES1/glext.h>
#import <OpenGLES/ES2/glext.h>

/**
 *  Describe the Hardware characteristic of the screen
 */
@interface UIScreen : NSObject

@end

@implementation UIScreen

@end

@interface EAGLDrawable : NSObject

@end

@implementation EAGLDrawable

@end


#endif  // __OBJC__

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

#define CALLOC_STRUCT(T)   (struct T *) calloc(1, sizeof(struct T))
#define Bool    bool

typedef void* Pixmap; /* FIXMEDAVID: What is the iOS equivalent ? */

typedef void (*__GLXextFuncPtr)(void);
__GLXextFuncPtr eaglGetProcAddress (const GLubyte *procName);
__GLXextFuncPtr eaglGetProcAddress (const GLubyte *procName) {

}

/* EAGL 1.0 */
typedef EAGLContext* (*EAGLCREATECONTEXTPROC)(UIWindow *dpy,
                                              UIScreen *vis,
                                              EAGLContext* shareList,
                                              Bool direct );
typedef void (*EAGLDESTROYCONTEXTPROC)( UIWindow *dpy, EAGLContext* ctx );
typedef Bool (*EAGLMAKECURRENTPROC)( UIWindow *dpy, EAGLDrawable* drawable, EAGLContext* ctx);
typedef void (*EAGLSWAPBUFFERSPROC)( UIWindow *dpy, EAGLDrawable* drawable );
typedef UIImage*/*GLXPixmap*/ (*EAGLCREATEEAGLPIXMAPPROC)( UIWindow *dpy, UIScreen *visual, Pixmap pixmap );
typedef void (*EAGLDESTROYEAGLPIXMAPPROC)( UIWindow *dpy, UIImage*/*GLXPixmap*/ pixmap );
typedef Bool (*EAGLQUERYVERSIONPROC)( UIWindow *dpy, int *maj, int *min );
typedef int (*EAGLGETCONFIGPROC)( UIWindow *dpy, UIScreen *visual, int attrib, int *value );
typedef void (*EAGLWAITGLPROC)( void );
typedef void (*EAGLWAITXPROC)( void );

/* EAGL 1.1 */
typedef const char *(*EAGLQUERYEXTENSIONSSTRINGPROC)( UIWindow *dpy, int screen );
typedef const char *(*EAGLQUERYSERVERSTRINGPROC)( UIWindow *dpy, int screen, int name );
typedef const char *(*EAGLGETCLIENTSTRINGPROC)( UIWindow *dpy, int name );

/** subclass of _EGLDriver */
struct EAGL_egl_driver
{
    _EGLDriver Base;   /**< base class */
    
    void *handle;
    
    /* EAGL 1.0 */
    EAGLCREATECONTEXTPROC eaglCreateContext;
    EAGLDESTROYCONTEXTPROC eaglDestroyContext;
    EAGLMAKECURRENTPROC eaglMakeCurrent;
    EAGLSWAPBUFFERSPROC eaglSwapBuffers;
    EAGLCREATEEAGLPIXMAPPROC eaglCreateEAGLPixmap;
    EAGLDESTROYEAGLPIXMAPPROC eaglDestroyEAGLPixmap;
    EAGLQUERYVERSIONPROC eaglQueryVersion;
    EAGLGETCONFIGPROC eaglGetConfig;
    EAGLWAITGLPROC eaglWaitGL;
    EAGLWAITXPROC eaglWaitX;
    
    /* EAGL 1.1 */
    EAGLQUERYEXTENSIONSSTRINGPROC eaglQueryExtensionsString;
    EAGLQUERYSERVERSTRINGPROC eaglQueryServerString;
    EAGLGETCLIENTSTRINGPROC eaglGetClientString;
    
//    /* EAGL 1.3 or (EAGL_SGI_make_current_read and EAGL_SGIX_fbconfig) */
//    PFNEAGLGETFBCONFIGSPROC eaglGetFBConfigs;
//    PFNEAGLGETFBCONFIGATTRIBPROC eaglGetFBConfigAttrib;
//    PFNEAGLGETVISUALFROMFBCONFIGPROC eaglGetVisualFromFBConfig;
//    PFNEAGLCREATEWINDOWPROC eaglCreateWindow;
//    PFNEAGLDESTROYWINDOWPROC eaglDestroyWindow;
//    PFNEAGLCREATEPIXMAPPROC eaglCreatePixmap;
//    PFNEAGLDESTROYPIXMAPPROC eaglDestroyPixmap;
//    PFNEAGLCREATEPBUFFERPROC eaglCreatePbuffer;
//    PFNEAGLDESTROYPBUFFERPROC eaglDestroyPbuffer;
//    PFNEAGLCREATENEWCONTEXTPROC eaglCreateNewContext;
//    PFNEAGLMAKECONTEXTCURRENTPROC eaglMakeContextCurrent;
    
//    /* EAGL 1.4 or EAGL_ARB_get_proc_address */
//    PFNEAGLGETPROCADDRESSPROC eaglGetProcAddress;
//    
//    /* EAGL_SGIX_pbuffer */
//    PFNEAGLCREATEEAGLPBUFFERSGIXPROC eaglCreateEAGLPbufferSGIX;
//    PFNEAGLDESTROYEAGLPBUFFERSGIXPROC eaglDestroyEAGLPbufferSGIX;
};


/** driver data of _EGLDisplay */
struct EAGL_egl_display
{
    UIWindow *dpy;
    UIScreen *visuals;
//    EAGLFBConfig *fbconfigs;
    
    int glx_maj, glx_min;
    
    const char *extensions;
    EGLBoolean have_1_3;
    EGLBoolean have_make_current_read;
    EGLBoolean have_fbconfig;
    EGLBoolean have_pbuffer;
    
    /* workaround quirks of different EAGL implementations */
    EGLBoolean single_buffered_quirk;
    EGLBoolean glx_window_quirk;
};


/** subclass of _EGLContext */
struct EAGL_egl_context
{
    _EGLContext Base;   /**< base class */
    
    EAGLContext* context;
};


/** subclass of _EGLSurface */
struct EAGL_egl_surface
{
    _EGLSurface Base;   /**< base class */
    
//    Drawable drawable;
    EAGLDrawable* glx_drawable;
    
    void (*destroy)(UIWindow *, EAGLDrawable*);
};


/** subclass of _EGLConfig */
struct EAGL_egl_config
{
    _EGLConfig Base;   /**< base class */
    EGLBoolean double_buffered;
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


static const struct {
    int attr;
    int egl_attr;
} fbconfig_attributes[] = {
    /* table 3.1 of EAGL 1.4 */
    { EAGL_FBCONFIG_ID,                  0 },
    { EAGL_BUFFER_SIZE,                  EGL_BUFFER_SIZE },
    { EAGL_LEVEL,                        EGL_LEVEL },
    { EAGL_DOUBLEBUFFER,                 0 },
    { EAGL_STEREO,                       0 },
    { EAGL_AUX_BUFFERS,                  0 },
    { EAGL_RED_SIZE,                     EGL_RED_SIZE },
    { EAGL_GREEN_SIZE,                   EGL_GREEN_SIZE },
    { EAGL_BLUE_SIZE,                    EGL_BLUE_SIZE },
    { EAGL_ALPHA_SIZE,                   EGL_ALPHA_SIZE },
    { EAGL_DEPTH_SIZE,                   EGL_DEPTH_SIZE },
    { EAGL_STENCIL_SIZE,                 EGL_STENCIL_SIZE },
    { EAGL_ACCUM_RED_SIZE,               0 },
    { EAGL_ACCUM_GREEN_SIZE,             0 },
    { EAGL_ACCUM_BLUE_SIZE,              0 },
    { EAGL_ACCUM_ALPHA_SIZE,             0 },
    { EAGL_SAMPLE_BUFFERS,               EGL_SAMPLE_BUFFERS },
    { EAGL_SAMPLES,                      EGL_SAMPLES },
    { EAGL_RENDER_TYPE,                  0 },
    { EAGL_DRAWABLE_TYPE,                EGL_SURFACE_TYPE },
    { EAGL_X_RENDERABLE,                 EGL_NATIVE_RENDERABLE },
    { EAGL_X_VISUAL_TYPE,                EGL_NATIVE_VISUAL_TYPE },
    { EAGL_CONFIG_CAVEAT,                EGL_CONFIG_CAVEAT },
    { EAGL_TRANSPARENT_TYPE,             EGL_TRANSPARENT_TYPE },
    { EAGL_TRANSPARENT_INDEX_VALUE,      0 },
    { EAGL_TRANSPARENT_RED_VALUE,        EGL_TRANSPARENT_RED_VALUE },
    { EAGL_TRANSPARENT_GREEN_VALUE,      EGL_TRANSPARENT_GREEN_VALUE },
    { EAGL_TRANSPARENT_BLUE_VALUE,       EGL_TRANSPARENT_BLUE_VALUE },
    { EAGL_MAX_PBUFFER_WIDTH,            EGL_MAX_PBUFFER_WIDTH },
    { EAGL_MAX_PBUFFER_HEIGHT,           EGL_MAX_PBUFFER_HEIGHT },
    { EAGL_MAX_PBUFFER_PIXELS,           EGL_MAX_PBUFFER_PIXELS },
    { EAGL_VISUAL_ID,                    EGL_NATIVE_VISUAL_ID }
};


static EGLBoolean
convert_fbconfig(struct EAGL_egl_driver *EAGL_drv,
                 struct EAGL_egl_display *EAGL_dpy, EAGLFBConfig fbconfig,
                 struct EAGL_egl_config *EAGL_conf)
{
    UIWindow *dpy = EAGL_dpy->dpy;
    int err, attr, val;
    unsigned i;
    
    /* must have rgba bit */
    err = EAGL_drv->eaglGetFBConfigAttrib(dpy, fbconfig, EAGL_RENDER_TYPE, &val);
    if (err || !(val & EAGL_RGBA_BIT))
        return EGL_FALSE;
    
    /* must know whether it is double-buffered */
    err = EAGL_drv->eaglGetFBConfigAttrib(dpy, fbconfig, EAGL_DOUBLEBUFFER, &val);
    if (err)
        return EGL_FALSE;
    EAGL_conf->double_buffered = val;
    
    EAGL_conf->Base.RenderableType = EGL_OPENGL_BIT;
    EAGL_conf->Base.Conformant = EGL_OPENGL_BIT;
    
    for (i = 0; i < ARRAY_SIZE(fbconfig_attributes); i++) {
        EGLint egl_attr, egl_val;
        
        attr = fbconfig_attributes[i].attr;
        egl_attr = fbconfig_attributes[i].egl_attr;
        if (!egl_attr)
            continue;
        
        err = EAGL_drv->eaglGetFBConfigAttrib(dpy, fbconfig, attr, &val);
        if (err) {
            if (err == EAGL_BAD_ATTRIBUTE) {
                err = 0;
                continue;
            }
            break;
        }
        
        switch (egl_attr) {
            case EGL_SURFACE_TYPE:
                egl_val = 0;
                if (val & EAGL_WINDOW_BIT)
                    egl_val |= EGL_WINDOW_BIT;
                /* pixmap and pbuffer surfaces must be single-buffered in EGL */
                if (!EAGL_conf->double_buffered) {
                    if (val & EAGL_PIXMAP_BIT)
                        egl_val |= EGL_PIXMAP_BIT;
                    if (val & EAGL_PBUFFER_BIT)
                        egl_val |= EGL_PBUFFER_BIT;
                }
                break;
            case EGL_NATIVE_VISUAL_TYPE:
                switch (val) {
                    case EAGL_TRUE_COLOR:
                        egl_val = TrueColor;
                        break;
                    case EAGL_DIRECT_COLOR:
                        egl_val = DirectColor;
                        break;
                    case EAGL_PSEUDO_COLOR:
                        egl_val = PseudoColor;
                        break;
                    case EAGL_STATIC_COLOR:
                        egl_val = StaticColor;
                        break;
                    case EAGL_GRAY_SCALE:
                        egl_val = GrayScale;
                        break;
                    case EAGL_STATIC_GRAY:
                        egl_val = StaticGray;
                        break;
                    default:
                        egl_val = EGL_NONE;
                        break;
                }
                break;
            case EGL_CONFIG_CAVEAT:
                egl_val = EGL_NONE;
                if (val == EAGL_SLOW_CONFIG) {
                    egl_val = EGL_SLOW_CONFIG;
                }
                else if (val == EAGL_NON_CONFORMANT_CONFIG) {
                    EAGL_conf->Base.Conformant &= ~EGL_OPENGL_BIT;
                    egl_val = EGL_NONE;
                }
                break;
            case EGL_TRANSPARENT_TYPE:
                egl_val = (val == EAGL_TRANSPARENT_RGB) ?
                EGL_TRANSPARENT_RGB : EGL_NONE;
                break;
            default:
                egl_val = val;
                break;
        }
        
        _eglSetConfigKey(&EAGL_conf->Base, egl_attr, egl_val);
    }
    if (err)
        return EGL_FALSE;
    
    if (!EAGL_conf->Base.SurfaceType)
        return EGL_FALSE;
    
    return EGL_TRUE;
}

static const struct {
    int attr;
    int egl_attr;
} visual_attributes[] = {
    /* table 3.7 of EAGL 1.4 */
    { EAGL_USE_GL,              0 },
    { EAGL_BUFFER_SIZE,         EGL_BUFFER_SIZE },
    { EAGL_LEVEL,               EGL_LEVEL },
    { EAGL_RGBA,                0 },
    { EAGL_DOUBLEBUFFER,        0 },
    { EAGL_STEREO,              0 },
    { EAGL_AUX_BUFFERS,         0 },
    { EAGL_RED_SIZE,            EGL_RED_SIZE },
    { EAGL_GREEN_SIZE,          EGL_GREEN_SIZE },
    { EAGL_BLUE_SIZE,           EGL_BLUE_SIZE },
    { EAGL_ALPHA_SIZE,          EGL_ALPHA_SIZE },
    { EAGL_DEPTH_SIZE,          EGL_DEPTH_SIZE },
    { EAGL_STENCIL_SIZE,        EGL_STENCIL_SIZE },
    { EAGL_ACCUM_RED_SIZE,      0 },
    { EAGL_ACCUM_GREEN_SIZE,    0 },
    { EAGL_ACCUM_BLUE_SIZE,     0 },
    { EAGL_ACCUM_ALPHA_SIZE,    0 },
    { EAGL_SAMPLE_BUFFERS,      EGL_SAMPLE_BUFFERS },
    { EAGL_SAMPLES,             EGL_SAMPLES },
    { EAGL_FBCONFIG_ID,         0 },
    /* EAGL_EXT_visual_rating */
    { EAGL_VISUAL_CAVEAT_EXT,   EGL_CONFIG_CAVEAT }
};

static EGLBoolean
convert_visual(struct EAGL_egl_driver *EAGL_drv,
               struct EAGL_egl_display *EAGL_dpy, UIScreen *vinfo,
               struct EAGL_egl_config *EAGL_conf)
{
    UIWindow *dpy = EAGL_dpy->dpy;
    int err, attr, val;
    unsigned i;
    
    /* the visual must support OpenGL and RGBA buffer */
    err = EAGL_drv->eaglGetConfig(dpy, vinfo, EAGL_USE_GL, &val);
    if (!err && val)
        err = EAGL_drv->eaglGetConfig(dpy, vinfo, EAGL_RGBA, &val);
    if (err || !val)
        return EGL_FALSE;
    
    /* must know whether it is double-buffered */
    err = EAGL_drv->eaglGetConfig(dpy, vinfo, EAGL_DOUBLEBUFFER, &val);
    if (err)
        return EGL_FALSE;
    EAGL_conf->double_buffered = val;
    
    EAGL_conf->Base.RenderableType = EGL_OPENGL_BIT;
    EAGL_conf->Base.Conformant = EGL_OPENGL_BIT;
    EAGL_conf->Base.SurfaceType = EGL_WINDOW_BIT;
    /* pixmap surfaces must be single-buffered in EGL */
    if (!EAGL_conf->double_buffered)
        EAGL_conf->Base.SurfaceType |= EGL_PIXMAP_BIT;
    
    EAGL_conf->Base.NativeVisualID = vinfo->visualid;
    EAGL_conf->Base.NativeVisualType = vinfo->class;
    EAGL_conf->Base.NativeRenderable = EGL_TRUE;
    
    for (i = 0; i < ARRAY_SIZE(visual_attributes); i++) {
        EGLint egl_attr, egl_val;
        
        attr = visual_attributes[i].attr;
        egl_attr = visual_attributes[i].egl_attr;
        if (!egl_attr)
            continue;
        
        err = EAGL_drv->eaglGetConfig(dpy, vinfo, attr, &val);
        if (err) {
            if (err == EAGL_BAD_ATTRIBUTE) {
                err = 0;
                continue;
            }
            break;
        }
        
        switch (egl_attr) {
            case EGL_CONFIG_CAVEAT:
                egl_val = EGL_NONE;
                if (val == EAGL_SLOW_VISUAL_EXT) {
                    egl_val = EGL_SLOW_CONFIG;
                }
                else if (val == EAGL_NON_CONFORMANT_VISUAL_EXT) {
                    EAGL_conf->Base.Conformant &= ~EGL_OPENGL_BIT;
                    egl_val = EGL_NONE;
                }
                break;
                break;
            default:
                egl_val = val;
                break;
        }
        _eglSetConfigKey(&EAGL_conf->Base, egl_attr, egl_val);
    }
    
    return (err) ? EGL_FALSE : EGL_TRUE;
}


static void
fix_config(struct EAGL_egl_display *EAGL_dpy, struct EAGL_egl_config *EAGL_conf)
{
    _EGLConfig *conf = &EAGL_conf->Base;
    
    if (!EAGL_conf->double_buffered && EAGL_dpy->single_buffered_quirk) {
        /* some EAGL impls do not like single-buffered window surface */
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
        /* some impls set them to -1 (EAGL_DONT_CARE) */
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
    struct EAGL_egl_display *EAGL_dpy = EAGL_egl_display(dpy);
    EGLint num_configs = 0, i;
    EGLint id = 1;
    
    if (EAGL_dpy->have_fbconfig) {
        EAGL_dpy->fbconfigs =
        EAGL_drv->eaglGetFBConfigs(EAGL_dpy->dpy, screen, &num_configs);
    }
    else {
        UIScreen vinfo_template;
        long mask;
        
        vinfo_template.screen = screen;
        mask = VisualScreenMask;
        EAGL_dpy->visuals = XGetVisualInfo(EAGL_dpy->dpy, mask, &vinfo_template,
                                          &num_configs);
    }
    
    if (!num_configs)
        return EGL_FALSE;
    
    for (i = 0; i < num_configs; i++) {
        struct EAGL_egl_config *EAGL_conf, template;
        EGLBoolean ok;
        
        memset(&template, 0, sizeof(template));
        _eglInitConfig(&template.Base, dpy, id);
        if (EAGL_dpy->have_fbconfig) {
            ok = convert_fbconfig(EAGL_drv, EAGL_dpy,
                                  EAGL_dpy->fbconfigs[i], &template);
        }
        else {
            ok = convert_visual(EAGL_drv, EAGL_dpy,
                                &EAGL_dpy->visuals[i], &template);
        }
        if (!ok)
            continue;
        
        fix_config(EAGL_dpy, &template);
        if (!_eglValidateConfig(&template.Base, EGL_FALSE)) {
            _eglLog(_EGL_DEBUG, "EAGL: failed to validate config %d", i);
            continue;
        }
        
        EAGL_conf = CALLOC_STRUCT(EAGL_egl_config);
        if (EAGL_conf) {
            memcpy(EAGL_conf, &template, sizeof(template));
            EAGL_conf->index = i;
            
            _eglLinkConfig(&EAGL_conf->Base);
            id++;
        }
    }
    
    return EGL_TRUE;
}


static void
check_extensions(struct EAGL_egl_driver *EAGL_drv,
                 struct EAGL_egl_display *EAGL_dpy, EGLint screen)
{
    EAGL_dpy->extensions =
    EAGL_drv->eaglQueryExtensionsString(EAGL_dpy->dpy, screen);
    if (EAGL_dpy->extensions) {
        if (strstr(EAGL_dpy->extensions, "EAGL_SGI_make_current_read")) {
            /* EAGL 1.3 entry points are used */
            EAGL_dpy->have_make_current_read = EGL_TRUE;
        }
        
        if (strstr(EAGL_dpy->extensions, "EAGL_SGIX_fbconfig")) {
            /* EAGL 1.3 entry points are used */
            EAGL_dpy->have_fbconfig = EGL_TRUE;
        }
        
        if (strstr(EAGL_dpy->extensions, "EAGL_SGIX_pbuffer")) {
            if (EAGL_drv->eaglCreateEAGLPbufferSGIX &&
                EAGL_drv->eaglDestroyEAGLPbufferSGIX &&
                EAGL_dpy->have_fbconfig)
                EAGL_dpy->have_pbuffer = EGL_TRUE;
        }
    }
    
    if (EAGL_dpy->glx_maj == 1 && EAGL_dpy->glx_min >= 3) {
        EAGL_dpy->have_1_3 = EGL_TRUE;
        EAGL_dpy->have_make_current_read = EGL_TRUE;
        EAGL_dpy->have_fbconfig = EGL_TRUE;
        EAGL_dpy->have_pbuffer = EGL_TRUE;
    }
}


static void
check_quirks(struct EAGL_egl_driver *EAGL_drv,
             struct EAGL_egl_display *EAGL_dpy, EGLint screen)
{
    const char *vendor;
    
    EAGL_dpy->single_buffered_quirk = EGL_TRUE;
    EAGL_dpy->glx_window_quirk = EGL_TRUE;
    
    vendor = EAGL_drv->eaglGetClientString(EAGL_dpy->dpy, EAGL_VENDOR);
    if (vendor && strstr(vendor, "NVIDIA")) {
        vendor = EAGL_drv->eaglQueryServerString(EAGL_dpy->dpy, screen, EAGL_VENDOR);
        if (vendor && strstr(vendor, "NVIDIA")) {
            _eglLog(_EGL_DEBUG, "disable quirks");
            EAGL_dpy->single_buffered_quirk = EGL_FALSE;
            EAGL_dpy->glx_window_quirk = EGL_FALSE;
        }
    }
}


/**
 * Called via eglInitialize(), EAGL_drv->API.Initialize().
 */
static EGLBoolean
EAGL_eglInitialize(_EGLDriver *drv, _EGLDisplay *disp)
{
    struct EAGL_egl_driver *EAGL_drv = EAGL_egl_driver(drv);
    struct EAGL_egl_display *EAGL_dpy;
    
    if (disp->Platform != _EGL_PLATFORM_IOS)
        return EGL_FALSE;
    
    /* this is a fallback driver */
    if (!disp->Options.UseFallback)
        return EGL_FALSE;
    
    if (disp->Options.TestOnly)
        return EGL_TRUE;
    
    EAGL_dpy = CALLOC_STRUCT(EAGL_egl_display);
    if (!EAGL_dpy)
        return _eglError(EGL_BAD_ALLOC, "eglInitialize");
    
    EAGL_dpy->dpy = (UIWindow *) disp->PlatformDisplay;
    if (!EAGL_dpy->dpy) {
        EAGL_dpy->dpy = [[UIApplication sharedApplication] keyWindow];
        if (!EAGL_dpy->dpy) {
            _eglLog(_EGL_WARNING, "EAGL: [[UIApplication sharedApplication] keyWindow] failed");
            free(EAGL_dpy);
            return EGL_FALSE;
        }
    }
    
    if (!EAGL_drv->eaglQueryVersion(EAGL_dpy->dpy,
                                  &EAGL_dpy->glx_maj, &EAGL_dpy->glx_min)) {
        _eglLog(_EGL_WARNING, "EAGL: eaglQueryVersion failed");
        if (!disp->PlatformDisplay) {
            //XCloseDisplay(EAGL_dpy->dpy);
            // EGL does not own UIWindow. Do not release it
        }
        free(EAGL_dpy);
        return EGL_FALSE;
    }
    
    disp->DriverData = (void *) EAGL_dpy;
    disp->ClientAPIs = EGL_OPENGL_ES_BIT;
    
    check_extensions(EAGL_drv, EAGL_dpy, DefaultScreen(EAGL_dpy->dpy));
    check_quirks(EAGL_drv, EAGL_dpy, DefaultScreen(EAGL_dpy->dpy));
    
    create_configs(drv, disp, DefaultScreen(EAGL_dpy->dpy));
    if (!_eglGetArraySize(disp->Configs)) {
        _eglLog(_EGL_WARNING, "EAGL: failed to create any config");
        if (!disp->PlatformDisplay)
            XCloseDisplay(EAGL_dpy->dpy);
        free(EAGL_dpy);
        return EGL_FALSE;
    }
    
    /* we're supporting EGL 1.4 */
    disp->VersionMajor = 1;
    disp->VersionMinor = 4;
    
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
    free(EAGL_dpy->fbconfigs);
    
    if (!disp->PlatformDisplay)
        XCloseDisplay(EAGL_dpy->dpy);
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
    struct EAGL_egl_context *EAGL_ctx = CALLOC_STRUCT(EAGL_egl_context);
    struct EAGL_egl_display *EAGL_dpy = EAGL_egl_display(disp);
    struct EAGL_egl_context *EAGL_ctx_shared = EAGL_egl_context(share_list);
    
    if (!EAGL_ctx) {
        _eglError(EGL_BAD_ALLOC, "eglCreateContext");
        return NULL;
    }
    
    if (!_eglInitContext(&EAGL_ctx->Base, disp, conf, attrib_list)) {
        free(EAGL_ctx);
        return NULL;
    }
    
    if (EAGL_dpy->have_fbconfig) {
        EAGL_ctx->context = EAGL_drv->eaglCreateNewContext(EAGL_dpy->dpy,
                                                        EAGL_dpy->fbconfigs[EAGL_egl_config_index(conf)],
                                                        EAGL_RGBA_TYPE,
                                                        EAGL_ctx_shared ? EAGL_ctx_shared->context : NULL,
                                                        GL_TRUE);
    }
    else {
        EAGL_ctx->context = EAGL_drv->eaglCreateContext(EAGL_dpy->dpy,
                                                     &EAGL_dpy->visuals[EAGL_egl_config_index(conf)],
                                                     EAGL_ctx_shared ? EAGL_ctx_shared->context : NULL,
                                                     GL_TRUE);
    }
    if (!EAGL_ctx->context) {
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
        EAGL_drv->eaglDestroyContext(EAGL_dpy->dpy, EAGL_ctx->context);
        
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
        EAGL_surf->destroy(EAGL_dpy->dpy, EAGL_surf->glx_drawable);
    
    free(EAGL_surf);
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
    EAGLDrawable* ddraw, rdraw;
    EAGLContext* cctx;
    EGLBoolean ret = EGL_FALSE;
    
    /* make new bindings */
    if (!_eglBindContext(ctx, dsurf, rsurf, &old_ctx, &old_dsurf, &old_rsurf))
        return EGL_FALSE;
    
    ddraw = (EAGL_dsurf) ? EAGL_dsurf->glx_drawable : None;
    rdraw = (EAGL_rsurf) ? EAGL_rsurf->glx_drawable : None;
    cctx = (EAGL_ctx) ? EAGL_ctx->context : NULL;
    
    if (EAGL_dpy->have_make_current_read)
        ret = EAGL_drv->eaglMakeContextCurrent(EAGL_dpy->dpy, ddraw, rdraw, cctx);
    else if (ddraw == rdraw)
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
    
    return ret;
}

/** Get size of given window */
static Status
get_drawable_size(UIWindow *dpy, Drawable d, unsigned *width, unsigned *height)
{
    Window root;
    Status stat;
    int xpos, ypos;
    unsigned int w, h, bw, depth;
    stat = XGetGeometry(dpy, d, &root, &xpos, &ypos, &w, &h, &bw, &depth);
    *width = w;
    *height = h;
    return stat;
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
    struct EAGL_egl_surface *EAGL_surf;
    unsigned width, height;
    
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
    
    EAGL_surf->drawable = window;
    
    if (EAGL_dpy->have_1_3 && !EAGL_dpy->glx_window_quirk) {
        EAGL_surf->glx_drawable = EAGL_drv->eaglCreateWindow(EAGL_dpy->dpy,
                                                          EAGL_dpy->fbconfigs[EAGL_egl_config_index(conf)],
                                                          EAGL_surf->drawable, NULL);
    }
    else {
        EAGL_surf->glx_drawable = EAGL_surf->drawable;
    }
    
    if (!EAGL_surf->glx_drawable) {
        free(EAGL_surf);
        return NULL;
    }
    
    if (EAGL_dpy->have_1_3 && !EAGL_dpy->glx_window_quirk)
        EAGL_surf->destroy = EAGL_drv->eaglDestroyWindow;
    
    get_drawable_size(EAGL_dpy->dpy, window, &width, &height);
    EAGL_surf->Base.Width = width;
    EAGL_surf->Base.Height = height;
    
    return &EAGL_surf->Base;
}

static _EGLSurface *
EAGL_eglCreatePixmapSurface(_EGLDriver *drv, _EGLDisplay *disp,
                           _EGLConfig *conf, EGLNativePixmapType pixmap,
                           const EGLint *attrib_list)
{
    struct EAGL_egl_driver *EAGL_drv = EAGL_egl_driver(drv);
    struct EAGL_egl_display *EAGL_dpy = EAGL_egl_display(disp);
    struct EAGL_egl_surface *EAGL_surf;
    unsigned width, height;
    
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
    
    EAGL_surf->drawable = pixmap;
    
    if (EAGL_dpy->have_1_3) {
        EAGL_surf->glx_drawable = EAGL_drv->eaglCreatePixmap(EAGL_dpy->dpy,
                                                          EAGL_dpy->fbconfigs[EAGL_egl_config_index(conf)],
                                                          EAGL_surf->drawable, NULL);
    }
    else if (EAGL_dpy->have_fbconfig) {
        EAGLFBConfig fbconfig = EAGL_dpy->fbconfigs[EAGL_egl_config_index(conf)];
        UIScreen *vinfo;
        
        vinfo = EAGL_drv->eaglGetVisualFromFBConfig(EAGL_dpy->dpy, fbconfig);
        if (vinfo) {
            EAGL_surf->glx_drawable = EAGL_drv->eaglCreateEAGLPixmap(EAGL_dpy->dpy,
                                                                 vinfo, EAGL_surf->drawable);
            free(vinfo);
        }
    }
    else {
        EAGL_surf->glx_drawable = EAGL_drv->eaglCreateEAGLPixmap(EAGL_dpy->dpy,
                                                             &EAGL_dpy->visuals[EAGL_egl_config_index(conf)],
                                                             EAGL_surf->drawable);
    }
    
    if (!EAGL_surf->glx_drawable) {
        free(EAGL_surf);
        return NULL;
    }
    
    EAGL_surf->destroy = (EAGL_dpy->have_1_3) ?
    EAGL_drv->eaglDestroyPixmap : EAGL_drv->eaglDestroyEAGLPixmap;
    
    get_drawable_size(EAGL_dpy->dpy, pixmap, &width, &height);
    EAGL_surf->Base.Width = width;
    EAGL_surf->Base.Height = height;
    
    return &EAGL_surf->Base;
}

static _EGLSurface *
EAGL_eglCreatePbufferSurface(_EGLDriver *drv, _EGLDisplay *disp,
                            _EGLConfig *conf, const EGLint *attrib_list)
{
    struct EAGL_egl_driver *EAGL_drv = EAGL_egl_driver(drv);
    struct EAGL_egl_display *EAGL_dpy = EAGL_egl_display(disp);
    struct EAGL_egl_surface *EAGL_surf;
    int attribs[5];
    int i;
    
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
    
    i = 0;
    attribs[i] = None;
    
    EAGL_surf->drawable = None;
    
    if (EAGL_dpy->have_1_3) {
        /* put geometry in attribs */
        if (EAGL_surf->Base.Width) {
            attribs[i++] = EAGL_PBUFFER_WIDTH;
            attribs[i++] = EAGL_surf->Base.Width;
        }
        if (EAGL_surf->Base.Height) {
            attribs[i++] = EAGL_PBUFFER_HEIGHT;
            attribs[i++] = EAGL_surf->Base.Height;
        }
        attribs[i] = None;
        
        EAGL_surf->glx_drawable = EAGL_drv->eaglCreatePbuffer(EAGL_dpy->dpy,
                                                           EAGL_dpy->fbconfigs[EAGL_egl_config_index(conf)], attribs);
    }
    else if (EAGL_dpy->have_pbuffer) {
        EAGL_surf->glx_drawable = EAGL_drv->eaglCreateEAGLPbufferSGIX(EAGL_dpy->dpy,
                                                                  EAGL_dpy->fbconfigs[EAGL_egl_config_index(conf)],
                                                                  EAGL_surf->Base.Width,
                                                                  EAGL_surf->Base.Height,
                                                                  attribs);
    }
    
    if (!EAGL_surf->glx_drawable) {
        free(EAGL_surf);
        return NULL;
    }
    
    EAGL_surf->destroy = (EAGL_dpy->have_1_3) ?
    EAGL_drv->eaglDestroyPbuffer : EAGL_drv->eaglDestroyEAGLPbufferSGIX;
    
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


static EGLBoolean
EAGL_eglSwapBuffers(_EGLDriver *drv, _EGLDisplay *disp, _EGLSurface *draw)
{
    struct EAGL_egl_driver *EAGL_drv = EAGL_egl_driver(drv);
    struct EAGL_egl_display *EAGL_dpy = EAGL_egl_display(disp);
    struct EAGL_egl_surface *EAGL_surf = EAGL_egl_surface(draw);
    
    EAGL_drv->eaglSwapBuffers(EAGL_dpy->dpy, EAGL_surf->glx_drawable);
    
    return EGL_TRUE;
}

/*
 * Called from eglGetProcAddress() via drv->API.GetProcAddress().
 */
static _EGLProc
EAGL_eglGetProcAddress(_EGLDriver *drv, const char *procname)
{
    struct EAGL_egl_driver *EAGL_drv = EAGL_egl_driver(drv);
    
    return (_EGLProc) EAGL_drv->eaglGetProcAddress((const GLubyte *) procname);
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
    EAGL_drv->eaglWaitX();
    return EGL_TRUE;
}

static void
EAGL_Unload(_EGLDriver *drv)
{
    struct EAGL_egl_driver *EAGL_drv = EAGL_egl_driver(drv);
    
    if (EAGL_drv->handle)
        dlclose(EAGL_drv->handle);
    free(EAGL_drv);
}


static EGLBoolean
EAGL_Load(_EGLDriver *drv)
{
    struct EAGL_egl_driver *EAGL_drv = EAGL_egl_driver(drv);
    void *handle = NULL;

    EAGL_drv->eaglGetProcAddress = eaglGetProcAddress;
    if (!EAGL_drv->eaglGetProcAddress)
            goto fail;
    }

#define GET_PROC(proc_type, proc_name, check)                                   \
    do {                                                                        \
        EAGL_drv->proc_name = (proc_type)                                       \
        EAGL_drv->eaglGetProcAddress((const GLubyte *) #proc_name);              \
        if (check && !EAGL_drv->proc_name) goto fail;                           \
    } while (0)
    
    /* EAGL 1.0 */
    GET_PROC(EAGLCREATECONTEXTPROC, eaglCreateContext, EGL_TRUE);
    GET_PROC(EAGLDESTROYCONTEXTPROC, eaglDestroyContext, EGL_TRUE);
    GET_PROC(EAGLMAKECURRENTPROC, eaglMakeCurrent, EGL_TRUE);
    GET_PROC(EAGLSWAPBUFFERSPROC, eaglSwapBuffers, EGL_TRUE);
    GET_PROC(EAGLCREATEEAGLPIXMAPPROC, eaglCreateEAGLPixmap, EGL_TRUE);
    GET_PROC(EAGLDESTROYEAGLPIXMAPPROC, eaglDestroyEAGLPixmap, EGL_TRUE);
    GET_PROC(EAGLQUERYVERSIONPROC, eaglQueryVersion, EGL_TRUE);
    GET_PROC(EAGLGETCONFIGPROC, eaglGetConfig, EGL_TRUE);
    GET_PROC(EAGLWAITGLPROC, eaglWaitGL, EGL_TRUE);
    GET_PROC(EAGLWAITXPROC, eaglWaitX, EGL_TRUE);
    
    /* EAGL 1.1 */
    GET_PROC(EAGLQUERYEXTENSIONSSTRINGPROC, eaglQueryExtensionsString, EGL_TRUE);
    GET_PROC(EAGLQUERYSERVERSTRINGPROC, eaglQueryServerString, EGL_TRUE);
    GET_PROC(EAGLGETCLIENTSTRINGPROC, eaglGetClientString, EGL_TRUE);
    
    /* EAGL 1.3 */
    GET_PROC(PFNEAGLGETFBCONFIGSPROC, eaglGetFBConfigs, EGL_FALSE);
    GET_PROC(PFNEAGLGETFBCONFIGATTRIBPROC, eaglGetFBConfigAttrib, EGL_FALSE);
    GET_PROC(PFNEAGLGETVISUALFROMFBCONFIGPROC, eaglGetVisualFromFBConfig, EGL_FALSE);
    GET_PROC(PFNEAGLCREATEWINDOWPROC, eaglCreateWindow, EGL_FALSE);
    GET_PROC(PFNEAGLDESTROYWINDOWPROC, eaglDestroyWindow, EGL_FALSE);
    GET_PROC(PFNEAGLCREATEPIXMAPPROC, eaglCreatePixmap, EGL_FALSE);
    GET_PROC(PFNEAGLDESTROYPIXMAPPROC, eaglDestroyPixmap, EGL_FALSE);
    GET_PROC(PFNEAGLCREATEPBUFFERPROC, eaglCreatePbuffer, EGL_FALSE);
    GET_PROC(PFNEAGLDESTROYPBUFFERPROC, eaglDestroyPbuffer, EGL_FALSE);
    GET_PROC(PFNEAGLCREATENEWCONTEXTPROC, eaglCreateNewContext, EGL_FALSE);
    GET_PROC(PFNEAGLMAKECONTEXTCURRENTPROC, eaglMakeContextCurrent, EGL_FALSE);
    
    /* EAGL_SGIX_pbuffer */
    GET_PROC(PFNEAGLCREATEEAGLPBUFFERSGIXPROC,
             eaglCreateEAGLPbufferSGIX, EGL_FALSE);
    GET_PROC(PFNEAGLDESTROYEAGLPBUFFERSGIXPROC,
             eaglDestroyEAGLPbufferSGIX, EGL_FALSE);
#undef GET_PROC
    
    EAGL_drv->handle = handle;
    
    return EGL_TRUE;
    
fail:
    if (handle)
        dlclose(handle);
    return EGL_FALSE;
}


#define _EGL_VERSION_MAJOR 1
#define _EGL_VERSION_MINOR 4

//
///**
// * Casts a member of a structure out to the containing structure
// * \param cType     the type of containing structure holding the member.
// *                  eg: Assuming struct MyType
// *                      {
// *                          int myMember0,
// *                          short myMember1
// *                      };
// struct MyType p* = ...
// *                      then pass MyType as parameter
// * \param mPtr      Pointer to the member mName
// *                  eg: Pass &p.myMember1
// * \param mName     the name of the member within the struct.
// *                  eg: Pass myMember1
// * \param mType     the type of the container struct this is embedded in.
// *                  eg: Pass short as parameter
// *
// *  Rationale: Linux kernel has a better macro "container_of(...) BUT it relies
// *  on:
// *  - typeof keyword not defined in C89/C99 (GNU/Clang compilers implements it as
// *  GNU typeof extension).
// *  - GNU statement expression. (GNU/Clang compilers implements it as
// *  GNU statement expression extension.)
// *
// *  This code aims to be cross platform and cross compiler. Hence no compiler
// *  extension is used at the cost of providing the exact member type"
// */
//#define container_of(cType, mPtr, mName, mType) (                              \
//(cType *)( (char *)((const mType *)(mPtr))-offsetof(cType, mName) ))  /** NOLINT(*) */
//
///**
// * Gets the struct for this entry
// * \param   cType  the type of the container the member is embbeded in.
// * \param   mPtr   the address of member within structure.
// * \param   mName  the name of the member within the struct.
// * \param   mType  the type of the member within structure
// */
//#define list_entry(cType, mPtr, mName, mType)                                  \
//container_of(cType, mPtr, mName, mType)
//
///**
// * For loop as long as condition is met
// * \param c         Pointer to container holding the mName.
// * \param cType     Type of the container
// * \param mName     Name of the member holding a list node.
// * \param mType     Type of the member holding a list node.
// * \param mPtrHead  Pointer to the head of the list.
// * \param cnd       Condition to continue the loop
// */
//#define list_for_until_condition(c, cType, mPtrHead, mName, mType, cnd)        \
//for (c = list_entry(cType, (mPtrHead)->next, mName, mType);                \
//(&c->mName != (mPtrHead)) && (cnd);                                       \
//c = list_entry(cType, c->mName.next, mName, mType))
//
//
///**
// *  Inits a list
// *  \param head List head to init
// *  \param size List size
// */
//void list_init_head(struct dlinkedlist_node* head, int_least32_t* size);
//
///**
// * Find a list's tail
// * \param head List head
// * \return List's tail
// */
//struct dlinkedlist_node* list_find_tail(struct _egl_list* head);
//
///**
// * Adds a node newnode after node
// *
// * \param node Node to append to
// * \param newnode Node to append
// */
//void list_add_after(struct _egl_list* list,
//                    struct dlinkedlist_node* newnode,
//                    struct dlinkedlist_node* node);
//
///**
// * Duplicates a list
// *
// * \param head List head
// * \param list_size Current list size
// */
//void list_duplicate(struct dlinkedlist_node* head, uint32_t list_size);
//
//void list_init_head(struct dlinkedlist_node* head, int_least32_t* size) {
//    dlinkedlist_init_head(head, size);
//}
//
//struct dlinkedlist_node* list_find_tail(struct _egl_list* list) {
//    return list->head.prev;
//}
//
//void list_add_after(struct _egl_list* list,
//                    struct dlinkedlist_node* newnode,
//                    struct dlinkedlist_node* node) {
//    dlinkedlist_add_after(node, newnode, &(list->size));
//}
//
//
//
//void* freeNodeEGLPlafromConfig(struct dlinkedlist_node* n) {
//    _EGLPlatformConfig* c = list_entry(_EGLPlatformConfig,
//                                       n,
//                                       list_node,
//                                       struct dlinkedlist_node);
//    FREE(c)
//    return NULL;
//}
//
///**
// * Convert EGLConfig into platform specific config
// *
// * \param c An EGL config
// * \param pc A platform specific config
// *
// * \return EGL_TRUE if successful convertion.
// */
////EGLBoolean to_EGLPlatformConfig(_EGLConfig* c, _EGLPlatformConfig* pc) {
////    if (c->colorbuffer_redSize >= 8
////        || c->colorbuffer_greenSize >= 8
////        || c->colorbuffer_blueSize >= 8) {
////        pc->colorbuffer_format = kEAGLColorFormatRGBA8;
////    } else {
////        pc->colorbuffer_format = kEAGLColorFormatRGB565;
////    }
////
////    if (c->renderableType == EGL_OPENGL_ES_BIT) {
////        pc->depth_component = 0;
////        if (c->depthbuffer_size == 16) {
////            // Defined in OpenGL ES extension "OES_framebuffer_object"
////            // Available on PowerVR SGX (iPhone 3GX and onwards)
////            pc->depth_component = GL_DEPTH_COMPONENT16_OES;
////        }
////    } else if (c->renderableType == EGL_OPENGL_ES2_BIT) {
////        pc->depth_component = 0;
////        if (c->depthbuffer_size == 16) {
////            // Defined in OpenGL ES 2.x
////            // Available on PowerVR SGX (iPhone 3GX and onwards)
////            pc->depth_component = GL_DEPTH_COMPONENT16;
////        }
////    }
////
////    pc->drawable_retained_backing_after_display = NO;
////
////    // EGL 1.3
////    switch (c->renderableType) {
////        case EGL_OPENGL_ES_BIT:
////            pc->api_version = kEAGLRenderingAPIOpenGLES1; // since iOS 2 TODO: Guard it + do in reverse function
////            break;
////        case EGL_OPENGL_ES2_BIT:
////            pc->api_version = kEAGLRenderingAPIOpenGLES2; // since iOS 3 TODO: Guard it + do in reverse function
////            break;
////        default:
////            pc->api_version = kEAGLRenderingAPIOpenGLES1;
////            break;
////    }
////    return true;
////}
//
///**
// * Convert platform specific config into _EGLConfig
// *
// * @param pc Platform specific config
// * @param c EGLConfig
// *
// * @return EGL_TRUE if successful convertion
// */
////EGLBoolean to_EGLConfig(_EGLPlatformConfig* pc, _EGLConfig* c) {
////   if (pc->colorbuffer_format == kEAGLColorFormatRGBA8) {
////        c->colorbuffer_redSize      = 8;
////        c->colorbuffer_greenSize    = 8;
////        c->colorbuffer_blueSize     = 8;
////        c->colorbuffer_alphaSize    = 8;
////   } else {
////        c->colorbuffer_redSize      = 5;
////        c->colorbuffer_greenSize    = 6;
////        c->colorbuffer_blueSize     = 5;
////        c->colorbuffer_alphaSize    = 0;
////   }
////
////    if (pc->api_version == kEAGLRenderingAPIOpenGLES1) {
////        c->depthbuffer_size = 0;
////        if (pc->depth_component == GL_DEPTH_COMPONENT16_OES) {
////            c->depthbuffer_size = 16;
////        }
////    }
////    else if (pc->api_version == kEAGLRenderingAPIOpenGLES2) {
////        c->depthbuffer_size = 0;
////        if (pc->depth_component == GL_DEPTH_COMPONENT16) {
////            c->depthbuffer_size = 16;
////        }
////    }
////
////    // pc->drawable_retained_backing_after_display has no matching in EGLConfig
////    // EGL 1.3
////    switch (pc->api_version) {
////        case kEAGLRenderingAPIOpenGLES1:
////            c->renderableType = EGL_OPENGL_ES_BIT;
////            break;
////        case kEAGLRenderingAPIOpenGLES2:
////            c->renderableType = EGL_OPENGL_ES2_BIT;
////            break;
////        default:
////            c->renderableType = -1;
////            break;
////    }
////
////    c->platformConfig = (void *) pc;
////    return true;
////}
//
////
////  EGL 1.0
////
////_EGLDisplay* GetDisplay (_EGLDriver* drv, const char* display_id) {
////    _EGLDisplay* d = MALLOC(_EGLDisplay)
////    if (EGL_DEFAULT_DISPLAY == display_id) {
////
////   }
////   return d;
////}
//
////EGLBoolean Initialize (_EGLDriver* drv, _EGLDisplay *dpy) {
//////    if (EGL_DEFAULT_DISPLAY == dpy->) {
//////        dpy->impl = (EGLDisplay*) [[UIApplication sharedApplication] keyWindow];
//////        dpy->eglAPIVersion.major = _EGL_VERSION_MAJOR;
//////        dpy->eglAPIVersion.minor = _EGL_VERSION_MINOR;
//////        dpy->eglAPIClients = "OpenGL_ES\0";
//////        return EGL_TRUE;
//////   }
////   return EGL_FALSE;
////}
//
//EGLBoolean Terminate (_EGLDriver* drv, _EGLDisplay *dpy) {
//    // TODO
//    return EGL_FALSE;
//}
//
//const char** QueryString (_EGLDriver *drv, _EGLDisplay *dpy, EGLint name, EGLint* num_r) {
//    char* v2;
//    switch (name) {
//        case EGL_CLIENT_APIS:
//        case EGL_VERSION:
//        case EGL_VENDOR: {
//            char** v = CALLOC_ARRAY(char*, 1)
//            v2 = CALLOC_ARRAY(char, 1)
//            *v2 = '\0';
//            *num_r = 0;
//            v = &v2;
//            return (const char**)v;
//        }
//        case EGL_EXTENSIONS: {
//            char** v = CALLOC_ARRAY(char*, 1)
//            v2 = CALLOC_ARRAY(char, 1)
//            *v2 = '\0';
//            *num_r = 0;
//            v = &v2;
//            return (const char**)v;
//        }
//        default: {
//            char** v = NULL;
//            return (const char**)v;
//        }
//    }
//}
//
///**
// * Duplicates a config and add it to a list if a condition is satisfy
// *
// * @param cnd   Condition to satisfy
// * @param c     Pointer to a config of type T
// * @param cT    Config of type T
// * @param lt    Pointer to list Tail to add c to
// * @param ls    List size to increment upon
// */
//#define DUPLICATE_CONFIG_AND_ADD_TO_LIST_ON_CONDITION(cnd, c, cT, lt, ls)   \
//    if (cnd) {                                                          \
//        c = MALLOC(cT);                                                 \
//        *c = *lt;                                                       \
//        list_add(c, lt);                                                \
//        lt = c;                                                         \
//        ls++;                                                           \
//    }
//
///**
// * Duplicates a list
// * \param l         List to duplicate (of type _egl_list)
// * \param l1        List to duplicate to (of type _egl_list)
// *                  (will be initialized to empty list)
// * \param eType     Type of containing structure holding the member.
// * \param mName     Name of the member in the structure
// * \param mType     Type of the member in the structure
// */
//#define DUPLICATE_LIST(l, l1, eType, mName, mType)                             \
//    {                                                                          \
//        list_init_head(&l1.head, &l1.size);                                    \
//        mType* m = NULL;                                                       \
//        /**mType* p = &l1.head;                                               */\
//        dlinkedlist_for_each(&l.head, m) {                                     \
//            eType* e = list_entry(eType, m, mName, mType);                     \
//            eType* ne = MALLOC(eType)                                          \
//            *ne = *e;                                                          \
//            list_init_head(&ne->mName, NULL);                                   \
//            list_add_after(&l1, &ne->mName, list_find_tail(&l1));              \
//        }                                                                      \
//    }
//
//
//EGLBoolean GetConfigs ( _EGLDriver *drv,
//                        _EGLDisplay *dpy,
//                        _EGLConfig *configs,
//                        EGLint config_size,
//                        EGLint *num_config) {
//    // Defined in OpenGLES/EAGL.h
//    int renderingAPICount = 2;
//    int api_versions[renderingAPICount];
//    api_versions[0] = kEAGLRenderingAPIOpenGLES1;
//    api_versions[1] = kEAGLRenderingAPIOpenGLES2;
//
//    // Defined in OpenGLES/EAGLDrawable.h
//    int colorFormatCount = 2;
//    NSString* colorformats[colorFormatCount];
//    colorformats[0] = kEAGLColorFormatRGBA8;
//    colorformats[1] = kEAGLColorFormatRGB565;
//
//    // Defined in OpenGLES/EAGLDrawable.h
//    int retainBackingCount = 1;
//    int retainbackings[retainBackingCount];
//    retainbackings[0] = NO;
//
//    struct _egl_list cfgList;
//    struct _egl_list cfgList2;
//    list_init_head(&cfgList.head, &cfgList.size);
//    list_init_head(&cfgList2.head, &cfgList2.size);
//    _EGLPlatformConfig* cf = MALLOC(_EGLPlatformConfig);
//    struct dlinkedlist_node* n = NULL;
//    for (int a=0;a<renderingAPICount;a++) {
//        if (cfgList.size != 0) {
//            DUPLICATE_LIST(cfgList,
//                           cfgList2,
//                           _EGLPlatformConfig,
//                           list_node,
//                           struct dlinkedlist_node)
//        }
//        else {
//            list_add_after(&cfgList, &cf->list_node, list_find_tail(&cfgList));
//        }
//
//        dlinkedlist_for_each(((a == 0) ? &(cfgList.head) : &(cfgList2.head)), n) {
//            cf = list_entry(_EGLPlatformConfig,
//                            n,
//                            list_node,
//                            struct dlinkedlist_node);
//            cf->api_version = api_versions[a];
//        }
//
//        dlinkedlist_splice(&cfgList2.head,
//                           &cfgList.head,
//                           &cfgList2.size,
//                           &cfgList.size);
//
//        for (int b=0;b<colorFormatCount;b++) {
//            if (b != 0) {
//                DUPLICATE_LIST(cfgList,
//                               cfgList2,
//                               _EGLPlatformConfig,
//                               list_node,
//                               struct dlinkedlist_node)
//            }
//
//            dlinkedlist_for_each(((b == 0) ? &(cfgList.head) : &(cfgList2.head)), n) {
//                cf = list_entry(_EGLPlatformConfig,
//                                n,
//                                list_node,
//                                struct dlinkedlist_node);
//                cf->colorbuffer_format = colorformats[b];
//            }
//
//            dlinkedlist_splice(&cfgList2.head,
//                               &cfgList.head,
//                               &cfgList2.size,
//                               &cfgList.size);
//
//            bool done = false;
//            for (int c=0;!done;c++) {
//                int* depths;
//                int depthsCount = 0;
//                switch (api_versions[a]) {
//                    case kEAGLRenderingAPIOpenGLES1:
//                    {
//                        depthsCount = 1;
//                        int depthsArr[depthsCount];
//                        depthsArr[0] = GL_DEPTH_COMPONENT16;
//                        depths = &depthsArr[0];
//                        done = true;
//                        break;
//                    }
//                    case kEAGLRenderingAPIOpenGLES2:
//                    {
//                        depthsCount = 1;
//                        int depthsArr[depthsCount];
//                        depthsArr[0] = GL_DEPTH_COMPONENT16;
//                        depths = &depthsArr[0];
//                        done = true;
//                        break;
//                    }
//                    default: {break;}
//                }
//
//                if (c != 0) {
//                    DUPLICATE_LIST(cfgList,
//                                   cfgList2,
//                                   _EGLPlatformConfig,
//                                   list_node,
//                                   struct dlinkedlist_node)
//                }
//
//                dlinkedlist_for_each(((c == 0) ? &(cfgList.head) : &(cfgList2.head)), n) {
//                    cf = list_entry(_EGLPlatformConfig,
//                                    n,
//                                    list_node,
//                                    struct dlinkedlist_node);
//                    cf->depth_component = depths[c];
//                }
//
//                dlinkedlist_splice(&cfgList2.head,
//                                   &cfgList.head,
//                                   &cfgList2.size,
//                                   &cfgList.size);
//
//
//                for (int d=0;d<retainBackingCount;d++) {
//                    if (d != 0) {
//                        DUPLICATE_LIST(cfgList,
//                                       cfgList2,
//                                       _EGLPlatformConfig,
//                                       list_node,
//                                       struct dlinkedlist_node)
//                    }
//
//                    dlinkedlist_for_each(((d == 0) ? &(cfgList.head) : &(cfgList2.head)), n) {
//                        cf = list_entry(_EGLPlatformConfig,
//                                        n,
//                                        list_node,
//                                        struct dlinkedlist_node);
//                        cf->drawable_retained_backing_after_display = retainbackings[d];
//                    }
//
//                    dlinkedlist_splice(&cfgList2.head,
//                                       &cfgList.head,
//                                       &cfgList2.size,
//                                       &cfgList.size);
//                }
//            }
//        }
//    }
//
//    *num_config = cfgList.size;
//    if (configs != NULL) {
//        *num_config = config_size > *num_config ? *num_config : config_size;
//        int i = 0;
//        _EGLPlatformConfig* c = NULL;
//        list_for_until_condition(c, _EGLPlatformConfig, &cfgList.head, list_node, struct dlinkedlist_node, (i < *num_config)) {
//            c = list_entry(_EGLPlatformConfig,
//                           &c->list_node,
//                           list_node,
//                           struct dlinkedlist_node);
//            __egl_EGLConfigCreateWithDefaultValue(&configs[i]);
//            configs[i].configId = i + 1;
//            to_EGLConfig(c,&configs[i]);
//            //list_init_head(&c->list_node, NULL);
//            i++;
//        }
//    }
//    return EGL_TRUE;
//}
//
//_EGLContext *CreateContext (_EGLDriver *drv, _EGLDisplay *dpy, _EGLConfig *config, _EGLContext *share_list, const EGLint *attrib_list) {
////    EGLContextImpl ctx = createOpenGLContext(*attrib_list);
////    return ctx.context;
//    return NULL;
//}
//
//_EGLSurface *CreateWindowSurface (_EGLDriver *drv, _EGLDisplay *dpy, _EGLConfig *config, EGLNativeWindowType window, const EGLint *attrib_list) {
//    return NULL;
//}
//_EGLSurface *CreatePbufferSurface (_EGLDriver *drv, _EGLDisplay *dpy, _EGLConfig *config, const EGLint *attrib_list) {
//    return NULL;
//}
//_EGLSurface *CreatePixmapSurface (_EGLDriver *drv, _EGLDisplay *dpy, _EGLConfig *config, EGLNativePixmapType pixmap, const EGLint *attrib_list) {
//    return NULL;
//}
//EGLBoolean DestroySurface (_EGLDriver *drv, _EGLDisplay *dpy, _EGLSurface *surface) {
//    return EGL_FALSE;
//}
//EGLBoolean QuerySurface (_EGLDriver *drv, _EGLDisplay *dpy, _EGLSurface *surface, EGLint attribute, EGLint *value) {
//return EGL_FALSE;
//}
//EGLBoolean DestroyContext (_EGLDriver *drv, _EGLDisplay *dpy, _EGLContext *ctx) {
//return EGL_FALSE;
//}
//
//EGLBoolean MakeCurrent (_EGLDriver *drv, _EGLDisplay *dpy, _EGLSurface *draw, _EGLSurface *read, _EGLContext *ctx) {
////    [EAGLContext setCurrentContext: ctx];
//    return EGL_FALSE;
//}
//
//_EGLSurface* GetCurrentSurface (_EGLDriver *drv, EGLint readdraw) {
//    return NULL;
//}
//_EGLDisplay GetCurrentDisplay (_EGLDriver *drv, _EGLContext *ctx) {
//    _EGLDisplay d;
//    return d;
//}
//EGLBoolean QueryContext (_EGLDriver *drv, _EGLDisplay *dpy, _EGLContext *ctx, EGLint attribute, EGLint *value) {
//    return EGL_FALSE;
//}
//EGLBoolean WaitGL (_EGLDriver *drv) {
//    return EGL_FALSE;
//}
//EGLBoolean WaitNative (_EGLDriver *drv, _EGLDisplay *dpy, EGLint engine) {
//    return EGL_FALSE;
//}
//EGLBoolean SwapBuffers (_EGLDriver *drv, _EGLDisplay *dpy, _EGLSurface *draw) {
//    return EGL_FALSE;
//}
//EGLBoolean CopyBuffers (_EGLDriver *drv, _EGLDisplay *dpy, _EGLSurface *surface, EGLNativePixmapType target) {
//    return EGL_FALSE;
//}
//_EGLProc GetProcAddress (_EGLDriver *drv, const char *procname) {
//    return NULL;
//}
//
//_EGLDriver * _eglLoadDriverIOS(_EGLAPI* fapi) {
//    _EGLDriver* d = __eglDriverInit(fapi);
//    if (d != NULL) {
////        d->name = "iOS\0";
//        d->API.GetDisplay = GetDisplay;
//        d->API.Initialize = Initialize;
//        d->API.Terminate = Terminate;
//        d->API.QueryString = QueryString;
//        d->API.GetConfigs = GetConfigs;
//        //d->API.GetConfigAttrib = GetConfigAttrib;
//        d->API.CreateWindowSurface = CreateWindowSurface;
//        d->API.CreatePbufferSurface = CreatePbufferSurface;
//        d->API.CreatePixmapSurface = CreatePixmapSurface;
//        d->API.DestroySurface = DestroySurface;
//        d->API.QuerySurface = QuerySurface;
//        d->API.CreateContext = CreateContext;
//        d->API.DestroyContext = DestroyContext;
//        d->API.MakeCurrent = MakeCurrent;
//        //d->API.GetCurrentContext = GetCurrentContext;
//        ////d->API.GetCurrentSurface = GetCurrentSurface;
//        ////d->API.GetCurrentDisplay =  GetCurrentDisplay;
//        d->API.QueryContext = QueryContext;
//        d->API.WaitNative = WaitNative;
//        d->API.WaitNative = WaitNative;
//        d->API.SwapBuffers = SwapBuffers;
//        d->API.CopyBuffers = CopyBuffers;
//        d->API.GetProcAddress = GetProcAddress;
//    }
//    return d;
//}
//
//EGLint _eglUnloadDriverIOS(_EGLDriver* drv) {
//    __eglDriverDestroy(drv);
//    return EGL_TRUE;
//}
//

//
////void egl_setEGLDisplay(UIWindow* displays, EGLint num_displays) {
////    if (displays == NULL || num_displays < 1) {return;}
////    FREE(_displays);
////    _displays = CALLOC_ARRAY(_EGLDisplay, num_displays);
////    _num_displays = num_displays;
////    for (int i=0; i<num_displays; i++) {
////        _displays[i].display = displays[i];
////        _displays[i].surface_impl = NULL;
////    }
////}
//
/////**
//// * Creates OpenGL ES context
//// * \param v OpenGL ES version
//// * \param An OpenGL Context or NULL.
//// */
////_EGLContextImpl __egl_createOpenGLESContext(OpenGLESVersion v) {
////    _EGLContextImpl c;
////    switch (v) {
////        case OPENGL_ES_1_X:
////            c.ctx_impl = [[EAGLContext alloc]
////                         initWithAPI: kEAGLRenderingAPIOpenGLES1];
////            break;
////        case OPENGL_ES_2_X:
////            c.ctx_impl = [[EAGLContext alloc]
////                         initWithAPI: kEAGLRenderingAPIOpenGLES2];
////            break;
////        default:
////            c.ctx_impl = NULL;
////    }
////    return c;
////}
////
/////**
//// * Destroys OpenGL ES context
//// * \param ctx OpenGL ES context
//// */
////void __egl_destroyOpenGLESContext(_EGLContextImpl* ctx) {
////
////}
////
/////**
//// * Gathers OpenGL Pixel formats for OpenGL ES Core or Open GL ES Extension
//// * \param pixelformat Array of pixel formats
//// * \param num_pixelformat Number of pixel formats in array
//// * \param openGLESExt Look for Pixel Format in OpenGL ES Extension name OR NULL for OpenGL ES Core.
//// * \param sType Look for Pixel Format for surface type.
//// */
////void __egl_gatherOpenGLPixelFormat(   EGLint* pixelformat,
////                                EGLint* num_pixelformat,
////                                const char* openGLESExt,
////                                _SurfaceType sType) {
////    switch (sType) {
////        case SURFACE_TYPE_WINDOW:
////            if (openGLESExt == NULL) {
////                *num_pixelformat = 2;
////                EGLint* a = CALLOC_ARRAY(EGLint, *num_pixelformat)
////                a[0] = GL_RGBA8_OES;
////                a[1] = GL_RGB565;
////                pixelformat = a;
////            }
////            else {
////                *num_pixelformat = 0;
////            }
////            break;
////        case SURFACE_TYPE_PBUFFER:
////            if (openGLESExt == NULL) {
////                *num_pixelformat = 3;
////                EGLint* a = CALLOC_ARRAY(EGLint, *num_pixelformat)
////                a[0] = GL_RGBA4;
////                a[1] = GL_RGB5_A1;
////                a[2] = GL_RGB565;
////                pixelformat = a;
////            }
////            else {
////                *num_pixelformat = 0;
////            }
////            break;
////        case SURFACE_TYPE_PIXMAP:
////            if (openGLESExt == NULL) {
////                *num_pixelformat = 0;
////            }
////            else {
////                *num_pixelformat = 0;
////            }
////            break;
////        default:
////            *num_pixelformat = 0;
////            break;
////    }
////}
////
/////**
//// * Gathers OpenGL Depth Buffer sizes (in bits) in currently binded depth buffer
//// *
//// * \param depths Array of depth
//// * \param num_depths Number of depths in array
//// * \param openGLESExt Look for Pixel Format in OpenGL ES Extension name OR NULL for OpenGL ES Core.
//// * \param sType Look for Pixel Format for surface type.
//// */
////void __egl_gatherOpenGLDepthBufferZ(  EGLint* depths,
////                                EGLint* num_depths,
////                                const char* openGLESExt,
////                                _SurfaceType sType) {
////    switch (sType) {
////        case SURFACE_TYPE_WINDOW:
////            if (openGLESExt == NULL) {
////                *depths = 1;
////                EGLint* a = CALLOC_ARRAY(EGLint, *num_depths)
////                glGetRenderbufferParameteriv(GL_RENDERBUFFER,
////                                             GL_RENDERBUFFER_DEPTH_SIZE,
////                                             &a[0]);
////                depths = a;
////            }
////            else {
////                *num_depths = 0;
////            }
////            break;
////        case SURFACE_TYPE_PBUFFER:
////                *num_depths = 0;
////            break;
////        case SURFACE_TYPE_PIXMAP:
////                *num_depths = 0;
////            break;
////        default:
////            *num_depths = 0;
////            break;
////    }
////}
////
/////**
//// * Gathers PBBuffer dimensions OpenGL ES
//// *
//// * \param dimensions Array of dimensions. [0] width, [1] heigth
//// * \param num_dimensions Number of dimensions in array
//// * \param openGLESExt Look for Pixel Format in OpenGL ES Extension name OR NULL for OpenGL ES Core.
//// * \param sType Look for Pixel Format for surface type.
//// */
////void __egl_gatherOpenGLPBBufferDimensions(  EGLint* dimensions,
////                                      EGLint* num_dimensions,
////                                      const char* openGLESExt,
////                                      _SurfaceType sType) {
////    switch (sType) {
////        case SURFACE_TYPE_WINDOW:
////            *num_dimensions = 0;
////            break;
////        case SURFACE_TYPE_PBUFFER:
////            *num_dimensions = 0;
////            break;
////        case SURFACE_TYPE_PIXMAP:
////            *num_dimensions = 0;
////            break;
////        default:
////            *num_dimensions = 0;
////            break;
////    }
////}
////
/////**
//// * Gathers PBBuffer Size OpenGL ES
//// *
//// * \param sizes Array of dimensions. [0] width, [1] heigth
//// * \param num_sizes Number of dimensions in array
//// * \param openGLESExt Look for Pixel Format in OpenGL ES Extension name OR NULL for OpenGL ES Core.
//// * \param sType Look for Pixel Format for surface type.
//// */
////void __egl_gatherOpenGLPBBufferSize(  EGLint* sizes,
////                                EGLint* num_sizes,
////                                const char* openGLESExt,
////                                _SurfaceType sType) {
////    switch (sType) {
////        case SURFACE_TYPE_WINDOW:
////            *num_sizes = 1;
////            sizes[0] = 0;
////            break;
////        case SURFACE_TYPE_PBUFFER:
////            *num_sizes = 0;
////            break;
////        case SURFACE_TYPE_PIXMAP:
////            *num_sizes = 0;
////            break;
////        default:
////            *num_sizes = 0;
////            break;
////    }
////}
////
/////**
//// * Gathers OpenGL ES Sample buffer
//// *
//// * \param sizes Array of dimensions. [0] width, [1] heigth
//// * \param num_sizes Number of dimensions in array
//// * \param openGLESExt Look for Pixel Format in OpenGL ES Extension name OR NULL for OpenGL ES Core.
//// * \param sType Look for Pixel Format for surface type.
//// */
////void __egl_gatherOpenGLSampleBuffers(   EGLint* sizes,
////                                  EGLint* num_sizes,
////                                  const char* openGLESExt,
////                                  _SurfaceType sType) {
////    switch (sType) {
////        case SURFACE_TYPE_WINDOW:
////            *num_sizes = 1;
////            sizes[0] = 0;
////            break;
////        case SURFACE_TYPE_PBUFFER:
////            *num_sizes = 0;
////            break;
////        case SURFACE_TYPE_PIXMAP:
////            *num_sizes = 0;
////            break;
////        default:
////            *num_sizes = 0;
////            break;
////    }
////}
////
/////**
//// * Gathers OpenGL ES Samples
//// *
//// * \param sizes Array of dimensions. [0] width, [1] heigth
//// * \param num_sizes Number of dimensions in array
//// * \param openGLESExt Look for Pixel Format in OpenGL ES Extension name OR NULL for OpenGL ES Core.
//// * \param sType Look for Pixel Format for surface type.
//// */
////void __egl_gatherOpenGLSamples(  EGLint* sizes,
////                           EGLint* num_sizes,
////                           const char* openGLESExt,
////                           _SurfaceType sType) {
////    switch (sType) {
////        case SURFACE_TYPE_WINDOW:
////            *num_sizes = 1;
////            sizes[0] = 0;
////            break;
////        case SURFACE_TYPE_PBUFFER:
////            *num_sizes = 0;
////            break;
////        case SURFACE_TYPE_PIXMAP:
////            *num_sizes = 0;
////            break;
////        default:
////            *num_sizes = 0;
////            break;
////    }
////}
////
/////**
//// * Gathers OpenGL ES Samples
//// *
//// * \param sizes Array of dimensions. [0] width, [1] heigth
//// * \param num_sizes Number of dimensions in array
//// * \param openGLESExt Look for Pixel Format in OpenGL ES Extension name OR NULL for OpenGL ES Core.
//// * \param sType Look for Pixel Format for surface type.
//// */
////void __egl_gatherOpenGLStencilBufferSize(  EGLint* sizes,
////                                     EGLint* num_sizes,
////                                     const char* openGLESExt,
////                                     _SurfaceType sType) {
////    switch (sType) {
////        case SURFACE_TYPE_WINDOW:
////            *num_sizes = 1;
////            sizes[0] = 0;
////            break;
////        case SURFACE_TYPE_PBUFFER:
////            *num_sizes = 0;
////            break;
////        case SURFACE_TYPE_PIXMAP:
////            *num_sizes = 0;
////            break;
////        default:
////            *num_sizes = 0;
////            break;
////    }
////}
////
////
////
/////**
//// * Gather Color component bit size from currently binded color buffer
//// * \param sType Surface type
//// * \param sizes [0] Red bits, [1] Green bits, [2] Blue bits, [3] Alpha bits
//// * \param num_sizes Number of sizes gathered.
//// */
////void __egl_gatherColorRenderBufferComponentColorBits(_SurfaceType sType, EGLint* sizes,
////                                               EGLint* num_sizes) {
////    switch (sType) {
////        case SURFACE_TYPE_WINDOW:
////            glGetRenderbufferParameteriv(GL_RENDERBUFFER,
////                                         GL_RENDERBUFFER_RED_SIZE,
////                                         &sizes[0]);
////            glGetRenderbufferParameteriv(GL_RENDERBUFFER,
////                                         GL_RENDERBUFFER_GREEN_SIZE,
////                                         &sizes[1]);
////            glGetRenderbufferParameteriv(GL_RENDERBUFFER,
////                                         GL_RENDERBUFFER_BLUE_SIZE,
////                                         &sizes[2]);
////            glGetRenderbufferParameteriv(GL_RENDERBUFFER,
////                                         GL_RENDERBUFFER_ALPHA_SIZE,
////                                         &sizes[3]);
////            *num_sizes = 4;
////            break;
////        default:
////            break;
////    }
////}
////
/////**
//// * EGL Public API 1.0
//// */
////
////EGLAPI const char * APIENTRY eglQueryString(EGLDisplay dpy, EGLint name) {
////    if (!__egl_isEGLInitializedOnDisplay(dpy)) {
////        __egl_setEGLError(EGL_NOT_INITIALIZED);
////        return NULL;
////    }
////    switch (name) {
////        case EGL_VENDOR:
////            __egl_setEGLError(EGL_SUCCESS);
////            return "libegl-Apple-iOS";
////        case EGL_VERSION:
////            __egl_setEGLError(EGL_SUCCESS);
////            int n=3;
////            int arraySize = n*sizeof(char);
////            char* v = CALLOC_ARRAY(char, n)
////            snprintf(v, arraySize,"%d.%d",EGL_MAJOR,EGL_MINOR);
////            return v;
////        case EGL_EXTENSIONS:
////            __egl_setEGLError(EGL_SUCCESS);
////            return "";
////        default:
////            __egl_setEGLError(EGL_BAD_PARAMETER);
////            return NULL;
////    }
////}
////
////EGLAPI EGLBoolean APIENTRY eglGetConfigs(EGLDisplay dpy, EGLConfig *configs,
////                                         EGLint config_size, EGLint *num_config) {
////    _EGLDisplay d = __egl_findDisplayByEGLDisplay(dpy,_displays,_num_displays);
////    if (d.display.impl == EGL_NO_DISPLAY) {
////        __egl_setEGLError(EGL_BAD_DISPLAY); return EGL_FALSE;
////    }
////    if (!__egl_isEGLInitializedOnDisplay(dpy)) {
////        __egl_setEGLError(EGL_NOT_INITIALIZED); return EGL_FALSE;
////    }
////    if (num_config == NULL) {
////        __egl_setEGLError(EGL_BAD_PARAMETER); return EGL_FALSE;
////    }
////    EGLint num_configs2;
////    _EGLConfig* configs2 = NULL;
////    __egl_gatherEGLConfigs(configs2, &num_configs2);
////    if (configs == NULL) {
////        *num_config = num_configs2;
////        return EGL_TRUE;
////    }
////    *num_config = config_size > num_configs2 ? num_configs2 : config_size;
////    for (EGLint i=0;i<*num_config;i++) {
////        configs[i] = configs2[i].impl;
////    }
////    FREE(configs2)
////    return EGL_TRUE;
////}
////
/////**
//// * Indicates if attribute value is valid for an attribute name
//// * \param c A config
//// * \return EGL_SUCCESS if all values are valid.
//// */
////EGLint checkValidConf(_EGLConfig* c) {
////
////    c->samples
////
////    switch (an) {
////        case EGL_BUFFER_SIZE:
////        case EGL_RED_SIZE:
////        case EGL_GREEN_SIZE:
////        case EGL_BLUE_SIZE:
////        case EGL_ALPHA_SIZE:
////        case EGL_CONFIG_ID:
////        case EGL_DEPTH_SIZE:
////        case EGL_LEVEL:
////        case EGL_NATIVE_RENDERABLE:
////        case EGL_NATIVE_VISUAL_TYPE:
////        case EGL_SAMPLE_BUFFERS:
////        case EGL_SAMPLES:
////        case EGL_STENCIL_SIZE:
////            if (av < EGL_DONT_CARE) {
////                __egl_setEGLError(EGL_BAD_PARAMETER);
////                return EGL_FALSE;
////            }
////            return EGL_TRUE;
////            break;
////        case EGL_CONFIG_CAVEAT:
////            if (av == EGL_NONE
////                || av == EGL_SLOW_CONFIG
////                || av == EGL_NON_CONFORMANT_CONFIG) {
////                return EGL_TRUE;
////            }
////            return EGL_FALSE;
////            break;
////        case EGL_SURFACE_TYPE:
////            if (av == EGL_WINDOW_BIT
////                || av == EGL_PIXMAP_BIT
////                || av == EGL_PBUFFER_BIT) {
////                return EGL_TRUE;
////            }
////            return EGL_FALSE;
////            break;
////        case EGL_TRANSPARENT_TYPE:
////            ac.transparentType = av;
////            break;
////        default:
////            __egl_setEGLError(EGL_BAD_ATTRIBUTE);
////            return EGL_FALSE;
////            break;
////    }
////
////
////
////    if (av < EGL_DONT_CARE) {
////        __egl_setEGLError(EGL_BAD_PARAMETER);
////        return EGL_FALSE;
////    }
////    return EGL_TRUE;
////}
////
////EGLAPI EGLBoolean APIENTRY eglChooseConfig(EGLDisplay dpy, const EGLint *attrib_list,
////                                           EGLConfig *configs, EGLint config_size,
////                                           EGLint *num_config) {
////    _EGLDisplay d = __egl_findDisplayByEGLDisplay(dpy,_displays,_num_displays);
////    if (d.display.impl == EGL_NO_DISPLAY) {
////        __egl_setEGLError(EGL_BAD_DISPLAY); return EGL_FALSE;
////    }
////    if (!__egl_isEGLInitializedOnDisplay(dpy)) {
////        __egl_setEGLError(EGL_NOT_INITIALIZED); return EGL_FALSE;
////    }
////    if (num_config == NULL) {
////        __egl_setEGLError(EGL_BAD_PARAMETER); return EGL_FALSE;
////    }
////
////    // Set value specified in attrib_list
////    _EGLConfig ac = __egl_createEGLConfigWithDefaultValue();
////    EGLint r;
////    if ((r = __egl_parseAttribList(attrib_list, &ac)) != EGL_SUCCESS) {
////        __egl_setEGLError(r);
////        return EGL_FALSE ;
////    }
////    if ((r = checkValidConf(&ac)) != EGL_SUCCESS ) {
////        __egl_setEGLError(r);
////        return EGL_FALSE ;
////    }
////
////    // Gather config
////    EGLint num_configs2; _EGLConfig* configs2 = NULL;
////    __egl_gatherEGLConfigs(configs2, &num_configs2);
////
////    // Selected EGLConfigs as per attributes
////    _EGLConfig* seconfigs = NULL; EGLint num_seconfigs;
////    __egl_selectEGLConfigs(seconfigs, &num_seconfigs, configs2, num_configs2, ac);
////
////    // Sort EGLConfigs
////    __sortEGLConfigs(seconfigs, &num_seconfigs, ac);
////
////    FREE(seconfigs)
////
////    if (configs_ == NULL) {
////        *num_config = num_configs_;
////        return EGL_TRUE;
////    }
////    *num_config = config_size > num_configs2 ? num_configs2 : config_size;
////    configs = CALLOC_ARRAY(EGLConfig, *num_config)
////    for (EGLint i=0;i<*num_config;i++) {
////        configs[i] = configs2[i].impl;
////    }
////    FREE(configs2)
////    return EGL_TRUE;
////
////
////
////
////
////
////   	EGLint num_matchconfigs = 0;
////   	_EGLConfig* matchconfigs = CALLOC_ARRAY(_EGLConfig,num_matchconfigs)
////
////	*num_config = num_matchconfigs;
////   	configs = matchconfigs;
////
////    // Construct a dictionary with configurations.
////	NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
////                          [NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking,
////                          kEAGLColorFormatRGB565, kEAGLDrawablePropertyColorFormat, nil];
////
////    // Set the properties to CAEALLayer.
////    [eaglLayer setOpaque:YES];
////    [eaglLayer perties:dict];}
////}
//
///**
// // * Gathers EGLConfigs from device
// // * \param configs Poointer to array of Configs gathered (NULL permitted)
// // * \param num_configs Number of config gathered
// // * \return Array of configs.
// // */
////void __egl_gatherEGLConfigs(_EGLConfig* configs, EGLint* num_configs) {
////    // Gather EGLConfigs based only on OpenGL ES Core features.
////    // TODO: Do the same for OpenGL ES Extension features.
////
////    EGLint* num_configs2 = 0;
////    _EGLConfig* configs2 = CALLOC_ARRAY(_EGLConfig, *num_configs2);
////    EGLint nextConfigId = 0;
////
////     // OpenGL ES Framebuffer Object (on iOS) is used for:
////    //  0x01 - OnScreen rendering - windows
////    //  0x02 - Offscreen rendering - pbuffers
////    //  0x03 - Offscreen rendering in buffer - pixmap
////    for (EGLint sType=0; sType<SURFACE_TYPE_COUNT;sType++) {
////        _EGLContextImpl ctx;
////        ctx = __egl_createOpenGLESContext(OPENGL_ES_2_X);
////        EGLint num_sizes = 4;
////        EGLint* sizes = CALLOC_ARRAY(EGLint, num_sizes)
////        EGLint* pfs;
////        EGLint num_pfs;
////
////        GLuint frameBufferObjectId;
////        GLuint colorRenderBufferId;
////        GLuint depthRenderBufferId;
////
////        glGenFramebuffers(1, &frameBufferObjectId);
////
////        switch (sType) {
////            case SURFACE_TYPE_WINDOW:
////                glGenRenderbuffers(1, &colorRenderBufferId);
////                glBindRenderbuffer(GL_RENDERBUFFER, colorRenderBufferId);
////
////                __egl_gatherOpenGLPixelFormat(pfs, &num_pfs, NULL, sType);
////                for (EGLint k=0;k<num_pfs;k++) {
////                    glBindFramebuffer(GL_FRAMEBUFFER, frameBufferObjectId);
////                    GLsizei rbMaxWidth; GLsizei rbMaxHeight;
////                    glGetIntegerv(GL_MAX_RENDERBUFFER_SIZE, &rbMaxWidth);
////                    rbMaxHeight = rbMaxWidth;
////                    glRenderbufferStorage(GL_RENDERBUFFER, pfs[k],
////                                          rbMaxWidth, rbMaxHeight);
////                    glFramebufferRenderbuffer(GL_FRAMEBUFFER,
////                                              GL_COLOR_ATTACHMENT0,
////                                              GL_RENDERBUFFER,
////                                              colorRenderBufferId);
////
////                    __egl_gatherColorRenderBufferComponentColorBits(sType, sizes,
////                                                              &num_sizes);
////                    _EGLConfig cfgImpl;
////                    cfgImpl.redSize = sizes[0]; cfgImpl.greenSize = sizes[1];
////                    cfgImpl.blueSize = sizes[2]; cfgImpl.alphaSize = sizes[3];
////                    cfgImpl.bufferSize = __egl_computeBufferSize(cfgImpl.redSize, cfgImpl.greenSize,
////                                                     cfgImpl.blueSize, cfgImpl.alphaSize);
////
////                    cfgImpl.configCaveat = EGL_NONE;
////                    ++nextConfigId;
////                    cfgImpl.configId = nextConfigId;
////
////                    glGenRenderbuffers(1, &depthRenderBufferId);
////                    glBindRenderbuffer(GL_RENDERBUFFER, depthRenderBufferId);
////                    __egl_gatherOpenGLDepthBufferZ(sizes, &num_sizes, NULL, sType);
////                    cfgImpl.depthSize = sizes[0];
////
////                    __egl_gatherOpenGLFrameBufferLevel(sizes);
////                    cfgImpl.level = sizes[0];
////
////                    __egl_gatherOpenGLPBBufferDimensions(sizes, &num_sizes, NULL, sType);
////                    cfgImpl.maxPBufferWidth = sizes[0];
////                    cfgImpl.maxPBufferHeight = sizes[1];
////                    __egl_gatherOpenGLPBBufferSize(sizes, &num_sizes, NULL, sType);
////                    cfgImpl.maxPBufferPixels = sizes[0];
////
////                    cfgImpl.nativeRenderable = EGL_TRUE;
////                    cfgImpl.nativeVisualID = 0;
////                    cfgImpl.nativeVisualType = EGL_NONE;
////                    __egl_gatherOpenGLSampleBuffers(sizes, &num_sizes, NULL, sType);
////                    __egl_gatherOpenGLSamples(sizes, &num_sizes, NULL, sType);
////                    __egl_gatherOpenGLStencilBufferSize(sizes, &num_sizes, NULL, sType);
////
////                    cfgImpl.surfaceType =     sType == SURFACE_TYPE_WINDOW ? EGL_WINDOW_BIT:
////                                        sType == SURFACE_TYPE_PBUFFER ? EGL_PBUFFER_BIT :
////                                        sType == SURFACE_TYPE_PIXMAP ? EGL_PIXMAP_BIT : 0;
////
////
////                    cfgImpl.transparentType = EGL_TRANSPARENT_RGB;
////                    cfgImpl.transparentRedValue = 0;
////                    cfgImpl.transparentGreenValue = 0;
////                    cfgImpl.transparentBlueValue = 0;
////
////                    ++(*num_configs2);
////                    REALLOC_ARRAY_MEM_MGT(_EGLConfig,
////                                          *num_configs2,
////                                          configs2)
////                    configs2[*num_configs2-1] = cfgImpl;
////                }
////                break;
////            default:
////                break;
////
////                FREE(pfs);
////                FREE(sizes)
////
////                glBindRenderbuffer(GL_RENDERBUFFER, 0);
////                glDeleteRenderbuffers(1, (const GLuint*)colorRenderBufferId);
////                glDeleteRenderbuffers(1, (const GLuint*)depthRenderBufferId);
////                __egl_destroyOpenGLESContext(&ctx);
////        }
////        *num_configs = *num_configs2;
////        configs = configs2;
////    }
////}
////

//
//  Sample0Test.c
//  eglTests
//
//  Created by David Andreoletti on 10/11/13.
//  Copyright (c) 2013 David Andreoletti. All rights reserved.
//

#include "Sample0Test.h"
#include "eglTestUtils.h"

#include <OpenGLES/ES1/gl.h>

void sample0(void* eglDisplay, void* nativeWinSurface) {
    setenv("EGL_PLATFORM", "ios", 1);
    EGLDisplay dpy = eglGetDisplay(eglDisplay);
    logEGLError("eglGetDisplay", eglGetError());
    EGLint major = 0;
    EGLint minor = 0;
    EGLBoolean r = eglInitialize(dpy, &major, &minor);
    logEGLError("eglInitialize", eglGetError());
    char n[64];
    LOG2(I, "Major: \t:", INT_TO_STR(n, major))
    LOG2(I, "Minor: \t:", INT_TO_STR(n, minor))
    if (r == EGL_TRUE) {
        const char* v = eglQueryString(dpy, EGL_VENDOR);
        logEGLError("eglQueryString", eglGetError());
        LOG2(I, "EGL_VENDOR\t:" ,STR_NULL(v))
        //        FREE(v)
        v = eglQueryString(dpy, EGL_CLIENT_APIS);
        logEGLError("eglQueryString", eglGetError());
        LOG2(I, "EGL_CLIENT_APIS\t:", STR_NULL(v))
        v = eglQueryString(dpy, EGL_VERSION);
        logEGLError("eglQueryString", eglGetError());
        LOG2(I, "EGL_VERSION\t:", STR_NULL(v))
        v = eglQueryString(dpy, EGL_EXTENSIONS);
        logEGLError("eglQueryString", eglGetError());
        LOG2(I, "EGL_EXTENSIONS\t:", STR_NULL(v))
        EGLConfig*  configs = NULL;
        EGLint     num_config = 0;
        r = eglGetConfigs(dpy, configs, 0, &num_config);
        logEGLError("eglGetConfigs", eglGetError());
        LOG2(I, "num_config:\t", INT_TO_STR(n, num_config))
        if (r == EGL_TRUE && ((num_config) > 0)) {
            configs = malloc(num_config * sizeof(EGLConfig));
            r = eglGetConfigs(dpy, configs, num_config, &num_config);
            logEGLError("eglGetConfigs", eglGetError());
            if (r == EGL_TRUE) {
                LOG2(I, "num_config:\t", INT_TO_STR(n, num_config))
                
                LOG(I, "")
                for (EGLint i=0;i<num_config;i++) {
                    LOG3(I, "EGLConfgs #" ,INT_TO_STR(n, i) ,":")
                    EGLConfig c = configs[i];
                    EGLint num_attrs = 0;
                    getEGLConfigAttributeForEGLAPIVersion(major,
                                                          minor,
                                                          NULL,
                                                          &num_attrs);
                    EGLint* attrs = (EGLint* ) malloc(num_attrs * sizeof(EGLint));
                    getEGLConfigAttributeForEGLAPIVersion(  major,
                                                          minor,
                                                          attrs,
                                                          &num_attrs);
                    
                    displayEGLConfig(dpy, c, attrs, num_attrs);
                    FREE(attrs)
                    LOG(I, "")
                }
                
                const EGLint* attrib_list;
                EGLint attribs[3] = {EGL_RED_SIZE, 8, EGL_NONE};
                attrib_list = attribs;
                r = eglChooseConfig(dpy,
                                    attrib_list,
                                    configs,
                                    num_config,
                                    &num_config);
                logEGLError("eglChooseConfig", eglGetError());
                if (r == EGL_TRUE) {
                    LOG2(I, "num_config :\t", INT_TO_STR(n, num_config))
                    for (EGLint i=0;i<num_config;i++) {
                        EGLConfig c = configs[i];
                        EGLint num_attrs = 0;
                        getEGLConfigAttributeForEGLAPIVersion(major,
                                                              minor,
                                                              NULL,
                                                              &num_attrs);
                        EGLint* attrs = (EGLint* ) malloc(num_attrs * sizeof(EGLint));
                        getEGLConfigAttributeForEGLAPIVersion(  major,
                                                              minor,
                                                              attrs,
                                                              &num_attrs);
                        
                        LOG3(I, "EGLConfgs #", INT_TO_STR(n,i), ":")
                        displayEGLConfig(dpy, c, attrs, num_attrs);
                        LOG(I, "")
                    }
                    
                }
            }

        }
        FREE(configs)
    }
    r = eglTerminate(dpy);
    logEGLError("eglTerminate", eglGetError());
    if (r == EGL_TRUE) {
        LOG(I, "")
    }
}

void run_sample0(TestPlatform* p) {
    LOG(I, "Executing: " __FILE__)
    setup(p);
    sample0(p->validNativeDisplay, p->validNativeWindow);
    teardown(p);
}
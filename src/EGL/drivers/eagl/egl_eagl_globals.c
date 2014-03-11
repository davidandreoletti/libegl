//
//  \file egl_eagl_globals.c
//  libegl
//
//  Created by Andreoletti David.
//  Copyright 2013 IO Stark. All rights reserved.
//

#include "EGL/drivers/eagl/egl_eagl_globals.h"
#include "eglmutex.h"

static _EGL_DECLARE_MUTEX(_eaglGlobalMutex);
struct EAGL_egl_global _eaglGlobal = {
    &_eaglGlobalMutex,
    true
};

bool isContextLost(struct EAGL_egl_global* global) {
    _eglLockMutex(&_eaglGlobalMutex);
    bool result = global->foregroundApplication;
    _eglUnlockMutex(&_eaglGlobalMutex);
    return result;
}

void setContextLost(struct EAGL_egl_global* global, bool value) {
    _eglLockMutex(&_eaglGlobalMutex);
    global->foregroundApplication = value;
    _eglUnlockMutex(&_eaglGlobalMutex);
}

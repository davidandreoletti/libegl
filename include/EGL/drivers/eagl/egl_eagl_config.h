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

#ifndef INCLUDE_EGL_DRIVERS_EAGL_EGL_EAGL_CONFIG_H_
#define INCLUDE_EGL_DRIVERS_EAGL_EGL_EAGL_CONFIG_H_

#ifdef _EGL_OS_APPLE_IOS

#include "EGL/drivers/eagl/ios/egl_eagl_ios_config.h"
typedef _EAGL_egl_Config_iOS EAGL_egl_config_platform;

#else 

typedef void EAGL_egl_config_platform;

#endif // _EGL_OS_APPLE_IOS

#include "EGL/drivers/eagl/egl_eagl_typedefs.h"
#include "EGL/drivers/eagl/egl_eagl_misc.h"
#include "EGL/eglConfig.h"

/** subclass of _EGLConfig */
struct EAGL_egl_config
{
    _EGLConfig Base;   /**< base class */
    EAGL_egl_config_platform Config;
    int Index;
};

static int
EAGL_egl_config_index(_EGLConfig *conf)
{
    struct EAGL_egl_config *EAGL_conf = EAGL_egl_config(conf);
    return EAGL_conf->Index;
}

#endif  // INCLUDE_EGL_DRIVERS_EAGL_EGL_EAGL_CONFIG_H_

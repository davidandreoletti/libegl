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

#ifndef INCLUDE_EGL_DRIVERS_EAGL_EGL_EAGL_CONTEXT_H_
#define INCLUDE_EGL_DRIVERS_EAGL_EGL_EAGL_CONTEXT_H_

#include "EGL/drivers/eagl/egl_eagl_typedefs.h"
#include "EGL/eglContext.h"

/** subclass of _EGLContext */
struct EAGL_egl_context
{
    _EGLContext Base;   /**< base class */
    __OWNERSHIP_QUALIFIER_WEAK _EAGLContext* context;
    _OpenGLESAPI openGLESAPI;
    EGLBoolean wasCurrent; // EGL_TRUE if this context has been current at least once
    EGLBoolean contextLost;
};

/**
 * Returns context lost status
 */
static EGLBoolean _eaglIsContextLost(struct EAGL_egl_context* context) {
    return context && context->contextLost;
}

/**
 * Sets context lost status
 */
static void _eaglSetContextLost(struct EAGL_egl_context* context, EGLBoolean value) {
    context->contextLost = value;
}

#endif  // INCLUDE_EGL_DRIVERS_EAGL_EGL_EAGL_CONTEXT_H_

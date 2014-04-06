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

#include "EGL/drivers/eagl/opengles/opengles3_ios.h"
#include <stddef.h>
#include <Availability.h>

#ifdef  __IPHONE_7_0

#include <OpenGLES/ES3/gl.h>
#include <OpenGLES/ES3/glext.h>

#endif // __IPHONE_7_0

void opengles3_api_init(__OpenGLESAPI* api) {
    if (api == NULL) {return;}
#ifdef  __IPHONE_7_0
    api->minorVersion = 0;
    api->glGenFrameBuffers = glGenFramebuffers;
    api->glBindFrameBuffers = glBindFramebuffer;
    api->GL_FRAMEBUFFER_ = GL_FRAMEBUFFER;
    api->glGenRenderBuffers = glGenRenderbuffers;
    api->glBindRenderBuffers = glBindRenderbuffer;
    api->GL_RENDERBUFFER_ = GL_RENDERBUFFER;
    api->glDeleteFrameBuffers = glDeleteFramebuffers;
    api->glDeleteRenderBuffers = glDeleteRenderbuffers;
    api->glFramebufferRenderbuffer = glFramebufferRenderbuffer;
    api->GL_COLOR_ATTACHMENT0_ = GL_COLOR_ATTACHMENT0;
    api->GL_DEPTH_ATTACHMENT_ = GL_DEPTH_ATTACHMENT;
    api->glGetRenderbufferParameteriv = glGetRenderbufferParameteriv;
    api->GL_RENDERBUFFER_WIDTH_ = GL_RENDERBUFFER_WIDTH;
    api->GL_RENDERBUFFER_HEIGHT_ = GL_RENDERBUFFER_HEIGHT;
    api->glCheckFramebufferStatus = glCheckFramebufferStatus;
    api->GL_FRAMEBUFFER_COMPLETE_ = GL_FRAMEBUFFER_COMPLETE;
    api->glRenderbufferStorage = glRenderbufferStorage;
    api->GL_DEPTH_COMPONENT16_ = GL_DEPTH_COMPONENT16;
    api->GL_DEPTH_COMPONENT24_ = GL_DEPTH_COMPONENT24;
    api->glViewport = glViewport;
    api->glScissor = glScissor;
    api->glFinish = glFinish;
#endif // __IPHONE_7_0
}

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

#include "EGL/drivers/eagl/opengles/opengles1_ios.h"
#include <stddef.h>
#include <OpenGLES/ES1/gl.h>
#include <OpenGLES/ES1/glext.h>

void opengles1_api_init(__OpenGLESAPI* api) {
    if (api == NULL) {return;}
    api->majorVersion = 1;
    api->minorVersion = 1;
    api->glGenFrameBuffers = glGenFramebuffersOES;
    api->glBindFrameBuffers = glBindFramebufferOES;
    api->GL_FRAMEBUFFER_ = GL_FRAMEBUFFER_OES;
    api->glGenRenderBuffers = glGenRenderbuffersOES;
    api->glBindRenderBuffers = glBindRenderbufferOES;
    api->GL_RENDERBUFFER_ = GL_RENDERBUFFER_OES;
    api->glDeleteFrameBuffers = glDeleteFramebuffersOES;
    api->glDeleteRenderBuffers = glDeleteRenderbuffersOES;
    api->glFramebufferRenderbuffer = glFramebufferRenderbufferOES;
    api->GL_COLOR_ATTACHMENT0_ = GL_COLOR_ATTACHMENT0_OES;
    api->GL_DEPTH_ATTACHMENT_ = GL_DEPTH_ATTACHMENT_OES;
    api->glGetRenderbufferParameteriv = glGetRenderbufferParameterivOES;
    api->GL_RENDERBUFFER_WIDTH_ = GL_RENDERBUFFER_WIDTH_OES;
    api->GL_RENDERBUFFER_HEIGHT_ = GL_RENDERBUFFER_HEIGHT_OES;
    api->glCheckFramebufferStatus = glCheckFramebufferStatusOES;
    api->GL_FRAMEBUFFER_COMPLETE_ = GL_FRAMEBUFFER_COMPLETE_OES;
    api->glRenderbufferStorage = glRenderbufferStorageOES;
    api->GL_DEPTH_COMPONENT16_ = GL_DEPTH_COMPONENT16_OES;
    api->GL_DEPTH_COMPONENT24_ = GL_DEPTH_COMPONENT24_OES;
    api->glViewport = glViewport;
    api->glScissor = glScissor;
    api->glFlush = glFlush;
    api->glFinish = glFinish;
}

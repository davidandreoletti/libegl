//
//  opengles2_ios.c
//  eglapi-core-lib
//
//  Created by David Andreoletti on 06/02/2014.
//  Copyright (c) 2014 IO Stark. All rights reserved.
//

#include "EGL/drivers/eagl/opengles/opengles2_ios.h"
#include <stddef.h>
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>

void opengles2_api_init(__OpenGLESAPI* api) {
    if (api == NULL) {return;}
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
    api->GL_DEPTH_COMPONENT24_ = GL_DEPTH_COMPONENT24_OES;
    api->glViewport = glViewport;
    api->glScissor = glScissor;
}

//
//  opengles_ios.c
//  eglapi-core-lib
//
//  Created by David Andreoletti on 06/02/2014.
//  Copyright (c) 2014 IO Stark. All rights reserved.
//

#include "EGL/drivers/eagl/opengles/opengles_ios.h"
#include <stddef.h>

void opengles_api_init(__OpenGLESAPI* api, _OpenGLESAPIVersion version) {
    if (api == NULL) {return;}
    switch (version) {
        case OPENGL_ES_1_1:
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
            break;
        case OPENGL_ES_2_0:
            api->majorVersion = 2;
        case OPENGL_ES_3_0:
            api->majorVersion = 3;
        default:
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
            break;
    }
}

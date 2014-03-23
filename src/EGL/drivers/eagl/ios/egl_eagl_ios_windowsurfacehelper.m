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

#include "EGL/drivers/eagl/ios/egl_eagl_ios_windowsurfacehelper.h"
#include "EGL/eglconfig.h"
#include <OpenGLES/ES1/gl.h>
#include <stdbool.h>

GLenum windowsurfacehelper_createDepthBuffer(_OpenGLESAPI* api, GLuint* depthBuffer,
                                             GLint width, GLint height, GLuint bits) {
    // Assumption: A render buffer is bound to the current context
    GLuint depth_component = 0;
    if (bits == 24) {
        depth_component = api->GL_DEPTH_COMPONENT24_;
    } else {
        /* ignore the bits value and use the default 16 bits */
        depth_component = api->GL_DEPTH_COMPONENT16_;
    }
    
    GLenum error = GL_NO_ERROR;
    GLenum step = 1;
    GL_GET_ERROR(api->glGenRenderBuffers(1, depthBuffer), error, step)
    GL_CLEANUP_ERROR(error != GL_NO_ERROR, cleanup)
    
    GL_GET_ERROR(api->glBindRenderBuffers(api->GL_RENDERBUFFER_, *depthBuffer), error, step)
    GL_CLEANUP_ERROR(error != GL_NO_ERROR, cleanup)
    
    GL_GET_ERROR(api->glRenderbufferStorage(api->GL_RENDERBUFFER_, depth_component, width, height), error, step)
    GL_CLEANUP_ERROR(error != GL_NO_ERROR, cleanup)
    
cleanup:
    if (error != GL_NO_ERROR) {
        //TODO
    }
    
    return error;
}

bool windowsurfacehelper_createFrameBuffer(struct EAGL_egl_context* context, _EAGLSurface* surface,
                                           _OpenGLESAPI* api) {
    GLuint framebuffer = 0;
    GLuint colorbuffer = 0;
    GLuint depthbuffer = 0;
    GLuint depthBits = context->Base.Config->DepthSize;
    
    // Create the framebuffer object
    GLenum error = GL_NO_ERROR;
    GLuint step = 1;
    GL_GET_ERROR(api->glGenFrameBuffers(1, &framebuffer), error, step)
    GL_CLEANUP_ERROR(error != GL_NO_ERROR, cleanup)
    
    // Binds framebuffer object
    GL_GET_ERROR(api->glBindFrameBuffers(api->GL_FRAMEBUFFER_, framebuffer), error, step);
    GL_CLEANUP_ERROR(error != GL_NO_ERROR, cleanup)
    
    // Create the color buffer object
    GL_GET_ERROR(api->glGenRenderBuffers(1, &colorbuffer), error, step)
    GL_CLEANUP_ERROR(error != GL_NO_ERROR, cleanup)
    
    // Binds colorbuffer object to framebuffer
    GL_GET_ERROR(api->glBindRenderBuffers(api->GL_RENDERBUFFER_, colorbuffer), error, step);
    GL_CLEANUP_ERROR(error != GL_NO_ERROR, cleanup)
    
    // Associate color buffer to framebuffer
    GL_GET_ERROR(api->glFramebufferRenderbuffer(api->GL_FRAMEBUFFER_, api->GL_COLOR_ATTACHMENT0_, api->GL_RENDERBUFFER_, colorbuffer), error, step);
    GL_CLEANUP_ERROR(error != GL_NO_ERROR, cleanup)
    
    // Allocate colorbuffer storage (same as glRenderbufferStorage)
    BOOL r = [context->Context.nativeContext renderbufferStorage:api->GL_RENDERBUFFER_
                                             fromDrawable: surface.windowSurface];
    GL_CLEANUP_ERROR(((r ? GL_NO_ERROR : (GL_NO_ERROR+1)) != GL_NO_ERROR), cleanup)
    
    // Get surface size from color buffer
    GLint backingWidth = 0;
    GLint backingHeight = 0;
    GL_GET_ERROR(api->glGetRenderbufferParameteriv(api->GL_RENDERBUFFER_, api->GL_RENDERBUFFER_WIDTH_, &backingWidth), error, step);
    GL_CLEANUP_ERROR(error != GL_NO_ERROR, cleanup)
    GL_GET_ERROR(api->glGetRenderbufferParameteriv(api->GL_RENDERBUFFER_, api->GL_RENDERBUFFER_HEIGHT_, &backingHeight), error, step);
    GL_CLEANUP_ERROR(error != GL_NO_ERROR, cleanup)
    
    if (depthBits) {
        // Create the depth buffer
        error = windowsurfacehelper_createDepthBuffer(api, &depthbuffer, backingWidth, backingHeight, depthBits);
        GL_CLEANUP_ERROR(error != GL_NO_ERROR, cleanup)
        // Associate depth buffer to framebuffer
        GL_GET_ERROR(api->glFramebufferRenderbuffer(api->GL_FRAMEBUFFER_, api->GL_DEPTH_ATTACHMENT_, api->GL_RENDERBUFFER_, depthbuffer), error, step)
        GL_CLEANUP_ERROR(error != GL_NO_ERROR, cleanup)
    }

    // Check framebuffer completeness
    GLenum status = api->glCheckFramebufferStatus(api->GL_FRAMEBUFFER_);
    if(status != api->GL_FRAMEBUFFER_COMPLETE_) {error = r ? GL_NO_ERROR : (GL_NO_ERROR+1);}
    GL_CLEANUP_ERROR(error != GL_NO_ERROR, cleanup)
    
//    // Make color buffer the current bound renderbuffer
//    GL_GET_ERROR(api->glBindRenderBuffers(api->GL_RENDERBUFFER_, colorbuffer), error, step);
//    GL_CLEANUP_ERROR(error != GL_NO_ERROR, cleanup)
    
    // Successful framebuffer creation, commit buffers ids to the surface
    _OpenGLBuffers buffs = {
        .framebuffer = framebuffer,
        .colorbuffer = colorbuffer,
        .depthbuffer = depthbuffer
    };
    surface.buffers = buffs;

cleanup:
    if (error != GL_NO_ERROR) {
        //TODO
    }
    
    return error == GL_NO_ERROR;
}

bool windowsurfacehelper_destroyFrameBuffer(struct EAGL_egl_context* context, _EAGLSurface* surface,
                                           _OpenGLESAPI* api) {
    GLint framebuffer = surface.buffers.framebuffer;
    GLint colorbuffer = surface.buffers.colorbuffer;
    GLint depthbuffer = surface.buffers.depthbuffer;
    GLenum error = GL_NO_ERROR;
    GLuint step = 1;
    
    // Binds framebuffer object
    GL_GET_ERROR(api->glBindFrameBuffers(api->GL_FRAMEBUFFER_, framebuffer), error, step);
    GL_CLEANUP_ERROR(error != GL_NO_ERROR, cleanup)
    
    // Unbinds colorbuffer object from framebuffer
    GL_GET_ERROR(api->glBindRenderBuffers(api->GL_RENDERBUFFER_, 0), error, step);
    GL_CLEANUP_ERROR(error != GL_NO_ERROR, cleanup)
    
    // Delete color buffer
    GL_GET_ERROR(api->glDeleteRenderBuffers(1, &colorbuffer), error, step);
    GL_CLEANUP_ERROR(error != GL_NO_ERROR, cleanup)
    
    
    // Delete depth buffer
    if (context->Base.Config->DepthSize) {
        // Unbinds depthbuffer object from framebuffer
        GL_GET_ERROR(api->glBindRenderBuffers(api->GL_RENDERBUFFER_, 0), error, step)
        GL_CLEANUP_ERROR(error != GL_NO_ERROR, cleanup)
        
        // Delete depth buffer
        GL_GET_ERROR(api->glDeleteRenderBuffers(1, &depthbuffer), error, step);
        GL_CLEANUP_ERROR(error != GL_NO_ERROR, cleanup)
    }
    // Binds framebuffer object
    GL_GET_ERROR(api->glBindFrameBuffers(api->GL_FRAMEBUFFER_, 0), error, step);
    GL_CLEANUP_ERROR(error != GL_NO_ERROR, cleanup)
    
    // Delete framebuffer
    GL_GET_ERROR(api->glDeleteFrameBuffers(1, &framebuffer), error, step);
    GL_CLEANUP_ERROR(error != GL_NO_ERROR, cleanup)
    
    _OpenGLBuffers zero = {0};
    surface.buffers = zero;
    
    return true;
    cleanup:
    return false;
}

bool windowsurfacehelper_makeFrameBufferCurrent(struct EAGL_egl_context* context, _EAGLSurface* surface,
                                                _OpenGLESAPI* api) {
    GLint framebuffer = surface.buffers.framebuffer;
    GLint colorbuffer = surface.buffers.colorbuffer;
    GLenum error = GL_NO_ERROR;
    GLuint step = 1;
    // Make framebuffer the current bound framebuffer
    GL_GET_ERROR(api->glBindFrameBuffers(api->GL_FRAMEBUFFER_, framebuffer), error, step);
    GL_CLEANUP_ERROR(error != GL_NO_ERROR, cleanup)
    // Make color buffer the current bound renderbuffer
    GL_GET_ERROR(api->glBindRenderBuffers(api->GL_RENDERBUFFER_, colorbuffer), error, step);
    GL_CLEANUP_ERROR(error != GL_NO_ERROR, cleanup)
    return true;
    cleanup:
    return false;
}

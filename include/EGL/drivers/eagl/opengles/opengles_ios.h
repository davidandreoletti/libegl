//
//  opengles_ios.h
//  eglapi-core-lib
//
//  Created by David Andreoletti on 06/02/2014.
//  Copyright (c) 2014 IO Stark. All rights reserved.
//

#ifndef INCLUDE_EGL_DRIVERS_EAGL_OPENGLES_OPENGLES_IOS_H_
#define INCLUDE_EGL_DRIVERS_EAGL_OPENGLES_OPENGLES_IOS_H_

#include <OpenGLES/ES1/gl.h>
#include <OpenGLES/ES1/glext.h>
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>

typedef GLvoid (*glGenBuffersFuncPtr) (GLsizei n, GLuint* buffers);
typedef GLvoid (*glBindBufferFuncPtr) (GLenum target,  GLuint framebuffer);
typedef GLvoid (*glDeleteBuffersFuncPtr) (GLsizei n, const GLuint* buffers);
typedef GLvoid (*glFramebufferRenderbufferFuncPtr) (GLenum target,  GLenum attachment,  GLenum renderbuffertarget,  GLuint renderbuffer);
typedef GLvoid (*glGetRenderbufferParameterivFuncPtr) (GLenum target,  GLenum pname,  GLint * params);
typedef GLenum (*glCheckFramebufferStatusFuncPtr) (GLenum target);
typedef GLvoid (*glRenderbufferStorageFuncPtr) (GLenum target, GLenum internalformat, GLsizei width, GLsizei height);
typedef void (*glViewportFuncPtr)(GLint x,  GLint y,  GLsizei width,  GLsizei height);
typedef void (*glScissorFuncPtr) (GLint x,  GLint y,  GLsizei width,  GLsizei height);

/**
 * OpenGL ES API
 */
typedef struct {
    int majorVersion;
    int minorVersion;
    glGenBuffersFuncPtr glGenFrameBuffers;
    glBindBufferFuncPtr glBindFrameBuffers;
    GLuint GL_FRAMEBUFFER_;
    glGenBuffersFuncPtr glGenRenderBuffers;
    glBindBufferFuncPtr glBindRenderBuffers;
    GLuint GL_RENDERBUFFER_;
    glDeleteBuffersFuncPtr glDeleteFrameBuffers;
    glDeleteBuffersFuncPtr glDeleteRenderBuffers;
    glFramebufferRenderbufferFuncPtr glFramebufferRenderbuffer;
    GLuint GL_COLOR_ATTACHMENT0_;
    GLuint GL_DEPTH_ATTACHMENT_;
    glGetRenderbufferParameterivFuncPtr glGetRenderbufferParameteriv;
    GLuint GL_RENDERBUFFER_WIDTH_;
    GLuint GL_RENDERBUFFER_HEIGHT_;
    glCheckFramebufferStatusFuncPtr glCheckFramebufferStatus;
    GLuint GL_FRAMEBUFFER_COMPLETE_;
    glRenderbufferStorageFuncPtr glRenderbufferStorage;
    GLuint renderbufferInternalFormat;
    GLuint GL_DEPTH_COMPONENT16_;
    GLuint GL_DEPTH_COMPONENT24_;
    glViewportFuncPtr glViewport;
    glScissorFuncPtr glScissor;
} __OpenGLESAPI;

typedef enum {
    OPENGL_ES_1_1 = 1, // OpenGL ES 1.1
    OPENGL_ES_2_0 = 2, // OpenGL ES 2.0
    OPENGL_ES_3_0 = 3  // OpenGL ES 3.0
} _OpenGLESAPIVersion;

/**
 * Initializes an OpenGL ES abstraction API instance pointing to functions for the requested
 * OpenGL API ES version
 * \param api OpenGL ES abstraction API instance. If NULL, no initialization occurs.
 * \param version Requested OpenGL API ES version
 */
void opengles_api_init(__OpenGLESAPI* api, _OpenGLESAPIVersion version);

/**
 * Finds the OpenGL ES API version supported
 * \param num Will contain the number of version supported
 * \return Array containing num supported version
 */
//_OpenGLESAPIVersion* opengles_supported_api(short* num);

/**
 * OpenGL ES buffer ids
 */
typedef struct {
    /**
     * Native OpenGL framebuffer ID
     */
    GLuint framebuffer;
    /**
     * Native OpenGL colorbuffer ID
     */
    GLuint colorbuffer;
    /**
     * Native OpenGL depthbuffer ID
     */
    GLuint depthbuffer;
} _OpenGLBuffers;


#endif  // INCLUDE_EGL_DRIVERS_EAGL_OPENGLES_OPENGLES_IOS_H_

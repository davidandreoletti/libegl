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

#define GL_GET_ERROR(f, error, step) { f; error = glGetError();  step += 1; }
#define GL_CLEANUP_ERROR(condition, aLabel) if (condition) {goto aLabel;}

typedef GLvoid (*GLGenBuffers_t) (GLsizei n, GLuint* buffers);
typedef GLvoid (*GLBindBuffer_t) (GLenum target,  GLuint framebuffer);
typedef GLvoid (*GLDeleteBuffers_t) (GLsizei n, const GLuint* buffers);
typedef GLvoid (*GLFramebufferRenderbuffer_t) (GLenum target,  GLenum attachment,  GLenum renderbuffertarget,  GLuint renderbuffer);
typedef GLvoid (*GLGetRenderbufferParameteriv_t) (GLenum target,  GLenum pname,  GLint * params);
typedef GLenum (*GLCheckFramebufferStatus_t) (GLenum target);
typedef GLvoid (*GLRenderbufferStorage_t) (GLenum target, GLenum internalformat, GLsizei width, GLsizei height);
typedef void (*GLViewport_t)(GLint x,  GLint y,  GLsizei width,  GLsizei height);
typedef void (*GLScissor_t) (GLint x,  GLint y,  GLsizei width,  GLsizei height);

/**
 * OpenGL ES API
 */
typedef struct {
    int majorVersion;
    int minorVersion;
    GLGenBuffers_t glGenFrameBuffers;
    GLBindBuffer_t glBindFrameBuffers;
    GLuint GL_FRAMEBUFFER_;
    GLGenBuffers_t glGenRenderBuffers;
    GLBindBuffer_t glBindRenderBuffers;
    GLuint GL_RENDERBUFFER_;
    GLDeleteBuffers_t glDeleteFrameBuffers;
    GLDeleteBuffers_t glDeleteRenderBuffers;
    GLFramebufferRenderbuffer_t glFramebufferRenderbuffer;
    GLuint GL_COLOR_ATTACHMENT0_;
    GLuint GL_DEPTH_ATTACHMENT_;
    GLGetRenderbufferParameteriv_t glGetRenderbufferParameteriv;
    GLuint GL_RENDERBUFFER_WIDTH_;
    GLuint GL_RENDERBUFFER_HEIGHT_;
    GLCheckFramebufferStatus_t glCheckFramebufferStatus;
    GLuint GL_FRAMEBUFFER_COMPLETE_;
    GLRenderbufferStorage_t glRenderbufferStorage;
    GLuint renderbufferInternalFormat;
    GLuint GL_DEPTH_COMPONENT16_;
    GLuint GL_DEPTH_COMPONENT24_;
    GLViewport_t glViewport;
    GLScissor_t glScissor;
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

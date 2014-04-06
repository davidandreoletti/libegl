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

#ifndef INCLUDE_EGL_DRIVERS_EAGL_OPENGLES_OPENGLES_IOS_H_
#define INCLUDE_EGL_DRIVERS_EAGL_OPENGLES_OPENGLES_IOS_H_

/** Temporary GL types */
#define GLuint unsigned int
#define GLenum unsigned int

/** GL functions prototypes */
typedef void (*GLGenBuffers_t) ();
typedef void (*GLBindBuffer_t) ();
typedef void (*GLDeleteBuffers_t) ();
typedef void (*GLFramebufferRenderbuffer_t) ();
typedef void (*GLGetRenderbufferParameteriv_t) ();
typedef unsigned int (*GLCheckFramebufferStatus_t) ();
typedef void (*GLRenderbufferStorage_t) ();
typedef void (*GLViewport_t)();
typedef void (*GLScissor_t) ();
typedef void (*GLFlush_t) ();
typedef void (*GLFinish_t) ();

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
    GLFlush_t glFlush;
    GLFinish_t glFinish;
} __OpenGLESAPI;

typedef enum {
    OPENGL_ES_NOT_SUPPORTED = 0,    // No OpenGL ES support
    OPENGL_ES_1_1 = 1,              // OpenGL ES 1.1
    OPENGL_ES_2_0 = 2,              // OpenGL ES 2.0
    OPENGL_ES_3_0 = 3               // OpenGL ES 3.0
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
_OpenGLESAPIVersion opengles_max_version_supported();

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

#undef GLuint
#undef GLenum

#define GL_GET_ERROR(f, error, step) { f; error = glGetError();  step += 1; }
#define GL_CLEANUP_ERROR(condition, aLabel) if (condition) {goto aLabel;}

#endif  // INCLUDE_EGL_DRIVERS_EAGL_OPENGLES_OPENGLES_IOS_H_

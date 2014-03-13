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
//  Inspired from: http://code.google.com/p/android-native-egl-example/source/browse/jni/renderer.cpp

#include "Sample1Test.h"
#include "eglTestUtils.h"
#include "eglTestTimeUtils.h"

#include <stdio.h>
#include <math.h>
#include <time.h>

/**************************************************************************
 EGL
 **************************************************************************/

static EGLDisplay display;
static EGLConfig config;
static EGLint numConfigs;
static EGLSurface surface;
static EGLContext context;
static EGLint width;
static EGLint height;

/**************************************************************************
 OpenGL ES 1.x
 Inspired from: http://code.google.com/p/android-native-egl-example/source/browse/jni/renderer.cpp
 **************************************************************************/

#include <OpenGLES/ES1/gl.h>

static GLint verticesES1[][3] = {
    { -0x10000, -0x10000, -0x10000 },
    {  0x10000, -0x10000, -0x10000 },
    {  0x10000,  0x10000, -0x10000 },
    { -0x10000,  0x10000, -0x10000 },
    { -0x10000, -0x10000,  0x10000 },
    {  0x10000, -0x10000,  0x10000 },
    {  0x10000,  0x10000,  0x10000 },
    { -0x10000,  0x10000,  0x10000 }
};

static GLint colors[][4] = {
    { 0x00000, 0x00000, 0x00000, 0x10000 },
    { 0x10000, 0x00000, 0x00000, 0x10000 },
    { 0x10000, 0x10000, 0x00000, 0x10000 },
    { 0x00000, 0x10000, 0x00000, 0x10000 },
    { 0x00000, 0x00000, 0x10000, 0x10000 },
    { 0x10000, 0x00000, 0x10000, 0x10000 },
    { 0x10000, 0x10000, 0x10000, 0x10000 },
    { 0x00000, 0x10000, 0x10000, 0x10000 }
};

GLubyte indicesES1[] = {
    0, 4, 5,    0, 5, 1,
    1, 5, 6,    1, 6, 2,
    2, 6, 7,    2, 7, 3,
    3, 7, 4,    3, 4, 0,
    4, 7, 6,    4, 6, 5,
    3, 0, 1,    3, 1, 2
};

EGLDisplay _display;
EGLSurface _surface;
EGLContext _context;
GLfloat _angle;

static void renderFrameOpenGLES1()
{
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    glTranslatef(0, 0, -4.0f);
    glRotatef(_angle, 0, 1, 0);
    glRotatef(_angle*0.25f, 1, 0, 0);
    
    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_COLOR_ARRAY);
    
    glFrontFace(GL_CW);
    glVertexPointer(3, GL_FIXED, 0, verticesES1);
    glColorPointer(4, GL_FIXED, 0, colors);
    glDrawElements(GL_TRIANGLES, 36, GL_UNSIGNED_BYTE, indicesES1);
    
    _angle += 1.2f;
}

static void destroyRenderOpenGLES1() {
    LOG(I, "Destroying context")
    
    eglMakeCurrent(_display, EGL_NO_SURFACE, EGL_NO_SURFACE, EGL_NO_CONTEXT);
    eglDestroyContext(_display, _context);
    eglDestroySurface(_display, _surface);
    eglTerminate(_display);
    eglReleaseThread();
    
    _display = EGL_NO_DISPLAY;
    _surface = EGL_NO_SURFACE;
    _context = EGL_NO_CONTEXT;
    return;
}

static int initRenderOpenGLES1(TestPlatform* p, void* eglDisplay, void* nativeWinSurface) {
    setenv(p->ios_platform_env_key, p->ios_platform_env_value, 1);
    const EGLint attribs[] = {
        EGL_SURFACE_TYPE, EGL_WINDOW_BIT,
        EGL_BLUE_SIZE, 8,
        EGL_GREEN_SIZE, 8,
        EGL_RED_SIZE, 8,
        EGL_RENDERABLE_TYPE, EGL_OPENGL_ES_BIT,
        EGL_NONE
    };
    EGLDisplay display = NULL;
    EGLConfig config = NULL;
    EGLint numConfigs = NULL;
    EGLSurface surface = NULL;
    EGLContext context = NULL;
    EGLint width = 0;
    EGLint height = 0;
    GLfloat ratio= 0;
    
    LOG(I, "Initializing context")
    
    if ((display = eglGetDisplay(eglDisplay)) == EGL_NO_DISPLAY) {
        logEGLError( "eglGetDisplay", eglGetError());
        return 0;
    }
    if (!eglInitialize(display, 0, 0)) {
        logEGLError( "eglInitialize", eglGetError());
        return 0;
    }
    
    if (!eglChooseConfig(display, attribs, &config, 1, &numConfigs)) {
        logEGLError( "eglChooseConfig", eglGetError());
        destroyRenderOpenGLES1();
        return 0;
    }
    
    if (!(surface = eglCreateWindowSurface(display, config, nativeWinSurface, NULL))) {
        logEGLError( "eglCreateWindowSurface", eglGetError());
        destroyRenderOpenGLES1();
        return 0;
    }
    
    if (!(context = eglCreateContext(display, config, EGL_NO_CONTEXT, NULL))) {
        logEGLError( "eglCreateContext", eglGetError());
        destroyRenderOpenGLES1();
        return 0;
    }
    
    if (!eglMakeCurrent(display, surface, surface, context)) {
        logEGLError( "eglMakeCurrent", eglGetError());
        destroyRenderOpenGLES1();
        return 0;
    }
    
    if (!eglQuerySurface(display, surface, EGL_WIDTH, &width) ||
        !eglQuerySurface(display, surface, EGL_HEIGHT, &height)) {
        logEGLError( "eglQuerySurface", eglGetError());
        destroyRenderOpenGLES1();
        return 0;
    }
    
    _display = display;
    _surface = surface;
    _context = context;
    
    glDisable(GL_DITHER);
    glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_FASTEST);
    glClearColor(0, 0, 0, 0);
    glEnable(GL_CULL_FACE);
    glShadeModel(GL_SMOOTH);
    glEnable(GL_DEPTH_TEST);
    
    glViewport(0, 0, width, height);
    
    ratio = (GLfloat) width / height;
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glFrustumf(-ratio, ratio, -1, 1, 1, 10);
    
    LOG(I, "Context initialized")
    return 1;
}


/**************************************************************************
 OpenGL ES 2.x 3.x
 Inspired from: http://cgit.freedesktop.org/mesa/demos/plain/src/egl/opengles2/es2gears.c
 **************************************************************************/

#include <OpenGLES/ES2/gl.h>

//
// Auxillary functions
//

#ifndef M_PI
#    define M_PI 3.14159265358979323846
#endif

void sincos(double x, double* p_sin, double* p_cos) {
    *p_sin = sin(x);
    *p_cos = cos(x);
}

/**
 * Multiplies two 4x4 matrices.
 *
 * The result is stored in matrix m.
 *
 * @param m the first matrix to multiply
 * @param n the second matrix to multiply
 */
static void
multiply(GLfloat *m, const GLfloat *n)
{
    GLfloat tmp[16];
    const GLfloat *row, *column;
    div_t d;
    int i, j;
    
    for (i = 0; i < 16; i++) {
        tmp[i] = 0;
        d = div(i, 4);
        row = n + d.quot * 4;
        column = m + d.rem;
        for (j = 0; j < 4; j++)
            tmp[i] += row[j] * column[j * 4];
    }
    memcpy(m, &tmp, sizeof tmp);
}

/**
 * Rotates a 4x4 matrix.
 *
 * @param[in,out] m the matrix to rotate
 * @param angle the angle to rotate
 * @param x the x component of the direction to rotate to
 * @param y the y component of the direction to rotate to
 * @param z the z component of the direction to rotate to
 */
static void
rotate(GLfloat *m, GLfloat angle, GLfloat x, GLfloat y, GLfloat z)
{
    double s, c;
    
    sincos(angle, &s, &c);
    GLfloat r[16] = {
        x * x * (1 - c) + c,     y * x * (1 - c) + z * s, x * z * (1 - c) - y * s, 0,
        x * y * (1 - c) - z * s, y * y * (1 - c) + c,     y * z * (1 - c) + x * s, 0,
        x * z * (1 - c) + y * s, y * z * (1 - c) - x * s, z * z * (1 - c) + c,     0,
        0, 0, 0, 1
    };
    
    multiply(m, r);
}


/**
 * Translates a 4x4 matrix.
 *
 * @param[in,out] m the matrix to translate
 * @param x the x component of the direction to translate to
 * @param y the y component of the direction to translate to
 * @param z the z component of the direction to translate to
 */
static void
translate(GLfloat *m, GLfloat x, GLfloat y, GLfloat z)
{
    GLfloat t[16] = { 1, 0, 0, 0,  0, 1, 0, 0,  0, 0, 1, 0,  x, y, z, 1 };
    
    multiply(m, t);
}

/**
 * Creates an identity 4x4 matrix.
 *
 * @param m the matrix make an identity matrix
 */
static void
identity(GLfloat *m)
{
    GLfloat t[16] = {
        1.0, 0.0, 0.0, 0.0,
        0.0, 1.0, 0.0, 0.0,
        0.0, 0.0, 1.0, 0.0,
        0.0, 0.0, 0.0, 1.0,
    };
    
    memcpy(m, t, sizeof(t));
}

/**
 * Transposes a 4x4 matrix.
 *
 * @param m the matrix to transpose
 */
static void
transpose(GLfloat *m)
{
    GLfloat t[16] = {
        m[0], m[4], m[8],  m[12],
        m[1], m[5], m[9],  m[13],
        m[2], m[6], m[10], m[14],
        m[3], m[7], m[11], m[15]};
    
    memcpy(m, t, sizeof(t));
}

/**
 * Inverts a 4x4 matrix.
 *
 * This function can currently handle only pure translation-rotation matrices.
 * Read http://www.gamedev.net/community/forums/topic.asp?topic_id=425118
 * for an explanation.
 */
static void
invert(GLfloat *m)
{
    GLfloat t[16];
    identity(t);
    
    // Extract and invert the translation part 't'. The inverse of a
    // translation matrix can be calculated by negating the translation
    // coordinates.
    t[12] = -m[12]; t[13] = -m[13]; t[14] = -m[14];
    
    // Invert the rotation part 'r'. The inverse of a rotation matrix is
    // equal to its transpose.
    m[12] = m[13] = m[14] = 0;
    transpose(m);
    
    // inv(m) = inv(r) * inv(t)
    multiply(m, t);
}

/**
 * Calculate a perspective projection transformation.
 *
 * @param m the matrix to save the transformation in
 * @param fovy the field of view in the y direction
 * @param aspect the view aspect ratio
 * @param zNear the near clipping plane
 * @param zFar the far clipping plane
 */
void perspective(GLfloat *m, GLfloat fovy, GLfloat aspect, GLfloat zNear, GLfloat zFar)
{
    GLfloat tmp[16];
    identity(tmp);
    
    double sine, cosine, cotangent, deltaZ;
    GLfloat radians = fovy / 2 * M_PI / 180;
    
    deltaZ = zFar - zNear;
    sincos(radians, &sine, &cosine);
    
    if ((deltaZ == 0) || (sine == 0) || (aspect == 0))
        return;
    
    cotangent = cosine / sine;
    
    tmp[0] = cotangent / aspect;
    tmp[5] = cotangent;
    tmp[10] = -(zFar + zNear) / deltaZ;
    tmp[11] = -1;
    tmp[14] = -2 * zNear * zFar / deltaZ;
    tmp[15] = 0;
    
    memcpy(m, tmp, sizeof(tmp));
}

static void perpective2( GLfloat* aGLMatrix, GLfloat left, GLfloat right, GLfloat bottom, GLfloat top, GLfloat near, GLfloat far) {
	aGLMatrix[0]  = (2.0 * near) / (right - left);
	aGLMatrix[1]  = 0.0;
	aGLMatrix[2]  = 0.0;
	aGLMatrix[3] = 0.0;
	
	aGLMatrix[4]  = 0.0;
	aGLMatrix[5]  = (2.0 * near) / (top - bottom);
	aGLMatrix[6]  = 0.0;
	aGLMatrix[7] = 0.0;
	
	aGLMatrix[8]  = (right + left) / (right - left);
	aGLMatrix[9]  = (top + bottom) / (top - bottom);
	aGLMatrix[10] = -(far + near) / (far - near);
	aGLMatrix[11] = -1.0;
	
	aGLMatrix[12]  = 0.0;
	aGLMatrix[13]  = 0.0;
	aGLMatrix[14] = -(2.0 * far * near) / (far - near);
	aGLMatrix[15] = 0.0;
}

//
// OpenGL ES 2.x data
//

static const GLchar vertexShader[] =
"attribute vec4 Position;\n"
"attribute vec4 SourceColor;\n"
"varying vec4 DestinationColor;\n"
"uniform mat4 Projection;\n"
"uniform mat4 Modelview;\n"
"\n"
"void main(void) {\n"
"    DestinationColor = SourceColor;\n"
"    gl_Position = Projection * Modelview * Position;\n"
"}";

static  const GLchar fragmentShader[] =
"varying lowp vec4 DestinationColor;\n"
"\n"
"void main(void) {\n"
"    gl_FragColor = DestinationColor;\n"
"}";

typedef struct {
    float Position[3];
    float Color[4];
} Vertex;

static const Vertex verticesES2[] = {
    {{1, -1, 1}, {1, 0, 0, 1}},
    {{1, 1, 1}, {1, 1, 0, 1}},
    {{-1, 1, 1}, {1, 1, 1, 1}},
    {{-1, -1, 1}, {0, 1, 0.5, 1}},
    {{1, -1, -1}, {1, 1, 0.5, 1}},
    {{1, 1, -1}, {1, 0.5, 0.5, 1}},
    {{-1, 1, -1}, {0, 1, 1, 1}},
    {{-1, -1, -1}, {0, 1, 0, 1}}
};

static const GLubyte indicesES2[] = {
    // Front
    0, 1, 2,
    2, 3, 0,
    // Back
    4, 6, 5,
    4, 7, 6,
    // Left
    2, 7, 3,
    7, 6, 2,
    // Right
    0, 4, 1,
    4, 1, 5,
    // Top
    6, 2, 1,
    1, 6, 5,
    // Bottom
    0, 3, 7,
    0, 7, 4
};

static GLuint _positionSlot = 0;
static GLuint _colorSlot = 0;
static GLuint _projectionUniform = 0;
static GLuint _modelViewUniform = 0;
static float _currentRotation = 0;
static GLuint vertexShaderObjectId = 0;
static GLuint fragmentShaderObjectId = 0;
static GLuint programObjectId = 0;
static GLuint vertexBuffer = 0;
static GLuint indexBuffer = 0;

//
// OpenGL ES 2.x auxillary functions
//

static GLboolean compileShader(const GLchar* shaderSource, GLint *shaderSourceLength, const GLenum shaderType, GLuint* shaderObjectId) {
    *shaderObjectId = glCreateShader(shaderType);
    glShaderSource(*shaderObjectId, 1, &shaderSource, shaderSourceLength);
    glCompileShader(*shaderObjectId);
    GLint compileSuccess = GL_FALSE;
    glGetShaderiv(*shaderObjectId, GL_COMPILE_STATUS, &compileSuccess);
    if (compileSuccess == GL_FALSE) {
        GLchar messages[256] = {0};
        glGetShaderInfoLog(*shaderObjectId, sizeof(messages), 0, messages);
        printf("Shader compilation failed: %s", messages);
        return GL_FALSE;
    }
    return GL_TRUE;
}

static GLboolean compileShaders(const GLchar* vertexShaderSource, const GLchar* fragmentShaderSource, GLuint* shaderVertexObjectId, GLuint* shaderFragmentObjectId, GLuint* programObjectId) {
    if(!compileShader(&vertexShaderSource[0], NULL, GL_VERTEX_SHADER, shaderVertexObjectId)) {
        // Undo compilation
    }
    if(!compileShader(&fragmentShaderSource[0], NULL, GL_FRAGMENT_SHADER, shaderFragmentObjectId)){
        // Undo compilation
        return GL_FALSE;
    }
    
    *programObjectId = glCreateProgram();
    glAttachShader(*programObjectId, *shaderVertexObjectId);
    glAttachShader(*programObjectId, *shaderFragmentObjectId);
    glLinkProgram(*programObjectId);
    
    GLint linkSuccess = GL_FALSE;
    glGetProgramiv(*programObjectId, GL_LINK_STATUS, &linkSuccess);
    if (linkSuccess == GL_FALSE) {
        GLchar messages[256] = {0};
        glGetProgramInfoLog(*programObjectId, sizeof(messages), 0, &messages[0]);
        printf("Prgram compilation failed: %s", messages);
        // Undo compilation
        return GL_FALSE;
    }
    
    return GL_TRUE;
}

static GLboolean setupAttribLocations(GLuint* programObjectId, GLuint* _positionSlot, GLuint* _colorSlot, GLuint* _projectionUniform, GLuint* _modelViewUniform) {
    glUseProgram(*programObjectId);
    *_positionSlot = glGetAttribLocation(*programObjectId, "Position");
    *_colorSlot = glGetAttribLocation(*programObjectId, "SourceColor");
    *_projectionUniform = glGetUniformLocation(*programObjectId, "Projection");
    *_modelViewUniform = glGetUniformLocation(*programObjectId, "Modelview");
    glEnableVertexAttribArray(*_positionSlot);
    glEnableVertexAttribArray(*_colorSlot);
    return GL_TRUE;
}

static GLboolean setupVBOs(GLuint* vertexBuffer, GLuint* indexBuffer, GLsizeiptr sizeVertice, const GLvoid* dataVertice, GLsizeiptr sizeIndice, const GLvoid* dataIndice) {
    
    glGenBuffers(1, vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, *vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeVertice, dataVertice, GL_STATIC_DRAW);
    
    glGenBuffers(1, indexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, *indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeIndice, dataIndice, GL_STATIC_DRAW);
    return GL_TRUE;
}

EGLDisplay _display;
EGLSurface _surface;
EGLContext _context;

static void renderFrameOpenGLES2()
{
    glClearColor(0, 0, 0, 0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glEnable(GL_DEPTH_TEST);
    
    GLfloat projectionMatrix[16];
    float h = 4.0f * height / width;
    perpective2(projectionMatrix, -2, 2, -h/2, h/2, 4, 10);
    glUniformMatrix4fv(_projectionUniform, 1, 0, projectionMatrix);
    
    time_t timer;
    time(&timer);
    
    GLfloat modelMatrix[16];
    identity(modelMatrix);
    translate(modelMatrix, 0, 0, -7);

    _currentRotation += /*displayLink.duration * */ 1;
    rotate(modelMatrix, _currentRotation * M_PI/180, 0, 1, 0);
    rotate(modelMatrix, _currentRotation * 0.25f * M_PI/180, 1, 0, 0);
    
    glUniformMatrix4fv(_modelViewUniform, 1, 0, modelMatrix);
    
    glViewport(0, 0, width, height);
    
    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE,
                          sizeof(Vertex), 0);
    glVertexAttribPointer(_colorSlot, 4, GL_FLOAT, GL_FALSE,
                          sizeof(Vertex), (GLvoid*) (sizeof(float) * 3));
    
    glDrawElements(GL_TRIANGLES, sizeof(indicesES2)/sizeof(indicesES2[0]),
                   GL_UNSIGNED_BYTE, 0);
}

static void destroyRenderOpenGLES2() {
    LOG(I, "Destroying context")
    
    eglMakeCurrent(_display, EGL_NO_SURFACE, EGL_NO_SURFACE, EGL_NO_CONTEXT);
    eglDestroyContext(_display, _context);
    eglDestroySurface(_display, _surface);
    eglTerminate(_display);
    eglReleaseThread();
    
    _display = EGL_NO_DISPLAY;
    _surface = EGL_NO_SURFACE;
    _context = EGL_NO_CONTEXT;
    return;
}

static int initRenderOpenGLES2(TestPlatform* p, void* eglDisplay, void* nativeWinSurface) {
    setenv(p->ios_platform_env_key, p->ios_platform_env_value, 1);
//    EGLint openglClientVersion = EGL_OPENGL_ES2_BIT;
    EGLint openglClientVersion = EGL_OPENGL_ES3_BIT_KHR;
    EGLint attribs[] = {
        EGL_SURFACE_TYPE, EGL_WINDOW_BIT,
        EGL_BLUE_SIZE, 8,
        EGL_GREEN_SIZE, 8,
        EGL_RED_SIZE, 8,
        EGL_RENDERABLE_TYPE, openglClientVersion,
        EGL_NONE
    };
    
    LOG(I, "Initializing context")
    
    if ((display = eglGetDisplay(eglDisplay)) == EGL_NO_DISPLAY) {
        logEGLError( "eglGetDisplay", eglGetError());
        return 0;
    }
    if (!eglInitialize(display, 0, 0)) {
        logEGLError( "eglInitialize", eglGetError());
        return 0;
    }
    
    if (!eglChooseConfig(display, attribs, &config, 1, &numConfigs)) {
        logEGLError( "eglChooseConfig", eglGetError());
        destroyRenderOpenGLES2();
        return 0;
    }
    
    EGLint num_attrs = 0;
    getEGLConfigAttributeForEGLAPIVersion(1,
                                          4,
                                          NULL,
                                          &num_attrs);
    EGLint* attrs = (EGLint* ) malloc(num_attrs * sizeof(EGLint));
    getEGLConfigAttributeForEGLAPIVersion(1,
                                          4,
                                          attrs,
                                          &num_attrs);
    displayEGLConfig(display, config, attrs, num_attrs);
    
    if (!(surface = eglCreateWindowSurface(display, config, nativeWinSurface, NULL))) {
        logEGLError( "eglCreateWindowSurface", eglGetError());
        destroyRenderOpenGLES2();
        return 0;
    }
    
    attribs[0] = EGL_CONTEXT_CLIENT_VERSION;
//    attribs[1] = 2;
    attribs[1] = 3;
    attribs[2] = EGL_NONE;
    if (!(context = eglCreateContext(display, config, EGL_NO_CONTEXT, attribs))) {
        logEGLError( "eglCreateContext", eglGetError());
        destroyRenderOpenGLES2();
        return 0;
    }
    
    if (!eglMakeCurrent(display, surface, surface, context)) {
        logEGLError( "eglMakeCurrent", eglGetError());
        destroyRenderOpenGLES2();
        return 0;
    }
    
    if (!eglQuerySurface(display, surface, EGL_WIDTH, &width) ||
        !eglQuerySurface(display, surface, EGL_HEIGHT, &height)) {
        logEGLError( "eglQuerySurface", eglGetError());
        destroyRenderOpenGLES2();
        return 0;
    }
    
    _display = display;
    _surface = surface;
    _context = context;
    
    if(!compileShaders(vertexShader, fragmentShader, &vertexShaderObjectId, &fragmentShaderObjectId, &programObjectId)) {
        destroyRenderOpenGLES2();
        return 0;
    }
    if(!setupAttribLocations(&programObjectId, &_positionSlot, &_colorSlot, &_projectionUniform, &_modelViewUniform)){
        destroyRenderOpenGLES2();
        return 0;
    }
    if(!setupVBOs(&vertexBuffer, &indexBuffer, sizeof(verticesES2), verticesES2, sizeof(indicesES2), indicesES2)) {
        destroyRenderOpenGLES2();
        return 0;
    }
    
    LOG(I, "Context initialized")
    return 1;
}

/**************************************************************************
 Sample
 **************************************************************************/

typedef int (*InitRender_t) (TestPlatform*, void*, void*);
typedef void (*RenderFrame_t)(void);
typedef void (*DestroyRender_t)(void);

/** OpenGL renderer */
struct renderer {
    InitRender_t init;
    RenderFrame_t renderFrame;
    DestroyRender_t destroy;
};

static void sample(TestPlatform* p, void* eglDisplay, void* nativeWinSurface, int maxFrameCount, int openglesVersion) {
    
    struct renderer renderer = {0};
    switch (openglesVersion) {
        case 1:
        {
            renderer.init = initRenderOpenGLES1;
            renderer.renderFrame = renderFrameOpenGLES1;
            renderer.destroy = destroyRenderOpenGLES1;
            LOG(I, "Running with OPENGL ES 1.X")
            break;
        }
        case 2:
        {
            renderer.init = initRenderOpenGLES2;
            renderer.renderFrame = renderFrameOpenGLES2;
            renderer.destroy = destroyRenderOpenGLES2;
            LOG(I, "Running with OPENGL ES 2.X")
            break;
        }
        default:
            return;
            break;
    }
    
    
    if (renderer.init(p, eglDisplay, nativeWinSurface)) {
        int i = 0;
        TimeRecord_t s;
        TimeRecord_t e;
        while (i < maxFrameCount)
        {
            LOG(I, "FRAME ...")
            renderer.renderFrame();
            START_RECORD_DURATION(&s);
            if (!eglSwapBuffers(_display, _surface)) {
                logEGLError("eglSwapBuffers()", eglGetError());
            }
            LOG(I, "FRAME DONE")
            END_RECORD_DURATION(&e);
            LOG_DURATION(&s, &e)
            i++;
        }
    }
    renderer.destroy();
}

void run_sample1(TestPlatform* p) {
    LOG(I, "Executing: " __FILE__)
    setup(p);
    sample(p, p->validNativeDisplay, p->validNativeWindow, 1000, 1);
    teardown(p);
    setup(p);
    sample(p, p->validNativeDisplay, p->validNativeWindow, 1000, 2);
    teardown(p);
}


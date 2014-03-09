//
//  Sample1Test.c
//  eglTests
//
//  Inspired from: http://code.google.com/p/android-native-egl-example/source/browse/jni/renderer.cpp
//
//  Created by David Andreoletti on 10/11/13.
//  Copyright (c) 2013 David Andreoletti. All rights reserved.
//

#include "Sample1Test.h"
#include "eglTestUtils.h"
#include "eglTestTimeUtils.h"

#include <OpenGLES/ES1/gl.h>


static GLint vertices[][3] = {
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

GLubyte indices[] = {
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

static void renderFrame()
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
    glVertexPointer(3, GL_FIXED, 0, vertices);
    glColorPointer(4, GL_FIXED, 0, colors);
    glDrawElements(GL_TRIANGLES, 36, GL_UNSIGNED_BYTE, indices);
    
    _angle += 1.2f;
}

static void destroyRender() {
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

static int initRender(TestPlatform* p, void* eglDisplay, void* nativeWinSurface) {
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
        destroyRender();
        return 0;
    }
        
    if (!(surface = eglCreateWindowSurface(display, config, nativeWinSurface, NULL))) {
        logEGLError( "eglCreateWindowSurface", eglGetError());
        destroyRender();
        return 0;
    }
    
    if (!(context = eglCreateContext(display, config, EGL_NO_CONTEXT, NULL))) {
        logEGLError( "eglCreateContext", eglGetError());
        destroyRender();
        return 0;
    }
    
    if (!eglMakeCurrent(display, surface, surface, context)) {
        logEGLError( "eglMakeCurrent", eglGetError());
        destroyRender();
        return 0;
    }
    
    if (!eglQuerySurface(display, surface, EGL_WIDTH, &width) ||
        !eglQuerySurface(display, surface, EGL_HEIGHT, &height)) {
        logEGLError( "eglQuerySurface", eglGetError());
        destroyRender();
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

TimeRecord_t s;
TimeRecord_t e;

static void sample(TestPlatform* p, void* eglDisplay, void* nativeWinSurface, int maxFrameCount) {
    if (initRender(p, eglDisplay, nativeWinSurface)) {
        int i = 0;
        while (i < maxFrameCount)
        {
            LOG(I, "FRAME ...")
            renderFrame();
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
    destroyRender();
}

void run_sample1(TestPlatform* p) {
    LOG(I, "Executing: " __FILE__)
    setup(p);
    sample(p, p->validNativeDisplay, p->validNativeWindow, 1000);
    teardown(p);
}
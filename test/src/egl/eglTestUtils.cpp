//
//  eglTestUtils.cpp
//  eglTests
//
//  Created by David Andreoletti on 10/11/13.
//  Copyright (c) 2013 David Andreoletti. All rights reserved.
//

#include "eglTestUtils.h"

#include <iostream> // std::out
#include <sstream>  // stringstream
#include <cstdio>   // sprintf

void logMessage(LoggerSeverity s, std::string msg) {
    std::stringstream ss;
    switch (s) {
        case F:
            ss << "FATAL\t";
            break;
        case W:
            ss << "WARNING";
            break;
        case I:
            ss << "INFO\t";
            break;
        case D:
            ss << "DEBUG\t";
            break;
        default:
            break;
    }
    std::cout << ss.str() << ": " << msg << std::endl;
}

void logMessage1(LoggerSeverity s, const char* msg) {
    std::string m(msg);
    logMessage(s, m.c_str());
}

void logMessage2(LoggerSeverity s, const char* msg, const char* msg2) {
    std::string m(msg);
    std::string m2(msg2);
    std::stringstream ss;
    ss << m << m2;
    logMessage(s, ss.str());
}

void logMessage3(LoggerSeverity s, const char* msg, const char* msg2, const char* msg3) {
    std::string m(msg);
    std::string m2(msg2);
    std::string m3(msg3);
    std::stringstream ss;
    ss << m << m2 << m3;
    logMessage(s, ss.str());
}

void logEGLError(const char * fName, EGLint err) {
    std::string f(fName);
    std::string e(getErrorString(err));
    std::stringstream ss;
    ss << f << " : " << e;
    logMessage(I, ss.str());

}

const char* getErrorString(EGLint e) {
    const char* s;
    switch (e) {
            //EGL 1.0
        case EGL_SUCCESS:
            s = "EGL_SUCCESS";
            break;
        case EGL_NOT_INITIALIZED:
            s = "EGL_NOT_INITIALIZED";
            break;
        case EGL_BAD_ACCESS:
            s = "EGL_BAD_ACCESS";
            break;
        case EGL_BAD_ALLOC:
            s = "EGL_BAD_ALLOC";
            break;
        case EGL_BAD_ATTRIBUTE:
            s = "EGL_BAD_ATTRIBUTE";
            break;
        case EGL_BAD_CONTEXT:
            s = "EGL_BAD_CONTEXT";
            break;
        case EGL_BAD_CONFIG:
            s = "EGL_BAD_CONFIG";
            break;
        case EGL_BAD_CURRENT_SURFACE:
            s = "EGL_BAD_CURRENT_SURFACE";
            break;
        case EGL_BAD_DISPLAY:
            s = "EGL_BAD_DISPLAY";
            break;
        case EGL_BAD_SURFACE:
            s = "EGL_BAD_SURFACE";
            break;
        case EGL_BAD_MATCH:
            s = "EGL_BAD_MATCH";
            break;
        case EGL_BAD_PARAMETER:
            s = "EGL_BAD_PARAMETER";
            break;
        case EGL_BAD_NATIVE_PIXMAP:
            s = "EGL_BAD_NATIVE_PIXMAP";
            break;
        case EGL_BAD_NATIVE_WINDOW:
            s = "EGL_BAD_NATIVE_WINDOW";
            break;
        default:
            s = "UNDEFINED ERROR. Have you forgotten to add an EGL error ?";
            break;
    }
    return s;
}

const char * getEGLConfigAttributeName(EGLint a) {
    const char *s;
    switch (a) {
            // EGL [1.0...1.4]
        case EGL_BUFFER_SIZE:
            s = "EGL_BUFFER_SIZE";
            break;
        case EGL_RED_SIZE:
            s = "EGL_RED_SIZE";
            break;
        case EGL_GREEN_SIZE:
            s = "EGL_GREEN_SIZE";
            break;
        case EGL_BLUE_SIZE:
            s = "EGL_BLUE_SIZE";
            break;
        case EGL_ALPHA_SIZE:
            s = "EGL_ALPHA_SIZE";
            break;
        case EGL_CONFIG_CAVEAT:
            s = "EGL_CONFIG_CAVEAT";
            break;
        case EGL_CONFIG_ID:
            s = "EGL_CONFIG_ID";
            break;
        case EGL_DEPTH_SIZE:
            s = "EGL_DEPTH_SIZE";
            break;
        case EGL_LEVEL:
            s = "EGL_LEVEL";
            break;
        case EGL_MAX_PBUFFER_WIDTH:
            s = "EGL_MAX_PBUFFER_WIDTH";
            break;
        case EGL_MAX_PBUFFER_HEIGHT:
            s = "EGL_MAX_PBUFFER_HEIGHT";
            break;
        case EGL_MAX_PBUFFER_PIXELS:
            s = "EGL_MAX_PBUFFER_PIXELS";
            break;
        case EGL_NATIVE_RENDERABLE:
            s = "EGL_NATIVE_RENDERABLE";
            break;
        case EGL_NATIVE_VISUAL_ID:
            s = "EGL_NATIVE_VISUAL_ID";
            break;
        case EGL_NATIVE_VISUAL_TYPE:
            s = "EGL_NATIVE_VISUAL_TYPE";
            break;
        case EGL_SAMPLE_BUFFERS:
            s = "EGL_SAMPLE_BUFFERS";
            break;
        case EGL_SAMPLES:
            s = "EGL_SAMPLES";
            break;
        case EGL_STENCIL_SIZE:
            s = "EGL_STENCIL_SIZE";
            break;
        case EGL_SURFACE_TYPE:
            s = "EGL_SURFACE_TYPE";
            break;
        case EGL_TRANSPARENT_TYPE:
            s = "EGL_TRANSPARENT_TYPE";
            break;
        case EGL_TRANSPARENT_RED_VALUE:
            s = "EGL_TRANSPARENT_RED_VALUE";
            break;
        case EGL_TRANSPARENT_GREEN_VALUE:
            s = "EGL_TRANSPARENT_GREEN_VALUE";
            break;
        case EGL_TRANSPARENT_BLUE_VALUE :
            s = "EGL_TRANSPARENT_BLUE_VALUE";
            break;
        case EGL_LUMINANCE_SIZE:
            s = "EGL_LUMINANCE_SIZE";
            break;
        case EGL_ALPHA_MASK_SIZE:
            s = "EGL_ALPHA_MASK_SIZE";
            break;
        case EGL_BIND_TO_TEXTURE_RGB:
            s = "EGL_BIND_TO_TEXTURE_RGB";
            break;
        case EGL_BIND_TO_TEXTURE_RGBA:
            s = "EGL_BIND_TO_TEXTURE_RGBA";
            break;
        case  EGL_COLOR_BUFFER_TYPE:
            s = "EGL_COLOR_BUFFER_TYPE";
            break;
        case  EGL_CONFORMANT:
            s = "EGL_CONFORMANT";
            break;
        case  EGL_MATCH_NATIVE_PIXMAP:
            s = "EGL_MATCH_NATIVE_PIXMAP";
            break;
        case  EGL_MAX_SWAP_INTERVAL:
            s = "EGL_MAX_SWAP_INTERVAL";
            break;
        case  EGL_MIN_SWAP_INTERVAL:
            s = "EGL_MIN_SWAP_INTERVAL";
            break;
        case  EGL_RENDERABLE_TYPE:
            s = "EGL_RENDERABLE_TYPE";
            break;
        default:
            s = "UNDEFINED ATTRIBUTE. Have you forgotten to add an EGLConfig Attributer ?";
            break;
    }
    return s;
}

void getEGLConfigAttributeForEGLAPIVersion(EGLint major,
                                           EGLint minor,
                                           EGLint* attrs,
                                           EGLint* num_attrs) {
    
    *num_attrs = 0;
    switch (major) {
        case 1:
            switch (minor) {
                case 4:
                    *num_attrs = 32;
                    if (attrs != NULL) {
                        attrs[0]=EGL_BUFFER_SIZE;
                        attrs[1]=EGL_RED_SIZE;
                        attrs[2]=EGL_GREEN_SIZE;
                        attrs[3]=EGL_BLUE_SIZE;
                        attrs[4]=EGL_LUMINANCE_SIZE;
                        attrs[5]=EGL_ALPHA_SIZE;
                        attrs[6]=EGL_ALPHA_MASK_SIZE;
                        attrs[7]=EGL_BIND_TO_TEXTURE_RGB;
                        attrs[8]=EGL_BIND_TO_TEXTURE_RGBA;
                        attrs[9]=EGL_COLOR_BUFFER_TYPE;
                        attrs[10]=EGL_CONFIG_CAVEAT;
                        attrs[11]=EGL_CONFIG_ID;
                        attrs[12]=EGL_CONFORMANT;
                        attrs[13]=EGL_DEPTH_SIZE;
                        attrs[14]=EGL_LEVEL;
                        attrs[15]=EGL_MAX_PBUFFER_WIDTH;
                        attrs[16]=EGL_MAX_PBUFFER_HEIGHT;
                        attrs[17]=EGL_MAX_PBUFFER_PIXELS;
                        attrs[18]=EGL_MAX_SWAP_INTERVAL;
                        attrs[19]=EGL_MIN_SWAP_INTERVAL;
                        attrs[20]=EGL_NATIVE_RENDERABLE;
                        attrs[21]=EGL_NATIVE_VISUAL_ID;
                        attrs[22]=EGL_NATIVE_VISUAL_TYPE;
                        attrs[23]=EGL_RENDERABLE_TYPE;
                        attrs[24]=EGL_SAMPLE_BUFFERS;
                        attrs[25]=EGL_SAMPLES;
                        attrs[26]=EGL_STENCIL_SIZE;
                        attrs[27]=EGL_SURFACE_TYPE;
                        attrs[28]=EGL_TRANSPARENT_TYPE;
                        attrs[29]=EGL_TRANSPARENT_RED_VALUE;
                        attrs[30]=EGL_TRANSPARENT_GREEN_VALUE;
                        attrs[31]=EGL_TRANSPARENT_BLUE_VALUE;
                    }
                    break;
            }
    }
}


int to_String(char * s, EGLint n) {
    return sprintf(s, "%d", n);
}

void displayEGLConfig(EGLDisplay dpy, EGLConfig c, EGLint* attrs, EGLint num_attrs) {
    EGLint r = EGL_TRUE;
    for (EGLint j = 0; j<num_attrs && r == EGL_TRUE; j++) {
        EGLint a = attrs[j];
        EGLint v = 0;
        r = eglGetConfigAttrib(dpy,c,a,&v);
        std::stringstream ss;
        if (r == EGL_FALSE) {
            ss << std::hex << a;
            std::string result( ss.str() );
            std::stringstream s;
            s << "eglGetConfigAttrib: attribute: 0x" << result;
            logEGLError(s.str().c_str(), eglGetError());
        }
        char n[64];
        ss << "Attribute:\t " << getEGLConfigAttributeName(a)
        << "\tValue:\t" << (to_String(n, v), n);
        LOG(I, ss.str().c_str())
    }
}
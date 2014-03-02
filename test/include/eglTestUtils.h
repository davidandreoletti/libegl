//
//  eglTestUtils.h
//  eglTests
//
//  Created by David Andreoletti on 10/11/13.
//  Copyright (c) 2013 David Andreoletti. All rights reserved.
//

#ifndef TEST_INCLUDE_EGLTESTUTILS_H_
#define TEST_INCLUDE_EGLTESTUTILS_H_

#include "EGL/egl.h"

#define FREE(a)  \
    if (a != NULL) {    \
        free(((void*)a));   \
        a = NULL;           \
    }

#define STR_NULL(v) (v == NULL ? "NULL" : v)
#define INT_TO_STR(arr, num) ((to_String(arr, num) > 0 ) ? arr : "Truncated or Error" )

#define LOG(s, msg)                 logMessage1(s, msg);
#define LOG2(s, msg, msg2)          logMessage2(s, msg, msg2);
#define LOG3(s, msg, msg2, msg3)    logMessage3(s, msg, msg2, msg3);

typedef enum {
    F   = 4, // Fatal
    E   = 3, // Error
    W   = 2, // Warning
    I   = 1, // Info
    D   = 0  // Debug
} LoggerSeverity;

#ifdef __cplusplus
extern "C" {
#endif


void logMessage1(LoggerSeverity s, const char* msg);
void logMessage2(LoggerSeverity s, const char* msg, const char* msg2);
void logMessage3(LoggerSeverity s, const char* msg, const char* msg2, const char* msg3);

void logEGLError(const char * fName, EGLint err);

/**
 * Get string representation for a specfic EGL error
 *
 * \param e EGL error code
 * \retrun EGL error code string representation
 */
const char * getErrorString(EGLint e);

/**
 * Log an EGL function completion status
 *
 * \param fName EGL function name
 * \param err EGL error reported by function name
 */
void logEGLError(const char * fName, EGLint err);

/**
 * Get string representation for a specific EGLConfig attribute
 *
 * \param a EGConfig attribute
 * \return EGLCOnfig attribute string representation
 */
const char * getEGLConfigAttributeName(EGLint a);

/**
 * Gets all attributes available in an EGLConfig for different
 * EGL version
 *
 * \param major     EGL major number
 * \param minor     EGL minor number
 * \param attrs     Pointer to array
 *                  (array memeory will be initialized by the callee)
 * \param num_attrs Pointer to number of attributes in attributes. IF attrs is NULL
 *                  num_attrs returns the number of attributes in the EGLConfig
 *                  for the requested EGL version.
 */
void getEGLConfigAttributeForEGLAPIVersion(EGLint major,
                                           EGLint minor,
                                           EGLint* attrs,
                                           EGLint* num_attrs);

/**
 * Convert an integer to string
 * \param s String array to copy string representation of n
 * \param n Integer value
 *
 * \return Number of character copied. Negative value if failure
 */
int to_String(char * s, EGLint n);

/**
 *  Displays an EGLConfig on the standard output
 *  \param dpy Display
 *  \param c Config
 *  \param attrs EGL Attributes
 *  \param num_attrs Number of attribute
 */
void displayEGLConfig(EGLDisplay dpy,
                      EGLConfig c,
                      EGLint* attrs,
                      EGLint num_attrs);

#ifdef __cplusplus
}
#endif

#endif  // TEST_INCLUDE_EGLTESTUTILS_H_
//
//  \file eglmemory.h
//  libegl
//
//  Created by Andreoletti David.
//  Copyright 2013 IO Stark. All rights reserved.
//

#ifndef INCLUDE_EGL_EGLMEMORY_H_
#define INCLUDE_EGL_EGLMEMORY_H_

#include <stdlib.h>

/**
 *  Free memory
 */
#define FREE(ptr)   if (ptr != NULL) {      \
                        free(ptr);          \
                        ptr = NULL;         \
                    }

/**
 * Allocate memory to hold a type T
 */
#define MALLOC(t)           (t*) malloc(sizeof(t));  // NOLINT(*)

/**
 * Allocate n block of memory of type T
 */
#define MALLOC_ARRAY(t, n)  (t*) malloc(n * sizeof(t));  // NOLINT(*)

/**
 * Allocate array of type t with size n
 */
#define CALLOC_ARRAY(t, n)              (t*) calloc(n, sizeof(t));  // NOLINT(*)
#define REALLOC_ARRAY(t, n, p) (t*)     realloc((void*)p, n*sizeof(t));  // NOLINT(*)
#define REALLOC_ARRAY_MEM_MGT(t, n, p)                          \
    {                                   \
        t* op = p;                      \
        p = (t*) REALLOC_ARRAY(t, n, p) /* NOLINT(*) */\
        if (op != p) {FREE(op)}         \
    }

#endif  // INCLUDE_EGL_EGLMEMORY_H_

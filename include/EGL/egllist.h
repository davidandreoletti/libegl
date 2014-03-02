//
//  \file egllist.h
//  libegl
//
//  Created by Andreoletti David.
//  Copyright 2013 IO Stark. All rights reserved.
//

#ifndef INCLUDE_EGL_EGLLIST_H_
#define INCLUDE_EGL_EGLLIST_H_

#include <stdint.h>
#include "datastructure/list/linkedlist/dlinkedlist.h"

/**
 *  EGL list
 */
struct _egl_list {
    struct dlinkedlist_node     head;   /** List head */
    int_least32_t               size;   /** List size */
};

#endif  // INCLUDE_EGL_EGLLIST_H_


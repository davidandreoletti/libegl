//
//  \file eglapi.m
//  libegl
//
//  Created by Andreoletti David.
//  Copyright 2013 IO Stark. All rights reserved.
//

//#define _EGL_VERSION_MAJOR 1
//#define _EGL_VERSION_MINOR 4

//
///**
// * Casts a member of a structure out to the containing structure
// * \param cType     the type of containing structure holding the member.
// *                  eg: Assuming struct MyType
// *                      {
// *                          int myMember0,
// *                          short myMember1
// *                      };
// struct MyType p* = ...
// *                      then pass MyType as parameter
// * \param mPtr      Pointer to the member mName
// *                  eg: Pass &p.myMember1
// * \param mName     the name of the member within the struct.
// *                  eg: Pass myMember1
// * \param mType     the type of the container struct this is embedded in.
// *                  eg: Pass short as parameter
// *
// *  Rationale: Linux kernel has a better macro "container_of(...) BUT it relies
// *  on:
// *  - typeof keyword not defined in C89/C99 (GNU/Clang compilers implements it as
// *  GNU typeof extension).
// *  - GNU statement expression. (GNU/Clang compilers implements it as
// *  GNU statement expression extension.)
// *
// *  This code aims to be cross platform and cross compiler. Hence no compiler
// *  extension is used at the cost of providing the exact member type"
// */
//#define container_of(cType, mPtr, mName, mType) (                              \
//(cType *)( (char *)((const mType *)(mPtr))-offsetof(cType, mName) ))  /** NOLINT(*) */
//
///**
// * Gets the struct for this entry
// * \param   cType  the type of the container the member is embbeded in.
// * \param   mPtr   the address of member within structure.
// * \param   mName  the name of the member within the struct.
// * \param   mType  the type of the member within structure
// */
//#define list_entry(cType, mPtr, mName, mType)                                  \
//container_of(cType, mPtr, mName, mType)
//
///**
// * For loop as long as condition is met
// * \param c         Pointer to container holding the mName.
// * \param cType     Type of the container
// * \param mName     Name of the member holding a list node.
// * \param mType     Type of the member holding a list node.
// * \param mPtrHead  Pointer to the head of the list.
// * \param cnd       Condition to continue the loop
// */
//#define list_for_until_condition(c, cType, mPtrHead, mName, mType, cnd)        \
//for (c = list_entry(cType, (mPtrHead)->next, mName, mType);                \
//(&c->mName != (mPtrHead)) && (cnd);                                       \
//c = list_entry(cType, c->mName.next, mName, mType))
//
//
///**
// *  Inits a list
// *  \param head List head to init
// *  \param size List size
// */
//void list_init_head(struct dlinkedlist_node* head, int_least32_t* size);
//
///**
// * Find a list's tail
// * \param head List head
// * \return List's tail
// */
//struct dlinkedlist_node* list_find_tail(struct _egl_list* head);
//
///**
// * Adds a node newnode after node
// *
// * \param node Node to append to
// * \param newnode Node to append
// */
//void list_add_after(struct _egl_list* list,
//                    struct dlinkedlist_node* newnode,
//                    struct dlinkedlist_node* node);
//
///**
// * Duplicates a list
// *
// * \param head List head
// * \param list_size Current list size
// */
//void list_duplicate(struct dlinkedlist_node* head, uint32_t list_size);
//
//void list_init_head(struct dlinkedlist_node* head, int_least32_t* size) {
//    dlinkedlist_init_head(head, size);
//}
//
//struct dlinkedlist_node* list_find_tail(struct _egl_list* list) {
//    return list->head.prev;
//}
//
//void list_add_after(struct _egl_list* list,
//                    struct dlinkedlist_node* newnode,
//                    struct dlinkedlist_node* node) {
//    dlinkedlist_add_after(node, newnode, &(list->size));
//}
//
//
//
//void* freeNodeEGLPlafromConfig(struct dlinkedlist_node* n) {
//    _EGLPlatformConfig* c = list_entry(_EGLPlatformConfig,
//                                       n,
//                                       list_node,
//                                       struct dlinkedlist_node);
//    FREE(c)
//    return NULL;
//}
//
///**
// * Convert EGLConfig into platform specific config
// *
// * \param c An EGL config
// * \param pc A platform specific config
// *
// * \return EGL_TRUE if successful convertion.
// */
////EGLBoolean to_EGLPlatformConfig(_EGLConfig* c, _EGLPlatformConfig* pc) {
////    if (c->colorbuffer_redSize >= 8
////        || c->colorbuffer_greenSize >= 8
////        || c->colorbuffer_blueSize >= 8) {
////        pc->colorbuffer_format = kEAGLColorFormatRGBA8;
////    } else {
////        pc->colorbuffer_format = kEAGLColorFormatRGB565;
////    }
////
////    if (c->renderableType == EGL_OPENGL_ES_BIT) {
////        pc->depth_component = 0;
////        if (c->depthbuffer_size == 16) {
////            // Defined in OpenGL ES extension "OES_framebuffer_object"
////            // Available on PowerVR SGX (iPhone 3GX and onwards)
////            pc->depth_component = GL_DEPTH_COMPONENT16_OES;
////        }
////    } else if (c->renderableType == EGL_OPENGL_ES2_BIT) {
////        pc->depth_component = 0;
////        if (c->depthbuffer_size == 16) {
////            // Defined in OpenGL ES 2.x
////            // Available on PowerVR SGX (iPhone 3GX and onwards)
////            pc->depth_component = GL_DEPTH_COMPONENT16;
////        }
////    }
////
////    pc->drawable_retained_backing_after_display = NO;
////
////    // EGL 1.3
////    switch (c->renderableType) {
////        case EGL_OPENGL_ES_BIT:
////            pc->api_version = kEAGLRenderingAPIOpenGLES1; // since iOS 2 TODO: Guard it + do in reverse function
////            break;
////        case EGL_OPENGL_ES2_BIT:
////            pc->api_version = kEAGLRenderingAPIOpenGLES2; // since iOS 3 TODO: Guard it + do in reverse function
////            break;
////        default:
////            pc->api_version = kEAGLRenderingAPIOpenGLES1;
////            break;
////    }
////    return true;
////}
//
///**
// * Convert platform specific config into _EGLConfig
// *
// * @param pc Platform specific config
// * @param c EGLConfig
// *
// * @return EGL_TRUE if successful convertion
// */
////EGLBoolean to_EGLConfig(_EGLPlatformConfig* pc, _EGLConfig* c) {
////   if (pc->colorbuffer_format == kEAGLColorFormatRGBA8) {
////        c->colorbuffer_redSize      = 8;
////        c->colorbuffer_greenSize    = 8;
////        c->colorbuffer_blueSize     = 8;
////        c->colorbuffer_alphaSize    = 8;
////   } else {
////        c->colorbuffer_redSize      = 5;
////        c->colorbuffer_greenSize    = 6;
////        c->colorbuffer_blueSize     = 5;
////        c->colorbuffer_alphaSize    = 0;
////   }
////
////    if (pc->api_version == kEAGLRenderingAPIOpenGLES1) {
////        c->depthbuffer_size = 0;
////        if (pc->depth_component == GL_DEPTH_COMPONENT16_OES) {
////            c->depthbuffer_size = 16;
////        }
////    }
////    else if (pc->api_version == kEAGLRenderingAPIOpenGLES2) {
////        c->depthbuffer_size = 0;
////        if (pc->depth_component == GL_DEPTH_COMPONENT16) {
////            c->depthbuffer_size = 16;
////        }
////    }
////
////    // pc->drawable_retained_backing_after_display has no matching in EGLConfig
////    // EGL 1.3
////    switch (pc->api_version) {
////        case kEAGLRenderingAPIOpenGLES1:
////            c->renderableType = EGL_OPENGL_ES_BIT;
////            break;
////        case kEAGLRenderingAPIOpenGLES2:
////            c->renderableType = EGL_OPENGL_ES2_BIT;
////            break;
////        default:
////            c->renderableType = -1;
////            break;
////    }
////
////    c->platformConfig = (void *) pc;
////    return true;
////}
//
////
////  EGL 1.0
////
////_EGLDisplay* GetDisplay (_EGLDriver* drv, const char* display_id) {
////    _EGLDisplay* d = MALLOC(_EGLDisplay)
////    if (EGL_DEFAULT_DISPLAY == display_id) {
////
////   }
////   return d;
////}
//
////EGLBoolean Initialize (_EGLDriver* drv, _EGLDisplay *dpy) {
//////    if (EGL_DEFAULT_DISPLAY == dpy->) {
//////        dpy->impl = (EGLDisplay*) [[UIApplication sharedApplication] keyWindow];
//////        dpy->eglAPIVersion.major = _EGL_VERSION_MAJOR;
//////        dpy->eglAPIVersion.minor = _EGL_VERSION_MINOR;
//////        dpy->eglAPIClients = "OpenGL_ES\0";
//////        return EGL_TRUE;
//////   }
////   return EGL_FALSE;
////}
//
//EGLBoolean Terminate (_EGLDriver* drv, _EGLDisplay *dpy) {
//    // TODO
//    return EGL_FALSE;
//}
//
//const char** QueryString (_EGLDriver *drv, _EGLDisplay *dpy, EGLint name, EGLint* num_r) {
//    char* v2;
//    switch (name) {
//        case EGL_CLIENT_APIS:
//        case EGL_VERSION:
//        case EGL_VENDOR: {
//            char** v = CALLOC_ARRAY(char*, 1)
//            v2 = CALLOC_ARRAY(char, 1)
//            *v2 = '\0';
//            *num_r = 0;
//            v = &v2;
//            return (const char**)v;
//        }
//        case EGL_EXTENSIONS: {
//            char** v = CALLOC_ARRAY(char*, 1)
//            v2 = CALLOC_ARRAY(char, 1)
//            *v2 = '\0';
//            *num_r = 0;
//            v = &v2;
//            return (const char**)v;
//        }
//        default: {
//            char** v = NULL;
//            return (const char**)v;
//        }
//    }
//}
//
///**
// * Duplicates a config and add it to a list if a condition is satisfy
// *
// * @param cnd   Condition to satisfy
// * @param c     Pointer to a config of type T
// * @param cT    Config of type T
// * @param lt    Pointer to list Tail to add c to
// * @param ls    List size to increment upon
// */
//#define DUPLICATE_CONFIG_AND_ADD_TO_LIST_ON_CONDITION(cnd, c, cT, lt, ls)   \
//    if (cnd) {                                                          \
//        c = MALLOC(cT);                                                 \
//        *c = *lt;                                                       \
//        list_add(c, lt);                                                \
//        lt = c;                                                         \
//        ls++;                                                           \
//    }
//
///**
// * Duplicates a list
// * \param l         List to duplicate (of type _egl_list)
// * \param l1        List to duplicate to (of type _egl_list)
// *                  (will be initialized to empty list)
// * \param eType     Type of containing structure holding the member.
// * \param mName     Name of the member in the structure
// * \param mType     Type of the member in the structure
// */
//#define DUPLICATE_LIST(l, l1, eType, mName, mType)                             \
//    {                                                                          \
//        list_init_head(&l1.head, &l1.size);                                    \
//        mType* m = NULL;                                                       \
//        /**mType* p = &l1.head;                                               */\
//        dlinkedlist_for_each(&l.head, m) {                                     \
//            eType* e = list_entry(eType, m, mName, mType);                     \
//            eType* ne = MALLOC(eType)                                          \
//            *ne = *e;                                                          \
//            list_init_head(&ne->mName, NULL);                                   \
//            list_add_after(&l1, &ne->mName, list_find_tail(&l1));              \
//        }                                                                      \
//    }
//
//
//EGLBoolean GetConfigs ( _EGLDriver *drv,
//                        _EGLDisplay *dpy,
//                        _EGLConfig *configs,
//                        EGLint config_size,
//                        EGLint *num_config) {
//    // Defined in OpenGLES/EAGL.h
//    int renderingAPICount = 2;
//    int api_versions[renderingAPICount];
//    api_versions[0] = kEAGLRenderingAPIOpenGLES1;
//    api_versions[1] = kEAGLRenderingAPIOpenGLES2;
//
//    // Defined in OpenGLES/EAGLDrawable.h
//    int colorFormatCount = 2;
//    NSString* colorformats[colorFormatCount];
//    colorformats[0] = kEAGLColorFormatRGBA8;
//    colorformats[1] = kEAGLColorFormatRGB565;
//
//    // Defined in OpenGLES/EAGLDrawable.h
//    int retainBackingCount = 1;
//    int retainbackings[retainBackingCount];
//    retainbackings[0] = NO;
//
//    struct _egl_list cfgList;
//    struct _egl_list cfgList2;
//    list_init_head(&cfgList.head, &cfgList.size);
//    list_init_head(&cfgList2.head, &cfgList2.size);
//    _EGLPlatformConfig* cf = MALLOC(_EGLPlatformConfig);
//    struct dlinkedlist_node* n = NULL;
//    for (int a=0;a<renderingAPICount;a++) {
//        if (cfgList.size != 0) {
//            DUPLICATE_LIST(cfgList,
//                           cfgList2,
//                           _EGLPlatformConfig,
//                           list_node,
//                           struct dlinkedlist_node)
//        }
//        else {
//            list_add_after(&cfgList, &cf->list_node, list_find_tail(&cfgList));
//        }
//
//        dlinkedlist_for_each(((a == 0) ? &(cfgList.head) : &(cfgList2.head)), n) {
//            cf = list_entry(_EGLPlatformConfig,
//                            n,
//                            list_node,
//                            struct dlinkedlist_node);
//            cf->api_version = api_versions[a];
//        }
//
//        dlinkedlist_splice(&cfgList2.head,
//                           &cfgList.head,
//                           &cfgList2.size,
//                           &cfgList.size);
//
//        for (int b=0;b<colorFormatCount;b++) {
//            if (b != 0) {
//                DUPLICATE_LIST(cfgList,
//                               cfgList2,
//                               _EGLPlatformConfig,
//                               list_node,
//                               struct dlinkedlist_node)
//            }
//
//            dlinkedlist_for_each(((b == 0) ? &(cfgList.head) : &(cfgList2.head)), n) {
//                cf = list_entry(_EGLPlatformConfig,
//                                n,
//                                list_node,
//                                struct dlinkedlist_node);
//                cf->colorbuffer_format = colorformats[b];
//            }
//
//            dlinkedlist_splice(&cfgList2.head,
//                               &cfgList.head,
//                               &cfgList2.size,
//                               &cfgList.size);
//
//            bool done = false;
//            for (int c=0;!done;c++) {
//                int* depths;
//                int depthsCount = 0;
//                switch (api_versions[a]) {
//                    case kEAGLRenderingAPIOpenGLES1:
//                    {
//                        depthsCount = 1;
//                        int depthsArr[depthsCount];
//                        depthsArr[0] = GL_DEPTH_COMPONENT16;
//                        depths = &depthsArr[0];
//                        done = true;
//                        break;
//                    }
//                    case kEAGLRenderingAPIOpenGLES2:
//                    {
//                        depthsCount = 1;
//                        int depthsArr[depthsCount];
//                        depthsArr[0] = GL_DEPTH_COMPONENT16;
//                        depths = &depthsArr[0];
//                        done = true;
//                        break;
//                    }
//                    default: {break;}
//                }
//
//                if (c != 0) {
//                    DUPLICATE_LIST(cfgList,
//                                   cfgList2,
//                                   _EGLPlatformConfig,
//                                   list_node,
//                                   struct dlinkedlist_node)
//                }
//
//                dlinkedlist_for_each(((c == 0) ? &(cfgList.head) : &(cfgList2.head)), n) {
//                    cf = list_entry(_EGLPlatformConfig,
//                                    n,
//                                    list_node,
//                                    struct dlinkedlist_node);
//                    cf->depth_component = depths[c];
//                }
//
//                dlinkedlist_splice(&cfgList2.head,
//                                   &cfgList.head,
//                                   &cfgList2.size,
//                                   &cfgList.size);
//
//
//                for (int d=0;d<retainBackingCount;d++) {
//                    if (d != 0) {
//                        DUPLICATE_LIST(cfgList,
//                                       cfgList2,
//                                       _EGLPlatformConfig,
//                                       list_node,
//                                       struct dlinkedlist_node)
//                    }
//
//                    dlinkedlist_for_each(((d == 0) ? &(cfgList.head) : &(cfgList2.head)), n) {
//                        cf = list_entry(_EGLPlatformConfig,
//                                        n,
//                                        list_node,
//                                        struct dlinkedlist_node);
//                        cf->drawable_retained_backing_after_display = retainbackings[d];
//                    }
//
//                    dlinkedlist_splice(&cfgList2.head,
//                                       &cfgList.head,
//                                       &cfgList2.size,
//                                       &cfgList.size);
//                }
//            }
//        }
//    }
//
//    *num_config = cfgList.size;
//    if (configs != NULL) {
//        *num_config = config_size > *num_config ? *num_config : config_size;
//        int i = 0;
//        _EGLPlatformConfig* c = NULL;
//        list_for_until_condition(c, _EGLPlatformConfig, &cfgList.head, list_node, struct dlinkedlist_node, (i < *num_config)) {
//            c = list_entry(_EGLPlatformConfig,
//                           &c->list_node,
//                           list_node,
//                           struct dlinkedlist_node);
//            __egl_EGLConfigCreateWithDefaultValue(&configs[i]);
//            configs[i].configId = i + 1;
//            to_EGLConfig(c,&configs[i]);
//            //list_init_head(&c->list_node, NULL);
//            i++;
//        }
//    }
//    return EGL_TRUE;
//}
//
//_EGLContext *CreateContext (_EGLDriver *drv, _EGLDisplay *dpy, _EGLConfig *config, _EGLContext *share_list, const EGLint *attrib_list) {
////    EGLContextImpl ctx = createOpenGLContext(*attrib_list);
////    return ctx.context;
//    return NULL;
//}
//
//_EGLSurface *CreateWindowSurface (_EGLDriver *drv, _EGLDisplay *dpy, _EGLConfig *config, EGLNativeWindowType window, const EGLint *attrib_list) {
//    return NULL;
//}
//_EGLSurface *CreatePbufferSurface (_EGLDriver *drv, _EGLDisplay *dpy, _EGLConfig *config, const EGLint *attrib_list) {
//    return NULL;
//}
//_EGLSurface *CreatePixmapSurface (_EGLDriver *drv, _EGLDisplay *dpy, _EGLConfig *config, EGLNativePixmapType pixmap, const EGLint *attrib_list) {
//    return NULL;
//}
//EGLBoolean DestroySurface (_EGLDriver *drv, _EGLDisplay *dpy, _EGLSurface *surface) {
//    return EGL_FALSE;
//}
//EGLBoolean QuerySurface (_EGLDriver *drv, _EGLDisplay *dpy, _EGLSurface *surface, EGLint attribute, EGLint *value) {
//return EGL_FALSE;
//}
//EGLBoolean DestroyContext (_EGLDriver *drv, _EGLDisplay *dpy, _EGLContext *ctx) {
//return EGL_FALSE;
//}
//
//EGLBoolean MakeCurrent (_EGLDriver *drv, _EGLDisplay *dpy, _EGLSurface *draw, _EGLSurface *read, _EGLContext *ctx) {
////    [EAGLContext setCurrentContext: ctx];
//    return EGL_FALSE;
//}
//
//_EGLSurface* GetCurrentSurface (_EGLDriver *drv, EGLint readdraw) {
//    return NULL;
//}
//_EGLDisplay GetCurrentDisplay (_EGLDriver *drv, _EGLContext *ctx) {
//    _EGLDisplay d;
//    return d;
//}
//EGLBoolean QueryContext (_EGLDriver *drv, _EGLDisplay *dpy, _EGLContext *ctx, EGLint attribute, EGLint *value) {
//    return EGL_FALSE;
//}
//EGLBoolean WaitGL (_EGLDriver *drv) {
//    return EGL_FALSE;
//}
//EGLBoolean WaitNative (_EGLDriver *drv, _EGLDisplay *dpy, EGLint engine) {
//    return EGL_FALSE;
//}
//EGLBoolean SwapBuffers (_EGLDriver *drv, _EGLDisplay *dpy, _EGLSurface *draw) {
//    return EGL_FALSE;
//}
//EGLBoolean CopyBuffers (_EGLDriver *drv, _EGLDisplay *dpy, _EGLSurface *surface, EGLNativePixmapType target) {
//    return EGL_FALSE;
//}

//
////void egl_setEGLDisplay(UIWindow* displays, EGLint num_displays) {
////    if (displays == NULL || num_displays < 1) {return;}
////    FREE(_displays);
////    _displays = CALLOC_ARRAY(_EGLDisplay, num_displays);
////    _num_displays = num_displays;
////    for (int i=0; i<num_displays; i++) {
////        _displays[i].display = displays[i];
////        _displays[i].surface_impl = NULL;
////    }
////}
//
/////**
//// * Creates OpenGL ES context
//// * \param v OpenGL ES version
//// * \param An OpenGL Context or NULL.
//// */
////_EGLContextImpl __egl_createOpenGLESContext(OpenGLESVersion v) {
////    _EGLContextImpl c;
////    switch (v) {
////        case OPENGL_ES_1_X:
////            c.ctx_impl = [[EAGLContext alloc]
////                         initWithAPI: kEAGLRenderingAPIOpenGLES1];
////            break;
////        case OPENGL_ES_2_X:
////            c.ctx_impl = [[EAGLContext alloc]
////                         initWithAPI: kEAGLRenderingAPIOpenGLES2];
////            break;
////        default:
////            c.ctx_impl = NULL;
////    }
////    return c;
////}
////
/////**
//// * Destroys OpenGL ES context
//// * \param ctx OpenGL ES context
//// */
////void __egl_destroyOpenGLESContext(_EGLContextImpl* ctx) {
////
////}
////
/////**
//// * Gathers OpenGL Pixel formats for OpenGL ES Core or Open GL ES Extension
//// * \param pixelformat Array of pixel formats
//// * \param num_pixelformat Number of pixel formats in array
//// * \param openGLESExt Look for Pixel Format in OpenGL ES Extension name OR NULL for OpenGL ES Core.
//// * \param sType Look for Pixel Format for surface type.
//// */
////void __egl_gatherOpenGLPixelFormat(   EGLint* pixelformat,
////                                EGLint* num_pixelformat,
////                                const char* openGLESExt,
////                                _SurfaceType sType) {
////    switch (sType) {
////        case SURFACE_TYPE_WINDOW:
////            if (openGLESExt == NULL) {
////                *num_pixelformat = 2;
////                EGLint* a = CALLOC_ARRAY(EGLint, *num_pixelformat)
////                a[0] = GL_RGBA8_OES;
////                a[1] = GL_RGB565;
////                pixelformat = a;
////            }
////            else {
////                *num_pixelformat = 0;
////            }
////            break;
////        case SURFACE_TYPE_PBUFFER:
////            if (openGLESExt == NULL) {
////                *num_pixelformat = 3;
////                EGLint* a = CALLOC_ARRAY(EGLint, *num_pixelformat)
////                a[0] = GL_RGBA4;
////                a[1] = GL_RGB5_A1;
////                a[2] = GL_RGB565;
////                pixelformat = a;
////            }
////            else {
////                *num_pixelformat = 0;
////            }
////            break;
////        case SURFACE_TYPE_PIXMAP:
////            if (openGLESExt == NULL) {
////                *num_pixelformat = 0;
////            }
////            else {
////                *num_pixelformat = 0;
////            }
////            break;
////        default:
////            *num_pixelformat = 0;
////            break;
////    }
////}
////
/////**
//// * Gathers OpenGL Depth Buffer sizes (in bits) in currently binded depth buffer
//// *
//// * \param depths Array of depth
//// * \param num_depths Number of depths in array
//// * \param openGLESExt Look for Pixel Format in OpenGL ES Extension name OR NULL for OpenGL ES Core.
//// * \param sType Look for Pixel Format for surface type.
//// */
////void __egl_gatherOpenGLDepthBufferZ(  EGLint* depths,
////                                EGLint* num_depths,
////                                const char* openGLESExt,
////                                _SurfaceType sType) {
////    switch (sType) {
////        case SURFACE_TYPE_WINDOW:
////            if (openGLESExt == NULL) {
////                *depths = 1;
////                EGLint* a = CALLOC_ARRAY(EGLint, *num_depths)
////                glGetRenderbufferParameteriv(GL_RENDERBUFFER,
////                                             GL_RENDERBUFFER_DEPTH_SIZE,
////                                             &a[0]);
////                depths = a;
////            }
////            else {
////                *num_depths = 0;
////            }
////            break;
////        case SURFACE_TYPE_PBUFFER:
////                *num_depths = 0;
////            break;
////        case SURFACE_TYPE_PIXMAP:
////                *num_depths = 0;
////            break;
////        default:
////            *num_depths = 0;
////            break;
////    }
////}
////
/////**
//// * Gathers PBBuffer dimensions OpenGL ES
//// *
//// * \param dimensions Array of dimensions. [0] width, [1] heigth
//// * \param num_dimensions Number of dimensions in array
//// * \param openGLESExt Look for Pixel Format in OpenGL ES Extension name OR NULL for OpenGL ES Core.
//// * \param sType Look for Pixel Format for surface type.
//// */
////void __egl_gatherOpenGLPBBufferDimensions(  EGLint* dimensions,
////                                      EGLint* num_dimensions,
////                                      const char* openGLESExt,
////                                      _SurfaceType sType) {
////    switch (sType) {
////        case SURFACE_TYPE_WINDOW:
////            *num_dimensions = 0;
////            break;
////        case SURFACE_TYPE_PBUFFER:
////            *num_dimensions = 0;
////            break;
////        case SURFACE_TYPE_PIXMAP:
////            *num_dimensions = 0;
////            break;
////        default:
////            *num_dimensions = 0;
////            break;
////    }
////}
////
/////**
//// * Gathers PBBuffer Size OpenGL ES
//// *
//// * \param sizes Array of dimensions. [0] width, [1] heigth
//// * \param num_sizes Number of dimensions in array
//// * \param openGLESExt Look for Pixel Format in OpenGL ES Extension name OR NULL for OpenGL ES Core.
//// * \param sType Look for Pixel Format for surface type.
//// */
////void __egl_gatherOpenGLPBBufferSize(  EGLint* sizes,
////                                EGLint* num_sizes,
////                                const char* openGLESExt,
////                                _SurfaceType sType) {
////    switch (sType) {
////        case SURFACE_TYPE_WINDOW:
////            *num_sizes = 1;
////            sizes[0] = 0;
////            break;
////        case SURFACE_TYPE_PBUFFER:
////            *num_sizes = 0;
////            break;
////        case SURFACE_TYPE_PIXMAP:
////            *num_sizes = 0;
////            break;
////        default:
////            *num_sizes = 0;
////            break;
////    }
////}
////
/////**
//// * Gathers OpenGL ES Sample buffer
//// *
//// * \param sizes Array of dimensions. [0] width, [1] heigth
//// * \param num_sizes Number of dimensions in array
//// * \param openGLESExt Look for Pixel Format in OpenGL ES Extension name OR NULL for OpenGL ES Core.
//// * \param sType Look for Pixel Format for surface type.
//// */
////void __egl_gatherOpenGLSampleBuffers(   EGLint* sizes,
////                                  EGLint* num_sizes,
////                                  const char* openGLESExt,
////                                  _SurfaceType sType) {
////    switch (sType) {
////        case SURFACE_TYPE_WINDOW:
////            *num_sizes = 1;
////            sizes[0] = 0;
////            break;
////        case SURFACE_TYPE_PBUFFER:
////            *num_sizes = 0;
////            break;
////        case SURFACE_TYPE_PIXMAP:
////            *num_sizes = 0;
////            break;
////        default:
////            *num_sizes = 0;
////            break;
////    }
////}
////
/////**
//// * Gathers OpenGL ES Samples
//// *
//// * \param sizes Array of dimensions. [0] width, [1] heigth
//// * \param num_sizes Number of dimensions in array
//// * \param openGLESExt Look for Pixel Format in OpenGL ES Extension name OR NULL for OpenGL ES Core.
//// * \param sType Look for Pixel Format for surface type.
//// */
////void __egl_gatherOpenGLSamples(  EGLint* sizes,
////                           EGLint* num_sizes,
////                           const char* openGLESExt,
////                           _SurfaceType sType) {
////    switch (sType) {
////        case SURFACE_TYPE_WINDOW:
////            *num_sizes = 1;
////            sizes[0] = 0;
////            break;
////        case SURFACE_TYPE_PBUFFER:
////            *num_sizes = 0;
////            break;
////        case SURFACE_TYPE_PIXMAP:
////            *num_sizes = 0;
////            break;
////        default:
////            *num_sizes = 0;
////            break;
////    }
////}
////
/////**
//// * Gathers OpenGL ES Samples
//// *
//// * \param sizes Array of dimensions. [0] width, [1] heigth
//// * \param num_sizes Number of dimensions in array
//// * \param openGLESExt Look for Pixel Format in OpenGL ES Extension name OR NULL for OpenGL ES Core.
//// * \param sType Look for Pixel Format for surface type.
//// */
////void __egl_gatherOpenGLStencilBufferSize(  EGLint* sizes,
////                                     EGLint* num_sizes,
////                                     const char* openGLESExt,
////                                     _SurfaceType sType) {
////    switch (sType) {
////        case SURFACE_TYPE_WINDOW:
////            *num_sizes = 1;
////            sizes[0] = 0;
////            break;
////        case SURFACE_TYPE_PBUFFER:
////            *num_sizes = 0;
////            break;
////        case SURFACE_TYPE_PIXMAP:
////            *num_sizes = 0;
////            break;
////        default:
////            *num_sizes = 0;
////            break;
////    }
////}
////
////
////
/////**
//// * Gather Color component bit size from currently binded color buffer
//// * \param sType Surface type
//// * \param sizes [0] Red bits, [1] Green bits, [2] Blue bits, [3] Alpha bits
//// * \param num_sizes Number of sizes gathered.
//// */
////void __egl_gatherColorRenderBufferComponentColorBits(_SurfaceType sType, EGLint* sizes,
////                                               EGLint* num_sizes) {
////    switch (sType) {
////        case SURFACE_TYPE_WINDOW:
////            glGetRenderbufferParameteriv(GL_RENDERBUFFER,
////                                         GL_RENDERBUFFER_RED_SIZE,
////                                         &sizes[0]);
////            glGetRenderbufferParameteriv(GL_RENDERBUFFER,
////                                         GL_RENDERBUFFER_GREEN_SIZE,
////                                         &sizes[1]);
////            glGetRenderbufferParameteriv(GL_RENDERBUFFER,
////                                         GL_RENDERBUFFER_BLUE_SIZE,
////                                         &sizes[2]);
////            glGetRenderbufferParameteriv(GL_RENDERBUFFER,
////                                         GL_RENDERBUFFER_ALPHA_SIZE,
////                                         &sizes[3]);
////            *num_sizes = 4;
////            break;
////        default:
////            break;
////    }
////}
////
/////**
//// * EGL Public API 1.0
//// */
////
////EGLAPI const char * APIENTRY eglQueryString(EGLDisplay dpy, EGLint name) {
////    if (!__egl_isEGLInitializedOnDisplay(dpy)) {
////        __egl_setEGLError(EGL_NOT_INITIALIZED);
////        return NULL;
////    }
////    switch (name) {
////        case EGL_VENDOR:
////            __egl_setEGLError(EGL_SUCCESS);
////            return "libegl-Apple-iOS";
////        case EGL_VERSION:
////            __egl_setEGLError(EGL_SUCCESS);
////            int n=3;
////            int arraySize = n*sizeof(char);
////            char* v = CALLOC_ARRAY(char, n)
////            snprintf(v, arraySize,"%d.%d",EGL_MAJOR,EGL_MINOR);
////            return v;
////        case EGL_EXTENSIONS:
////            __egl_setEGLError(EGL_SUCCESS);
////            return "";
////        default:
////            __egl_setEGLError(EGL_BAD_PARAMETER);
////            return NULL;
////    }
////}
////
////EGLAPI EGLBoolean APIENTRY eglGetConfigs(EGLDisplay dpy, EGLConfig *configs,
////                                         EGLint config_size, EGLint *num_config) {
////    _EGLDisplay d = __egl_findDisplayByEGLDisplay(dpy,_displays,_num_displays);
////    if (d.display.impl == EGL_NO_DISPLAY) {
////        __egl_setEGLError(EGL_BAD_DISPLAY); return EGL_FALSE;
////    }
////    if (!__egl_isEGLInitializedOnDisplay(dpy)) {
////        __egl_setEGLError(EGL_NOT_INITIALIZED); return EGL_FALSE;
////    }
////    if (num_config == NULL) {
////        __egl_setEGLError(EGL_BAD_PARAMETER); return EGL_FALSE;
////    }
////    EGLint num_configs2;
////    _EGLConfig* configs2 = NULL;
////    __egl_gatherEGLConfigs(configs2, &num_configs2);
////    if (configs == NULL) {
////        *num_config = num_configs2;
////        return EGL_TRUE;
////    }
////    *num_config = config_size > num_configs2 ? num_configs2 : config_size;
////    for (EGLint i=0;i<*num_config;i++) {
////        configs[i] = configs2[i].impl;
////    }
////    FREE(configs2)
////    return EGL_TRUE;
////}
////
/////**
//// * Indicates if attribute value is valid for an attribute name
//// * \param c A config
//// * \return EGL_SUCCESS if all values are valid.
//// */
////EGLint checkValidConf(_EGLConfig* c) {
////
////    c->samples
////
////    switch (an) {
////        case EGL_BUFFER_SIZE:
////        case EGL_RED_SIZE:
////        case EGL_GREEN_SIZE:
////        case EGL_BLUE_SIZE:
////        case EGL_ALPHA_SIZE:
////        case EGL_CONFIG_ID:
////        case EGL_DEPTH_SIZE:
////        case EGL_LEVEL:
////        case EGL_NATIVE_RENDERABLE:
////        case EGL_NATIVE_VISUAL_TYPE:
////        case EGL_SAMPLE_BUFFERS:
////        case EGL_SAMPLES:
////        case EGL_STENCIL_SIZE:
////            if (av < EGL_DONT_CARE) {
////                __egl_setEGLError(EGL_BAD_PARAMETER);
////                return EGL_FALSE;
////            }
////            return EGL_TRUE;
////            break;
////        case EGL_CONFIG_CAVEAT:
////            if (av == EGL_NONE
////                || av == EGL_SLOW_CONFIG
////                || av == EGL_NON_CONFORMANT_CONFIG) {
////                return EGL_TRUE;
////            }
////            return EGL_FALSE;
////            break;
////        case EGL_SURFACE_TYPE:
////            if (av == EGL_WINDOW_BIT
////                || av == EGL_PIXMAP_BIT
////                || av == EGL_PBUFFER_BIT) {
////                return EGL_TRUE;
////            }
////            return EGL_FALSE;
////            break;
////        case EGL_TRANSPARENT_TYPE:
////            ac.transparentType = av;
////            break;
////        default:
////            __egl_setEGLError(EGL_BAD_ATTRIBUTE);
////            return EGL_FALSE;
////            break;
////    }
////
////
////
////    if (av < EGL_DONT_CARE) {
////        __egl_setEGLError(EGL_BAD_PARAMETER);
////        return EGL_FALSE;
////    }
////    return EGL_TRUE;
////}
////
////EGLAPI EGLBoolean APIENTRY eglChooseConfig(EGLDisplay dpy, const EGLint *attrib_list,
////                                           EGLConfig *configs, EGLint config_size,
////                                           EGLint *num_config) {
////    _EGLDisplay d = __egl_findDisplayByEGLDisplay(dpy,_displays,_num_displays);
////    if (d.display.impl == EGL_NO_DISPLAY) {
////        __egl_setEGLError(EGL_BAD_DISPLAY); return EGL_FALSE;
////    }
////    if (!__egl_isEGLInitializedOnDisplay(dpy)) {
////        __egl_setEGLError(EGL_NOT_INITIALIZED); return EGL_FALSE;
////    }
////    if (num_config == NULL) {
////        __egl_setEGLError(EGL_BAD_PARAMETER); return EGL_FALSE;
////    }
////
////    // Set value specified in attrib_list
////    _EGLConfig ac = __egl_createEGLConfigWithDefaultValue();
////    EGLint r;
////    if ((r = __egl_parseAttribList(attrib_list, &ac)) != EGL_SUCCESS) {
////        __egl_setEGLError(r);
////        return EGL_FALSE ;
////    }
////    if ((r = checkValidConf(&ac)) != EGL_SUCCESS ) {
////        __egl_setEGLError(r);
////        return EGL_FALSE ;
////    }
////
////    // Gather config
////    EGLint num_configs2; _EGLConfig* configs2 = NULL;
////    __egl_gatherEGLConfigs(configs2, &num_configs2);
////
////    // Selected EGLConfigs as per attributes
////    _EGLConfig* seconfigs = NULL; EGLint num_seconfigs;
////    __egl_selectEGLConfigs(seconfigs, &num_seconfigs, configs2, num_configs2, ac);
////
////    // Sort EGLConfigs
////    __sortEGLConfigs(seconfigs, &num_seconfigs, ac);
////
////    FREE(seconfigs)
////
////    if (configs_ == NULL) {
////        *num_config = num_configs_;
////        return EGL_TRUE;
////    }
////    *num_config = config_size > num_configs2 ? num_configs2 : config_size;
////    configs = CALLOC_ARRAY(EGLConfig, *num_config)
////    for (EGLint i=0;i<*num_config;i++) {
////        configs[i] = configs2[i].impl;
////    }
////    FREE(configs2)
////    return EGL_TRUE;
////
////
////
////
////
////
////   	EGLint num_matchconfigs = 0;
////   	_EGLConfig* matchconfigs = CALLOC_ARRAY(_EGLConfig,num_matchconfigs)
////
////	*num_config = num_matchconfigs;
////   	configs = matchconfigs;
////
////    // Construct a dictionary with configurations.
////	NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
////                          [NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking,
////                          kEAGLColorFormatRGB565, kEAGLDrawablePropertyColorFormat, nil];
////
////    // Set the properties to CAEALLayer.
////    [eaglLayer setOpaque:YES];
////    [eaglLayer perties:dict];}
////}
//
///**
// // * Gathers EGLConfigs from device
// // * \param configs Poointer to array of Configs gathered (NULL permitted)
// // * \param num_configs Number of config gathered
// // * \return Array of configs.
// // */
////void __egl_gatherEGLConfigs(_EGLConfig* configs, EGLint* num_configs) {
////    // Gather EGLConfigs based only on OpenGL ES Core features.
////    // TODO: Do the same for OpenGL ES Extension features.
////
////    EGLint* num_configs2 = 0;
////    _EGLConfig* configs2 = CALLOC_ARRAY(_EGLConfig, *num_configs2);
////    EGLint nextConfigId = 0;
////
////     // OpenGL ES Framebuffer Object (on iOS) is used for:
////    //  0x01 - OnScreen rendering - windows
////    //  0x02 - Offscreen rendering - pbuffers
////    //  0x03 - Offscreen rendering in buffer - pixmap
////    for (EGLint sType=0; sType<SURFACE_TYPE_COUNT;sType++) {
////        _EGLContextImpl ctx;
////        ctx = __egl_createOpenGLESContext(OPENGL_ES_2_X);
////        EGLint num_sizes = 4;
////        EGLint* sizes = CALLOC_ARRAY(EGLint, num_sizes)
////        EGLint* pfs;
////        EGLint num_pfs;
////
////        GLuint frameBufferObjectId;
////        GLuint colorRenderBufferId;
////        GLuint depthRenderBufferId;
////
////        glGenFramebuffers(1, &frameBufferObjectId);
////
////        switch (sType) {
////            case SURFACE_TYPE_WINDOW:
////                glGenRenderbuffers(1, &colorRenderBufferId);
////                glBindRenderbuffer(GL_RENDERBUFFER, colorRenderBufferId);
////
////                __egl_gatherOpenGLPixelFormat(pfs, &num_pfs, NULL, sType);
////                for (EGLint k=0;k<num_pfs;k++) {
////                    glBindFramebuffer(GL_FRAMEBUFFER, frameBufferObjectId);
////                    GLsizei rbMaxWidth; GLsizei rbMaxHeight;
////                    glGetIntegerv(GL_MAX_RENDERBUFFER_SIZE, &rbMaxWidth);
////                    rbMaxHeight = rbMaxWidth;
////                    glRenderbufferStorage(GL_RENDERBUFFER, pfs[k],
////                                          rbMaxWidth, rbMaxHeight);
////                    glFramebufferRenderbuffer(GL_FRAMEBUFFER,
////                                              GL_COLOR_ATTACHMENT0,
////                                              GL_RENDERBUFFER,
////                                              colorRenderBufferId);
////
////                    __egl_gatherColorRenderBufferComponentColorBits(sType, sizes,
////                                                              &num_sizes);
////                    _EGLConfig cfgImpl;
////                    cfgImpl.redSize = sizes[0]; cfgImpl.greenSize = sizes[1];
////                    cfgImpl.blueSize = sizes[2]; cfgImpl.alphaSize = sizes[3];
////                    cfgImpl.bufferSize = __egl_computeBufferSize(cfgImpl.redSize, cfgImpl.greenSize,
////                                                     cfgImpl.blueSize, cfgImpl.alphaSize);
////
////                    cfgImpl.configCaveat = EGL_NONE;
////                    ++nextConfigId;
////                    cfgImpl.configId = nextConfigId;
////
////                    glGenRenderbuffers(1, &depthRenderBufferId);
////                    glBindRenderbuffer(GL_RENDERBUFFER, depthRenderBufferId);
////                    __egl_gatherOpenGLDepthBufferZ(sizes, &num_sizes, NULL, sType);
////                    cfgImpl.depthSize = sizes[0];
////
////                    __egl_gatherOpenGLFrameBufferLevel(sizes);
////                    cfgImpl.level = sizes[0];
////
////                    __egl_gatherOpenGLPBBufferDimensions(sizes, &num_sizes, NULL, sType);
////                    cfgImpl.maxPBufferWidth = sizes[0];
////                    cfgImpl.maxPBufferHeight = sizes[1];
////                    __egl_gatherOpenGLPBBufferSize(sizes, &num_sizes, NULL, sType);
////                    cfgImpl.maxPBufferPixels = sizes[0];
////
////                    cfgImpl.nativeRenderable = EGL_TRUE;
////                    cfgImpl.nativeVisualID = 0;
////                    cfgImpl.nativeVisualType = EGL_NONE;
////                    __egl_gatherOpenGLSampleBuffers(sizes, &num_sizes, NULL, sType);
////                    __egl_gatherOpenGLSamples(sizes, &num_sizes, NULL, sType);
////                    __egl_gatherOpenGLStencilBufferSize(sizes, &num_sizes, NULL, sType);
////
////                    cfgImpl.surfaceType =     sType == SURFACE_TYPE_WINDOW ? EGL_WINDOW_BIT:
////                                        sType == SURFACE_TYPE_PBUFFER ? EGL_PBUFFER_BIT :
////                                        sType == SURFACE_TYPE_PIXMAP ? EGL_PIXMAP_BIT : 0;
////
////
////                    cfgImpl.transparentType = EGL_TRANSPARENT_RGB;
////                    cfgImpl.transparentRedValue = 0;
////                    cfgImpl.transparentGreenValue = 0;
////                    cfgImpl.transparentBlueValue = 0;
////
////                    ++(*num_configs2);
////                    REALLOC_ARRAY_MEM_MGT(_EGLConfig,
////                                          *num_configs2,
////                                          configs2)
////                    configs2[*num_configs2-1] = cfgImpl;
////                }
////                break;
////            default:
////                break;
////
////                FREE(pfs);
////                FREE(sizes)
////
////                glBindRenderbuffer(GL_RENDERBUFFER, 0);
////                glDeleteRenderbuffers(1, (const GLuint*)colorRenderBufferId);
////                glDeleteRenderbuffers(1, (const GLuint*)depthRenderBufferId);
////                __egl_destroyOpenGLESContext(&ctx);
////        }
////        *num_configs = *num_configs2;
////        configs = configs2;
////    }
////}
////

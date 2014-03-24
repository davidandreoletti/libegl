# Bug/Feature Lists

## TODO LibEGL Bug Priority List:

    - None yet :)

## TODO LibEGL Feature Priority List:

    - Add EGL_SWAP_BEHAVIOR_PRESERVED_BIT support. See EGL 1.4 Table 3.2
      Surface swap is EGL_BUFFER_DESTROYED for now ? See iOS support EGL_BUFFER_RETAINED via kEAGLDrawablePropertyRetainedBacking too
    - Add support for rotation. See EGL 1.4 - Section 3.9.1 Native Window Resizing
    - Add support for Multisampling

## TODO Uncategorised List:

    - Memory Leak: App starts with 8.5Mb without EGL. Running the demo + unit test consumes more 16Mb. When the demo stops, the memory consumption is higher than 8.5Mb. Some resources are not deleted
    - Split Samples from UT Xcode projects 
    - Can add support for GLKView (currently only CEAGLLayer supported) ?

## TODO Code Cleanup Priority List:

    - None. 

## TODO Unit Test Bug Priority List:

    - None yet :)

# PERSONAL NOTES:

    EGL:  several types of drawing surfaces collectively referred to as EGLSurfaces;
    - windows, used for onscreen rendering; 
    - pbuffers, used for offscreen rendering; 
    - pixmaps, used for offscreen rendering into buffers that may be accessed through native APIs. 
        
    EGL windows and pixmaps are tied to native window system windows and pixmaps
        
    db-blog:
    EGLDisplay = the UIWindow holding our custom view 
    EGLSurface = window surf: CAEAGLayer's attached to a sub-class from UIView 
             pbuffer surf (block of memory dynamically allocated on the graphics card, but not visible on-screen): OpenGL's Framebuffer Objects -> See https://developer.apple.com/library/ios/documentation/3ddrawing/conceptual/opengles_programmingguide/WorkingwithEAGLContexts/WorkingwithEAGLContexts.html#//apple_ref/doc/uid/TP40008793-CH103-SW6
             pixmap surf ( uses whatever pixel buffer representation is supported by the platform’s native graphics API (in the case of Android, this would be a Bitmap), allowing you to mix and match OpenGL and native graphics drawing calls into the same pixels without having to copy buffers back and forth): CGContextRef from Quartz 2D


    http://android-dls.com/wiki/index.php?title=EGL_notes  - About offscreen rendering

    http://www.slideshare.net/llopis/the-best-of-both-worlds-mixing-uikit-with-opengl 
    http://gamesfromwithin.com/remixing-opengl-and-uikit
    https://developer.tizen.org/help/index.jsp?topic=%2Forg.tizen.native.appprogramming%2Fhtml%2Fguide%2Fgraphics%2Fopengl.htm

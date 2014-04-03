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

#include "EGL/drivers/eagl/opengles/opengles_ios.h"
#include "EGL/drivers/eagl/opengles/opengles1_ios.h"
#include "EGL/drivers/eagl/opengles/opengles2_ios.h"
#include "EGL/drivers/eagl/opengles/opengles3_ios.h"
#include "EGL/drivers/eagl/ios/ObjCMemoryManagement.h"
#include "EGL/drivers/eagl/ios/OSVersions.h"
#include <stddef.h>
#include <Availability.h>
#import <Foundation/NSObjCRuntime.h>
#import <OpenGLES/EAGL.h>

void opengles_api_init(__OpenGLESAPI* api, _OpenGLESAPIVersion version) {
    if (api == NULL) {return;}
    switch (version) {
        case OPENGL_ES_1_1:
            api->majorVersion = 1;
            opengles1_api_init(api);
            break;
        case OPENGL_ES_2_0:
            api->majorVersion = 2;
            opengles2_api_init(api);
            break;
        case OPENGL_ES_3_0:
            api->majorVersion = 3;
            opengles3_api_init(api);
            break;
        default:
            break;
    }
}

_OpenGLESAPIVersion opengles_max_version_supported() {
    EAGLRenderingAPI renderingAPIs[] = {
#ifdef  __IPHONE_7_0
        SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"),
        kEAGLRenderingAPIOpenGLES3,
        OPENGL_ES_3_0,
#endif // __IPHONE_7_0
#ifdef  __IPHONE_3_0
        SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"3.0"),
        kEAGLRenderingAPIOpenGLES2,
        OPENGL_ES_2_0,
#endif // __IPHONE_3_0
        1,
        kEAGLRenderingAPIOpenGLES1,
        OPENGL_ES_1_1
    };
    int count = sizeof(renderingAPIs)/sizeof(renderingAPIs[0]);
    bool supported = false;
    int i = 0;
    while (!supported && i<count) {
        if (renderingAPIs[i]) {
            EAGLContext *context = [[EAGLContext alloc] initWithAPI:renderingAPIs[i+1]];
            supported = (context != nil);
            OWNERSHIP_RELEASE(context);
        }
        if (!supported) {i+=3;}
    };
    return supported ? (_OpenGLESAPIVersion)renderingAPIs[i+2] : OPENGL_ES_NOT_SUPPORTED;
}

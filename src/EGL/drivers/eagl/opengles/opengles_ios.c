//
//  opengles_ios.c
//  eglapi-core-lib
//
//  Created by David Andreoletti on 06/02/2014.
//  Copyright (c) 2014 IO Stark. All rights reserved.
//

#include "EGL/drivers/eagl/opengles/opengles_ios.h"
#include "EGL/drivers/eagl/opengles/opengles1_ios.h"
#include "EGL/drivers/eagl/opengles/opengles2_ios.h"
#include <stddef.h>

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
            opengles2_api_init(api);
            break;
        default:
            break;
    }
}

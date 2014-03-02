//
//  \file AppleIOSMemoryManagement.m
//  libegl
//
//  Created by Andreoletti David.
//  Copyright 2013 IO Stark. All rights reserved.
//

#include "EGL/drivers/eagl/ios/AppleIOSMemoryManagement.h"

CFTypeRef ownership_bridge_retain (id nsTypeRef) {
    return OWNERSHIP_BRIDGE_RETAINED(CFTypeRef, nsTypeRef);
}

id ownership_bridge_release (CFTypeRef cfTypeRef) {
    return OWNERSHIP_BRIDGE_TRANSFER(id, cfTypeRef);
}

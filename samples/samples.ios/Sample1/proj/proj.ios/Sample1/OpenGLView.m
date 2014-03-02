//
//  OpenGLView.m
//  Sample0
//
//  Created by David Andreoletti on 10/8/13.
//  Copyright (c) 2013 David Andreoletti. All rights reserved.
//

#import "OpenGLView.h"
#import  <QuartzCore/QuartzCore.h>

@implementation OpenGLView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

+ (Class)layerClass {
    return [CAEAGLLayer class];
}

@end

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

@implementation NSMutableArray (Stack)

//ORIG
//- (void) push: (id)item {
//    [self addObject:item];
//}
//
//- (id) pop {
//    id item = nil;
//    if ([self count] != 0) {
//        item = [[[self lastObject] retain] autorelease];
//        [self removeLastObject];
//    }
//    return item;
//}
//
//- (id) peek {
//    id item = nil;
//    if ([self count] != 0) {
//        item = [[[self lastObject] retain] autorelease];
//    }
//    return item;
//}

//SIMPLER
//- (void) push: (id)item {
//    [self addObject:item];
//}
//
//- (id) pop {
//    id item = nil;
//    if ([self count] > 0) {
//        item = [self lastObject];
//        [[item retain] autorelease];
//        [self removeLastObject];
//    }
//    return item;
//}
//
//- (id) peek {
//    return [self lastObject];;
//}

// NO STACK
id value;

- (void) push: (id)item {
    value = item;
}

- (id) pop {
    id item = value;
    value = nil;
    return item;
}

- (id) peek {
    return value;
}


@end
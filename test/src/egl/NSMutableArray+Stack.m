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
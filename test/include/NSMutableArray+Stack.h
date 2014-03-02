// http://saturnboy.com/2011/02/stack-queue-nsmutablearray/

@interface NSMutableArray (Stack)

- (void) push: (id)item;
- (id) pop;
- (id) peek;

@end
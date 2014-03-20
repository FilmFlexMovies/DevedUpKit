//
//  NSMutableArray+Extensions.m
//  Flickr
//
//  Created by David Casserly on 26/05/2011.
//  Copyright 2011 DevedUp Ltd. All rights reserved.
//

#import "NSMutableArray+Extensions.h"

@implementation NSMutableArray (NSMutableArray_Extensions)

- (void)shuffle {
    static BOOL seeded = NO;
    if(!seeded)
    {
        seeded = YES;
        srandom((int)time(NULL));
    }
    
    NSUInteger count = [self count];
    for (NSUInteger i = 0; i < count; ++i) {
        // Select a random element between i and end of array to swap with.
        NSInteger nElements = count - i;
        NSInteger n = (random() % nElements) + i;
        [self exchangeObjectAtIndex:i withObjectAtIndex:n];
    }

}

@end

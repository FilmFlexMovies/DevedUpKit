//
//  DUBlocks.m
//  FilmFlexMovies
//
//  Created by Casserly on 23/04/2013.
//  Copyright (c) 2013 FilmFlex Movies Ltd. All rights reserved.
//
// Based on http://www.mikeash.com/svn/PLBlocksPlayground/BlocksAdditions.m

#import "DUBlocks.h"

@implementation NSObject (BlocksAdditions)

- (void) my_callBlock {
    void (^block)(void) = (id)self;
    block();
}

- (void) my_callBlockWithObject:(id)obj {
    void (^block)(id obj) = (id)self;
    block(obj);
}

@end

void executeBlockOnThread(NSThread *thread, BasicBlock block) {
    [[block copy] performSelector:@selector(my_callBlock) onThread:thread withObject:nil waitUntilDone:YES];
}

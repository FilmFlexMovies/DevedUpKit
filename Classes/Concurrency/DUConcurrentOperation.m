//
//  DUConcurrentOperation.m
//  FilmFlexMovies
//
//  Created by Casserly on 19/04/2013.
//  Copyright (c) 2013 FilmFlex Movies Ltd. All rights reserved.
//

#import "DUConcurrentOperation.h"

@interface DUConcurrentOperation ()
@property (nonatomic, assign) BOOL isOperationExecuting;
@property (nonatomic, assign) BOOL isOperationFinished;
@end

@implementation DUConcurrentOperation

- (instancetype) init {
    self = [super init];
    if (self) {
        _isOperationExecuting = NO;
        _isOperationFinished = NO;
    }
    return self;
}

- (BOOL) isExecuting {
    return self.isOperationExecuting;
}

- (BOOL) isFinished {
    return self.isOperationFinished;
}

- (BOOL) isConcurrent {
    //This allows it to live beyond it first call so you can do asyn operation within it
    //However you have to manage its lifecycle
    return YES;
}

- (void) start {    
    if ([self isCancelled]) {
        // Must move the operation to the finished state if it is canceled.
        [self finish];
        return; 
    }
    
    //NSLog(@"opeartion started");
    [self willChangeValueForKey:@"isExecuting"];
    self.isOperationExecuting = YES;
    [self didChangeValueForKey:@"isExecuting"];
    
    
}

- (void) finish {
    //NSLog(@"Ending operation now");    
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    self.isOperationExecuting = NO;
    self.isOperationFinished = YES;
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

- (void) cancel {
	[super cancel];
	[self finish];
}

@end

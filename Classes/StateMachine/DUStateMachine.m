//
//  DUState.m
//  FilmFlexMovies
//
//  Created by Casserly on 03/11/2012.
//  Copyright (c) 2012 FilmFlex Movies Ltd. All rights reserved.
//

#import "DUStateMachine.h"

@interface DUStateMachine ()
@property (nonatomic, retain) id<DUState> currentState;
@end

@implementation DUStateMachine

- (void) changeToState:(id<DUState>)newState withContext:(id)context {
    NSLog(@"Changing to state %@ with context %@", newState, context);
    if ([self.currentState respondsToSelector:@selector(exitStateWithContext:)]) {
        [self.currentState exitStateWithContext:context];
    }
    if ([newState respondsToSelector:@selector(enterStateWithContext:)]) {
        [newState enterStateWithContext:context];
    }    
    self.currentState = newState;
}

- (void) executeCurrentStateWithContext:(id)context {
    if ([self.currentState hasBegunExecuting]) {
        NSLog(@"State machine is trying to execute state %@ again with context %@ (but we have prevented it)", self.currentState, context);
        return;
    } else {
        NSLog(@"Executing state %@ with context %@", self.currentState, context);
        [self.currentState executeStateWithContext:context];
    }
}

@end

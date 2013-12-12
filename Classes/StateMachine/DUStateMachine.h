//
//  DUState.h
//  FilmFlexMovies
//
//  Created by Casserly on 03/11/2012.
//  Copyright (c) 2012 FilmFlex Movies Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DUStateMachine;

@protocol DUState <NSObject>

@optional
- (void) enterStateWithContext:(id)context;
- (void) exitStateWithContext:(id)context;

@required
- (BOOL) executeStateWithContext:(id)context;
- (BOOL) hasBegunExecuting;
- (NSUInteger) stateValueInt;
- (BOOL) requiresNetwork;

@end


@interface DUStateMachine : NSObject

@property (nonatomic, retain, readonly) id<DUState> currentState;

- (void) executeCurrentStateWithContext:(id)context;
- (void) changeToState:(id<DUState>)newState withContext:(id)context;

@end

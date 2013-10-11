//
//  NSObject+DUExtensions.h
//  DevedUp
//
//  Created by David Casserly on 15/01/2012.
//  Copyright (c) 2012 DevedUp Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PerformBlock

- (void) performBlock:(void (^)(void))block ifRespondsTo:(SEL)aSelector;

@end

@interface NSObject (DUExtensions) <PerformBlock>

- (void) performBlock:(void (^)(void))block ifRespondsTo:(SEL)aSelector;


- (void) performBlockAfterDelayDU:(CGFloat)delay block:(void (^)(void))block;

//Guarantees that if the value at keyPath is a dictionary or array, it will return an array
- (NSArray *) arrayValueForKeyPath:(NSString *)keyPath;

@end



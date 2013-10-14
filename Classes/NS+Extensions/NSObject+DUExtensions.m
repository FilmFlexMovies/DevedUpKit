//
//  NSObject+DUExtensions.m
//  DevedUp
//
//  Created by David Casserly on 15/01/2012.
//  Copyright (c) 2012 DevedUp Ltd. All rights reserved.
//

#import "NSObject+DUExtensions.h"

@implementation NSObject (DUExtensions)

-(void) performBlock:(void (^)(void))block ifRespondsTo:(SEL)aSelector {
    if ([self respondsToSelector:aSelector]) {
        block();
    }
}

- (void) performBlockAfterDelayDU:(CGFloat)delay block:(void (^)(void))block {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        block();
    }); 
    
//    [UIView animateWithDuration:0.0 
//                          delay:delay 
//                        options:UIViewAnimationCurveLinear 
//                     animations:^{
//                         
//                     } 
//                     completion:^(BOOL finished) {
//                         block();
//                     }];
}


//Guarantees that if the value at keyPath is a dictionary or array, it will return an array
- (NSArray *) arrayValueForKeyPath:(NSString *)keyPath {
    NSArray *result = nil;
    id data = [self valueForKeyPath:keyPath];
    if ([data isKindOfClass:NSArray.class]) {
        result = data;
    } else if([data isKindOfClass:NSDictionary.class]) {
        result = @[data];
    }
    return result;
}

@end

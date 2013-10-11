//
//  NSDecimalNumber+Extensions.h
//  DevedUp
//
//  Created by David Casserly on 15/09/2010.
//  Copyright 2010 IGIndex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDecimalNumber (Extensions)

- (NSDecimalNumber *) decimalPartOfDecimalNumber;
- (NSDecimalNumber *) integerPartOfDecimalNumber;
+ (NSDecimalNumber *) decimalNumberWithFloat:(float)theFloat;

@end

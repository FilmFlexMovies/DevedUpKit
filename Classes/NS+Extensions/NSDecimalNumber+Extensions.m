//
//  NSDecimalNumber+Extensions.m
//  DevedUp
//
//  Created by David Casserly on 15/09/2010.
//  Copyright 2010 IGIndex. All rights reserved.
//

#import "NSDecimalNumber+Extensions.h"


@implementation NSDecimalNumber (Extensions)

- (NSDecimalNumber *) decimalPartOfDecimalNumber {
	NSDecimalNumberHandler *behavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown 
																							  scale:0 
																				   raiseOnExactness:NO 
																					raiseOnOverflow:NO 
																				   raiseOnUnderflow:NO 
																				raiseOnDivideByZero:NO];
	NSDecimalNumber *integerPart = [self decimalNumberByRoundingAccordingToBehavior:behavior];
	NSDecimalNumber *decimalPart = [self decimalNumberBySubtracting:integerPart];
	return decimalPart;
}

- (NSDecimalNumber *) integerPartOfDecimalNumber {
	NSDecimalNumberHandler *behavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown 
																							  scale:0 
																				   raiseOnExactness:NO 
																					raiseOnOverflow:NO 
																				   raiseOnUnderflow:NO 
																				raiseOnDivideByZero:NO];
	NSDecimalNumber *integerPart = [self decimalNumberByRoundingAccordingToBehavior:behavior];
	return integerPart;
}

+ (NSDecimalNumber *) decimalNumberWithFloat:(float)theFloat {
	return [NSDecimalNumber decimalNumberWithDecimal:[@(theFloat) decimalValue]];
}

@end

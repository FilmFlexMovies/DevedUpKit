//
//  NSNumber+Extensions.m
//  DevedUp
//
//  Created by igmac0002 on 09/09/2010.
//  Copyright 2010 IGIndex. All rights reserved.
//

#import "NSNumber+Extensions.h"


@implementation NSNumber (Extensions)


+(NSNumber*) numberOfDecimalPlaces:(NSNumber*)number {
	
	NSString* numericString = [number stringValue];
	
	NSUInteger locationOfDecimalPoint = [numericString rangeOfString:@"."].location;
	NSUInteger decimalPlaces;
	if (locationOfDecimalPoint == NSNotFound) {
		decimalPlaces = 0;
	} else {
		//There are some decimal places to consider
		NSUInteger stringLength = [numericString length];
	
		decimalPlaces = stringLength - locationOfDecimalPoint - 1; //-1 cos indexing starts at 0
	}
	return [NSNumber numberWithInt:decimalPlaces];
}





@end

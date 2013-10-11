//
//  NSNumberFormatter+Extensions.m
//  iDeal
//
//  Created by igmac0007 on 06/01/2011.
//  Copyright 2011 IG Group. All rights reserved.
//

#import "NSNumberFormatter+Extensions.h"


@implementation NSNumberFormatter (Extensions)

- (id) initWithIGStyle {

	if ((self = [self init])) {
		
		[self setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"]];
	}
	return self;
}

+ (NSString*)dashOrNumberString:(NSDecimalNumber*)decimalNumber usingFormatter:(NSNumberFormatter*)formatter {
	if([decimalNumber isKindOfClass:NSDecimalNumber.class]) {
		if(formatter) {
			return [formatter stringFromNumber:decimalNumber];
		}
		else {
			return [decimalNumber stringValue];
		}
	}
	else {
		return @"-";
	}
}

+ (id)formatterWithDecimalPlaces:(NSInteger)decimalPlaces {
	NSNumberFormatter *numberFormatter = [[[self class] alloc] initWithIGStyle]; // use [self class] so that when invoked via a subclass (e.g. DMAPriceFormatter) one of those is created instead
	if (decimalPlaces > 0){
		[numberFormatter setMinimumIntegerDigits:1]; // ensure there's a 0 before any decimal point
	}
	[numberFormatter setMaximumFractionDigits:decimalPlaces];
	[numberFormatter setMinimumFractionDigits:decimalPlaces];
	return numberFormatter;
}

+ (id)formatterWithOptionalDecimalPlaces:(NSInteger)decimalPlaces {
	NSNumberFormatter *numberFormatter = [[[self class] alloc] initWithIGStyle]; // use [self class] so that when invoked via a subclass (e.g. DMAPriceFormatter) one of those is created instead
	if (decimalPlaces > 0){
		[numberFormatter setMinimumIntegerDigits:1]; // ensure there's a 0 before any decimal point
	}
	[numberFormatter setMaximumFractionDigits:decimalPlaces];
	[numberFormatter setMinimumFractionDigits:0];
	return numberFormatter;
}
@end

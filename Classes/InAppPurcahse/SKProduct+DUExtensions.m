//
//  SKProduct+DUExtensions.m
//  DevedUp
//
//  Created by Casserly on 20/06/2013.
//
//

#import "SKProduct+DUExtensions.h"

@implementation SKProduct (DUExtensions)

- (NSString *) localizedPrice_DU {	
	static NSNumberFormatter *formatter = nil;
	if (!formatter) {
		formatter = [[NSNumberFormatter alloc] init];
		[formatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
		[formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
	}		
	[formatter setLocale:[self priceLocale]];	
	NSString *str = [formatter stringFromNumber:[self price]];
	return str;
}

@end

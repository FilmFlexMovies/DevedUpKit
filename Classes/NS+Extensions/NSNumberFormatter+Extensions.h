//
//  NSNumberFormatter+Extensions.h
//  iDeal
//
//  Created by igmac0007 on 06/01/2011.
//  Copyright 2011 IG Group. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSNumberFormatter (Extensions) 

- (id) initWithIGStyle ;

+ (NSString*)dashOrNumberString:(NSDecimalNumber*)decimalNumber usingFormatter:(NSNumberFormatter*)formatter;

+ (id)formatterWithDecimalPlaces:(NSInteger)decimalPlaces;
+ (id)formatterWithOptionalDecimalPlaces:(NSInteger)decimalPlaces;

@end

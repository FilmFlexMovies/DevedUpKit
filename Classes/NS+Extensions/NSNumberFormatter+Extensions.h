//
//  NSNumberFormatter+Extensions.h
//  iDeal
//
//  Created by igmac0007 on 06/01/2011.
//  Copyright 2011 IG Group. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSNumberFormatter (Extensions) 

- (instancetype) initWithIGStyle ;

+ (NSString*)dashOrNumberString:(NSDecimalNumber*)decimalNumber usingFormatter:(NSNumberFormatter*)formatter;

+ (instancetype)formatterWithDecimalPlaces:(NSInteger)decimalPlaces;
+ (instancetype)formatterWithOptionalDecimalPlaces:(NSInteger)decimalPlaces;

@end

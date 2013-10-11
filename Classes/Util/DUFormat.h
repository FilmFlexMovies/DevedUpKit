//
//  DUFormat.h
//  DevedUp
//
//  Created by David Casserly on 18/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DUFormat : NSObject

+ (NSString *) thousandSeparatedNumber:(NSNumber *)number;
+ (NSString *) thousandSeparatedString:(NSString *)string;
+ (NSString *) thousandSeparatedInteger:(NSUInteger)integer;

@end

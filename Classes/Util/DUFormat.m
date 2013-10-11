//
//  DUFormat.m
//  DevedUp
//
//  Created by David Casserly on 18/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DUFormat.h"

@implementation DUFormat


+ (NSString *) formatNumber:(id)number {
    NSNumberFormatter *numberFormat = [[NSNumberFormatter alloc] init];
    numberFormat.usesGroupingSeparator = YES;
    numberFormat.groupingSeparator = @",";
    numberFormat.groupingSize = 3; 
    NSString *numberString = [numberFormat stringForObjectValue:number];
    return numberString;
}


+ (NSString *) thousandSeparatedNumber:(NSNumber *)number {
    return [self formatNumber:number];
}

+ (NSString *) thousandSeparatedString:(NSString *)string {
    return [self formatNumber:string];
}

+ (NSString *) thousandSeparatedInteger:(NSUInteger)integer {
    NSNumber *num = [NSNumber numberWithLongLong:integer];
    return [self formatNumber:num];
}


@end

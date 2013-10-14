//
//  NSString+DUBase64.m
//  DevedUpKit
//
//  Created by David Casserly on 11/10/2013.
//  Copyright (c) 2013 DevedUp. All rights reserved.
//

#import "NSString+DUBase64.h"

@implementation NSString (DUBase64)

- (NSString *) base64EncodedString_DU {
    if (iOS_6) {
        NSData *data =  [self dataUsingEncoding:NSUTF8StringEncoding];
        return [self base64forData:data];
    } else {
        return [[self dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
    }
}

- (NSString*) base64forData:(NSData*)theData {
	
	const uint8_t* input = (const uint8_t*)[theData bytes];
	NSInteger length = [theData length];
	
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
	
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
	
	NSInteger i,i2;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
		for (i2=0; i2<3; i2++) {
            value <<= 8;
            if (i+i2 < length) {
                value |= (0xFF & input[i+i2]);
            }
        }
		
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
	
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

@end

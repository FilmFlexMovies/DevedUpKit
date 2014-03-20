//
//  NSString+Extensions.m
//  iDeal
//
//  Created by casserd on 20/05/2010.
//  Copyright 2010 IGIndex. All rights reserved.
//

#import "NSString+Extensions.h"
#import "NSNumberFormatter+Extensions.h"

@implementation NSString (Extensions) 

- (NSString *) trim_DU {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *) DU_stripAllHTMLExceptTags:(NSArray *)tags {
    
    NSMutableString *ms = [NSMutableString stringWithCapacity:[self length]];
    
    NSScanner *scanner = [NSScanner scannerWithString:self];
    [scanner setCharactersToBeSkipped:nil]; //default will skip new line and whitespace
    NSString *s = nil;
    NSString *tagFound = nil;
    while (![scanner isAtEnd]) {
        //Scan up to the first tag
        [scanner scanUpToString:@"<" intoString:&s];
        if (s != nil) {
            [ms appendString:s];
        }
        
        [scanner scanUpToString:@">" intoString:&tagFound];
        if (tagFound != nil) {
            //add end
            NSString *check = [NSString stringWithFormat:@"%@>", tagFound];
            //Check the tag
            if ([tags containsObject:check]) {
                [ms appendString:check];
            } else if([check hasPrefix:@"<img"]) {
                [ms appendString:@"[image]"];
            }
        }
        
        if (![scanner isAtEnd])
            [scanner setScanLocation:[scanner scanLocation]+1];
        s = nil;
        tagFound = nil;
    }
    
    return [ms stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

//- (NSString *) DU_stripAllHTMLExceptTags:(NSArray *)tags {
//
//
//    NSRange r;
//    NSMutableString *parsedString = [[[NSMutableString alloc] init] autorelease];
//    NSString *s = [[self copy] autorelease];
//    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound) {
//        NSString *tag = [s substringWithRange:r];
//        if ([tags containsObject:tag]) {
//            continue;
//        }
//        s = [s stringByReplacingCharactersInRange:r withString:@""];
//    }
//    [s stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    return s;
//}

- (NSString *) DU_stripHTML {
    NSRange r;
    NSString *s = [self copy];
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound) {
        //NSString *tag = [s substringWithRange:r];
        
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    }
    [s stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return s;
}

- (NSNumberFormatter *) formatterWithSameDecimalPlaces {
	
	NSInteger decimalPlaces = [self calculateNumberOfDecimalPlaces];
	//int integerPlaces = [self calculateNumberOfIntegerPlaces];
	NSNumberFormatter *numberFormat = [[NSNumberFormatter alloc] initWithIGStyle];
	[numberFormat setMaximumFractionDigits:decimalPlaces];
	[numberFormat setMinimumFractionDigits:decimalPlaces];
	//[numberFormat setMinimumIntegerDigits:integerPlaces];
	
	return numberFormat;
}

- (NSUInteger) calculateNumberOfIntegerPlaces {
	NSUInteger locationOfDecimalPoint = [self rangeOfString:@"."].location;
	NSUInteger integerPlaces;
	if (locationOfDecimalPoint == NSNotFound) {
		integerPlaces = [self length];
	}else {
		//There is decimal places
		integerPlaces = locationOfDecimalPoint;
	}
	return integerPlaces;
}

- (NSUInteger) calculateNumberOfDecimalPlaces {
	
	NSUInteger locationOfDecimalPoint = [self rangeOfString:@"."].location;
	NSUInteger decimalPlaces;
	if (locationOfDecimalPoint == NSNotFound) {
		decimalPlaces = 0;
	} else {
		//There are some decimal places to consider
		NSUInteger stringLength = [self length];
		
		decimalPlaces = stringLength - locationOfDecimalPoint - 1; //-1 cos indexing starts at 0
	}
	return decimalPlaces;
}

/*
 * compareVersions(@"10.4",             @"10.3")             returns NSOrderedDescending (1)
 * compareVersions(@"10.5",             @"10.5.0")           returns NSOrderedSame (0)
 * compareVersions(@"10.4 Build 8L127", @"10.4 Build 8P135") returns NSOrderedAscending (-1)
 */
+ (NSComparisonResult) compareVersions:(NSString *)leftVersion rightVersion:(NSString *)rightVersion {
	int i;
	
	// Break version into fields (separated by '.')
	NSMutableArray *leftFields  = [[NSMutableArray alloc] initWithArray:[leftVersion  componentsSeparatedByString:@"."]];
	NSMutableArray *rightFields = [[NSMutableArray alloc] initWithArray:[rightVersion componentsSeparatedByString:@"."]];
	
	// Implict ".0" in case version doesn't have the same number of '.'
	if ([leftFields count] < [rightFields count]) {
		while ([leftFields count] != [rightFields count]) {
			[leftFields addObject:@"0"];
		}
	} else if ([leftFields count] > [rightFields count]) {
		while ([leftFields count] != [rightFields count]) {
			[rightFields addObject:@"0"];
		}
	}
	
	// Do a numeric comparison on each field
	for(i = 0; i < [leftFields count]; i++) {
		NSComparisonResult result = [[leftFields objectAtIndex:i] compare:[rightFields objectAtIndex:i] options:NSNumericSearch];
		if (result != NSOrderedSame) {
			return result;
		}
	}
	
	return NSOrderedSame;
}


int char2hex(unichar c) {
	switch (c) {
		case '0' ... '9': return c - '0';
		case 'a' ... 'f': return c - 'a' + 10;
		case 'A' ... 'F': return c - 'A' + 10;
		default: @throw [NSException exceptionWithName:@"Invalid hex digit" reason:@"" userInfo:nil];
	}
}

- (int) hexToInt {
	int value = 0;
	
	for (int i = 0; i < [self length]; i++) {
		value = (value * 16) + char2hex([self characterAtIndex:i]);
	}
	
	return value;
}

- (BOOL) containsOnlyDigits {
	NSCharacterSet *nonDigitCharacters = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
	return [self rangeOfCharacterFromSet:nonDigitCharacters].location == NSNotFound;
}


- (NSString *) unescapeUnicodeString_DU {
	NSMutableString *convertedString = [self mutableCopy];	
	CFStringRef transform = CFSTR("Any-Hex/Java");
	CFStringTransform((__bridge CFMutableStringRef)convertedString, NULL, transform, YES);	
	return convertedString;
}

// Convert \uXXXX sequences in NSStrings to actual unicode characters
- (NSString *)unescapeUnicodeString_old {
	NSMutableString *returnString = [NSMutableString stringWithCapacity:[self length]];
	
	
	NSUInteger length = [self length];
	
	NSUInteger scanLocation = 0;
	
	NSRange foundRange = [self rangeOfString:@"\\u" options:0 range:NSMakeRange(scanLocation, length - scanLocation)];
	
	while (foundRange.length > 0) {
		
		[returnString appendString:[self substringWithRange:NSMakeRange(scanLocation, foundRange.location - scanLocation)]];
		
		if (foundRange.location + 6 <= length) {
			NSString* hexCharacters = [self substringWithRange:NSMakeRange(foundRange.location + 2, 4)];
			
			@try {
				unichar character = [hexCharacters hexToInt];
				[returnString appendString:[NSString stringWithCharacters:&character length:1]];
				scanLocation = foundRange.location + 6;
			}
			@catch (NSException * e) {
				[returnString appendString:@"\\u"];
				scanLocation = foundRange.location + 2;
			}
		} else {
			[returnString appendString:@"\\u"];
			scanLocation = foundRange.location + 2;
		}
		
		foundRange = [self rangeOfString:@"\\u" options:0 range:NSMakeRange(scanLocation, length - scanLocation)];
	}
	
	[returnString appendString:[self substringFromIndex:scanLocation]];
	
	return returnString;
}

- (NSString*) decodeHtmlAmpersands {
	
	return [self stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
}

- (NSString*)camelCasedString {
	switch ([self length]) {
		case 0:
			return self;
		case 1:
			return [NSString stringWithFormat:@"%@",[self lowercaseString]];
	}
	return [NSString stringWithFormat:@"%@%@",[[self substringToIndex:1] lowercaseString],[self substringFromIndex:1]];
}

- (NSString*)capitalisedCamelCasedString {
	switch ([self length]) {
		case 0:
			return self;
		case 1:
			return [NSString stringWithFormat:@"%@",[self capitalizedString]];
	}
	return [NSString stringWithFormat:@"%@%@",[[self substringToIndex:1] capitalizedString],[self substringFromIndex:1]];
}

- (NSInteger) indexOf:(NSString *)searchChar {
    NSRange range = [self rangeOfString:searchChar];
    if (range.location == NSNotFound) {
        return -1;
    } else {
        return range.location;
    }
}

@end

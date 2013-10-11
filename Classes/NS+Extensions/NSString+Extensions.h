//
//  NSString+Extensions.h
//  iDeal
//
//  Created by casserd on 20/05/2010.
//  Copyright 2010 IGIndex. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (Extensions) 

- (NSNumberFormatter *) formatterWithSameDecimalPlaces;
- (NSUInteger) calculateNumberOfDecimalPlaces;
- (NSUInteger) calculateNumberOfIntegerPlaces;
+ (NSComparisonResult) compareVersions:(NSString *)leftVersion rightVersion:(NSString *)rightVersion;
- (int) hexToInt;
- (BOOL) containsOnlyDigits;
- (NSString *) unescapeUnicodeString_DU;
- (NSString*) decodeHtmlAmpersands;
- (NSString*)camelCasedString;	// e.g. MyString -> myString
- (NSString*)capitalisedCamelCasedString; // e.g. myString -> MyString
- (NSString *) DU_stripHTML;
- (NSString *) DU_stripAllHTMLExceptTags:(NSArray *)tags;
- (NSString *) trim_DU;
- (NSInteger) indexOf:(NSString *)searchChar;



@end

//
//  NSString+Extensions.h
//  iDeal
//
//  Created by casserd on 20/05/2010.
//  Copyright 2010 IGIndex. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (Extensions) 

@property (nonatomic, readonly, copy) NSNumberFormatter *formatterWithSameDecimalPlaces;
@property (nonatomic, readonly) NSUInteger calculateNumberOfDecimalPlaces;
@property (nonatomic, readonly) NSUInteger calculateNumberOfIntegerPlaces;
+ (NSComparisonResult) compareVersions:(NSString *)leftVersion rightVersion:(NSString *)rightVersion;
@property (nonatomic, readonly) int hexToInt;
@property (nonatomic, readonly) BOOL containsOnlyDigits;
@property (nonatomic, readonly, copy) NSString *unescapeUnicodeString_DU;
@property (nonatomic, readonly, copy) NSString *decodeHtmlAmpersands;
@property (nonatomic, readonly, copy) NSString *camelCasedString;	// e.g. MyString -> myString
@property (nonatomic, readonly, copy) NSString *capitalisedCamelCasedString; // e.g. myString -> MyString
@property (nonatomic, readonly, copy) NSString *DU_stripHTML;
- (NSString *) DU_stripAllHTMLExceptTags:(NSArray *)tags;
@property (nonatomic, readonly, copy) NSString *trim_DU;
- (NSInteger) indexOf:(NSString *)searchChar;



@end

//
//  NSDate+Extensions.h
//  DevedUp
//
//  Created by igmac0001 on 19/08/2011.
//  Copyright 2011 DevedUp Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (DUExtensions)

- (NSDate *) sevenDaysAgo_DU;

- (NSString *) agoFormatWithCalendar:(NSCalendar *)calendar;

- (BOOL) isMoreThanOneMonthAgo_DU;
- (BOOL) isMoreThanOneDayAgo_DU;
- (BOOL) isMoreThanOneHourAgo_DU;
- (BOOL) isMoreThanHalfDayAgo_DU;
- (BOOL) isMoreThanOneMinuteAgo_DU;
- (BOOL) isMoreThanFiveMinutesAgo_DU;

- (NSDate *) yesterday;

@end

//
//  NSDate+Extensions.h
//  DevedUp
//
//  Created by igmac0001 on 19/08/2011.
//  Copyright 2011 DevedUp Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (DUExtensions)

@property (nonatomic, readonly, copy) NSDate *sevenDaysAgo_DU;

- (NSString *) agoFormatWithCalendar:(NSCalendar *)calendar;

@property (nonatomic, getter=isMoreThanOneMonthAgo_DU, readonly) BOOL moreThanOneMonthAgo_DU;
@property (nonatomic, getter=isMoreThanOneDayAgo_DU, readonly) BOOL moreThanOneDayAgo_DU;
@property (nonatomic, getter=isMoreThanOneHourAgo_DU, readonly) BOOL moreThanOneHourAgo_DU;
@property (nonatomic, getter=isMoreThanHalfDayAgo_DU, readonly) BOOL moreThanHalfDayAgo_DU;
@property (nonatomic, getter=isMoreThanOneMinuteAgo_DU, readonly) BOOL moreThanOneMinuteAgo_DU;
@property (nonatomic, getter=isMoreThanFiveMinutesAgo_DU, readonly) BOOL moreThanFiveMinutesAgo_DU;

@property (nonatomic, readonly, copy) NSDate *yesterday;

- (NSDate *) dateByAddingHours:(NSInteger)hours;

@end

//
//  NSDate+Extensions.m
//  DevedUp
//
//  Created by igmac0001 on 19/08/2011.
//  Copyright 2011 DevedUp Ltd. All rights reserved.
//

#import "NSDate+Extensions.h"
#import "DULocalisation.h"

@implementation NSDate (DUExtensions)

- (NSCalendar *) gregorianCalendar_DU {
    static NSCalendar *gregorian = nil;
    if (!gregorian) {
        gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    }
    return gregorian;
}

- (NSDate *) sevenDaysAgo_DU {
    NSCalendar *gregorian = [self gregorianCalendar_DU];
    NSDateComponents *sevenDaysAgo = [[NSDateComponents alloc] init];
    sevenDaysAgo.day = -7;
    
    NSDate *dateMinus7Days = [gregorian dateByAddingComponents:sevenDaysAgo toDate:self options:0];
    return dateMinus7Days;
}

- (NSDate *) dateByAddingHours:(NSInteger)hours {
    NSCalendar *gregorian = [self gregorianCalendar_DU];
    NSDateComponents *hoursAdded = [[NSDateComponents alloc] init];
    hoursAdded.hour = hours;
    
    return [gregorian dateByAddingComponents:hoursAdded toDate:self options:0];
}

//- (NSString *) formatTheUnit:(NSString *)unit value:(NSInteger)value {    
//    NSString *returnUnit = value == 1 ? unit : [NSString stringWithFormat:@"%@s", unit];
//    NSString *string = [NSString stringWithFormat:@"%i %@ ago", value, returnUnit];
//    return string;
//}

- (NSDate *) yesterday {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *daysAgo = [[NSDateComponents alloc] init];
    daysAgo.day = -1;
    
    NSDate *newDate = [gregorian dateByAddingComponents:daysAgo toDate:self options:0];
    return newDate;
}


- (NSString *) agoFormatWithCalendar:(NSCalendar *)calendar {
    NSDate *now = [NSDate date];    
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond)
                                               fromDate:self toDate:now options:0];
    
    NSString *formattedDate = nil;
    
    while (!formattedDate) {
        NSInteger yearsAgo = components.year;
        if (yearsAgo && !formattedDate) {
            if (yearsAgo > 1) {
                formattedDate = [NSString stringWithFormat:DULocalizedString(@"%i years ago", @"year ago"), yearsAgo];
            } else {
                formattedDate = [NSString stringWithFormat:DULocalizedString(@"%i year ago", @"year ago"), yearsAgo];
            }
            break;
        }
        NSInteger monthsAgo = components.month;
        if (monthsAgo) {
            if (monthsAgo > 1) {
                formattedDate = [NSString stringWithFormat:DULocalizedString(@"%i months ago", @"month ago"), monthsAgo];
            } else {
                formattedDate = [NSString stringWithFormat:DULocalizedString(@"%i month ago", @"month ago"), monthsAgo];
            }
            break;
        }
        NSInteger daysAgo = components.day;
        if (daysAgo) {
            if (daysAgo > 1) {
                formattedDate = [NSString stringWithFormat:DULocalizedString(@"%i days ago", @"day ago"), daysAgo];
            } else {
                formattedDate = [NSString stringWithFormat:DULocalizedString(@"%i day ago", @"day ago"), daysAgo];
            }
            break;
        }
        NSInteger hoursAgo = components.hour;
        if (hoursAgo) {
            if (hoursAgo > 1) {
                formattedDate = [NSString stringWithFormat:DULocalizedString(@"%i hours ago", @"hour ago"), hoursAgo];
            } else {
                formattedDate = [NSString stringWithFormat:DULocalizedString(@"%i hour ago", @"hour ago"), hoursAgo];
            }
            break;
        }
        NSInteger minutesAgo = components.minute;
        if (minutesAgo) {
            if (minutesAgo > 1) {
                formattedDate = [NSString stringWithFormat:DULocalizedString(@"%i minutes ago", @"minute ago"), minutesAgo];
            } else {
                formattedDate = [NSString stringWithFormat:DULocalizedString(@"%i minute ago", @"minute ago"), minutesAgo];
            }
            break;
        }    
        NSInteger secondsAgo = components.second;
        if (secondsAgo) {
            if (yearsAgo > 1) {
                formattedDate = [NSString stringWithFormat:DULocalizedString(@"%i seconds ago", @"second ago"), secondsAgo];
            } else {
                formattedDate = [NSString stringWithFormat:DULocalizedString(@"%i second ago", @"second ago"), secondsAgo];
            }
            break;
        } 
        if(!formattedDate) {
            formattedDate = DULocalizedString(@"A moment ago", @"time, a moment ago");
            break;
        }
    }
    
    
    return formattedDate;
}

- (BOOL) isMoreThanOneMonthAgo_DU {
    static NSTimeInterval oneMonth = 60 * 60 * 24 * 30;
    NSTimeInterval intervalFromNow = fabs([self timeIntervalSinceNow]);
    if(intervalFromNow > oneMonth) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL) isMoreThanOneDayAgo_DU {
    static NSTimeInterval oneDay = 60 * 60 * 24;
    NSTimeInterval intervalFromNow = fabs([self timeIntervalSinceNow]);
    if(intervalFromNow > oneDay) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL) isMoreThanOneHourAgo_DU {
    static NSTimeInterval oneHour = 60 * 60;
    NSTimeInterval intervalFromNow = fabs([self timeIntervalSinceNow]);
    if(intervalFromNow > oneHour) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL) isMoreThanHalfDayAgo_DU {
    static NSTimeInterval oneDay = 60 * 60 * 12;
    NSTimeInterval intervalFromNow = fabs([self timeIntervalSinceNow]);
    if(intervalFromNow > oneDay) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL) isMoreThanFiveMinutesAgo_DU {
    static NSTimeInterval fiveMins = 60 * 5;
    NSTimeInterval intervalFromNow = fabs([self timeIntervalSinceNow]);
    if(intervalFromNow > fiveMins) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL) isMoreThanOneMinuteAgo_DU {
    static NSTimeInterval oneMinute = 60;
    NSTimeInterval intervalFromNow = fabs([self timeIntervalSinceNow]);
    if(intervalFromNow > oneMinute) {
        return YES;
    } else {
        return NO;
    }
}

@end

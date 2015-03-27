//
//  DUVersion.m
//  DevedUpKit
//
//  Created by David Casserly on 14/02/2014.
//  Copyright (c) 2014 DevedUp. All rights reserved.
//

#import "DUVersion.h"

@interface DUVersion ()
@property (nonatomic, strong) NSNumber *major;
@property (nonatomic, strong) NSNumber *minor;
@property (nonatomic, strong) NSNumber *revision;
@end

@implementation DUVersion

- (instancetype) initWithVersionString:(NSString *)version {
    self = [super init];
    if (self) {
        NSMutableArray *numbers = [[NSMutableArray alloc] initWithArray:[version componentsSeparatedByString:@"."]];
        
        if (3 != numbers.count) {
            NSAssert(NO, @"This class currently only supported versions in the triple format of x.x.x");
        }
        
        id first = numbers[0];
        id second = numbers[1];
        id third = numbers[2];
        
        self.major = @([first integerValue]);
        self.minor = @([second integerValue]);
        self.revision = @([third integerValue]);
    }
    return self;
}

- (BOOL) isBeforeVersionString:(NSString *)version {
    DUVersion *thisVersion = [DUVersion.alloc initWithVersionString:version];
    return [self isBeforeVersion:thisVersion];
}

- (BOOL) isBeforeVersion:(DUVersion *)version {
    NSComparisonResult result = [self compare:version];
    if (NSOrderedDescending == result) {
        return YES;
    } else {
        return NO;
    }
}

- (NSComparisonResult) compare:(DUVersion *)version {
    if (self.major.intValue < version.major.intValue) {
        return NSOrderedDescending;
    } else {
        if (self.major.intValue == version.major.intValue) {
            if (self.minor.intValue < version.minor.intValue) {
                return NSOrderedDescending;
            } else {
                if (self.minor.intValue == version.minor.intValue) {
                    if (self.revision.intValue < version.revision.intValue) {
                        return NSOrderedDescending;
                    } else {
                        if (self.revision.intValue == version.revision.intValue) {
                            return NSOrderedSame;
                        } else {
                            return NSOrderedAscending;
                        }
                    }
                } else {
                    return NSOrderedAscending;
                }
            }
        } else {
            return NSOrderedAscending;
        }
    }
}

@end

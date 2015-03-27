//
//  DUVersion.h
//  DevedUpKit
//
//  Created by David Casserly on 14/02/2014.
//  Copyright (c) 2014 DevedUp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DUVersion : NSObject

- (instancetype) initWithVersionString:(NSString *)version NS_DESIGNATED_INITIALIZER;

@property (nonatomic, strong, readonly) NSNumber *major;
@property (nonatomic, strong, readonly) NSNumber *minor;
@property (nonatomic, strong, readonly) NSNumber *revision;

- (BOOL) isBeforeVersionString:(NSString *)version;
- (BOOL) isBeforeVersion:(DUVersion *)version;

- (NSComparisonResult) compare:(DUVersion *)otherVersion;

@end

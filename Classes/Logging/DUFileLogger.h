//
//  DUFileLogger.h
//  DevedUpKit
//
//  Created by David Casserly on 21/01/2014.
//  Copyright (c) 2014 DevedUp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DUFileLogger : NSObject

+ (DUFileLogger *) fileLoggerForFile:(NSString *)filename;

- (void) blankLine;
- (void) append:(NSString *)logMessage;

@end

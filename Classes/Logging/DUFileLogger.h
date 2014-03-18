//
//  DUFileLogger.h
//  DevedUpKit
//
//  Created by David Casserly on 21/01/2014.
//  Copyright (c) 2014 DevedUp. All rights reserved.
//

@protocol DUFileLogger <NSObject>
- (void) blankLine;
- (void) append:(NSString *)logMessage;
@end

@interface DUFileLoggerFactory : NSObject
+ (id<DUFileLogger>) fileLoggerForFile:(NSString *)filename;
@end

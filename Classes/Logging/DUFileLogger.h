//
//  DUFileLogger.h
//  DevedUpKit
//
//  Created by David Casserly on 21/01/2014.
//  Copyright (c) 2014 DevedUp. All rights reserved.
//

@import MessageUI;

@protocol DUFileLogger <NSObject, MFMailComposeViewControllerDelegate>
- (void) blankLine;
- (void) append:(NSString *)logMessage;
- (void) emailLogFileFromViewController:(UIViewController *)viewController;
@end

@interface DUFileLoggerFactory : NSObject
+ (id<DUFileLogger>) fileLoggerForFile:(NSString *)filename;
@end

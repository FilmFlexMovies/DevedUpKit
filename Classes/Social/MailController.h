//
//  DMMailController.h
//  ios-common
//
//  Created by David Casserly on 16/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>

@interface MailController : NSObject <MFMailComposeViewControllerDelegate> 

+ (MailController *) sharedMailController;
+ (BOOL) canSendMail;

- (void) presentMailComposerOverViewController:(UIViewController *)vc subject:(NSString *)subject body:(NSString *)body to:(NSString *)to html:(BOOL)isHTML completion:(void (^) (NSError *error))completionBlock;

@end

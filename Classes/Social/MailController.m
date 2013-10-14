//
//  DMMailController.m
//  ios-common
//
//  Created by David Casserly on 16/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MailController.h"



@interface MailController () 
@property (nonatomic, copy) DUBlockWithError completionBlock;
@property (nonatomic, assign) UIViewController *hostController;

@end

@implementation MailController

- (void)dealloc {
	self.completionBlock = nil;  
}


+ (MailController *) sharedMailController {
    static dispatch_once_t onceToken;
    static MailController * __sharedManager = nil;
    
    dispatch_once(&onceToken, ^{
        __sharedManager = [[self alloc] init];
    });
    
    return __sharedManager;
}

+ (BOOL) canSendMail {
    return [MFMailComposeViewController canSendMail];
}

//// From StackOverflow: http://stackoverflow.com/questions/1690279
////Returns true if the ToAddress field was found any of the sub views and made first responder
////passing in @"MFComposeSubjectView"     as the value for field makes the subject become first responder 
////passing in @"MFComposeTextContentView" as the value for field makes the body become first responder 
////passing in @"RecipientTextField"       as the value for field makes the to address field become first responder 
//-(BOOL)setMFMailFieldAsFirstResponder:(UIView*)view mfMailField:(NSString*)field
//{
//    for (UIView *subview in view.subviews)
//	{
//        NSString *className = [NSString stringWithFormat:@"%@", [subview class]];
//        if([className isEqualToString:field])
//        {
//            //Found the sub view we need to set as first responder
//            [subview becomeFirstResponder];
//			
//            return YES;
//        }
//		
//        if([subview.subviews count] > 0)
//		{
//            if([self setMFMailFieldAsFirstResponder:subview mfMailField:field])
//			{
//                //Field was found and made first responder in a subview
//                return YES;
//            }
//        }
//    }
//	
//    //field not found in this view.
//    return NO;
//}

- (void) presentMailComposerOverViewController:(UIViewController *)vc subject:(NSString *)subject body:(NSString *)body to:(NSString *)to html:(BOOL)isHTML completion:(void (^) (NSError *error))completionBlock {
    self.completionBlock = completionBlock;
    
    // Push the emailer view controller
	if([MFMailComposeViewController canSendMail]) {
		MFMailComposeViewController *emailViewController = [[MFMailComposeViewController alloc] init];

        [[emailViewController navigationBar] setTintColor:[UIColor blackColor]];
        
        
        //[emailViewController navigationBar].topItem.titleView
        
#if DEBUG
        [emailViewController setToRecipients:[NSArray arrayWithObject:@"testemail@davidjc.com"]];
#endif

        if (to) {
            [emailViewController setToRecipients:[NSArray arrayWithObject:to]];
        }
 
        [emailViewController setMessageBody:body isHTML:isHTML];
		[emailViewController setSubject:subject];
		emailViewController.mailComposeDelegate = self;
		
        self.hostController = vc; //Just assign
		[vc presentViewController:emailViewController animated:YES completion:nil];
	} else {
        NSError *error = [NSError errorWithDomain:@"You don't have an email address setup on this device" code:999 userInfo:nil];
        if(self.completionBlock)
            self.completionBlock(error);
	}
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void) mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {	
    
	if(error || result==MFMailComposeResultCancelled || result==MFMailComposeResultFailed) {
        if (!error) {
            error = [NSError errorWithDomain:@"Cancelled" code:999 userInfo:nil];
        }
        if(self.completionBlock)
            self.completionBlock(error);
	} else {
        if(self.completionBlock)
            self.completionBlock(nil);    
	}
    [self.hostController dismissViewControllerAnimated:YES completion:nil];
}

@end

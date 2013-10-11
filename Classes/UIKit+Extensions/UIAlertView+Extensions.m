//
//  UIAlertView+Extensions.m
//  DevedUp
//
//  Created by David Casserly on 11/09/2009.
//  Copyright 2010 devedup.com. All rights reserved.
//

#import "UIAlertView+Extensions.h"


@implementation UIAlertView (Extensions)

+ (void) showAlert:(NSString *)alertString {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
													message:alertString
												   delegate:nil 
										  cancelButtonTitle:@"OK" 
										  otherButtonTitles:nil];		
	[alert show];
}

+ (void) askQuestion:(NSString *)question
           withTitle:(NSString *)title
 positiveButtonTitle:(NSString *)yesTitle
 negativeButtonTitle:(NSString *)noTitle
    onPositiveAction:( void (^) (void))positiveAction
    onNegativeAction:( void (^)(void))negativeAction {
    
    
    
}

@end

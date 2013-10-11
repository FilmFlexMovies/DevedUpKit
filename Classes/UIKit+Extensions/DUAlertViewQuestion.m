//
//  DUAlertViewQuestion.m
//  Spend
//
//  Created by Casserly on 11/12/2012.
//  Copyright (c) 2012 David Casserly. All rights reserved.
//

#import "DUAlertViewQuestion.h"

@interface DUAlertViewQuestion ()
@property (nonatomic, strong) UIAlertView *alertView;
@property (nonatomic, copy) DUBlock positiveBlock;
@property (nonatomic, copy) DUBlock negativeBlock;
@end

@implementation DUAlertViewQuestion

- (void) dealloc {
    self.alertView.delegate = nil;
}

- (void) askQuestion:(NSString *)question
           withTitle:(NSString *)title
 positiveButtonTitle:(NSString *)yesTitle
 negativeButtonTitle:(NSString *)noTitle
    onPositiveAction:( void (^) (void))positiveAction
    onNegativeAction:( void (^)(void))negativeAction {
    
    self.positiveBlock = positiveAction;
    self.negativeBlock = negativeAction;
    
    self.alertView = [[UIAlertView alloc] initWithTitle:title
													message:question
												   delegate:self
										  cancelButtonTitle:noTitle
										  otherButtonTitles:yesTitle, nil];
	[self.alertView show];
    
}

#pragma mark - UIAlertViewDelegate

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            if (self.negativeBlock) {
                self.negativeBlock();
                self.negativeBlock = nil;
            }
            break;
        case 1:
            if (self.positiveBlock) {
                self.positiveBlock();
                self.positiveBlock = nil;
            }
            break;
        default:
            break;
    }
}

@end

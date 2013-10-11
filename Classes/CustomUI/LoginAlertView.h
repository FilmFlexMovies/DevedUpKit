//
//  LoginAlertView.h
//  iDeal
//
//  Created by igmac0005 on 15/11/2010.
//  Copyright 2010 DevedUp Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LoginAlertView : UIAlertView <UITextFieldDelegate> {

	@private
	UITextField *_usernameField;
    UITextField *_passwordField;
}

@property (weak, readonly) NSString *username;
@property (weak, readonly) NSString *password;

- (id) initWithDelegate:(id)delegate;

- (void) setDefaultUsername:(NSString *)username;
- (void) clear;

@end

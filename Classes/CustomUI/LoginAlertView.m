//
//  LoginAlertView.m
//  iDeal
//
//  Created by igmac0005 on 15/11/2010.
//  Copyright 2010 DevedUp Ltd. All rights reserved.
//

#import "LoginAlertView.h"

@implementation LoginAlertView

#pragma mark -
#pragma mark Release



#pragma mark -
#pragma mark Init 

- (id) initWithDelegate:(id)delegate {

    NSString *title = NSLocalizedString(@"Login to Flurry", @"");
    NSString *cancel = NSLocalizedString(@"Cancel", @"");
    NSString *ok = NSLocalizedString(@"Find API Key", @"");
    CGSize titleSize = [title sizeWithFont:[UIFont boldSystemFontOfSize:18] constrainedToSize:CGSizeMake(260, MAXFLOAT)];
    
	if ((self = [super initWithTitle:title
							message:(titleSize.height>24)?@"\n\n\n\n":@"\n\n\n"
						   delegate:delegate
				  cancelButtonTitle:cancel
				  otherButtonTitles:ok, nil])) {
		
		
		_usernameField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, (titleSize.height>24)?75.0:45.0, 260.0, 25.0)]; 
		[_usernameField setTextAlignment:NSTextAlignmentLeft];
		[_usernameField setBorderStyle:UITextBorderStyleRoundedRect];
		[_usernameField setSecureTextEntry:NO];
		[_usernameField setDelegate:self];
        [_usernameField setPlaceholder:@"Flurry Username"];
        [_usernameField setKeyboardType:UIKeyboardTypeEmailAddress];
        _usernameField.autocorrectionType = UITextAutocorrectionTypeNo;
		[self addSubview:_usernameField];
        
		float passwordY = _usernameField.frame.origin.y + _usernameField.frame.size.height + 10;
        _passwordField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, passwordY, 260.0, 25.0)]; 
		[_passwordField setTextAlignment:NSTextAlignmentLeft];
		[_passwordField setBorderStyle:UITextBorderStyleRoundedRect];
		[_passwordField setSecureTextEntry:YES];
        [_passwordField setPlaceholder:@"Flurry Password"];
		[_passwordField setDelegate:self];
        _passwordField.autocorrectionType = UITextAutocorrectionTypeNo;
		[self addSubview:_passwordField];
        

#ifdef DEBUG
        _usernameField.text = @"";
        _passwordField.text = @"";
#endif
        
	}
	return self;

}

- (BOOL)textFieldShouldReturn:(UITextField *)_textField {
    if (_textField == _usernameField) {
        if ([_usernameField.text length] > 0) {
           [_passwordField becomeFirstResponder];
            return YES;
        } else {
            return NO;
        }
    } else if (_textField == _passwordField) {
        if ([_passwordField.text length] > 0) {
            [_passwordField resignFirstResponder];        
            if ([_usernameField.text length] > 0) {
                [self dismissWithClickedButtonIndex:1 animated:YES];
                return YES;
            } else {
                [_usernameField becomeFirstResponder];
                return YES;
            }
        } else {
            return NO;
        } 
    } else {
        return NO;
    }
}

- (void) show {
    [_usernameField becomeFirstResponder];
    [super show];
}

- (NSString *) username {
    return _usernameField.text;
}

- (NSString *) password {
    return _passwordField.text;
}

- (void) setDefaultUsername:(NSString *)username {
    _usernameField.text = username;
}

- (void) clear {
    _usernameField.text = @"";
    _passwordField.text = @"";
}

@end

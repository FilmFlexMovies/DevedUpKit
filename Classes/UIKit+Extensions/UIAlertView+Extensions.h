//
//  UIAlertView+Extensions.h
//  DevedUp
//
//  Created by David Casserly on 11/09/2009.
//  Copyright 2010 devedup.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIAlertView (Extensions)

+ (void) showAlert:(NSString *)alertString;

+ (void) askQuestion:(NSString *)question
           withTitle:(NSString *)title
 positiveButtonTitle:(NSString *)yesTitle
 negativeButtonTitle:(NSString *)noTitle
    onPositiveAction:( void (^) (void))positiveAction
    onNegativeAction:( void (^)(void))negativeAction;

@end

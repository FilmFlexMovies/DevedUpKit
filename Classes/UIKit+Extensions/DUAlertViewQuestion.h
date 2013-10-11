//
//  DUAlertViewQuestion.h
//  Spend
//
//  Created by Casserly on 11/12/2012.
//  Copyright (c) 2012 David Casserly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DUAlertViewQuestion : NSObject <UIAlertViewDelegate>

- (void) askQuestion:(NSString *)question
           withTitle:(NSString *)title
 positiveButtonTitle:(NSString *)yesTitle
 negativeButtonTitle:(NSString *)noTitle
    onPositiveAction:( void (^) (void))positiveAction
    onNegativeAction:( void (^)(void))negativeAction;

@end

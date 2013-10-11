//
//  DUBaseViewController.h
//  TEMPLATE
//
//  Created by David Casserly on 01/12/2012.
//  Copyright (c) 2012 David Casserly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DUBaseViewController : UIViewController

#pragma mark - Progress

- (void) showProgressOverView:(UIView *)progressHostView;
- (void) hideProgressOverView:(UIView *)progressHostView;

- (void) showProgressImmediatelyOverView:(UIView *)progressHostView;
- (void) hideProgressImmediatelyOverView:(UIView *)progressHostView;

- (void) showProgress;
- (void) hideProgress;

@end

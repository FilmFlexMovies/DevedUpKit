//
//  DUBaseViewController.m
//  TEMPLATE
//
//  Created by David Casserly on 01/12/2012.
//  Copyright (c) 2012 David Casserly. All rights reserved.
//

#import "DUBaseViewController.h"
#import "DUGestureFactory.h"
#import "DUModalProgressView.h"

@interface DUBaseViewController ()
@property (nonatomic, retain) NSMutableDictionary *subProgressViews; //ie progress over sub views /regions
@property (nonatomic, retain) NSTimer *hideProgressTimer;
@property (nonatomic, retain) NSTimer *showProgressTimer;
@end

@implementation DUBaseViewController

//- (void)viewDidLoad {
//    [super viewDidLoad];
//	[DUGestureFactory addSingleTapToView:self.view target:self action:@selector(viewSingleTapped:)];
//}
//
//#pragma mark - Gestures
//
//- (void) viewSingleTapped:(UIGestureRecognizer *)gesture {
//    [self.view endEditing:YES];
//}

- (void) viewDidLoad {
    [super viewDidLoad];
    self.subProgressViews = [[NSMutableDictionary alloc] init];
}

#pragma mark - Progress

- (void) showProgressImmediatelyOverView:(UIView *)progressHostView {
    [self showProgressOverView:progressHostView delay:0];
}

- (void) showProgressOverView:(UIView *)progressHostView {
    [self showProgressOverView:progressHostView delay:0.3];
}

- (void) showProgressOverView:(UIView *)progressHostView delay:(NSTimeInterval)delay {
    [self.hideProgressTimer invalidate];
    self.hideProgressTimer = nil;
    
    if (self.showProgressTimer) {
        //one already about to appear
        return;
    } else {
        NSDictionary *userInfo = @{ @"data" : progressHostView };
        self.showProgressTimer = [NSTimer scheduledTimerWithTimeInterval:delay target:self selector:@selector(delayedShowProgress:) userInfo:userInfo repeats:NO];
    }
}

- (void) delayedShowProgress:(NSTimer *)timer {
    NSDictionary *userInfo = timer.userInfo;
    
    UIView *progressHostView = [userInfo objectForKey:@"data"];
    
    NSUInteger hash = [progressHostView hash]; //hash because SwipeView didn't implement copyWithZone
	
    if ([self.subProgressViews objectForKey:@(hash)]) {
        //This host already has a progress view
        return;
    }
    CGRect modalFrame = progressHostView.bounds;
    
    DUModalProgressView *progressView = [[DUModalProgressView alloc] initWithFrame:modalFrame];
    [progressHostView addSubview:progressView];
    [progressView showAnimatedWithOverlay:YES];
	[progressView setUserInteractionEnabled:YES];
    
    [self.subProgressViews setObject:progressView forKey:@(hash)];
}

- (void) delayedHideProgress:(NSTimer *)timer {
    NSDictionary *userInfo = timer.userInfo;
    
    UIView *progressHostView = [userInfo objectForKey:@"data"];
    
    NSUInteger hash = [progressHostView hash]; //hash because SwipeView didn't implement copyWithZone
	
    DUModalProgressView *progressView = [self.subProgressViews objectForKey:@(hash)];
    
    if (!progressView) {
        //This host doesn't have a progress view
        return;
    }
    
    [progressView hideAnimatedWithCompletion:^{
        [progressView removeFromSuperview];
        [self.subProgressViews removeObjectForKey:@(hash)];
    }];
}


- (void) hideProgressImmediatelyOverView:(UIView *)progressHostView {
    [self hideProgressOverView:progressHostView delay:0];
}

- (void) hideProgressOverView:(UIView *)progressHostView {
    [self hideProgressOverView:progressHostView delay:0.2];
}

- (void) hideProgressOverView:(UIView *)progressHostView delay:(NSTimeInterval)delay {
    if (!progressHostView) {
        return;
    }
    
    [self.showProgressTimer invalidate];
    self.showProgressTimer = nil;
    
    if (self.hideProgressTimer) {
        return;
    } else {
        NSDictionary *userInfo = @{ @"data" : progressHostView };
        self.hideProgressTimer = [NSTimer scheduledTimerWithTimeInterval:delay target:self selector:@selector(delayedHideProgress:) userInfo:userInfo repeats:NO];
    }
}

- (void) removedAllProgressViews {
    //Get rid of all current progress views
    for (NSNumber *key in [self.subProgressViews allKeys]) {
        DUModalProgressView *progressView = [self.subProgressViews objectForKey:key];
        [progressView removeFromSuperview];
    }
    [self.subProgressViews removeAllObjects];
    [self.showProgressTimer invalidate];
    self.showProgressTimer = nil;
}


//This covers the whole view of the controller
- (void) showProgress {
    [self showProgressOverView:self.view];
}

- (void) hideProgress {
    [self hideProgressOverView:self.view];
}

@end

//
//  DUGestureFactory.h
//  DevedUp
//
//  Created by David Casserly on 13/12/2011.
//  Copyright (c) 2011 DevedUp Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DUTouchDownGestureRecogniser.h"

@interface DUGestureFactory : NSObject

#pragma mark - Swipes
+ (UISwipeGestureRecognizer *) addRightSwipeToView:(UIView *)view target:(id)target action:(SEL)selector requireGestureToFail:(UIGestureRecognizer *)gesture;
+ (UISwipeGestureRecognizer *) addRightSwipeToView:(UIView *)view target:(id)target action:(SEL)selector;
+ (UISwipeGestureRecognizer *) addLeftSwipeToView:(UIView *)view target:(id)target action:(SEL)selector requireGestureToFail:(UIGestureRecognizer *)gesture;
+ (UISwipeGestureRecognizer *) addLeftSwipeToView:(UIView *)view target:(id)target action:(SEL)selector;
+ (UISwipeGestureRecognizer *) addTwoFingerSwipeDownToView:(UIView *)view target:(id)target action:(SEL)selector requireGestureToFail:(UIGestureRecognizer *)gesture;
+ (UISwipeGestureRecognizer *) addSwipeDownToView:(UIView *)view target:(id)target action:(SEL)selector requireGestureToFail:(UIGestureRecognizer *)gesture;
+ (UISwipeGestureRecognizer *) addSwipeUpToView:(UIView *)view target:(id)target action:(SEL)selector requireGestureToFail:(UIGestureRecognizer *)gesture;

#pragma mark - Taps
+ (UITapGestureRecognizer *) addDoubleTapToView:(UIView *)view target:(id)target action:(SEL)selector;
+ (UITapGestureRecognizer *) addSingleTapToView:(UIView *)view target:(id)target action:(SEL)selector requireGestureToFail:(UIGestureRecognizer *)gesture;
+ (UITapGestureRecognizer *) addSingleTapToView:(UIView *)view target:(id)target action:(SEL)selector;
+ (DUTouchDownGestureRecogniser *) addTouchDownToView:(UIView *)view target:(id)target action:(SEL)selector;

+ (UITapGestureRecognizer *) addFiveTapToView:(UIView *)view target:(id)target action:(SEL)selector;

#pragma mark - Pan
+ (UIPanGestureRecognizer *) addPanToView:(UIView *)view target:(id)target action:(SEL)selector requireGestureToFail:(UIGestureRecognizer *)gesture;
+ (UIPanGestureRecognizer *) addPanToView:(UIView *)view target:(id)target action:(SEL)selector;
+ (UIPanGestureRecognizer *) addPanTwoFingersToView:(UIView *)view target:(id)target action:(SEL)selector;

#pragma mark - Pinch
+ (UIPinchGestureRecognizer *) addPinchToView:(UIView *)view target:(id)target action:(SEL)selector;

@end

//
//  DUAutolayout.h
//  FilmFlexMovies
//
//  Created by David Casserly on 08/08/2013.
//  Copyright (c) 2013 FilmFlex Movies Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DUAutolayout : NSObject

#pragma mark - Size

+ (void) constraintWidth:(CGFloat)width height:(CGFloat)height toView:(UIView *)view;

#pragma mark - Alignment

+ (void) pinSubview:(UIView *)subview toRightOfView:(UIView *)superview padding:(CGFloat)padding;
+ (void) horizontallyCenterSubview:(UIView *)subview inView:(UIView *)superview;
+ (void) verticallyCenterSubview:(UIView *)subview inView:(UIView *)superview;
+ (void) centerSubview:(UIView *)subview inView:(UIView *)superview;
+ (void) addSubviewAndFillBounds:(UIView *)subview toView:(UIView *)superview;

#pragma mark - iOS 7 Layout Guides

+ (void) pinView:(UIView *)view toBottomLayout:(id)bottomLayoutGuide removingCurrentConstraint:(NSLayoutConstraint *)bottomConstraint;

+ (void) pinView:(UIView *)view toBottomLayout:(id)bottomLayoutGuide removingCurrentConstraint:(NSLayoutConstraint *)bottomConstraint offset:(CGFloat)offset;

@end

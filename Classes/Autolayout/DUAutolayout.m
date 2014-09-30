//
//  DUAutolayout.m
//  FilmFlexMovies
//
//  Created by David Casserly on 08/08/2013.
//  Copyright (c) 2013 FilmFlex Movies Ltd. All rights reserved.
//

#import "DUAutolayout.h"

@implementation DUAutolayout

#pragma mark - Size

+ (void) constraintWidth:(CGFloat)width height:(CGFloat)height toView:(UIView *)view {
    NSLayoutConstraint *widthContraint =
    [NSLayoutConstraint constraintWithItem:view
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1.0
                                  constant:width];
    [view addConstraint:widthContraint];
    
    NSLayoutConstraint *heightContraint =
    [NSLayoutConstraint constraintWithItem:view
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1.0
                                  constant:height];
    [view addConstraint:heightContraint];
}



+ (void) addSubviewAndFillBounds:(UIView *)subview toView:(UIView *)superview {
    
    [superview addSubview:subview];
    
    NSLayoutConstraint *widthContraint =
    [NSLayoutConstraint constraintWithItem:subview
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:superview
                                 attribute:NSLayoutAttributeWidth
                                multiplier:1.0
                                  constant:0.0];
    [superview addConstraint:widthContraint];
    
    NSLayoutConstraint *heightContraint =
    [NSLayoutConstraint constraintWithItem:subview
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:superview
                                 attribute:NSLayoutAttributeHeight
                                multiplier:1.0
                                  constant:0.0];
    [superview addConstraint:heightContraint];
    
    [self centerSubview:subview inView:superview];
}

+ (void) pinSubview:(UIView *)subview toRightOfView:(UIView *)superview padding:(CGFloat)padding {
    NSLayoutConstraint *pinConstraint =
    [NSLayoutConstraint constraintWithItem:subview
                                 attribute:NSLayoutAttributeRight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:superview
                                 attribute:NSLayoutAttributeRight
                                multiplier:1.0
                                  constant:-padding];
    [superview addConstraint:pinConstraint];
}

+ (void) pinSubview:(UIView *)subview toLeftOfView:(UIView *)superview padding:(CGFloat)padding {
    NSLayoutConstraint *pinConstraint =
    [NSLayoutConstraint constraintWithItem:subview
                                 attribute:NSLayoutAttributeLeft
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:superview
                                 attribute:NSLayoutAttributeLeft
                                multiplier:1.0
                                  constant:-padding];
    [superview addConstraint:pinConstraint];
}

+ (void) horizontallyCenterSubview:(UIView *)subview inView:(UIView *)superview {
    NSLayoutConstraint *centerXConstraint =
    [NSLayoutConstraint constraintWithItem:subview
                                 attribute:NSLayoutAttributeCenterX
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:superview
                                 attribute:NSLayoutAttributeCenterX
                                multiplier:1.0
                                  constant:0.0];
    [superview addConstraint:centerXConstraint];
}

+ (void) verticallyCenterSubview:(UIView *)subview inView:(UIView *)superview {
//    NSDictionary *variables = NSDictionaryOfVariableBindings(subview, superview);    
//    NSArray *constraints =
//    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[superview]-(<=1)-[subview]"
//                                            options:NSLayoutFormatAlignAllLeft
//                                            metrics:nil
//                                              views:variables];
//    [superview addConstraints:constraints];
    
    NSLayoutConstraint *centerYConstraint =
    [NSLayoutConstraint constraintWithItem:subview
                                 attribute:NSLayoutAttributeCenterY
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:superview
                                 attribute:NSLayoutAttributeCenterY
                                multiplier:1.0
                                  constant:0.0];
    [superview addConstraint:centerYConstraint];
}

+ (void) centerSubview:(UIView *)subview inView:(UIView *)superview {
 
    subview.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *centerYConstraint =
    [NSLayoutConstraint constraintWithItem:subview
                                 attribute:NSLayoutAttributeCenterY
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:superview
                                 attribute:NSLayoutAttributeCenterY
                                multiplier:1.0
                                  constant:0.0];
    [superview addConstraint:centerYConstraint];
    
    NSLayoutConstraint *centerXConstraint =
    [NSLayoutConstraint constraintWithItem:subview
                                 attribute:NSLayoutAttributeCenterX
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:superview
                                 attribute:NSLayoutAttributeCenterX
                                multiplier:1.0
                                  constant:0.0];
    [superview addConstraint:centerXConstraint];
    
}

/* 
 // how to centre using visual format
+ (void) centerSubview2:(UIView *)subview inView:(UIView *)superview {
    
    subview.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *variables = NSDictionaryOfVariableBindings(subview, superview);
    NSArray *constraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[superview]-(<=1)-[subview]"
                                            options:NSLayoutFormatAlignAllCenterX
                                            metrics:nil
                                              views:variables];
    [superview addConstraints:constraints];
    
    constraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:[superview]-(<=1)-[subview]"
                                            options:NSLayoutFormatAlignAllCenterY
                                            metrics:nil
                                              views:variables];
    [superview addConstraints:constraints];
}
*/

#pragma mark - iOS 7 Layout Guides

+ (void) pinView:(UIView *)view toBottomLayout:(id)bottomLayoutGuide removingCurrentConstraint:(NSLayoutConstraint *)bottomConstraint {
    [self pinView:view toBottomLayout:bottomLayoutGuide removingCurrentConstraint:bottomConstraint offset:0];
}

+ (void) pinView:(UIView *)view toBottomLayout:(id)bottomLayoutGuide removingCurrentConstraint:(NSLayoutConstraint *)bottomConstraint offset:(CGFloat)offset {
    
    [view.superview removeConstraint:bottomConstraint];
    NSDictionary *views = @{@"view":view, @"bottomLayoutGuide":bottomLayoutGuide};
    NSDictionary *metrics = @{@"offset": @(offset)};
    [view.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[view]-offset-[bottomLayoutGuide]" options:0 metrics:metrics views:views]];
}

@end

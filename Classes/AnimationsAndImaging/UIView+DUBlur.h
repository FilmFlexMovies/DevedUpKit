//
//  UIView+DUBlur.h
//  FilmFlexMovies
//
//  Created by David Casserly on 02/09/2013.
//  Copyright (c) 2013 FilmFlex Movies Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (DUBlur)

#pragma mark - Apply blur and return an Image View

- (UIImageView *) blurredImageView_DU:(CGFloat)intensity;

#pragma mark - Apply Blur to current view

- (void) blurWithIntensity_DU:(CGFloat)intensity;
- (void) removeBlur_DU;

@end

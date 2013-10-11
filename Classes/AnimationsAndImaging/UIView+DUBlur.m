//
//  UIView+DUBlur.m
//  FilmFlexMovies
//
//  Created by David Casserly on 02/09/2013.
//  Copyright (c) 2013 FilmFlex Movies Ltd. All rights reserved.
//

#import "UIView+DUBlur.h"
#import "UIImage+ImageEffects.h"

NSInteger kBlurredViewTag = 5784738;

@implementation UIView (DUBlur)

- (void) blur_DU {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImage *blurredImage = [viewImage applyDarkEffect];
    UIImageView *imageView = [UIImageView.alloc initWithImage:blurredImage];
    imageView.frame = self.bounds;
    imageView.tag = kBlurredViewTag;
    imageView.alpha = 0.0f;
    [self addSubview:imageView];
    [UIView animateWithDuration:0.3f animations:^{
        imageView.alpha = 1.0f;
    }];
}

- (void) removeBlur_DU {
    UIImageView *imageView = (UIImageView *) [self viewWithTag:kBlurredViewTag];
    [UIView animateWithDuration:0.3f animations:^{
        imageView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [imageView removeFromSuperview];
    }];
}

@end

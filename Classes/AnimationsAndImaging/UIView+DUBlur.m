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

- (UIImageView *) blurredImageView_DU:(CGFloat)intensity {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImage *blurredImage = [viewImage applyDarkEffectWithBlurIntensity:intensity];
    UIImageView *imageView = [UIImageView.alloc initWithImage:blurredImage];
    imageView.frame = self.bounds;
    imageView.tag = kBlurredViewTag;
    return imageView;
}

- (void) blurWithIntensity_DU:(CGFloat)intensity {
    UIImageView *imageView = [self blurredImageView_DU:intensity];
    imageView.alpha = 0.0f;
    [self addSubview:imageView];
    [UIView animateWithDuration:0.5f animations:^{
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

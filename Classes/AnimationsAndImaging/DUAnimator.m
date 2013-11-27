//
//  DUAnimator.m
//  ProjectAirside
//
//  Created by David Casserly on 29/07/2013.
//
//

#import "DUAnimator.h"

@implementation DUAnimator

#define kStaggerAnimationSpeed 0.4
#define kStaggerAnimationDelay 0.05

+ (void) staggerAnimate:(id<DUStaggerAnimatee>)target inFromDirection:(DUAnimationDirection)direction completion:(void(^)(void))completion {
    NSArray *views = [target viewsToStaggerAnimateForDirection:direction];
    UIView *containerView = [target containerView];
    
    CGFloat width = CGRectGetWidth(containerView.bounds);
    if (DUAnimationDirectionLeft == direction) {
        width = 0 - width; //reverse width
    }
    for (UIView *view in views) {
        view.layer.transform = CATransform3DMakeTranslation(width, 0, 0);
    }
    
    [self applyStaggerAnimationsToViews:views withTransform:CATransform3DIdentity completion:completion];
}

+ (void) staggerAnimate:(id<DUStaggerAnimatee>)target outInDirection:(DUAnimationDirection)direction completion:(void(^)(void))completion {
    NSArray *views = [target viewsToStaggerAnimateForDirection:direction];
    UIView *containerView = [target containerView];
    
    CGFloat width = CGRectGetWidth(containerView.bounds);
    if (DUAnimationDirectionLeft == direction) {
        width = 0 - width; //reverse width
    }
    
    CATransform3D transform = CATransform3DMakeTranslation(width, 0, 0);
    [self applyStaggerAnimationsToViews:views withTransform:transform completion:^{
        if (completion) {
            completion();
        }
        for (UIView *view in views) {
            view.layer.transform = CATransform3DIdentity; //reset
        }
    }];
}

+ (void) applyStaggerAnimationsToViews:(NSArray *)views withTransform:(CATransform3D)transform completion:(void(^)(void))completion {
    float delay = kStaggerAnimationDelay;
    int count = 1;
    for (UIView *view in views) {
        [UIView animateWithDuration:kStaggerAnimationSpeed delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
            view.layer.transform = transform;
        } completion:^(BOOL finished) {
            if (count == views.count) {
                //i.e. last view
                if (completion) {
                    completion();
                }
            }
        }];
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
			delay += kStaggerAnimationDelay;
		}
        count++;
    }
}




@end

//
//  DUAnimator.h
//  ProjectAirside
//
//  Created by David Casserly on 29/07/2013.
//
//

#import <Foundation/Foundation.h>

typedef enum {
	DUAnimationDirectionLeft,
    DUAnimationDirectionRight,
    DUAnimationDirectionUp,
    DUAnimationDirectionDown
} DUAnimationDirection;

@protocol DUStaggerAnimatee;

@interface DUAnimator : NSObject

+ (void) staggerAnimate:(id<DUStaggerAnimatee>)target inFromDirection:(DUAnimationDirection)direction completion:(void(^)(void))completion;
+ (void) staggerAnimate:(id<DUStaggerAnimatee>)target outInDirection:(DUAnimationDirection)direction completion:(void(^)(void))completion;

@end

#pragma mark - DUStaggerAnimatee

@protocol DUStaggerAnimatee <NSObject>
@required
- (UIView *) containerView;
- (NSArray *) viewsToStaggerAnimateForDirection:(DUAnimationDirection)direction;
@end



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

@interface DUAnimator : NSObject

+ (void) staggerAnimateViews:(NSArray *)views inView:(UIView *)containerView inFromDirection:(DUAnimationDirection)direction completion:(void(^)(void))completion;
+ (void) staggerAnimateViews:(NSArray *)views inView:(UIView *)containerView outInDirection:(DUAnimationDirection)direction completion:(void(^)(void))completion;

@end

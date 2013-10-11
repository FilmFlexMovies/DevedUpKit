//
//  CALayer+DUExtensions.h
//  DevedUp
//
//  Created by David Casserly on 28/12/2011.
//  Copyright (c) 2011 DevedUp Ltd. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

typedef enum {
    DUAnchorPointDefault = 0,
	DUAnchorPointTopCenter,
} DUAnchorPoint;

@interface CALayer (DUExtensions)

- (void) applyTopShadowAtPath:(CGPathRef)path;
- (void) applyRightShadowAtPath:(CGPathRef)path;
- (void) applyBottomShadowAtPath:(CGPathRef)path;
- (void) applyLeftShadowAtPath:(CGPathRef)path;

- (void) setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view;
- (void) setAnchorPointWithPoint:(DUAnchorPoint)anchorPoint forView:(UIView *)view;

@end

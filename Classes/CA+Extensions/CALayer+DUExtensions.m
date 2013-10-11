//
//  CALayer+DUExtensions.m
//  DevedUp
//
//  Created by David Casserly on 28/12/2011.
//  Copyright (c) 2011 DevedUp Ltd. All rights reserved.
//

#import "CALayer+DUExtensions.h"

@implementation CALayer (DUExtensions)

- (void) applyDefaultShadowProperties {
    self.shadowRadius = 4.0f;
    self.shadowOpacity = 0.7f;
    self.shadowColor = [UIColor blackColor].CGColor;
}

- (void) applyTopShadowAtPath:(CGPathRef)path {
    [self applyDefaultShadowProperties];
    self.shadowPath = path;
    self.shadowOffset = CGSizeMake(0.0, -5.0);
}

- (void) applyBottomShadowAtPath:(CGPathRef)path {
    [self applyDefaultShadowProperties];
    self.shadowPath = path;
    self.shadowOffset = CGSizeMake(0.0, 5.0);
}

- (void) applyRightShadowAtPath:(CGPathRef)path {
   [self applyDefaultShadowProperties];
    self.shadowPath = path;
    self.shadowOffset = CGSizeMake(5.0, 0.0);
}

- (void) applyLeftShadowAtPath:(CGPathRef)path {
    [self applyDefaultShadowProperties];
    self.shadowPath = path;
    self.shadowOffset = CGSizeMake(-5.0, 0.0);
}

- (void) setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view {
    CGPoint newPoint = CGPointMake(view.bounds.size.width * anchorPoint.x, view.bounds.size.height * anchorPoint.y);
    CGPoint oldPoint = CGPointMake(view.bounds.size.width * view.layer.anchorPoint.x, view.bounds.size.height * view.layer.anchorPoint.y);
    
    newPoint = CGPointApplyAffineTransform(newPoint, view.transform);
    oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform);
    
    CGPoint position = view.layer.position;
    
    position.x -= oldPoint.x;
    position.x += newPoint.x;
    
    position.y -= oldPoint.y;
    position.y += newPoint.y;
    
    view.layer.position = position;
    view.layer.anchorPoint = anchorPoint;
}

- (void) setAnchorPointWithPoint:(DUAnchorPoint)anchorPoint forView:(UIView *)view {
    CGPoint ap;
    switch (anchorPoint) {
        case DUAnchorPointDefault:
            ap = CGPointMake(0.5, 0.5);
            break;
        case DUAnchorPointTopCenter:
            ap = CGPointMake(0.5, 0);
            break;         
        default:
            break;
    }
    [self setAnchorPoint:ap forView:view];
}
@end

//
//  UIView+UIView_DUExtensions.m
//  DevedUp
//
//  Created by David Casserly on 19/11/2011.
//  Copyright (c) 2011 Ground Floor. All rights reserved.
//

#import "UIView+DUExtensions.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (DUExtensions)

- (void) du_setAnchorPoint:(CGPoint)anchorPoint {
    CGPoint newPoint = CGPointMake(self.bounds.size.width * anchorPoint.x, self.bounds.size.height * anchorPoint.y);
    CGPoint oldPoint = CGPointMake(self.bounds.size.width * self.layer.anchorPoint.x, self.bounds.size.height * self.layer.anchorPoint.y);
    
    newPoint = CGPointApplyAffineTransform(newPoint, self.transform);
    oldPoint = CGPointApplyAffineTransform(oldPoint, self.transform);
    
    CGPoint position = self.layer.position;
    
    position.x -= oldPoint.x;
    position.x += newPoint.x;
    
    position.y -= oldPoint.y;
    position.y += newPoint.y;
    
    self.layer.position = position;
    self.layer.anchorPoint = anchorPoint;
}

- (BOOL) visible {
    return !self.hidden;
}

- (void) addSubviewAndFillBounds:(UIView *)subview {
    subview.frame = self.bounds;
    subview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:subview];
}

#pragma mark - Bounces

- (void) shake {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.duration = 0.6;
    animation.values = @[ @(-20), @(20), @(-20), @(20), @(-10), @(10), @(-5), @(5), @(0) ];
    [self.layer addAnimation:animation forKey:@"shake"];
}

- (void) bounceOnLeft {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.duration = 0.5;
    animation.values = @[ @(0), @(15), @(0), @(5), @(0) ];
    [self.layer addAnimation:animation forKey:@"shake"];
}

- (void) bounceOnRight {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.duration = 0.5;
    animation.values = @[ @(0), @(-15), @(0), @(-5), @(0) ];
    [self.layer addAnimation:animation forKey:@"shake"];
}

- (void) bounceUpAndDown:(UIView *)viewToBound forKey:(NSString *)key {
	CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"];
	[animation setValue:key forKey:@"name"];
	[animation setDelegate:self];
	
	animation.duration = 0.5;
	animation.values = @[@0,
						@-15,
						@0,
						@-5,
						@0];
	
	animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
	
	[viewToBound.layer addAnimation:animation forKey:@"bounceUpAndDown"];
}

@end

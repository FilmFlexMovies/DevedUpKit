//
//  ViewHelper.m
//  DevedUp
//
//  Created by David Casserly on 21/08/2009.
//  Copyright 2010 devedup.com. All rights reserved.
//

#import "ViewHelper.h"
#import <QuartzCore/CoreAnimation.h>

@implementation ViewHelper

#pragma mark -
#pragma mark Move views by pixels

+ (void) moveView:(UIView *)view up:(float)pixels {
	//inverse if negative
	if (pixels < 0) {
		pixels = -pixels;
	}
	CGRect currentFrame = view.frame;
	currentFrame.origin.y = currentFrame.origin.y - pixels;	
	view.frame = currentFrame;
}

+ (void) moveView:(UIView *)view down:(float)pixels {
	//inverse if negative
	if (pixels < 0) {
		pixels = -pixels;
	}
	CGRect currentFrame = view.frame;
	currentFrame.origin.y = currentFrame.origin.y + pixels;	
	view.frame = currentFrame;
}

#pragma mark -
#pragma mark Move views by their height

+ (void) moveViewDownByItsHeight:(UIView *)view and:(float)extra{
	CGRect currentFrame = view.frame;
	currentFrame.origin.y = currentFrame.origin.y + currentFrame.size.height + extra;	
	view.frame = currentFrame;
}

+ (void) moveViewUpByItsHeight:(UIView *)view and:(float)extra{
	CGRect currentFrame = view.frame;
	currentFrame.origin.y = currentFrame.origin.y - currentFrame.size.height - extra;	
	view.frame = currentFrame;
}

#pragma mark -
#pragma mark Scroll View Content

+ (void) setScrollViewContentSizeBasedOnContents:(UIScrollView *)scrollView {
	//Find width for content
	NSArray *subviews = [scrollView subviews];
	float highest = 0;
	for (UIView *sub in subviews) {
		CGRect frame = sub.frame;
		float x = frame.origin.x;
		float width = frame.size.width;
		float farRight = x + width + (width / 2);
		if (farRight > highest) {
			highest = farRight;
		}
	}
	
	scrollView.contentSize = CGSizeMake(highest, scrollView.frame.size.height);
}

+ (void) roundCorners:(UIRectCorner)corners withRadii:(CGSize)size onView:(UIView *)view {
    // Create the path (with only the top-left corner rounded)
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds 
                                                   byRoundingCorners:corners
                                                         cornerRadii:size];
    
    // Create the shape layer and set its path
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    
    // Set the newly created shape layer as the mask for the image view's layer
    view.layer.mask = maskLayer;
    
    // Clean up
}

+ (void) roundBottomCornersOnView:(UIView *)view {
    [self roundCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight withRadii:CGSizeMake(10.0, 10.0) onView:view];
}

@end

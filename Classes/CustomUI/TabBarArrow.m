//
//  TabBarArrow.m
//  DevedUp
//
//  Created by David Casserly on 23/02/2009.
//  Copyright 2010 devedup.com. All rights reserved.
//

#import "TabBarArrow.h"
#import <QuartzCore/CoreAnimation.h>

//Offset is because of the size of the image
#define offset 7.5
#define kTabOneCentre 55.0 - offset
#define kTabTwoCentre 160.0 - offset
#define kTabThreeCentre 265.0 - offset
//below unused in this app
#define kTabFourCentre 224.0 - offset
#define kTabFiveCentre 288.0 - offset

#define kArrowHeight 8.0
#define kArrowWidth	16.0

/**
 *	Private Methods Category
 */
@interface TabBarArrow () 

- (void) createGraphics;

@end

/**
 *	Implementation
 */
@implementation TabBarArrow

- (id) init {
	/*
		Creating a frame which is just above the tab bar and is 
	 */
    if (self = [super initWithFrame:CGRectMake(0, 416 - 56 -kArrowHeight, 320, kArrowHeight)]) {
        self.backgroundColor = [UIColor clearColor];
		self.userInteractionEnabled = NO;
		
		currentTab = ShowArrowTabOne;
		
		[self createGraphics];
    }
    return self;
}

- (void) createGraphics {
	
	/*
		Paint a base white line
	 */
//	CGContextRef ctx = UIGraphicsGetCurrentContext();
//	CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
//	CGContextFillRect(ctx, CGRectMake(0, 0, 320, 1));
//	
//	UIImage *whiteLine = UIGraphicsGetImageFromCurrentImageContext();
//	UIGraphicsEndImageContext();
//	UIImageView *whiteLineView = [[UIImageView alloc] initWithImage:whiteLine];
//	whiteLineView.frame = CGRectMake(-320, kArrowHeight - 1, 640, 1);
//	[self insertSubview:whiteLineView atIndex:0];
//	
//	UIGraphicsEndImageContext();
	
	/*
		Draw the black triangle
	 */
	
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(16,8), NO, 0.0f);
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetLineWidth(context, 1.5);

	/*
		Draw 3 triangles on top of each other, progressively smaller to
		give the border effect. This is easier than trying to draw borders.
	 */
	
	//Bottom triangle
	CGContextSetFillColorWithColor(context, [UIColor colorWithRed:3.0f/255.0f green:30.0f/255.0f blue:24.0f/255.0f alpha:1.0f].CGColor);
	CGPoint points[3];
	points[0] = CGPointMake (-1, 7);
	points[1] = CGPointMake (8, 0); 
	points[2] = CGPointMake (17, 7);	
	CGContextAddLines(context, points, 3);
	CGContextDrawPath(context, kCGPathFill);
	
	//2nd triangle
	CGContextSetFillColorWithColor(context, [UIColor colorWithRed:235.0f/255.0f green:235.0f/255.0f blue:235.0f/255.0f alpha:1.0f].CGColor);
	points[0] = CGPointMake (0, 8);
	points[1] = CGPointMake (8, 2); 
	points[2] = CGPointMake (16, 8);	
	CGContextAddLines(context, points, 3);
	CGContextDrawPath(context, kCGPathFill);
	
	//3rd triangle
	CGContextSetFillColorWithColor(context, [UIColor colorWithRed:227.0f/255.0f green:227.0f/255.0f blue:227.0f/255.0f alpha:1.0f].CGColor);
	points[0] = CGPointMake (2, 9);
	points[1] = CGPointMake (9, 4); 
	points[2] = CGPointMake (14, 9);	
	CGContextAddLines(context, points, 3);
	CGContextDrawPath(context, kCGPathFill);
	
	UIImage *arrow = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	UIImageView *arrowView = [[UIImageView alloc] initWithImage:arrow];
	arrowView.frame = CGRectMake(0, 0, 16, 8);
	arrowView.backgroundColor = [UIColor clearColor];
	arrowView.contentMode = UIViewContentModeBottomLeft;
	//arrowView.backgroundColor = [UIColor yellowColor];
	//arrowView.backgroundColor = [UIColor redColor];
	[self insertSubview:arrowView atIndex:1];
}

- (id) initWithFrame:(CGRect)frame {
	return [self init];
}

- (void) showArrowAtTab:(ShowArrowTab)tab {		
	currentTab = tab;
	[self setNeedsDisplayInRect:CGRectMake(0, 0, 320, 44)];
}

- (void)drawRect:(CGRect)rect {
	//Find where the arrow current is
	CALayer *presentationLayer = (CALayer *) [self.layer presentationLayer];
	NSNumber *currentPosition = [presentationLayer valueForKeyPath:@"transform.translation.x"];
	
	//Create a translation animation
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
	animation.fromValue = currentPosition;
 	//Where to move to...
	float moveToPosition = 0.0;
	switch (currentTab) {
		case ShowArrowTabOne:
			moveToPosition = kTabOneCentre;
			break;
		case ShowArrowTabTwo:
			moveToPosition = kTabTwoCentre;
			break;
		case ShowArrowTabThree:
			moveToPosition = kTabThreeCentre;
			break;
		case ShowArrowTabFour:
			moveToPosition = kTabFourCentre;
			break;
		case ShowArrowTabFive:
			moveToPosition = kTabFiveCentre;
			break;
		default:
			break;
	}
	animation.toValue = @(moveToPosition);
	animation.duration = 0.5f;
	//Persist the animation
	animation.removedOnCompletion = NO; 
	animation.fillMode = kCAFillModeForwards;
	//Make it smooooth
	animation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
	[self.layer addAnimation:animation forKey:@"arrowAnimation"];
}


@end

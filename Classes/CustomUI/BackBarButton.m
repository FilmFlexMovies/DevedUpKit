//
//  BackBarButton.m
//  DevedUp
//
//  Created by David Casserly on 07/08/2009.
//  Copyright 2010 devedup.com. All rights reserved.
//

#import "BackBarButton.h"


@implementation BackBarButton

#pragma mark -
#pragma mark Init

//This concatenates 3 images - the center one changing width
//dependent on the frame size
- (UIImage *) createTheBackgroundImageWithWidth:(CGFloat)width {
	
	/*
		I think you can do this with SDK too by specify areas of your image that you don't
		want to stretch - but i haven't tried thForForfat.
	 */
	
	UIImage *head = [UIImage imageNamed:@"backButtonHead.png"]; //x = 15
	UIImage *center = [UIImage imageNamed:@"backButtonCenter.png"];
	UIImage *tail = [UIImage imageNamed:@"backButtonTail.png"]; //x = 6
	
	CGSize imageSize = CGSizeMake(width + 21, 30.0f);
	
	UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0f);
    
	CGPoint headPoint = CGPointMake(0, 0);
	[head drawAtPoint:headPoint];
	
	CGPoint centerPoint = CGPointMake(15, 0);
	[center drawAtPoint:centerPoint];
	
	CGPoint tailPoint = CGPointMake(imageSize.width - 6, 0);
	[tail drawAtPoint:tailPoint];
	
	UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return finalImage;
}

- (id)initWithFrame:(CGRect)frame title:(NSString *)title {
	
	//Find the size of the title
	UIFont *buttonFont = [UIFont boldSystemFontOfSize:13.0];
	CGSize size = [title sizeWithFont:buttonFont];
	//Modify frame width accordingly
	frame.size.width = size.width + 21;
	
    if ((self = [super initWithFrame:frame])) {	
		
		self.titleLabel.font = buttonFont;
		self.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, 0);
		self.adjustsImageWhenHighlighted = NO;
		
		CGSize size = [title sizeWithFont:buttonFont];
		
		//Add the back views
		UIImage *buttonBackground = [self createTheBackgroundImageWithWidth:size.width];
		[self setTitle:title forState:UIControlStateNormal];
		[self setBackgroundImage:buttonBackground forState:UIControlStateNormal];
		
		
    }
    return self;
}



@end

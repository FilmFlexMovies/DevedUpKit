//
//  DoubleTapCaptureView.m
//  DevedUp
//
//  Created by David Casserly on 09/08/2009.
//  Copyright 2010 devedup.com. All rights reserved.
//

#import "DoubleTapCaptureView.h"


@implementation DoubleTapCaptureView

@synthesize delegate;

#pragma mark -
#pragma mark Touches

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	UITouch *touch = [touches anyObject];
	if (touch.tapCount == 2) {
		//double tap
		[delegate doubleTapped];
	}
	
}



@end

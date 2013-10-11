//
//  UIView+Extensions.m
//  DevedUp
//
//  Created by David Casserly on 23/03/2010.
//  Copyright 2010 devedup.com. All rights reserved.
//

#import "UIView+Extensions.h"
#import <QuartzCore/CoreAnimation.h>

@implementation UIView (Extensions)

- (void) swapSubviewAtTag:(NSInteger)tag withView:(UIView *)newView {
	UIView *currentView = [self viewWithTag:tag];
	[self swapSubview:currentView withView:newView];
}

- (void) swapSubview:(UIView *)currentView withView:(UIView *)newView {
	//DULog(@"Swapping [%@] with [%@]", currentView, newView);
	newView.frame = CGRectMake(currentView.frame.origin.x, currentView.frame.origin.y, newView.frame.size.width, newView.frame.size.height);
	[currentView removeFromSuperview];
	
	
	[self insertSubview:newView atIndex:0];
}

- (void) scrollInputViewForUIControl:(UIControl *)control offset:(float)offset {
	static const float deviceHeight = 480;
	static const float keyboardHeight = 216; 
	static const float gap = 5;
	
	//float userDefinedOffset = offset;
	
	/*
		Find the current offset if its already scrolled
	 */
	CALayer *presentationLayer = (CALayer *) [self.layer presentationLayer];
	NSNumber *currentPosition = [presentationLayer valueForKeyPath:@"transform.translation.y"];
	offset = offset + [currentPosition floatValue];
	
	
	//Find the textfields absolute position in the 320*480 window
	CGPoint absolute = [control.superview convertPoint:control.frame.origin toView:nil];

	//if (absolute.y > (keyboardHeight + gap + userDefinedOffset)) {
		//Shift the view
		float shiftBy = (deviceHeight - absolute.y) - (deviceHeight - keyboardHeight - gap - offset);
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.3f]; //this is speed of keyboard
		CGAffineTransform slideTransform = CGAffineTransformMakeTranslation(0.0, shiftBy);
		self.transform = slideTransform;			
		[UIView commitAnimations];
	//} else {
		//Need to scroll back the other way
		/*
		 
			I Could allow the code above to scroll back the other way, but when the keyboard helper
			is showing, it pushes it out of view. So for the time being, skip this.
		 
		 */
		
	//}
	
}

- (void) resetInputViewForUIControl:(UIControl *)control {		
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3f]; //this is speed of keyboard
	CGAffineTransform slideTransform = CGAffineTransformIdentity;
	//slideTransform = CGAffineTransformConcat(slideTransform, self.transform);
	self.transform = slideTransform;			
	[UIView commitAnimations];
}

- (UIImage *) renderViewInRect:(CGRect)rect {
//	UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0);
//	CGContextRef context = UIGraphicsGetCurrentContext();
//	//CGContextTranslateCTM(context, -rect.origin.x, -rect.origin.y);
//	
//    [self.layer renderInContext:context];
//	
//	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    
//    
//    NSData *data ;
//    (@"Start while  ");
//    int temp=0;
//    while (data.length / 1000 >= 10) {
//        image = [UIImage imageWithImage:image andWidth:image.size.width/2 andHeight:image.size.height/2];
//        data = UIImageJPEGRepresentation(image, .0032);
//        temp++;
//        (@"temp  %u",temp);
//    }
//    (@"End while  ");
//    int size = data.length;
//    (@"SIZE OF IMAGE:after %i ", size);
//    //return data;
//    
//    
//	//NSData *imageData = UIImageJPEGRepresentation(renderedImage, 0.7); // convert to jpeg
//    renderedImage = [UIImage imageWithData:imageData];
    
    //return renderedImage;
    return nil;
}

@end

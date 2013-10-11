//
//  EditableImageView.m
//  EditableImageView
//
//  Created by David Casserly on 21/03/2011.
//  Copyright 2011 devedup.com. All rights reserved.
//

#import "DUEditableImageView.h"
#import <QuartzCore/QuartzCore.h>

@interface DUEditableImageView ()

@property (nonatomic, strong) UIImage *theTransformedImage;

@end


@implementation DUEditableImageView

@synthesize theTransformedImage;

#pragma mark -
#pragma mark Release


#pragma mark -
#pragma mark Init 

- (id) initWithFrame:(CGRect)frame image:(UIImage *)_image {
	if (self = [super initWithFrame:frame]) {
		
		imageDirty = YES;
		
		image = _image;
		imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
		
		//DULog(@"frame of UIImageView is %@", NSStringFromCGRect(imageView.frame));
		
		imageView.image = image;
		imageView.userInteractionEnabled = YES;
		imageView.multipleTouchEnabled = YES;
		imageView.exclusiveTouch = NO;
		imageView.contentMode = UIViewContentModeScaleAspectFill;
		imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | 
		UIViewAutoresizingFlexibleLeftMargin | 
		UIViewAutoresizingFlexibleRightMargin | 
		UIViewAutoresizingFlexibleHeight |
		UIViewAutoresizingFlexibleTopMargin |
		UIViewAutoresizingFlexibleBottomMargin;
		
		
		//test
		//imageView.center = CGPointMake(160 / 1.3913, 146 / 1.3774);
		
		self.clipsToBounds = YES;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | 
								UIViewAutoresizingFlexibleLeftMargin | 
								UIViewAutoresizingFlexibleRightMargin | 
								UIViewAutoresizingFlexibleHeight |
								UIViewAutoresizingFlexibleTopMargin |
								UIViewAutoresizingFlexibleBottomMargin;
		
		
		
		[self addSubview:imageView];
		
//		UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotatePiece:)];
//		[imageView addGestureRecognizer:rotationGesture];
//		[rotationGesture release];
		
		UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scalePiece:)];
		[pinchGesture setDelegate:self];
		[imageView  addGestureRecognizer:pinchGesture];
		
		UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panPiece:)];
		[panGesture setMaximumNumberOfTouches:2];
		[panGesture setDelegate:self];
		[imageView  addGestureRecognizer:panGesture];
		
//		UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showResetMenu:)];
//		[imageView  addGestureRecognizer:longPressGesture];
//		[longPressGesture release];
	}
	return self;
}

- (UIImage *) image {
	return image;
}

- (void) setImage:(UIImage *)newImage {
	if (image != newImage) {
		image = newImage;
	}
	imageView.image = newImage;
}

/*
- (void) checkForTransparency:(UIView *)view {
	if ([view.subviews count] > 0) {
		for (UIView *subview in view.subviews) {
			[self checkForTransparency:subview];
		}
	}
	DULog(@"Opaque is: %i in %@ and alpha is %f", view.opaque, view, view.alpha);	
}
*/

- (UIImage *) transformedImage {
	if (imageDirty) {
		//Transform and save it
		UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0f);
		CGContextRef context = UIGraphicsGetCurrentContext();
		
		//[self checkForTransparency:self];
		
		[self.layer renderInContext:context];
		
		UIImage *theNewlyTransformedImage = UIGraphicsGetImageFromCurrentImageContext();
		//UIImageWriteToSavedPhotosAlbum(theImage, nil, nil, nil);
		UIGraphicsEndImageContext();
		
		self.theTransformedImage = theNewlyTransformedImage;
		imageDirty = NO;
	}
	
	return self.theTransformedImage;
}

#pragma mark -
#pragma mark Reset 

- (void) reset {
	CGPoint locationInSuperview = [self convertPoint:CGPointMake(CGRectGetMidX(imageView.bounds), CGRectGetMidY(imageView.bounds)) toView:[imageView superview]];

	[[imageView layer] setAnchorPoint:CGPointMake(0.5, 0.5)];
    [imageView setCenter:locationInSuperview];
    
    [UIView beginAnimations:nil context:nil];
    [imageView setTransform:CGAffineTransformIdentity];
    [UIView commitAnimations];
}

#pragma mark -
#pragma mark UIGestureRecognizerDelegate

- (void)adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UIView *piece = gestureRecognizer.view;
        CGPoint locationInView = [gestureRecognizer locationInView:piece];
        CGPoint locationInSuperview = [gestureRecognizer locationInView:piece.superview];
        
        piece.layer.anchorPoint = CGPointMake(locationInView.x / piece.bounds.size.width, locationInView.y / piece.bounds.size.height);
        piece.center = locationInSuperview;
    }
}

- (void)panPiece:(UIPanGestureRecognizer *)gestureRecognizer {
    UIView *piece = [gestureRecognizer view];
	
    [self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gestureRecognizer translationInView:[piece superview]];
        
		CGPoint newCentre = CGPointMake([piece center].x + translation.x, [piece center].y + translation.y);
        [piece setCenter:newCentre];
        [gestureRecognizer setTranslation:CGPointZero inView:[piece superview]];
    }
    imageDirty = YES;
}

// rotate the piece by the current rotation
// reset the gesture recognizer's rotation to 0 after applying so the next callback is a delta from the current rotation
- (void)rotatePiece:(UIRotationGestureRecognizer *)gestureRecognizer {
    [self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        [gestureRecognizer view].transform = CGAffineTransformRotate([[gestureRecognizer view] transform], [gestureRecognizer rotation]);
        [gestureRecognizer setRotation:0];
    }
	imageDirty = YES;
}

// scale the piece by the current scale
// reset the gesture recognizer's rotation to 0 after applying so the next callback is a delta from the current scale
- (void)scalePiece:(UIPinchGestureRecognizer *)gestureRecognizer {
    [self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
	
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        [gestureRecognizer view].transform = CGAffineTransformScale([[gestureRecognizer view] transform], [gestureRecognizer scale], [gestureRecognizer scale]);
        [gestureRecognizer setScale:1];
    }
	imageDirty = YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    // if the gesture recognizers's view isn't one of our pieces, don't allow simultaneous recognition
	// if (gestureRecognizer.view != firstPieceView && gestureRecognizer.view != secondPieceView && gestureRecognizer.view != thirdPieceView)
	//   return NO;
    
    // if the gesture recognizers are on different views, don't allow simultaneous recognition
    if (gestureRecognizer.view != otherGestureRecognizer.view)
        return NO;
    
    // if either of the gesture recognizers is the long press, don't allow simultaneous recognition
    if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]] || [otherGestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]])
        return NO;
    
    return YES;
}

#pragma mark -
#pragma mark Find EditedPosition

- (CGPoint) currentLocation {
	return [self convertPoint:CGPointMake(CGRectGetMidX(imageView.frame), CGRectGetMidY(imageView.frame)) toView:[imageView superview]];
}

- (void) setLocation:(CGPoint)location {
	[imageView setCenter:location];
}


- (CGAffineTransform) currentTransform {
	return imageView.transform;
}

- (void) setTransform:(CGAffineTransform)transform {
	imageView.transform = transform;
}

@end

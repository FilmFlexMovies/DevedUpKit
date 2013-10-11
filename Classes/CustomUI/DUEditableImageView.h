//
//  EditableImageView.h
//  EditableImageView
//
//  Created by David Casserly on 21/03/2011.
//  Copyright 2011 devedup.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DUEditableImageView : UIView <UIGestureRecognizerDelegate> {

	@private
	UIImageView *imageView;
	UIImage *image;
	
	BOOL imageDirty; //needs transforming
	UIImage *theTransformedImage;
}

#pragma mark -
#pragma mark Init 

- (id) initWithFrame:(CGRect)frame image:(UIImage *)image;

#pragma mark -
#pragma mark Returns the image in its current transformation

- (UIImage *) image;
- (void) setImage:(UIImage *)newImage;
- (UIImage *) transformedImage;


#pragma mark -
#pragma mark Find EditedPosition

- (CGPoint) currentLocation;
- (void) setLocation:(CGPoint)location;

- (CGAffineTransform) currentTransform;
- (void) setTransform:(CGAffineTransform)transform;

#pragma mark -
#pragma mark Reset 

- (void) reset;

@end

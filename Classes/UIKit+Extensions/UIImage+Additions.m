//
//  UImage+Additions.m
//  DevedUp
//
//  Created by David Casserly on 10/08/2009.
//  Copyright 2010 devedup.com. All rights reserved.
//

#import "UIImage+Additions.h"

@implementation UIImage (Additions)

- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize {
	
	//Current and New Image references
	UIImage *sourceImage = self;
	UIImage *newImage = nil;
	
	//Current Image Dimensions
	CGSize imageSize = sourceImage.size;
	CGFloat width = imageSize.width;
	CGFloat height = imageSize.height;
	
	//Target dimensions
	CGFloat targetWidth = targetSize.width;
	CGFloat targetHeight = targetSize.height;
	
	
	/*
		Find the scaling dimensions
	 */
	
	CGFloat scaleFactor = 0.0;
	CGFloat scaledWidth = targetWidth;
	CGFloat scaledHeight = targetHeight;
	
	CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
	
	//Check the image isn't already that size
	if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
		
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
		
        if (widthFactor < heightFactor) 
			scaleFactor = widthFactor;
        else
			scaleFactor = heightFactor;
		
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
		
        // center the image
		
        if (widthFactor < heightFactor) {
			thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5; 
        } else if (widthFactor > heightFactor) {
			thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
	}
	

	/*
		Now scale the image
	 */ 
    UIGraphicsBeginImageContextWithOptions(targetSize, NO, 0.0f);
	
	CGRect thumbnailRect = CGRectZero;
	thumbnailRect.origin = thumbnailPoint;
	thumbnailRect.size.width  = scaledWidth;
	thumbnailRect.size.height = scaledHeight;
	
	[sourceImage drawInRect:thumbnailRect];
	
	newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	if(newImage == nil) DULog(@"could not scale image");
	
	return newImage;
}


- (UIImage *) imageWithShadow {
    CGColorSpaceRef colourSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef shadowContext = CGBitmapContextCreate(NULL, self.size.width + 10, self.size.height + 10, CGImageGetBitsPerComponent(self.CGImage), 0, 
													   colourSpace, (CGBitmapInfo) kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colourSpace);
	
    CGContextSetShadowWithColor(shadowContext, CGSizeMake(5, -5), 5, [UIColor blackColor].CGColor);
    CGContextDrawImage(shadowContext, CGRectMake(0, 10, self.size.width, self.size.height), self.CGImage);
	
    CGImageRef shadowedCGImage = CGBitmapContextCreateImage(shadowContext);
    CGContextRelease(shadowContext);
	
    UIImage * shadowedImage = [UIImage imageWithCGImage:shadowedCGImage];
    CGImageRelease(shadowedCGImage);
	
    return shadowedImage;
}

@end

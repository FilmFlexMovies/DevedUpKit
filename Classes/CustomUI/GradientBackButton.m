//
//  GradientBackButton.m
//  iDeal
//
//  Created by igmac0005 on 01/10/2010.
//  Copyright 2010 DevedUp Ltd. All rights reserved.
//

#import "GradientBackButton.h"

#define kGradientButtonEdgeInsertsWidth 24
#define X_OFFSET_FOR_POINT 15

static NSString *defaultHexEncodedColorsString;

@implementation GradientBackButton

- (CGMutablePathRef) newRectanglePathWithInset:(CGFloat)inset width:(CGFloat)width height:(CGFloat)height radius:(CGFloat)radius {
	
	// Going to start bottom right then heading anticlockwise
	
	CGMutablePathRef path = CGPathCreateMutable();
	
	CGPathMoveToPoint(path, NULL, (width - radius), height-inset); // start bottom right
	
	CGPathAddArcToPoint(path, NULL,width-inset, height-inset, width-inset, (height - radius - inset), radius);
	
	CGPathAddLineToPoint(path, NULL, width-inset, radius+inset);
	
	CGPathAddArcToPoint(path, NULL, width-inset, inset , (width - radius - inset), inset, radius);
	
	// specify the arrow tip mid left
	CGFloat arrowTipx = inset;
	CGFloat arrowTipy = (height/2.0);
	
	// calculate where on the top line to slope down from
	CGFloat arrowSlope = 0.75;	
	CGFloat p1y = inset;
	CGFloat p1x = (arrowTipy - p1y)*arrowSlope;
	// and a mid point of the slope to end the slight curve
	CGFloat p2x = arrowTipx + (p1x - arrowTipx)/2.0;
	CGFloat p2y = arrowTipy + (p1y - arrowTipy)/2.0;
	
	CGPathAddLineToPoint(path, NULL, p1x+4.0, p1y); // line to top left	
	CGPathAddArcToPoint(path, NULL, p1x, p1y, p2x, p2y, 8.0); // slight curve
	CGPathAddLineToPoint(path, NULL, arrowTipx , arrowTipy); // line to point tip
	CGPathAddLineToPoint(path, NULL, p2x, height - p2y); // back out from arrow tip
	CGPathAddArcToPoint(path, NULL, p1x, height - p1y, p1x+4.0, height - p1y, 8.0); // slight curve

	
	CGPathAddLineToPoint(path, NULL, (width - radius-inset), height-inset);
	CGPathCloseSubpath(path);
	
	return path;
}
+ (void)setDefaultHexEncodedColorsString:(NSString*)hex {
	defaultHexEncodedColorsString = [hex copy];
}

+ (UIButton *) gradientBackButtonWithTitle:(NSString*)title width:(CGFloat)width {
	
	UIFont *titleFont = [UIFont boldSystemFontOfSize:12];
	CGSize size = [title sizeWithFont:titleFont];
	
	if((size.width + kGradientButtonEdgeInsertsWidth) < width) {
		width = (size.width + kGradientButtonEdgeInsertsWidth);
	}
	
	GradientBackButton *customButton = [[GradientBackButton alloc] initWithFrame:CGRectMake(0, 0, width, 31)];
	[customButton colorWithHexEncodedColorsString:defaultHexEncodedColorsString];
	customButton.titleLabel.font = titleFont;
	[customButton setTitle:title forState:UIControlStateNormal];
	[customButton.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
	customButton.titleEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 5);
	
	return customButton;
}
@end

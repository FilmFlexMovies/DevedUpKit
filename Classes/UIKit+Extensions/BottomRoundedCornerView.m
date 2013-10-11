//
//  BottomRoundedCornerView.m
//  Flickr
//
//  Created by David Casserly on 14/06/2011.
//  Copyright 2011 DevedUp Ltd. All rights reserved.
//

#import "BottomRoundedCornerView.h"
#import <QuartzCore/CoreAnimation.h>

@implementation BottomRoundedCornerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    // Create the path (with only the top-left corner rounded)
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds 
                                                   byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight
                                                         cornerRadii:CGSizeMake(10.0, 10.0)];
    
    // Create the shape layer and set its path
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    
    // Set the newly created shape layer as the mask for the image view's layer
    self.layer.mask = maskLayer;
    
    // Clean up
}



@end

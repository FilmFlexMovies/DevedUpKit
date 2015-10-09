//
//  DUGradientBackgroundView.m
//  DevedUpKit
//
//  Created by David Casserly on 01/04/2014.
//  Copyright (c) 2014 DevedUp. All rights reserved.
//

#import "DUGradientBackgroundView.h"
#import "UIColor+Extensions.h"
#import "UIView+DUExtensions.h"

@implementation DUGradientBackgroundView

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    @throw [NSException exceptionWithName:@"Not Supported" reason:@"init not Supported" userInfo:nil];
}

- (instancetype) initWithFrame:(CGRect)frame {
    @throw [NSException exceptionWithName:@"Not Supported" reason:@"init not Supported" userInfo:nil];
}

- (instancetype) initWithFrame:(CGRect)frame gradient:(CAGradientLayer *)gradient {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        gradient.frame = self.bounds;
        [self.layer insertSublayer:gradient atIndex:1];
    }
    return self;
}

- (void) addDarkAlpha {
    UIView *alpha = [UIView.alloc initWithFrame:self.bounds];
    alpha.backgroundColor = [UIColor blackColor];
    alpha.alpha = 0.4f;
    [self addSubviewAndFillBounds:alpha];
}

- (UIImage *) renderToImage {
    CGFloat scale = 0;
    
    // If scale is 0, it'll follows the screen scale for creating the bounds
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, scale);
    

    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    
        // Get the image out of the context
    UIImage *copied = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Return the result
    return copied;
}

@end

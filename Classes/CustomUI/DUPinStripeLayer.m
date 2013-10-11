//
//  DUPinStripeLayer.m
//  DevedUp
//
//  Created by David Casserly on 23/11/2011.
//  Copyright (c) 2011 Ground Floor. All rights reserved.
//

#import "DUPinStripeLayer.h"

@implementation DUPinStripeLayer


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    return self;
}

- (void) drawRect:(CGRect)rect {
     
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGFloat height = self.bounds.size.height;
    CGFloat width = self.bounds.size.width;
    
    CGContextSetFillColorWithColor(ctx, [UIColor grayColor].CGColor);
    

    //DULog(@"Bounds %@ %@ %@", NSStringFromCGRect(self.bounds), NSStringFromCGRect(self.frame), NSStringFromCGPoint(self.position));
    //CGContextStrokeRect(ctx, CGRectMake(10, 10, self.bounds.size.width - 20, self.bounds.size.height - 20));
    
    //Draw a stripe every other pixel
    int count = 0; 
    while (count < height) {   
        CGContextFillRect(ctx, CGRectMake(0, count, width, 1));
        count=count+2;
    }
}

@end

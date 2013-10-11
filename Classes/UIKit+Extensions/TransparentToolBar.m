//
//  TransparentToolBar.m
//  DevedUp
//
//  Created by David Casserly on 23/10/2009.
//  Copyright 2010 devedup.com. All rights reserved.
//

#import "TransparentToolBar.h"


@implementation TransparentToolBar

- (void)drawRect:(CGRect)rect 
{
    [[UIColor colorWithWhite:1 alpha:0.0f] set]; // or clearColor etc
    CGContextFillRect(UIGraphicsGetCurrentContext(), rect);
}

@end

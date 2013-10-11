//
//  RefreshArrowView.m
//  FlurryStats
//
//  Created by David Casserly on 05/08/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RefreshArrowView.h"
#import <QuartzCore/QuartzCore.h>

@interface RefreshArrowView () 
@property (nonatomic, strong) UIColor *startColor;
@end
@implementation RefreshArrowView

@synthesize startColor = _startColor;


- (id)initWithFrame:(CGRect)frame startColor:(UIColor *)color {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.startColor = color;        
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext(); 
    
    float totalHeight = self.frame.size.height;
    float totalWidth = self.frame.size.width;
    
    float arrowHeight = totalHeight / 3;
    float arrowTailWidth = (totalWidth / 100) * 60;
    float arrowTailSectionHeight = totalHeight / 9;
    
    float tailXStart = (totalWidth - arrowTailWidth) / 2;
    
    //Add the arrow head
    CGContextSetFillColorWithColor(context, self.startColor.CGColor);
    CGPoint points[3];
	points[0] = CGPointMake (totalWidth / 2, totalHeight);
	points[1] = CGPointMake (0, totalHeight - arrowHeight);
	points[2] = CGPointMake (totalWidth, totalHeight - arrowHeight);	
	CGContextAddLines(context, points, 3);
	CGContextDrawPath(context, kCGPathFill);
    
    //Add arrow tail
    CGContextSetFillColorWithColor(context, self.startColor.CGColor);
    CGRect tailSection = CGRectMake(tailXStart, totalHeight - arrowHeight - arrowTailSectionHeight + 1, arrowTailWidth, arrowTailSectionHeight);
    CGContextFillRect(context, tailSection);

    float white = 0.8;
    for (int i = 0 ; i < 4; i++) {
        CGContextSetFillColorWithColor(context, [self.startColor colorWithAlphaComponent:white].CGColor);
        //add 4 tail sections
        CGRect nextSection = tailSection;
        nextSection.origin.y = tailSection.origin.y - (arrowTailSectionHeight * 1.5);
        CGContextFillRect(context, nextSection);
        tailSection = nextSection;
        white = white - 0.2;
    }
    
}


/* previous version
 
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 // Drawing code
 CGContextRef context = UIGraphicsGetCurrentContext(); 
 
 float totalHeight = self.frame.size.height;
 float totalWidth = self.frame.size.width;
 
 float arrowHeight = totalHeight / 3;
 float arrowTailWidth = (totalWidth / 100) * 60;
 float arrowTailSectionHeight = totalHeight / 9;
 
 float tailXStart = (totalWidth - arrowTailWidth) / 2;
 
 //Add the arrow head
 CGContextSetFillColorWithColor(context, [UIColor colorWithWhite:0.0f alpha:1.0].CGColor);
 CGPoint points[3];
 points[0] = CGPointMake (totalWidth / 2, totalHeight);
 points[1] = CGPointMake (0, totalHeight - arrowHeight);
 points[2] = CGPointMake (totalWidth, totalHeight - arrowHeight);	
 CGContextAddLines(context, points, 3);
 CGContextDrawPath(context, kCGPathFill);
 
 //Add arrow tail
 CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
 CGRect tailSection = CGRectMake(tailXStart, totalHeight - arrowHeight - arrowTailSectionHeight + 1, arrowTailWidth, arrowTailSectionHeight);
 CGContextFillRect(context, tailSection);
 
 float white = 0.2;
 for (int i = 0 ; i < 4; i++) {
 CGContextSetFillColorWithColor(context, [UIColor colorWithWhite:white alpha:1.0f].CGColor);
 //add 4 tail sections
 CGRect nextSection = tailSection;
 nextSection.origin.y = tailSection.origin.y - (arrowTailSectionHeight * 1.5);
 CGContextFillRect(context, nextSection);
 tailSection = nextSection;
 white = white + 0.2;
 }
 
 //CGContext
 
 //    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:63.0f/255.0f green:187.0f/255.0f blue:49.0f/255.0f alpha:1.0f].CGColor);
 //    
 //    int height = self.frame.size.height / 2;
 //    int y = (self.frame.size.height / 2) - (height / 2);
 //    
 //    CGContextFillRect(context, CGRectMake(0, y, _barWidth, height));  
 //    
 //    _percentLabel.center = CGPointMake(_percentLabel.center.x + _barWidth + 5 , _percentLabel.center.y);
 }
 
 */
@end

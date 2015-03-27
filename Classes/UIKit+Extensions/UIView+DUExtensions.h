//
//  UIView+UIView_DUExtensions.h
//  DevedUp
//
//  Created by David Casserly on 19/11/2011.
//  Copyright (c) 2011 Ground Floor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (DUExtensions)

- (void) du_setAnchorPoint:(CGPoint)anchorPoint;
@property (nonatomic, readonly) BOOL visible;
- (void) addSubviewAndFillBounds:(UIView *)subview;


#pragma mark - Bounces

- (void) shake;
- (void) bounceOnRight;
- (void) bounceOnLeft;

@end

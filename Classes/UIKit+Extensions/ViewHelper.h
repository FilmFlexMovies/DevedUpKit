//
//  ViewHelper.h
//  DevedUp
//
//  Created by David Casserly on 21/08/2009.
//  Copyright 2010 devedup.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ViewHelper : NSObject {

}

#pragma mark -
#pragma mark Move views by pixels

+ (void) moveView:(UIView *)view up:(float)pixels;
+ (void) moveView:(UIView *)view down:(float)pixels;

#pragma mark -
#pragma mark Move views by their height

+ (void) moveViewDownByItsHeight:(UIView *)view and:(float)extra;
+ (void) moveViewUpByItsHeight:(UIView *)view and:(float)extra;

#pragma mark -
#pragma mark Scroll View Content

+ (void) setScrollViewContentSizeBasedOnContents:(UIScrollView *)scrollView;

+ (void) roundCorners:(UIRectCorner)corners withRadii:(CGSize)size onView:(UIView *)view;
+ (void) roundBottomCornersOnView:(UIView *)view;

@end

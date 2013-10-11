//
//  DUShadowView.h
//  DevedUp
//
//  Created by David Casserly on 22/11/2011.
//  Copyright (c) 2011 Ground Floor. All rights reserved.
//
//  Usage

//  add any drop shadow
//  if (self.wantsDropShadow){
//    [self.view addSubview:[[[DUShadowView alloc] initWithFrame:CGRectMake(0,0,CGRectGetWidth(self.view.frame),        kIGShadowViewHeight)] autorelease]];
//  }

#import <UIKit/UIKit.h>

extern const CGFloat kDUShadowViewHeight;

typedef enum {
	ShadowAnchorTop	= 0,
	ShadowAnchorBottom,
	ShadowAnchorRight,
	ShadowAnchorLeft
} ShadowAnchor;

typedef enum {
    ShadowPositionInner = 0,
    ShadowPositionOuter
} ShadowPosition;

// IGShadowView: simple wrapper around a CAGradientLayer
@interface DUShadowView : UIView {
    
@private
    int _shadowWidth;
    ShadowAnchor _anchor;
    ShadowPosition _shadowPosition;
}

+ (DUShadowView *) outerShawdowWithFrame:(CGRect)frame anchor:(ShadowAnchor)anchor shadowSize:(int)size;
+ (DUShadowView *) innerShawdowWithFrame:(CGRect)frame anchor:(ShadowAnchor)anchor shadowSize:(int)size;

@end
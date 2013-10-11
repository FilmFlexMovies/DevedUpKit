//
//  DUShadowView.m
//  DevedUp
//
//  Created by David Casserly on 22/11/2011.
//  Copyright (c) 2011 Ground Floor. All rights reserved.
//

#import "DUShadowView.h"
#import <QuartzCore/QuartzCore.h>

const CGFloat kDefaultShadowWidth = 7;
const CGFloat kDUShadowViewHeight = 15;

@implementation DUShadowView

+ (Class)layerClass {
    return [CAGradientLayer class];
}

- (id)initWithFrame:(CGRect)frame anchor:(ShadowAnchor)anchor width:(int)width position:(ShadowPosition)shadowPosition {
    self = [super initWithFrame:frame]; //if you change this to init - it recurses into initWithFrame  
    if (self){
        
        //self.autoresizingMask = UIViewAutoresizingFlexibleWidth;// | UIViewAutoresizingFlexibleHeight;
        
        _shadowPosition = shadowPosition;
        _shadowWidth = width;
        _anchor = anchor;
        
        //This overides
        [self setFrame:frame];
        
        CAGradientLayer* layer = (CAGradientLayer*)self.layer;
        layer.colors = @[(id)[[UIColor blackColor] colorWithAlphaComponent:0.5].CGColor,
                        (id)[[UIColor blackColor] colorWithAlphaComponent:0].CGColor];
        
        switch (anchor) {
            case ShadowAnchorTop:
                if (_shadowPosition == ShadowPositionInner) {
                    layer.startPoint = CGPointMake(0.5, 0.0);   //default
                    layer.endPoint = CGPointMake(0.5, 1.0);     //default
                } else {
                    layer.startPoint = CGPointMake(0.5, 1.0);   //default
                    layer.endPoint = CGPointMake(0.5, 0.0);     //default   
                }                
                break;
            case ShadowAnchorBottom:
                if (_shadowPosition == ShadowPositionInner) {
                    layer.startPoint = CGPointMake(0.5, 1.0);   
                    layer.endPoint = CGPointMake(0.5, 0.0);
                } else {
                    layer.startPoint = CGPointMake(0.5, 0.0);   
                    layer.endPoint = CGPointMake(0.5, 1.0);  
                }                   
                break;
            case ShadowAnchorRight:
                if (_shadowPosition == ShadowPositionInner) {                    
                    layer.startPoint = CGPointMake(1.0, 0.5);
                    layer.endPoint = CGPointMake(0.0, 0.5);
                } else {
                    layer.startPoint = CGPointMake(0, 0.5);
                    layer.endPoint = CGPointMake(1.0, 0.5); 
                }                
                break;
            case ShadowAnchorLeft:
                layer.startPoint = CGPointMake(0.0, 0.5);
                layer.endPoint = CGPointMake(1.0, 0.5);
                break;
            default:
                break;
        }
        
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame anchor:ShadowAnchorTop width:kDefaultShadowWidth position:ShadowPositionOuter];
}

- (void) setFrame:(CGRect)frame {
    int x;
    int y;
    int width;
    int height;
    
    switch (_anchor) {
        case ShadowAnchorTop:
            x = 0;
            y = _shadowPosition == ShadowPositionOuter ? 0 - _shadowWidth : 0;
            width = frame.size.width;
            height = _shadowWidth; 
            break;
        case ShadowAnchorBottom:
            x = 0;
            y = _shadowPosition == ShadowPositionOuter ? frame.size.height : frame.size.height - _shadowWidth;
            width = frame.size.width;
            height = _shadowWidth;    
            break;
        case ShadowAnchorRight:
            x = _shadowPosition == ShadowPositionOuter ? frame.size.width : frame.size.width - _shadowWidth;
            y = 0;
            width = _shadowWidth;
            height = frame.size.height;
            break;
        case ShadowAnchorLeft:
            x = _shadowPosition == ShadowPositionOuter ? 0 - _shadowWidth : 0;
            y = 0;
            width = _shadowWidth;
            height = frame.size.height;
            break;
        default:
            break;
    }
    
    [super setFrame:CGRectMake(x, y, width, height)];
}

+ (DUShadowView *) outerShawdowWithFrame:(CGRect)frame anchor:(ShadowAnchor)anchor shadowSize:(int)size {
    DUShadowView *shadow = [[DUShadowView alloc] initWithFrame:frame anchor:anchor width:size position:ShadowPositionOuter];    
    return shadow;
}

+ (DUShadowView *) innerShawdowWithFrame:(CGRect)frame anchor:(ShadowAnchor)anchor shadowSize:(int)size {
    DUShadowView *shadow = [[DUShadowView alloc] initWithFrame:frame anchor:anchor width:size position:ShadowPositionInner];    
    return shadow; 
}

- (BOOL)isUserInteractionEnabled {
    return NO;
}

@end

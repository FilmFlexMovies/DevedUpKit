//
//  UIColor-HSVAdditions.h
//
//  Created by Matt Reagan (bravobug.com) on 12/31/09.
//  
//

#import <UIKit/UIKit.h>

//#import "UIColor-Expanded.h"
//  get it here:
//  http://github.com/ars/uicolor-utilities

#define MIN3(x,y,z)  ((y) <= (z) ? \
((x) <= (y) ? (x) : (y)) \
: \
((x) <= (z) ? (x) : (z)))

#define MAX3(x,y,z)  ((y) >= (z) ? \
((x) >= (y) ? (x) : (y)) \
: \
((x) >= (z) ? (x) : (z)))


struct rgb_color {
    CGFloat r, g, b;
};

struct hsv_color {
    CGFloat hue;        
    CGFloat sat;        
    CGFloat val;        
};

@interface UIColor (Extensions)

@property (nonatomic, readonly) CGFloat hue; // Only valid if canProvideRGBComponents is YES
@property (nonatomic, readonly) CGFloat saturation; // Only valid if canProvideRGBComponents is YES
@property (nonatomic, readonly) CGFloat brightness; // Only valid if canProvideRGBComponents is YES
@property (nonatomic, readonly) CGFloat value; // (same as brightness, added for naming consistency)


//workhorse method, does conversion:
+(struct hsv_color)HSVfromRGB:(struct rgb_color)rgb;
//individual value accessors:
-(CGFloat)hue;
-(CGFloat)saturation;
-(CGFloat)brightness;
-(CGFloat)value;

- (CGFloat)alpha;

//+ (UIColor*) UIColorFromRGBString:(NSString*)stringColorValue;

+ (UIColor *) colorWithRGBACommaString:(NSString *)rgbaCommaString;

- (NSString*) hexStringValue;


//- (CGColorRef) newLowCGColor;
//- (CGColorRef) newHighCGColor;

+ (UIColor *) buttonBaseGrayColor;

- (CGColorRef) lowCGColor;
- (CGColorRef) highCGColor;

+ (UIColor *) colorWithRGBString:(NSString *)rgbString;

@end


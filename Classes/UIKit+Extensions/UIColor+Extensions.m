//
//  UIColor-HSVAdditions.m
//
//  Created by Matt Reagan (bravobug.com) on 12/31/09.
//  
// Released into the public domain
//Original code: http://en.literateprograms.org/RGB_to_HSV_color_space_conversion_%28C%29

#import "UIColor+Extensions.h"
#import "NSString+Extensions.h"

@implementation UIColor (Extensions)
+(struct hsv_color)HSVfromRGB:(struct rgb_color)rgb
{
	struct hsv_color hsv;
	
	CGFloat rgb_min, rgb_max;
	rgb_max = MAX3(rgb.r, rgb.g, rgb.b);
	
	hsv.val = rgb_max;
	if (hsv.val == 0) {
		hsv.hue = hsv.sat = 0;
		return hsv;
	}
	
	rgb.r /= hsv.val;
	rgb.g /= hsv.val;
	rgb.b /= hsv.val;
	rgb_min = MIN3(rgb.r, rgb.g, rgb.b);
	rgb_max = MAX3(rgb.r, rgb.g, rgb.b);
	
	hsv.sat = rgb_max - rgb_min;
	if (hsv.sat == 0) {
		hsv.hue = 0;
		return hsv;
	}
	
	if (rgb_max == rgb.r) {
		hsv.hue = 0.0 + 60.0*(rgb.g - rgb.b);
		if (hsv.hue < 0.0) {
			hsv.hue += 360.0;
		}
	} else if (rgb_max == rgb.g) {
		hsv.hue = 120.0 + 60.0*(rgb.b - rgb.r);
	} else /* rgb_max == rgb.b */ {
		hsv.hue = 240.0 + 60.0*(rgb.r - rgb.g);
	}
	
	return hsv;
}

- (CGFloat)red {
	//NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -red");
	const CGFloat *c = CGColorGetComponents(self.CGColor);
	return c[0];
}

- (CGFloat)green {
	//NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -green");
	const CGFloat *c = CGColorGetComponents(self.CGColor);
	//if (self.colorSpaceModel == kCGColorSpaceModelMonochrome) return c[0];
	return c[1];
}

- (CGFloat)blue {
	//NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -blue");
	const CGFloat *c = CGColorGetComponents(self.CGColor);
	//if (self.colorSpaceModel == kCGColorSpaceModelMonochrome) return c[0];
	return c[2];
}

- (CGFloat)alpha {
	return CGColorGetAlpha(self.CGColor);
}

-(CGFloat)hue
{
	struct hsv_color hsv;
	struct rgb_color rgb;
	rgb.r = [self red];
	rgb.g = [self green];
	rgb.b = [self blue];
	hsv = [UIColor HSVfromRGB: rgb];
	return (hsv.hue / 360.0);
}
-(CGFloat)saturation
{
	struct hsv_color hsv;
	struct rgb_color rgb;
	rgb.r = [self red];
	rgb.g = [self green];
	rgb.b = [self blue];
	hsv = [UIColor HSVfromRGB: rgb];
	return hsv.sat;
}
-(CGFloat)brightness
{
	struct hsv_color hsv;
	struct rgb_color rgb;
	rgb.r = [self red];
	rgb.g = [self green];
	rgb.b = [self blue];
	hsv = [UIColor HSVfromRGB: rgb];
	return hsv.val;
}
-(CGFloat)value
{
	return [self brightness];
}

//+(UIColor *)UIColorFromRGBString:(NSString*)stringColorValue {
//
//	UIColor * color = nil;
//	
//	if ([stringColorValue hasPrefix:@"#"]) {
//		
//		NSString* colourString = [stringColorValue substringFromIndex:1];
//		
//		float red = (float)[[colourString substringWithRange:NSMakeRange(0, 2)] hexToInt] / 255.0f;
//		float green = (float)[[colourString substringWithRange:NSMakeRange(2, 2)] hexToInt] / 255.0f;
//		float blue = (float)[[colourString substringWithRange:NSMakeRange(4, 2)] hexToInt] / 255.0f;
//		
//		color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
//	} else {
//		NSArray* components = [stringColorValue componentsSeparatedByString:@","];
//		color = [UIColor colorWithRed:[[components objectAtIndex:0] floatValue] green:[[components objectAtIndex:1] floatValue] blue:[[components objectAtIndex:2] floatValue] alpha:[[components objectAtIndex:3] floatValue]];
//	}
//	
//	return color;
//}

+ (UIColor *) colorWithRGBACommaString:(NSString *)rgbaCommaString {
	if (rgbaCommaString && [rgbaCommaString length] > 0) {
		NSArray* components = [rgbaCommaString componentsSeparatedByString:@","];
		UIColor *color = [UIColor colorWithRed:[[components objectAtIndex:0] floatValue] green:[[components objectAtIndex:1] floatValue] blue:[[components objectAtIndex:2] floatValue] alpha:[[components objectAtIndex:3] floatValue]];
		return color;
	}else {
		return nil;
	}
}

- (NSString*) hexStringValue
{
	const CGFloat *components = CGColorGetComponents(self.CGColor);
	return [NSString stringWithFormat:@"#%X%X%X", (int)(components[0]*255), (int)(components[1]*255), (int)(components[2]*255)];
}

+ (UIColor *) buttonBaseGrayColor {
	static UIColor *color = nil;
	if (!color) {
		color = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
	}
	return color;
}

- (CGColorRef) lowCGColor {
	const CGFloat *components = CGColorGetComponents(self.CGColor);
	
    CGColorSpaceRef colorSpace = (__bridge CGColorSpaceRef) (__bridge id) CGColorSpaceCreateDeviceRGB();
    
	switch (CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor))) {
		case kCGColorSpaceModelRGB:
		{
			const CGFloat lowComponents[4] = {MAX(0.0, floor(((components[0]-0.2)*1000)+0.5)/1000), MAX(0.0, floor(((components[1]-0.2)*1000)+0.5)/1000), MAX(0.0, floor(((components[2]-0.2)*1000)+0.5)/1000), CGColorGetAlpha(self.CGColor)};
            
			return (__bridge CGColorRef) (__bridge id)CGColorCreate(colorSpace, lowComponents);
			break;
		}
		case kCGColorSpaceModelMonochrome:
		{
			const CGFloat lowComponents[4] = {MAX(0.0, floor(((components[0]-0.2)*1000)+0.5)/1000), MAX(0.0, floor(((components[0]-0.2)*1000)+0.5)/1000), MAX(0.0, floor(((components[0]-0.2)*1000)+0.5)/1000), CGColorGetAlpha(self.CGColor)};
			return (__bridge CGColorRef) (__bridge id)CGColorCreate(colorSpace, lowComponents);
			break;
		}
		default:
			break;
	}
	return nil;
}

- (CGColorRef) highCGColor {
	const CGFloat *components = CGColorGetComponents(self.CGColor);
	
    CGColorSpaceRef colorSpace = (__bridge CGColorSpaceRef) (__bridge id) CGColorSpaceCreateDeviceRGB();
    
	switch (CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor))) {
		case kCGColorSpaceModelRGB:
		{
			const CGFloat lowComponents[4] = {MIN(1.0, components[0]+0.3), MIN(1.0, components[1]+0.3), MIN(1.0, components[2]+0.3), CGColorGetAlpha(self.CGColor)};
			return (__bridge CGColorRef) (__bridge id)CGColorCreate(colorSpace, lowComponents) ;
			break;
		}
		case kCGColorSpaceModelMonochrome:
		{
			const CGFloat lowComponents[4] = {MIN(1.0, components[0]+0.3), MIN(1.0, components[0]+0.3), MIN(1.0, components[0]+0.3), CGColorGetAlpha(self.CGColor)};
			return (__bridge CGColorRef) (__bridge id)CGColorCreate(colorSpace, lowComponents);
			break;
		}
		default:
			break;
	}
	return nil;
}

+ (UIColor *) colorWithRGBString:(NSString *)rgbString {
    rgbString = [rgbString stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSArray *rgbComponents = [rgbString componentsSeparatedByString:@","];
    NSAssert(rgbComponents.count == 3, @"Needs to have 3 components");
    
    float r = [rgbComponents[0] floatValue] / 255.0f;
    float g = [rgbComponents[1] floatValue] / 255.0f;
    float b = [rgbComponents[2] floatValue] / 255.0f;
    
    return [UIColor colorWithRed:r green:g blue:b alpha:1.0f];
    
}

@end

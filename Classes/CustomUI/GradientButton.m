#import "GradientButton.h"
#import "NSString+Extensions.h"
#import "UIColor+Extensions.h"

static NSString *defaultHexEncodedColorsString;

#define kGradientButtonEdgeInsertsWidth 24
#define X_OFFSET_FOR_POINT 15

@interface GradientButton ()

-(void)updateAlphaForEnabledState;

@end

@implementation GradientButton

@synthesize	gradient1TopColour;
@synthesize gradient1BottomColour;
@synthesize gradient2TopColour;
@synthesize gradient2BottomColour;
@synthesize alphaWhenEnabled = _alphaWhenEnabled;
@synthesize alphaWhenDisabled = _alphaWhenDisabled;

#pragma mark -
#pragma mark Dealloc


-(id)init {
    _alphaWhenEnabled = 1.0F;
    _alphaWhenDisabled = 0.3F;
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    if (!(self = [super initWithCoder:aDecoder])) return nil;
    return [self init];
}

-(id)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame])) return nil;
    return [self init];
}

#pragma mark - accessors
-(void)setAlphaWhenEnabled:(CGFloat)alphaWhenEnabled {
    _alphaWhenEnabled = alphaWhenEnabled;
    [self updateAlphaForEnabledState];
}

-(void)setAlphaWhenDisabled:(CGFloat)alphaWhenDisabled {
    _alphaWhenDisabled = alphaWhenDisabled;
    [self updateAlphaForEnabledState];
}

#pragma mark - helper methods

- (void) updateColoursWithAlpha:(float)alpha {
	self.gradient1TopColour = [self.gradient1TopColour colorWithAlphaComponent:alpha];
	self.gradient1BottomColour = [self.gradient1BottomColour colorWithAlphaComponent:alpha];
	self.gradient2TopColour = [self.gradient2TopColour colorWithAlphaComponent:alpha];
	self.gradient2BottomColour = [self.gradient2BottomColour colorWithAlphaComponent:alpha];
}

-(void) updateAlphaForEnabledState:(BOOL)enable {
    if (enable) {
		[self updateColoursWithAlpha:_alphaWhenEnabled];
		[self setNeedsDisplay];
	}else {
		[self updateColoursWithAlpha:_alphaWhenDisabled];
		[self setNeedsDisplay];
	} 
}

-(void)updateAlphaForEnabledState {
    [self updateAlphaForEnabledState:self.enabled];
}

/**
 * eg #5F5F87|#10104B|#00003F|#000035
 */
- (void)colorWithHexEncodedColorsString:(NSString*)hexString {
//	if (hexString && [hexString length] > 0) {
//		NSArray* colours = [hexString componentsSeparatedByString:@"|"];
//		for (int i=0; i < [colours count]; i++) {
//			
//			UIColor* colour = nil;
//			
//			NSString* colourAsHex = [[colours objectAtIndex:i] substringFromIndex:0];
//			
//			colour = [UIColor UIColorFromRGBString:colourAsHex];
//			
//			if (i == 0) {
//				self.gradient1TopColour = colour;
//			} else if (i == 1) {
//				self.gradient1BottomColour = colour;
//			} else if (i == 2) {
//				self.gradient2TopColour = colour;
//			} else if (i == 3) {
//				self.gradient2BottomColour = colour;
//			}
//		}
//		
//	} else {
//		// Default to black button
//		self.gradient1TopColour = [UIColor colorWithRed:98.0f/255 green:98.0f/255 blue:98.0f/255 alpha:1.0f];
//		self.gradient1BottomColour = [UIColor colorWithRed:34.0f/255 green:34.0f/255 blue:34.0f/255 alpha:1.0f];
//		self.gradient2TopColour = [UIColor colorWithRed:16.0f/255 green:16.0f/255 blue:16.0f/255 alpha:1.0f];
//		self.gradient2BottomColour = [UIColor colorWithRed:36.0f/255 green:36.0f/255 blue:36.0f/255 alpha:1.0f];
//	}
//
//    [self updateAlphaForEnabledState];
}

- (CGMutablePathRef) newRectanglePathWithInset:(CGFloat)inset width:(CGFloat)width height:(CGFloat)height radius:(CGFloat)radius {
	
	// Going to start bottom right then heading anticlockwise
	
	CGMutablePathRef path = CGPathCreateMutable();
	 
	CGPathMoveToPoint(path, NULL, (width - radius), height-inset); // start bottom right
	
	CGPathAddArcToPoint(path, NULL,width-inset, height-inset, width-inset, (height - radius - inset), radius);
	
	CGPathAddLineToPoint(path, NULL, width-inset, radius+inset);

	CGPathAddArcToPoint(path, NULL, width-inset, inset , (width - radius - inset), inset, radius);
	
	CGPathAddLineToPoint(path, NULL, radius+inset, inset);

	CGPathAddArcToPoint(path, NULL, inset, inset, inset, radius+inset, radius);
	
	CGPathAddLineToPoint(path, NULL, inset, (height - radius-inset));

	CGPathAddArcToPoint(path, NULL, inset, height - inset, radius+inset, height-inset, radius);
	
	CGPathAddLineToPoint(path, NULL, (width - radius-inset), height-inset);
	CGPathCloseSubpath(path);
	
	return path;
}

#pragma mark - custom drawing

- (void)drawRect:(CGRect)rect {
    self.backgroundColor = [UIColor clearColor];
    
    
	CGGradientRef gradient;
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGPoint point;
	CGPoint point2;
    
	CGFloat stroke = 1.0;
		
	CGMutablePathRef path = [self newRectanglePathWithInset:(stroke/2.0f + 1.0f) width:self.bounds.size.width height:self.bounds.size.height radius:5.0f];
	
    
	CGContextAddPath(context, path);
	CGContextSaveGState(context);
	CGContextEOClip(context);
	point = CGPointMake((self.bounds.size.width / 2.0), 0.5f);
	point2 = CGPointMake((self.bounds.size.width / 2.0), self.bounds.size.height - 0.5f);
	
	CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
	NSMutableArray *colors = [NSMutableArray arrayWithObjects:(id)[gradient1TopColour CGColor], (id)[gradient1BottomColour CGColor],
							  (id)[gradient2TopColour CGColor], (id)[gradient2BottomColour CGColor], nil];
	CGFloat locations[4];
	locations[0] = 0.0f;
	locations[1] = 0.5f;
	locations[2] = 0.501f;
	locations[3] = 1.0f;
	
	gradient = CGGradientCreateWithColors(space, (__bridge  CFArrayRef)colors, locations);
	
	CGContextDrawLinearGradient(context, gradient, point, point2, (kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation));
	
	CGContextRestoreGState(context);
	CGGradientRelease(gradient);
	CGColorSpaceRelease(space);
	
	if (self.highlighted) {
		// Overlay with a black highlight
		CGContextSaveGState(context);
		CGContextAddPath(context, path);
		CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.375] CGColor]);
		CGContextFillPath(context);
		CGContextRestoreGState(context);
	}
	
	// Setup for Shadow Effect
	CGContextSaveGState(context);
	CGContextSetShadowWithColor(context, CGSizeMake(0.0f, 1.0f), 0.0f, [ [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.2f] CGColor]);
	CGContextBeginTransparencyLayer(context, NULL);
	
	//[strokeColor setStroke];
	CGContextSetStrokeColorWithColor(context, self.gradient2BottomColour.CGColor);
	CGContextSetLineWidth(context, stroke);
	CGContextSetLineCap(context, kCGLineCapSquare);
	CGContextAddPath(context, path);
	CGContextStrokePath(context);

	CGPathRelease(path);
	
	// Shadow Effect
	CGContextEndTransparencyLayer(context);
	CGContextRestoreGState(context);
}


#pragma mark -
#pragma mark Highlight Handling

- (void) setHighlighted:(BOOL)highlighted {
	// If the 'highlighted' value changes force the button to redraw so we can add or remove the 'highlight'
	if (highlighted != self.highlighted) {
		[self setNeedsDisplay];
	}
	
	[super setHighlighted:highlighted];
}

#pragma mark -
#pragma mark Enable and Disable Handling

- (void) setEnabled:(BOOL)enable {
    [self updateAlphaForEnabledState:enable];
    [super setEnabled:enable];
}

+ (void)setDefaultHexEncodedColorsString:(NSString*)hex {
	defaultHexEncodedColorsString = [hex copy];
}

+ (UIButton *) gradientButtonWithTitle:(NSString*)title width:(CGFloat)width {
	
	UIFont *titleFont = [UIFont boldSystemFontOfSize:12];
    
	CGSize size;
    if (iOS_7_or_later) {
        size = [title sizeWithAttributes:@{NSFontAttributeName:titleFont}];
    } else {
        #if __IPHONE_OS_VERSION_MAX_ALLOWED < 70000
        size = [title sizeWithFont:titleFont];
        #endif
    }
	
	if((size.width + kGradientButtonEdgeInsertsWidth) < width) {
		width = (size.width + kGradientButtonEdgeInsertsWidth);
	}
	
	GradientButton *customButton = [[GradientButton alloc] initWithFrame:CGRectMake(0, 0, width, 31)];
	[customButton colorWithHexEncodedColorsString:defaultHexEncodedColorsString];
	customButton.titleLabel.font = titleFont;
	[customButton setTitle:title forState:UIControlStateNormal];
	[customButton.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
	//customButton.titleEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 5);
	
	return customButton;
}

@end

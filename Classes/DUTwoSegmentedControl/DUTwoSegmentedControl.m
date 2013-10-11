//
//  DUTwoSegmentedControl.h
//
//  Created by casserd on 13/12/2010.
//  Copyright 2010 DevedUp Ltd. All rights reserved.
//

#import "DUTwoSegmentedControl.h"
#import "UIColor+Extensions.h"


@interface DUVerticalSeparatorLayer : CALayer

@property (nonatomic, assign) CGColorRef leftColor;
@property (nonatomic, assign) CGColorRef rightColor;
@property (nonatomic, assign) BOOL switchedSides;

+ (DUVerticalSeparatorLayer*) layerWithLeftColor:(CGColorRef)leftColor rightColor:(CGColorRef)rightColor;
- (void) setSwitchedSides:(BOOL)switchedSides;

@end

@implementation DUVerticalSeparatorLayer

@synthesize leftColor = _leftColor;
@synthesize rightColor = _rightColor;
@synthesize switchedSides = _switchedSides;

- (void) dealloc {
	CGColorRelease(_leftColor);
	CGColorRelease(_rightColor);
}

+ (DUVerticalSeparatorLayer*) layerWithLeftColor:(CGColorRef)leftColor rightColor:(CGColorRef)rightColor {
	DUVerticalSeparatorLayer *instance = [super layer];
	if (nil != instance) {
		instance.leftColor = CGColorRetain(leftColor);
		instance.rightColor = CGColorRetain(rightColor);
		instance.switchedSides = NO;
	}
	return instance;
}

- (void) setSwitchedSides:(BOOL)switchedSides {
	if (switchedSides != self.switchedSides) {
		CGColorRef temp = self.leftColor;
		self.leftColor = self.rightColor;
		self.rightColor = temp;
		[self setNeedsDisplay];
		_switchedSides = switchedSides;
	}
}

- (void)drawInContext:(CGContextRef)theContext {
	//fill the top half of the area as the top color.
	CGContextSetFillColorWithColor(theContext, self.leftColor);
	CGContextFillRect(theContext, CGRectMake(0, 0, 1, self.bounds.size.height));
	
	//fill the bottom half of the area with the bottom color.
	CGContextSetFillColorWithColor(theContext, self.rightColor);
	CGContextFillRect(theContext, CGRectMake(1, 0, 1, self.bounds.size.height));
}

@end




#pragma mark - DUTwoSegmentedControl





#define DUTwoSegmentedControlSettingKeyTitleColor	@"DUTwoSegmentedControlSettingKeyTitleColor"
#define DUTwoSegmentedControlSettingKeyColor		@"DUTwoSegmentedControlSettingKeyColor"

@interface DUTwoSegmentedControl ()

@property (nonatomic, retain) UILabel *leftLabel;
@property (nonatomic, retain) UILabel *rightLabel;
@property (nonatomic, assign) DUTwoSegmentedControlState state;
@property (nonatomic, retain) NSArray *settingsForStates;
@property (nonatomic, retain) CAGradientLayer *leftBackgroundLayer;
@property (nonatomic, retain) CAGradientLayer *leftShineLayer;
@property (nonatomic, retain) CAGradientLayer *rightBackgroundLayer;
@property (nonatomic, retain) CAGradientLayer *rightShineLayer;
@property (nonatomic, retain) DUVerticalSeparatorLayer *separatorLayer;

@end


@implementation DUTwoSegmentedControl


@synthesize state = _state;

#pragma mark -  Init 

- (void)awakeFromNib {
    [super awakeFromNib];
	[self setup];
}

+ (id) buttonWithType:(UIButtonType)buttonType {
	if (buttonType != UIButtonTypeCustom) {
		DULog(@"+[DUTwoSegmentedControl buttonWithType:] does not accept buttonType other than UIButtonTypeCustom. Assuming UIButtonTypeCustom.");
	}
	DUTwoSegmentedControl *instance = [super buttonWithType:UIButtonTypeCustom];
	return instance;
}

- (id)initWithFrame:(CGRect)rect {
	self = [super initWithFrame:rect];
	if (self) {
		[self setup];
	}
	return self;
}

//This component is going to be fixed size
- (id) initWithFrame:(CGRect)frame leftLabel:(NSString *)leftLabelText rightLabel:(NSString *)rightLabelText {
	self = [self initWithFrame:frame];
	if (self) {
		[self.leftLabel setText:leftLabelText];
		[self.rightLabel setText:rightLabelText];
	}
	return self;
}

#pragma mark - Drawing

- (void) setup {
		
	//initial colors
	NSMutableDictionary *settingsForNeutralState = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                    [UIColor buttonBaseGrayColor], DUTwoSegmentedControlSettingKeyColor,
                                                    [UIColor grayColor], DUTwoSegmentedControlSettingKeyTitleColor, nil];
    
	NSMutableDictionary *settingsForLeftState = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                 [UIColor colorWithRed:0.22 green:0.47 blue:0.84 alpha:1.0], DUTwoSegmentedControlSettingKeyColor,
                                                 [UIColor whiteColor], DUTwoSegmentedControlSettingKeyTitleColor, nil];
    
	NSMutableDictionary *settingsForRightState = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                  [UIColor colorWithRed:0.22 green:0.47 blue:0.84 alpha:1.0], DUTwoSegmentedControlSettingKeyColor,
                                                  [UIColor whiteColor], DUTwoSegmentedControlSettingKeyTitleColor, nil];
	
	self.settingsForStates = @[settingsForNeutralState, settingsForLeftState, settingsForRightState];
	
	//setting up graphical elements
	self.leftBackgroundLayer = [CAGradientLayer layer];
	CGColorRef lowColor = [[[self.settingsForStates objectAtIndex:DUTwoSegmentedControlStateNeutral] objectForKey:DUTwoSegmentedControlSettingKeyColor] lowCGColor];
	CGColorRef highColor = [[[self.settingsForStates objectAtIndex:DUTwoSegmentedControlStateNeutral] objectForKey:DUTwoSegmentedControlSettingKeyColor] highCGColor];
	[self.leftBackgroundLayer setColors:@[(__bridge id)highColor, (__bridge id)lowColor]];
	[self.layer insertSublayer:self.leftBackgroundLayer atIndex:0];
	
	self.rightBackgroundLayer = [CAGradientLayer layer];
	[self.rightBackgroundLayer setColors:@[(__bridge id)highColor, (__bridge id)lowColor]];
	[self.layer insertSublayer:self.rightBackgroundLayer atIndex:1];
	
	if (!self.leftLabel) {
		self.leftLabel = [[UILabel alloc] init];
		[self.leftLabel setBackgroundColor:[UIColor clearColor]];
		[self.leftLabel setFont:[UIFont systemFontOfSize:16]];
		[self.leftLabel setAdjustsFontSizeToFitWidth:YES];
		[self.leftLabel setTextAlignment:NSTextAlignmentCenter];
		[self.leftLabel setShadowColor:[UIColor whiteColor]];
		[self.leftLabel setShadowOffset:CGSizeMake(0, 1)];
        self.leftLabel.textColor = [UIColor grayColor];
		[self addSubview:self.leftLabel];
	}
	
	if (!self.rightLabel) {
		self.rightLabel = [[UILabel alloc] init];
		[self.rightLabel setBackgroundColor:[UIColor clearColor]];
		[self.rightLabel setFont:[UIFont systemFontOfSize:16]];
		[self.rightLabel setAdjustsFontSizeToFitWidth:YES];
		[self.rightLabel setTextAlignment:NSTextAlignmentCenter];
		[self.rightLabel setShadowColor:[UIColor whiteColor]];
		[self.rightLabel setShadowOffset:CGSizeMake(0, 1)];
        self.rightLabel.textColor = [UIColor grayColor];
		[self addSubview:self.rightLabel];
	}
	
	self.leftShineLayer = [CAGradientLayer layer];
	[self.leftShineLayer setColors:@[(id)[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.05].CGColor, (id)[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.20].CGColor]];
	[self.layer insertSublayer:self.leftShineLayer atIndex:2];
	
	self.rightShineLayer = [CAGradientLayer layer];
	[self.rightShineLayer setColors:@[(id)[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.05].CGColor, (id)[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.20].CGColor]];
	[self.layer insertSublayer:self.rightShineLayer atIndex:3];
	
	self.separatorLayer = [DUVerticalSeparatorLayer layerWithLeftColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6].CGColor rightColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.6].CGColor];
	[self.layer insertSublayer:self.separatorLayer atIndex:4];
	
	//setting up some drawing behaviours
	[self.layer setCornerRadius:4.0f];
	[self.layer setMasksToBounds:YES];
	[self.layer setBorderWidth:1.0f];
    self.layer.borderColor = [UIColor grayColor].CGColor;
	
	[self setState:DUTwoSegmentedControlStateNeutral];
    
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
}

- (void) layoutSubviews {
	[self.leftBackgroundLayer setFrame:CGRectMake(0, 0, self.bounds.size.width/2, self.bounds.size.height)];
	[self.leftShineLayer setFrame:CGRectMake(self.leftBackgroundLayer.frame.origin.x, self.leftBackgroundLayer.frame.origin.y, self.leftBackgroundLayer.frame.size.width, self.leftBackgroundLayer.frame.size.height/2)];
	
	[self.rightBackgroundLayer setFrame:CGRectMake(self.bounds.size.width/2, 0, self.bounds.size.width/2, self.bounds.size.height)];
	[self.rightShineLayer setFrame:CGRectMake(self.rightBackgroundLayer.frame.origin.x, self.rightBackgroundLayer.frame.origin.y, self.rightBackgroundLayer.frame.size.width, self.rightBackgroundLayer.frame.size.height/2)];
	
	[self.separatorLayer setFrame:CGRectMake(self.bounds.size.width/2-1, 0, 2, self.bounds.size.height)];
	
	CGRect leftFrame = self.leftBackgroundLayer.frame;
	leftFrame.size.width = leftFrame.size.width-2;
	leftFrame.origin.x = leftFrame.origin.x+2;
	[self.leftLabel setFrame:leftFrame];
	
	CGRect rightFrame = self.rightBackgroundLayer.frame;
	rightFrame.size.width = rightFrame.size.width-2;
	[self.rightLabel setFrame:rightFrame];
	
	[self.leftBackgroundLayer setNeedsLayout];
	[self.leftBackgroundLayer setNeedsLayout];
	[self.rightBackgroundLayer setNeedsLayout];
	[self.rightShineLayer setNeedsLayout];
	[self.leftLabel setNeedsLayout];
	[self.rightLabel setNeedsLayout];
	[self.separatorLayer setNeedsLayout];
	[self.separatorLayer setNeedsDisplay];
	
	[super layoutSubviews];
}

- (void) setEnabled:(BOOL)_enabled {
	[self.leftLabel setTextColor:(_enabled)?[[self.settingsForStates objectAtIndex:self.state] objectForKey:DUTwoSegmentedControlSettingKeyTitleColor]:[UIColor lightTextColor]];
	[self.rightLabel setTextColor:(_enabled)?[[self.settingsForStates objectAtIndex:self.state] objectForKey:DUTwoSegmentedControlSettingKeyTitleColor]:[UIColor lightTextColor]];
	[super setEnabled:_enabled];
}

- (void) drawRightSelected:(BOOL)_selected {
	//Redraw right gradient
	if (_selected) {
		CGColorRef lowColor = [[[self.settingsForStates objectAtIndex:DUTwoSegmentedControlStateRightSelected] objectForKey:DUTwoSegmentedControlSettingKeyColor] lowCGColor];
		CGColorRef highColor =  [[[self.settingsForStates objectAtIndex:DUTwoSegmentedControlStateRightSelected] objectForKey:DUTwoSegmentedControlSettingKeyColor] highCGColor];
		[self.rightBackgroundLayer setColors:@[(__bridge id)lowColor, (__bridge id)highColor]];
		[self.rightBackgroundLayer setNeedsDisplay];
		[self.rightLabel setTextColor:[[self.settingsForStates objectAtIndex:DUTwoSegmentedControlStateRightSelected] objectForKey:DUTwoSegmentedControlSettingKeyTitleColor]];
		[self.rightLabel setShadowColor:[UIColor clearColor]];
		[self.rightShineLayer setHidden:YES];
	} else {
		CGColorRef lowColor = [[[self.settingsForStates objectAtIndex:DUTwoSegmentedControlStateNeutral] objectForKey:DUTwoSegmentedControlSettingKeyColor] lowCGColor];
		CGColorRef highColor =  [[[self.settingsForStates objectAtIndex:DUTwoSegmentedControlStateNeutral] objectForKey:DUTwoSegmentedControlSettingKeyColor] highCGColor];
		[self.rightBackgroundLayer setColors:@[(__bridge id)highColor, (__bridge id)lowColor]];
		[self.rightBackgroundLayer setNeedsDisplay];
		[self.rightLabel setTextColor:[[self.settingsForStates objectAtIndex:DUTwoSegmentedControlStateNeutral] objectForKey:DUTwoSegmentedControlSettingKeyTitleColor]];
		[self.rightLabel setShadowColor:[UIColor whiteColor]];
		[self.rightLabel setShadowOffset:CGSizeMake(0, 1)];
		[self.rightShineLayer setHidden:NO];
	}
}

- (void) drawLeftSelected:(BOOL)_selected {
	//Redraw left gradient
	if (_selected) {
		CGColorRef lowColor = [[[self.settingsForStates objectAtIndex:DUTwoSegmentedControlStateLeftSelected] objectForKey:DUTwoSegmentedControlSettingKeyColor] lowCGColor];
		CGColorRef highColor =  [[[self.settingsForStates objectAtIndex:DUTwoSegmentedControlStateLeftSelected] objectForKey:DUTwoSegmentedControlSettingKeyColor] highCGColor];
		[self.leftBackgroundLayer setColors:@[(__bridge id)lowColor, (__bridge id)highColor]];
		[self.leftBackgroundLayer setNeedsDisplay];
		[self.leftLabel setTextColor:[[self.settingsForStates objectAtIndex:DUTwoSegmentedControlStateLeftSelected] objectForKey:DUTwoSegmentedControlSettingKeyTitleColor]];
		[self.leftLabel setShadowColor:[UIColor clearColor]];
		[self.leftShineLayer setHidden:YES];
	} else {
		CGColorRef lowColor = [[[self.settingsForStates objectAtIndex:DUTwoSegmentedControlStateNeutral] objectForKey:DUTwoSegmentedControlSettingKeyColor] lowCGColor];
		CGColorRef highColor =  [[[self.settingsForStates objectAtIndex:DUTwoSegmentedControlStateNeutral] objectForKey:DUTwoSegmentedControlSettingKeyColor] highCGColor];
		[self.leftBackgroundLayer setColors:@[(__bridge id)highColor, (__bridge id)lowColor]];
		[self.leftBackgroundLayer setNeedsDisplay];
		[self.leftLabel setTextColor:[[self.settingsForStates objectAtIndex:DUTwoSegmentedControlStateNeutral] objectForKey:DUTwoSegmentedControlSettingKeyTitleColor]];
		[self.leftLabel setShadowColor:[UIColor whiteColor]];
		[self.leftLabel setShadowOffset:CGSizeMake(0, 1)];
		[self.leftShineLayer setHidden:NO];
	}
	
}

#pragma mark - Setter methods

- (void) setState:(DUTwoSegmentedControlState)state {
	switch (state) {
		case DUTwoSegmentedControlStateLeftSelected:
			[self setLeftSelected];
			break;
		case DUTwoSegmentedControlStateRightSelected:
			[self setRightSelected];
			break;
		default:
			break;
	}
}

- (void) setLeftSelected {
	_state = DUTwoSegmentedControlStateLeftSelected;
	
	[self drawLeftSelected:YES];
	[self drawRightSelected:NO];
	[self.separatorLayer setSwitchedSides:NO];
	
	[self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void) setRightSelected {
	_state = DUTwoSegmentedControlStateRightSelected;
	
	[self drawRightSelected:YES];
	[self drawLeftSelected:NO];
	[self.separatorLayer setSwitchedSides:YES];
	
	[self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void) setTitle:(NSString*)title forDUTwoSegmentedControlState:(DUTwoSegmentedControlState)state {
	switch (state) {
		case DUTwoSegmentedControlStateLeftSelected:
			[self.leftLabel setText:title];
			break;
		case DUTwoSegmentedControlStateRightSelected:
			[self.rightLabel setText:title];
			break;
		default:
			break;
	}
}

- (void) setColor:(UIColor*)color forDUTwoSegmentedControlState:(DUTwoSegmentedControlState)state {
	if (nil != [self.settingsForStates objectAtIndex:state]) {
		[[self.settingsForStates objectAtIndex:state] setObject:color forKey:DUTwoSegmentedControlSettingKeyColor];
	}
}

- (void) setTitleColor:(UIColor*)color forDUTwoSegmentedControlState:(DUTwoSegmentedControlState)state {
	if (nil != [self.settingsForStates objectAtIndex:state]) {
		[[self.settingsForStates objectAtIndex:state] setObject:color forKey:DUTwoSegmentedControlSettingKeyTitleColor];
	}
}

#pragma mark - Actions

- (BOOL) beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
	if ([self isEnabled]) {
		CGPoint location = [touch locationInView:self];
		if (location.x > self.frame.size.width/2) {
			[self drawRightSelected:YES];
		}else {
			[self drawLeftSelected:YES];
		}
	}
	
	return [super beginTrackingWithTouch:touch withEvent:event];
}

- (void) endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
	if ([self isEnabled]) {
		if (self.oneButtonBehaviour) {
			switch (self.state) {
				case DUTwoSegmentedControlStateLeftSelected:
					[self setRightSelected];
					break;
				case DUTwoSegmentedControlStateRightSelected:
					[self setLeftSelected];
					break;
				default:
				{
					CGPoint location = [touch locationInView:self];
					if (location.x > self.frame.size.width/2) {
						[self setRightSelected];
					}else {
						[self setLeftSelected];
					}
					break;
				}
			}
		} else {
			CGPoint location = [touch locationInView:self];
			if (location.x > self.frame.size.width/2) {
				[self setRightSelected];
			}else {
				[self setLeftSelected];
			}
		}
	}
	
	[super endTrackingWithTouch:touch withEvent:event];
}

@end
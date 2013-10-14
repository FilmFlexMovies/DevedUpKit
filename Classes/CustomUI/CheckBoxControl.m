//
//  CheckBoxControl.m
//  iDeal
//
//  Created by igmac0007 on 15/12/2010.
//  Copyright 2010 IG Group. All rights reserved.
//

#import "CheckBoxControl.h"
#import "ASHSoundManager.h"

#define LABEL_PADDING_LEFT 8

@interface CheckBoxControl ()

@property (nonatomic, strong) UIImage		*checkBox;
@property (nonatomic, strong) UIImage		*checkBoxPressed;
@property (nonatomic, strong) UIImage		*checkBoxChecked;
@property (nonatomic, strong) UIImageView	*checkBoxImageView;
@property (nonatomic, strong) UILabel		*checkBoxLabel;

- (void) prepareImageViewForCheckState;

@end

@implementation CheckBoxControl

@synthesize checkBox;
@synthesize checkBoxPressed;
@synthesize checkBoxChecked;
@synthesize checkBoxImageView;
@synthesize checkBoxLabel;
@synthesize checked;

#pragma mark -
#pragma mark Release 


#pragma mark -
#pragma mark Init

- (void) initImages {
    // prepare images and view
	self.checkBox = [UIImage imageNamed:@"checkbox.png"];
	self.checkBoxPressed = [UIImage imageNamed:@"checkbox-pressed.png"];
	self.checkBoxChecked = [UIImage imageNamed:@"checkbox-checked.png"];
}

- (void) _init {
	// set flag
	self.checked = NO;
	
	[self initImages];
	
	self.checkBoxImageView = [[UIImageView alloc] 
							   initWithFrame:CGRectMake(0, 
														(self.frame.size.height - self.checkBox.size.height) / 2, 
														self.checkBox.size.width, 
														self.checkBox.size.height)];
	
	[self addSubview:self.checkBoxImageView];
	
	[self prepareImageViewForCheckState];
	
	// prepare Label with params
	float labelX = self.checkBoxImageView.frame.size.width + LABEL_PADDING_LEFT;
	self.checkBoxLabel = [[UILabel alloc] 
						   initWithFrame:CGRectMake(labelX, 
													0, 
													self.frame.size.width - labelX, 
													self.frame.size.height)];
	
	self.checkBoxLabel.backgroundColor = [UIColor clearColor];
	self.checkBoxLabel.textColor = [UIColor whiteColor];
	
	// layout of label
	self.checkBoxLabel.lineBreakMode = NSLineBreakByWordWrapping;
	self.checkBoxLabel.numberOfLines = 0;
	
	[self addSubview:self.checkBoxLabel];
}

- (id) initWithCoder:(NSCoder *)aDecoder {
	if ((self = [super initWithCoder:aDecoder])) {
		[self _init];
		self.checkBoxLabel.textColor = [UIColor blackColor]; // default to black text when loaded from a nib
		self.checkBoxLabel.font = [UIFont systemFontOfSize:12.0];
	}
	return self;
}

- (id) initWithFrame:(CGRect)_frame 
			   title:(NSString*)_title 
				font:(UIFont*)_font 
			 checked:(BOOL)_checked {

	if ((self = [super initWithFrame:_frame])) {
		[self _init];
		
		self.font = _font;
		self.text = _title;
		self.checked = _checked;
	}
	
	return self;
}

#pragma mark - Accessors

- (void) setChecked:(BOOL)_checked {
	[self setChecked:_checked andFireEvent:YES];
}

- (void) setChecked:(BOOL)_checked andFireEvent:(BOOL)fireEvent {
	BOOL wasChecked = checked;
	checked = _checked;
	[self prepareImageViewForCheckState];
	if (wasChecked != _checked && fireEvent) {
		[super sendActionsForControlEvents:UIControlEventValueChanged];
	}
}

- (UIColor*)textColor {
	return self.checkBoxLabel.textColor;
}

- (void) setTextColor:(UIColor *)_color {
	self.checkBoxLabel.textColor = _color;
}

- (UIFont*) font {
	return self.checkBoxLabel.font;
}

- (void) setFont:(UIFont*)_font {
	self.checkBoxLabel.font = _font;
}

- (NSString*)text {
	return self.checkBoxLabel.text;
}

- (void)setText:(NSString*)_text {
	self.checkBoxLabel.text = _text;
}

- (void) setEnabled:(BOOL)value {
	if (YES == value) {
		self.alpha = 1.0;
		self.userInteractionEnabled = YES;
	} else {
		self.alpha = 0.5;
		self.userInteractionEnabled = NO;
	}
}

#pragma mark -
#pragma mark UIControl overrides

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [[ASHSoundManager sharedManager] playSound:ASHSoundManagerSoundIDTap];
    
	self.checkBoxImageView.image = self.checkBoxPressed;
	
	return [super beginTrackingWithTouch:touch withEvent:event];
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
	
	// flip the flag
	self.checked = !self.checked;
	
	[self prepareImageViewForCheckState];
	
	return [super endTrackingWithTouch:touch withEvent:event];
}

#pragma mark -
#pragma mark PrivateMethods Category implementation

- (void) prepareImageViewForCheckState {
	
	self.checkBoxImageView.image = self.checked ? self.checkBoxChecked : self.checkBox;	
}

@end

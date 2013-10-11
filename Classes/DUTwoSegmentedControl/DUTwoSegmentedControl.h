//
//  DUTwoSegmentedControl.h
//
//  Created by casserd on 13/12/2010.
//  Copyright 2010 DevedUp Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class DUVerticalSeparatorLayer;

typedef enum {
	DUTwoSegmentedControlStateNeutral = 0,
	DUTwoSegmentedControlStateLeftSelected,
	DUTwoSegmentedControlStateRightSelected
} DUTwoSegmentedControlState;

@interface DUTwoSegmentedControl : UIButton 

@property (nonatomic, readonly) DUTwoSegmentedControlState state;
@property (nonatomic, retain, readonly) UILabel *leftLabel;
@property (nonatomic, retain, readonly) UILabel *rightLabel;
@property (nonatomic, assign) BOOL oneButtonBehaviour;


- (id) initWithFrame:(CGRect)frame leftLabel:(NSString *)leftLabelText rightLabel:(NSString *)rightLabelText;
- (void) setLeftSelected;
- (void) setRightSelected;
- (void) setTitle:(NSString*)title forDUTwoSegmentedControlState:(DUTwoSegmentedControlState)state;
- (void) setColor:(UIColor*)color forDUTwoSegmentedControlState:(DUTwoSegmentedControlState)state;
- (void) setTitleColor:(UIColor*)color forDUTwoSegmentedControlState:(DUTwoSegmentedControlState)state;

@end
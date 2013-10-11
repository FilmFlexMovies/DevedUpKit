//
//  ToolTipPopUpView.m
//  DevedUp
//
//  Created by David Casserly on 15/08/2009.
//  Copyright 2010 devedup.com. All rights reserved.
//

#import "ToolTipPopUpView.h"


@implementation ToolTipPopUpView

@synthesize view;
@synthesize background;
@synthesize label;

#pragma mark -
#pragma mark Release



#pragma mark -
#pragma mark Init 

+ (UIView *) toolTipWithText:(NSString *)text {
	ToolTipPopUpView *toolTip = [[ToolTipPopUpView alloc] init];
	if (![[NSBundle mainBundle] loadNibNamed:@"ToolTipPopUpView" owner:toolTip options:nil]) {
		return nil;
	}
	toolTip.label.text = text;
	return toolTip.view;
}


@end

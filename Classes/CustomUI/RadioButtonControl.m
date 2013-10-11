//
//  RadioButtonControl.m
//  DevedUp
//
//  Created by David Casserly on 01/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RadioButtonControl.h"

@implementation RadioButtonControl

- (void) initImages {
    // prepare images and view
	checkBox = [UIImage imageNamed:@"radio.png"];
	checkBoxPressed = [UIImage imageNamed:@"radio-pressed.png"];
	checkBoxChecked = [UIImage imageNamed:@"radio-selected.png"];
}

@end

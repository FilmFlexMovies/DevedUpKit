//
//  DULocalisation.m
//  DevedUp
//
//  Created by David Casserly on 28/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define DEBUG_TRANSLATIONS 0

#import "DULocalisation.h"

@implementation DULocalisation

+ (DULocalisation *) sharedController {
    static dispatch_once_t onceToken;
    static DULocalisation * __sharedManager = nil;
    
    dispatch_once(&onceToken, ^{
        __sharedManager = [[self alloc] init];
    });
    
    return __sharedManager;
}

- (NSString *) localisedString:(NSString *)string {
    if (!string || string.length == 0) {
        return @""; //don't translate blank
    }
    
    NSString *defaultValue = @"";
    
#if DEBUG_TRANSLATIONS
    defaultValue = [NSString stringWithFormat:@"TRANSLATE: %@", string];
    if ([string hasPrefix:@"TRANSLATE:"]) {
        //don't translate twice
        return string;
    }
#endif
#ifndef DEBUG
	[self.analytics logEvent:@"Missing Translation" withKey:string value:nil];
#endif

    NSBundle *bundle = [NSBundle mainBundle];
    
    //First look for a target specific string - default here is blank
    NSString *translated = [bundle localizedStringForKey:string value:@"doesntexist" table:@"TargetSpecific"];
    if ([@"doesntexist" isEqualToString:translated]) {
        //try the default strings file, and use default if it doesn't exist
        translated = [bundle localizedStringForKey:string value:defaultValue table:@"Localizable"];
    }
    
    return translated;
}

- (void) localizeViewHierarchy:(UIView *)view {
        
    if ([view isKindOfClass:[UILabel class]]) {
		UILabel *label = (UILabel*)view;
		[label setText:[self localisedString:label.text]];
	} else if ([view isKindOfClass:[UIButton class]]) {
		UIButton *button = (UIButton*)view;
		[button setTitle:[self localisedString:[button titleForState:UIControlStateSelected]] forState:UIControlStateSelected];
		[button setTitle:[self localisedString:[button titleForState:UIControlStateDisabled]] forState:UIControlStateDisabled];
		[button setTitle:[self localisedString:[button titleForState:UIControlStateHighlighted]] forState:UIControlStateHighlighted];
		[button setTitle:[self localisedString:[button titleForState:UIControlStateNormal]] forState:UIControlStateNormal];
	} else if ([view isKindOfClass:[UISegmentedControl class]]) {
		UISegmentedControl *segmentedControl = (UISegmentedControl*)view;
		for (int i = 0; i < segmentedControl.numberOfSegments; i++) {			
			if (![segmentedControl imageForSegmentAtIndex:i]) {
				[segmentedControl setTitle:[self localisedString:[segmentedControl titleForSegmentAtIndex:i]] forSegmentAtIndex:i];
			}
		}
	} else if ([view isKindOfClass:[UITextField class]]) {
		UITextField *textField = (UITextField*)view;
		[textField setPlaceholder:[self localisedString:textField.placeholder]];
	} else if ([view isKindOfClass:UITextView.class]) {
        UITextView *textView = (UITextView *)view;
        [textView setText:[self localisedString:textView.text]];
    }
    
    //Now do the subviews
    for (UIView *subview in [view subviews]) {
        if (![subview isKindOfClass:UIDatePicker.class]) {
            [self localizeViewHierarchy:subview];
        }
        
    }
}

@end

//
//  UIView+Extensions.h
//  DevedUp
//
//  Created by David Casserly on 23/03/2010.
//  Copyright 2010 devedup.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*
	Generally its bad practice to use categories on Cocoa classes as
	if a later API is released with the same method as these, then there
	would be name clashes, and problems of devestating proportions !
 
	So only add stuff here if you're sure it won't clash ! (or you don't care)
 
 */
@interface UIView (Extensions)

// This will get the frame of the currentView and apply it to the newView and then
// remove the currentView and replace it with the newView
- (void) swapSubviewAtTag:(NSInteger)tag withView:(UIView *)newView;
- (void) swapSubview:(UIView *)currentView withView:(UIView *)newView;

// This will scroll up the view so the textfield is always in view when the keyboard
// appears and then there is another method to reset it
- (void) scrollInputViewForUIControl:(UIControl *)control offset:(float)offset; 
- (void) resetInputViewForUIControl:(UIControl *)control;

- (UIImage *) renderViewInRect:(CGRect)rect;

@end

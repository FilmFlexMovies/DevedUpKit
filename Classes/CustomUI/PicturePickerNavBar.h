//
//  PicturePickerNavBar.h
//  DevedUp
//
//  Created by David Casserly on 07/08/2009.
//  Copyright 2010 devedup.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BackBarButton.h"

@protocol CustomNavBarDelegate 

- (void) backButtonWasPressed;
- (void) doneButtonWasPressed;

@end


@interface PicturePickerNavBar : UINavigationBar {

	BackBarButton *backButton;
	UILabel *titleLabel;
	
	id<CustomNavBarDelegate> __weak delegate;
	
	BOOL isDoneButtonVisible;
	
	NSString *initialTitle;
	
}

@property (nonatomic, copy) NSString *initialTitle;
@property (nonatomic, weak) id<CustomNavBarDelegate> delegate;

@property (nonatomic, strong) BackBarButton *backButton;
@property (nonatomic, strong) UILabel *titleLabel;

#pragma mark -
#pragma mark Init 

- (id)initWithFrame:(CGRect)frame delegate:(id<CustomNavBarDelegate>)_delegate backTitle:(NSString *)backTitle title:(NSString *)title;

- (void) setTitle:(NSString *)title animated:(BOOL)animated;

#pragma mark -
#pragma mark Done Button

- (void) showDoneButton;
- (void) hideDoneButton;

@end

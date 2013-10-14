//
//  PicturePickerNavBar.m
//  DevedUp
//
//  Created by David Casserly on 07/08/2009.
//  Copyright 2010 devedup.com. All rights reserved.
//

#import "PicturePickerNavBar.h"

@implementation PicturePickerNavBar

@synthesize initialTitle;
@synthesize backButton;
@synthesize titleLabel;

//Assign
@synthesize delegate;

#pragma mark -
#pragma mark Release

- (void) dealloc {
	self.delegate = nil;

}

#pragma mark -
#pragma mark Init 

- (id)initWithFrame:(CGRect)frame delegate:(id<CustomNavBarDelegate>)_delegate backTitle:(NSString *)backTitle title:(NSString *)title {
    if ((self = [super initWithFrame:frame])) {
		
		initialTitle = title;
		
		delegate = _delegate;
		
		//Create the 'hidden' back button - fades in in drawRect:
		if (backTitle) {
			backButton = [[BackBarButton alloc] initWithFrame:CGRectMake(5, 7, 60, 30) title:backTitle];
			backButton.alpha = 0.0;
			[backButton addTarget:delegate action:@selector(backButtonWasPressed) forControlEvents:UIControlEventTouchUpInside];
			[self addSubview:backButton];
		}
		
		
		titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(320, 0, 100, 40)];
		titleLabel.backgroundColor = [UIColor clearColor];
		titleLabel.textColor = [UIColor whiteColor];
		titleLabel.font = [UIFont boldSystemFontOfSize:19.0];
		//titleLabel.minimumFontSize = 8.0;
		titleLabel.adjustsFontSizeToFitWidth = YES;
		[self addSubview:titleLabel];
		
		
		
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	
	//Animate the title of the nav bar
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3]; 
	
	[self setTitle:initialTitle animated:NO];
	
	//Fade in the back button
	backButton.alpha = 1.0;
	
	[UIView commitAnimations];
}

#pragma mark -
#pragma mark Set title

- (void) setTitle:(NSString *)title animated:(BOOL)animated {
	
	if (animated) {
		titleLabel.frame = CGRectMake(320, 0, 150, 40);
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3]; 
	}
	
	titleLabel.text = title;
	CGSize size = [titleLabel.text sizeWithFont:titleLabel.font];
	titleLabel.frame = CGRectMake(160 - (size.width / 2), 0, 110, 44);
	
	
	if (animated) {
		[UIView commitAnimations];
	}
	
}


#pragma mark -
#pragma mark Done Button

- (void) showDoneButton{
	if (isDoneButtonVisible) {
		return;
	}
	UINavigationItem *navItem = [[UINavigationItem alloc] init];
	navItem.backBarButtonItem = nil;
	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self.delegate action:@selector(doneButtonWasPressed)];
	navItem.rightBarButtonItem = rightButton;
	[self pushNavigationItem:navItem animated:YES];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3]; 
	self.backButton.alpha = 0.0;
	[UIView commitAnimations];
	
	
	isDoneButtonVisible = YES;
}

- (void) hideDoneButton {
	if (!isDoneButtonVisible) {
		return;
	}
	[super popNavigationItemAnimated:YES];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3]; 
	self.backButton.alpha = 1.0;
	[UIView commitAnimations];
	
	
	isDoneButtonVisible = NO;
}




@end

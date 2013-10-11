//
//  DUUITextView.m
//  DevedUp
//
//  Created by David Casserly on 22/03/2011.
//  Copyright 2011 devedup.com. All rights reserved.
//

#import "DUUITextView.h"


@implementation DUUITextView

- (void) setText:(NSString *)newText {
	if ([self.superview isKindOfClass:UIScrollView.class]) {
		UIScrollView *parentScrollView = (UIScrollView *) self.superview;
		CGSize previousContentSize = parentScrollView.contentSize;
		parentScrollView.contentSize = CGSizeMake(parentScrollView.frame.size.width, parentScrollView.frame.size.height);
		[super setText:newText];
		parentScrollView.contentSize = previousContentSize;
	} else {
		[super setText:newText];
	}

}

@end

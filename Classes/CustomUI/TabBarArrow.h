//
//  TabBarArrow.h
//  DevedUp
//
//  Created by David Casserly on 23/02/2009.
//  Copyright 2010 devedup.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	ShowArrowTabOne = 0,
	ShowArrowTabTwo = 1,
	ShowArrowTabThree = 2,
	ShowArrowTabFour = 3,
	ShowArrowTabFive = 4
} ShowArrowTab;

@interface TabBarArrow : UIView {
		
@private
	ShowArrowTab currentTab;

}

- (void) showArrowAtTab:(ShowArrowTab)tab;

@end

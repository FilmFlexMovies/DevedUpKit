//
//  ToolTipPopUpView.h
//  DevedUp
//
//  Created by David Casserly on 15/08/2009.
//  Copyright 2010 devedup.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ToolTipPopUpView : NSObject {

	IBOutlet UIView *view;
	IBOutlet UIImageView *background;
	IBOutlet UILabel *label;
	
}

@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UIImageView *background;
@property (nonatomic, strong) UILabel *label;

#pragma mark -
#pragma mark Init 

+ (UIView *) toolTipWithText:(NSString *)text;

@end

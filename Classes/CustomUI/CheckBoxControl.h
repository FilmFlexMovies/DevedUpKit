//
//  CheckBoxControl.h
//  iDeal
//
//  Created by igmac0007 on 15/12/2010.
//  Copyright 2010 IG Group. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CheckBoxControl : UIControl {

	
	UIImage		*checkBox;
	UIImage		*checkBoxPressed;
	UIImage		*checkBoxChecked;
    
    @private
	UIImageView	*checkBoxImageView;
	UILabel		*checkBoxLabel;
	BOOL		checked;
}

@property (nonatomic, assign, getter = isChecked) BOOL checked;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) NSString *text;

- (void) initImages;
- (id) initWithFrame:(CGRect)frame title:(NSString*)title font:(UIFont*)font checked:(BOOL)checked;
- (void) setChecked:(BOOL)_checked andFireEvent:(BOOL)fireEvent;
@end

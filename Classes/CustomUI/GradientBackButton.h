//
//  GradientBackButton.h
//  iDeal
//
//  Created by igmac0005 on 01/10/2010.
//  Copyright 2010 DevedUp Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GradientButton.h"

@interface GradientBackButton : GradientButton {

}

+ (void)setDefaultHexEncodedColorsString:(NSString*)hex;

+ (UIButton *) gradientBackButtonWithTitle:(NSString*)title width:(CGFloat)width;

@end

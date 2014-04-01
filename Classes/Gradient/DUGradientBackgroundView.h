//
//  DUGradientBackgroundView.h
//  DevedUpKit
//
//  Created by David Casserly on 01/04/2014.
//  Copyright (c) 2014 DevedUp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DUGradientBackgroundView : UIView

- (id) initWithFrame:(CGRect)frame gradient:(CAGradientLayer *)gradient;

- (UIImage *) renderToImage;

@end

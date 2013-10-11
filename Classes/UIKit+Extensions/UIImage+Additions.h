//
//  UImage+Additions.h
//  DevedUp
//
//  Created by David Casserly on 10/08/2009.
//  Copyright 2010 devedup.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIImage (Additions) 

- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;
- (UIImage *) imageWithShadow;

@end

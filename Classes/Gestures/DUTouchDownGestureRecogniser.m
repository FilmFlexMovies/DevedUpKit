//
//  DUTouchDownGestureRecogniser.m
//  DevedUp
//
//  Created by David Casserly on 06/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DUTouchDownGestureRecogniser.h"

@implementation DUTouchDownGestureRecogniser


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    self.state = UIGestureRecognizerStateRecognized;    
}


@end

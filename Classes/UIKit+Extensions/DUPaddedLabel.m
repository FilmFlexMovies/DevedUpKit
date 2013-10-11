//
//  DUPaddedLabel.m
//  DevedUp
//
//  Created by David Casserly on 20/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DUPaddedLabel.h"

@implementation DUPaddedLabel

@synthesize insets = _insets;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.insets = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {
         self.insets = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return self;
}

- (id)init{
    self = [super init];
    if (self) {
         self.insets = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect {
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.insets)];
}

@end

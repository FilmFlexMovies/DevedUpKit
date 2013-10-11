//
//  DUTableView.m
//  DevedUp
//
//  Created by David Casserly on 30/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DUTableView.h"

@implementation DUTableView

- (void) reloadDataWithCompletion:( void (^) (void) )completionBlock {
    [super reloadData];
    if (completionBlock) {
        completionBlock();
    }    
}

//- (void) setNeedsDisplay {
//    [super setNeedsDisplay];
//}
//
//- (void) setNeedsLayout {
//    [super setNeedsLayout];
//}

@end

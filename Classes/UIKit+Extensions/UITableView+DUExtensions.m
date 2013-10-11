//
//  UITableView_DUExtensions.h
//  DevedUp
//
//  Created by David Casserly on 29/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UITableView+DUExtensions.h"


@implementation UITableView (DUExtensions)

- (void) reloadSectionDU:(NSInteger)section withRowAnimation:(UITableViewRowAnimation)rowAnimation {
    NSRange range = NSMakeRange(section, 1);
    NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];                                     
    [self reloadSections:sectionToReload withRowAnimation:rowAnimation];
}

@end

//
//  DUTableView.h
//  DevedUp
//
//  Created by David Casserly on 30/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DUTableView : UITableView

- (void) reloadDataWithCompletion:( void (^) (void) )completionBlock;

@end

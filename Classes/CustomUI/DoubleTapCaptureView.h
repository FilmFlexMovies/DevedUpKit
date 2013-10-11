//
//  DoubleTapCaptureView.h
//  DevedUp
//
//  Created by David Casserly on 09/08/2009.
//  Copyright 2010 devedup.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DoubleTapDelegate <NSObject>

- (void) doubleTapped;

@end

/*
	Not used anywhere yet, but could be
 */
@interface DoubleTapCaptureView : UIView {

	id<DoubleTapDelegate> __weak delegate;
	
}

@property (nonatomic, weak) id<DoubleTapDelegate> delegate;

@end

//
//  DUModalProgressView.h
//
//  Created by David Casserly on 27/12/2011.
//  Copyright (c) 2011 DevedUp Ltd. All rights reserved.
//

extern CGFloat const ModalProgressViewHeight;

@interface DUModalProgressView : UIView

- (void) showAnimatedWithOverlay:(BOOL)overlay;
- (void) hideAnimatedWithCompletion:(void (^)(void))completionBlock;

@end

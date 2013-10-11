//
//  DUCAAnimationBlockDelegate.h
//  DevedUp
//
//  Created by David Casserly on 28/06/2013.
//
//

#import <Foundation/Foundation.h>

@interface DUCAAnimationBlockDelegate : NSObject

// Block to call when animation is started
@property (nonatomic, copy) void(^blockOnAnimationStarted)(void);

// Block to call when animation is successful
@property (nonatomic, copy) void(^blockOnAnimationSucceeded)(void);

// Block to call when animation fails
@property (nonatomic, copy) void(^blockOnAnimationFailed)(void);

@end

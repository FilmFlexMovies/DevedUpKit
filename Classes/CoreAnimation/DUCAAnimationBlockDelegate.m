//
//  DUCAAnimationBlockDelegate.m
//  DevedUp
//
//  Created by David Casserly on 28/06/2013.
//
//

#import "DUCAAnimationBlockDelegate.h"
#import <QuartzCore/QuartzCore.h>

@implementation DUCAAnimationBlockDelegate

/* Called when the animation begins its active duration. */
- (void) animationDidStart:(CAAnimation *)anim {
    if(self.blockOnAnimationStarted) {
        self.blockOnAnimationStarted();
    }    
}

/* Called when the animation either completes its active duration or
 * is removed from the object it is attached to (i.e. the layer). 'flag'
 * is true if the animation reached the end of its active duration
 * without being removed. */
- (void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if(flag) {
        if(self.blockOnAnimationSucceeded) {
            self.blockOnAnimationSucceeded();
        }        
        return;
    }
    if(self.blockOnAnimationFailed) {
        self.blockOnAnimationFailed();
    }    
}

@end

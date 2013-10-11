//
//  ASHSoundManager.h
//  Nifty
//
//  Created by Ashley Mills on 23/03/2012.
//  Copyright (c) 2012 Joylord Systems Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const SoundEffectsOnOffKey;
extern NSString * const SoundEffectsChangedNotification;

typedef enum {
    ASHSoundManagerSoundIDDelete = 0,
    ASHSoundManagerSoundIDFail,
    ASHSoundManagerSoundIDHide,
    ASHSoundManagerSoundIDShow,
    ASHSoundManagerSoundIDSuccessBell,
    ASHSoundManagerSoundIDTick,
    ASHSoundManagerSoundIDLeftSwipe,
    ASHSoundManagerSoundIDRightSwipe,
    ASHSoundManagerSoundIDTap
} ASHSoundManagerSoundID;

@interface ASHSoundManager : NSObject

+ (ASHSoundManager *) sharedManager;

- (void) playSound:(ASHSoundManagerSoundID) soundID;

@end

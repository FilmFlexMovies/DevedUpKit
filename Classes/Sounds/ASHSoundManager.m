//
//  ASHSoundManager.m
//  Nifty
//
//  Created by Ashley Mills on 23/03/2012.
//  Copyright (c) 2012 Joylord Systems Ltd. All rights reserved.
//

#import "ASHSoundManager.h"
#import <AudioToolbox/AudioToolbox.h>

NSString * const SoundEffectsOnOffKey = @"SoundEffectsOnOffKey";
NSString * const SoundEffectsChangedNotification = @"NSString * const ";

@interface ASHSoundManager () {
    BOOL playSoundEffects;
}

@property (nonatomic, assign) SystemSoundID * sounds;

@end

@implementation ASHSoundManager

@synthesize sounds = sounds;

+ (ASHSoundManager *) sharedManager
{
    static ASHSoundManager * __sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[self alloc] init];
    });
    
	return __sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        playSoundEffects = NO;
        NSNumber *soundNum = [[NSUserDefaults standardUserDefaults] objectForKey:SoundEffectsOnOffKey];
        if (soundNum) {
            playSoundEffects = [soundNum boolValue];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(soundEffectSettingChanged:) name:SoundEffectsChangedNotification object:nil];
        
        char * fileNames[] = {"delete","fail_noise", "hide", "show", "success_bell", "tick", "leftswipe", "rightswipe", "tap"}; //last 3 are .caf, others are .aif
        
        int count = sizeof(fileNames) / sizeof(*fileNames);
        sounds = malloc(count * sizeof(SystemSoundID));
        
        for (int i = 0; i < count; i++) {
   
            SystemSoundID sound = -1;
            CFStringRef fileName = CFStringCreateWithCString(kCFAllocatorDefault, fileNames[i], kCFStringEncodingASCII);
            CFStringRef type;
            if (i < 6) {
                type = CFSTR("aif");
            } else {
                type = CFSTR("caf");
            }
            CFURLRef alertURL = CFBundleCopyResourceURL(CFBundleGetMainBundle(), fileName, type, NULL);
            OSStatus status = AudioServicesCreateSystemSoundID(alertURL, &sound);
            //AudioServicesCreateSystemSoundID(alertURL, &sound);
            
            UNUSED_VARIABLE(status);
            
            //if (sound) {
            sounds[i] = sound;
            //} else {
            //DULog(@"Sound status %i", status);
            //}
            CFRelease(alertURL);
            CFRelease(fileName);
        }
    }
    return self;
}

- (void) soundEffectSettingChanged:(NSNotification *)notification {
    NSNumber *sound = notification.object;
    playSoundEffects = [sound boolValue];
}

- (void) playSound: (ASHSoundManagerSoundID) soundID {
    
    if (soundID == ASHSoundManagerSoundIDShow) {
        soundID = ASHSoundManagerSoundIDLeftSwipe;
    }
    
    
    if (soundID == ASHSoundManagerSoundIDHide) {
        soundID = ASHSoundManagerSoundIDRightSwipe;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        if (playSoundEffects) {
            AudioServicesPlayAlertSound(self.sounds[soundID]);
        }
    });
    
}

- (void) vibrate {// trigger the phone’s vibration
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}


@end

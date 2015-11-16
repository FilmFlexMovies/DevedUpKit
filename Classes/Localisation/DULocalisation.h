//
//  DULocalisation.h
//  DevedUp
//
//  Created by David Casserly on 28/06/2012.
//  Copyright (c) 2012 DevedUp Ltd. All rights reserved.
//

#import	"DUAnalytics.h"

extern NSString * const DULocalizationMissing;

@interface DULocalisation : NSObject

+ (DULocalisation *) sharedController;

@property (nonatomic, retain) id<DUAnalytics> analytics;

/**
 Will localize the string from the Localizable.strings file. If you are in DEBUG mode and there isn't a translation, it will put
 */
- (NSString *) localizedString:(NSString *)string;

/**
 Will recurse the view heirarchy, replacing strings with those in the strings file
 */
- (void) localizeViewHierarchy:(UIView *)view;

@end


/*
 Use as a replacment of NS LocalizedString(@"", @"")
 
 Will localize the string from the Localizable.strings file. If you are in DEBUG mode and there isn't a translation, it will put
 
 */
#define DULocalizedString(key, comment) \
[[DULocalisation sharedController] localizedString:(key)]

#define DULocalizedView(view) \
[[DULocalisation sharedController] localizeViewHierarchy:(view)]

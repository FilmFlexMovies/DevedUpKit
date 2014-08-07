//
//  DULocalisation.h
//  DevedUp
//
//  Created by David Casserly on 28/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import	"DUAnalytics.h"

extern NSString * const DULocalizationMissing;

@interface DULocalisation : NSObject

@property (nonatomic, retain) id<DUAnalytics> analytics;

+ (DULocalisation *) sharedController;

- (NSString *) localisedString:(NSString *)string;

- (void) localizeViewHierarchy:(UIView *)view;

@end

#define DULocalizedString(key, comment) \
[[DULocalisation sharedController] localisedString:(key)]

#define DULocalizedView(view) \
[[DULocalisation sharedController] localizeViewHierarchy:(view)]

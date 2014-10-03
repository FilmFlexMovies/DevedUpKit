//
//  Macros.h
//  Flickr
//
//  Created by David Casserly on 01/06/2011.
//  Copyright 2011 DevedUp Ltd. All rights reserved.
//

#include <libgen.h>
#import "Logger.h"

#define _GNU_SOURCE
#include <stdio.h>

//Blocks
typedef void (^DUBlock)(void);
typedef void (^DUBlockWithError)(NSError *error);

#define UNUSED_VARIABLE(x)					((void)(x))

#define IS_PORTRAIT UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)
#define IS_LANDSCAPE UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)



//#define log4Method() DULog(@"%@", [NSString stringWithFormat:@"[%s:%d %@]",basename(__FILE__),__LINE__,NSStringFromSelector(_cmd)])


	#ifdef DEBUG
		#define DULog( s, ... ) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
	#else
		#define DULog( s, ... )
    #endif

//Shouldn't need to use NSLog in code anywhere
#define ErrorLog( s, ... ) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )

#define LogCGRect(rect) DULog(@"CGRect:%@", NSStringFromCGRect(rect));
#define LogCGSize(size) DULog(@"CGSize:%@", NSStringFromCGSize(size));
#define LogCGPoint(point) DULog(@"CGPoint:%@", NSStringFromCGPoint(point));
#define LogDimensions(view) DULog(@"Frame:'%@' Bounds:'%@' Center:'%@'", NSStringFromCGRect(view.frame), NSStringFromCGRect(view.bounds), NSStringFromCGPoint(view.center));

#define RELEASE_AND_NIL(x) [(x) release], (x) = nil;
#define INVALIDATE_RELEASE_AND_NIL(x) [(x) invalidate], RELEASE_AND_NIL(x);
#define NIL_DELEGATE_RELEASE_AND_NIL(x) x.delegate = nil, RELEASE_AND_NIL(x);

#define COUNTOF(x) (sizeof(x)/sizeof(x[0]))
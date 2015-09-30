//
//  Macros.h
//  Flickr
//
//  Created by David Casserly on 01/06/2011.
//  Copyright 2011 DevedUp Ltd. All rights reserved.
//

#include <libgen.h>

#define _GNU_SOURCE
#include <stdio.h>

//Blocks
typedef void (^DUBlock)(void);
typedef void (^DUBlockWithError)(NSError *error);

#define UNUSED_VARIABLE(x)					((void)(x))

#define IS_PORTRAIT UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)
#define IS_LANDSCAPE UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)

#define LogCGRect(rect) NSLog(@"CGRect:%@", NSStringFromCGRect(rect));
#define LogCGSize(size) NSLog(@"CGSize:%@", NSStringFromCGSize(size));
#define LogCGPoint(point) NSLog(@"CGPoint:%@", NSStringFromCGPoint(point));
#define LogDimensions(view) NSLog(@"Frame:'%@' Bounds:'%@' Center:'%@'", NSStringFromCGRect(view.frame), NSStringFromCGRect(view.bounds), NSStringFromCGPoint(view.center));

#define RELEASE_AND_NIL(x) [(x) release], (x) = nil;
#define INVALIDATE_RELEASE_AND_NIL(x) [(x) invalidate], RELEASE_AND_NIL(x);
#define NIL_DELEGATE_RELEASE_AND_NIL(x) x.delegate = nil, RELEASE_AND_NIL(x);

#define COUNTOF(x) (sizeof(x)/sizeof(x[0]))
//
//  UIDevice+Extensions.h
//  DevedUp
//
//  Created by David Casserly on 13/08/2010.
//  Copyright 2010 IGIndex. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIDevice (Extensions)

+ (NSString *) device;
+ (NSString *) friendlyDeviceName;
+ (BOOL) isOSLessThanVersion4;
+ (BOOL) isOSLessThanVersion3_2;
+ (BOOL) isOSGreaterThanVersion5;
+ (BOOL) isOSLessThanVersion:(NSString*)versionString;
+ (BOOL) is3GDevice;
+ (BOOL) isIPad;
+ (BOOL) isIPadOriginal;

+ (NSString *) cachesDirectory;
+ (NSString *) documentsDirectory;

+ (BOOL) isRetinaDevice;

@end

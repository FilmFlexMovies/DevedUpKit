//
//  UIDevice+Extensions.m
//  iDeal
//
//  Created by casserd on 13/08/2010.
//  Copyright 2010 IGIndex. All rights reserved.
//

#import "UIDevice+Extensions.h"
#import "NSString+Extensions.h"
#include <sys/types.h>
#include <sys/sysctl.h>

@implementation UIDevice (Extensions)


+(BOOL)isLandscape {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if(orientation == UIInterfaceOrientationLandscapeLeft) return YES;
    if(orientation == UIInterfaceOrientationLandscapeRight) return YES;
    return NO;
}

+(BOOL)isLandscape:(UIInterfaceOrientation)orientation {
    if(orientation == UIInterfaceOrientationLandscapeLeft) return YES;
    if(orientation == UIInterfaceOrientationLandscapeRight) return YES;
    return NO;
}

+(BOOL)is_iPad {
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

+ (BOOL) is_iPhone {
    return (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad);
}

+(BOOL)isRetina {
	if([[[UIDevice currentDevice] systemVersion] intValue] >= 4 && [[UIScreen mainScreen] scale] == 2.0) {
        return YES;
    }
	return NO;
}

+(BOOL)supportsCustomFonts {
    if([UIDevice is_iPad]) return YES;
    if([[[UIDevice currentDevice] systemVersion] intValue] >= 4) return YES;
    return NO;
}

+(CGPoint)getPoint:(CGPoint)p {
	if([UIDevice is_iPad]) return CGPointMake(p.x * 2, p.y * 2);
	return p;
}

+(float)getFloat:(float)f {
	if([UIDevice is_iPad]) return f * 2;
	return f;
}

+(CGRect)getRect:(CGRect)rect {
	if([UIDevice is_iPad]) return CGRectMake(rect.origin.x * 2, rect.origin.y * 2, rect.size.width * 2, rect.size.height * 2);
	return rect;
}

+(CGSize)getSize:(CGSize)size {
	if([UIDevice is_iPad]) return CGSizeMake(size.width * 2, size.height * 2);
	return size;
}

+ (NSString *) friendlyDeviceName {
	static NSMutableDictionary *devices;
	NSString *friendlyDeviceName;
	if (!devices) {
		devices = [[NSMutableDictionary alloc] initWithCapacity:10];
		
        //http://www.everyi.com/by-identifier/ipod-iphone-ipad-specs-by-model-identifier.html
        
        
		//iPhone Simulator
		devices[@"i386"] = @"iPhone Simulator";
		devices[@"x86_64"] = @"iPhone Simulator_";
        
		//iPhone Original
		devices[@"iPhone1,1"] = @"iPhone (Original/Edge)";
        
        //iPhone 3G
		devices[@"iPhone1,2"] = @"iPhone 3G";
        devices[@"iPhone1,2*"] = @"iPhone 3G (China no Wi-Fi)";
        
        //iPhone 3GS
		devices[@"iPhone2,1"] = @"iPhone 3GS";
        devices[@"iPhone2,1*"] = @"iPhone 3GS (China no Wi-Fi)";
        
        //iPhone 4
		devices[@"iPhone3,1"] = @"iPhone 4 (GSM)";
        devices[@"iPhone3,3"] = @"iPhone 4 (CDMA/Verizon/Sprint)";
        
        //iPhone 4S
		devices[@"iPhone4,1"] = @"iPhone 4S";
        
		//iPods
		devices[@"iPod1,1"] = @"iPod Touch Original";
		devices[@"iPod2,1"] = @"iPod Touch 2nd Gen";
		devices[@"iPod3,1"] = @"iPod Touch 3rd Gen";
		devices[@"iPod4,1"] = @"iPod Touch(Retina) 4th Gen";
		
		//iPads
		devices[@"iPad1,1"] = @"iPad 1";
        
        //iPad 2
        devices[@"iPad2,1"] = @"iPad 2 Wi-Fi";
		devices[@"iPad2,2"] = @"iPad 2 Wi-Fi/GSM";
        devices[@"iPad2,3"] = @"iPad 2 Wi-Fi/CDMA";
        devices[@"iPad2,4"] = @"iPad 2 Wi-Fi/CDMA Small Chip";
        
        //iPad 3
        devices[@"iPad3,1"] = @"iPad 3 Wi-Fi";
		devices[@"iPad3,2"] = @"iPad 3 Wi-Fi/GSM";
        devices[@"iPad3,3"] = @"iPad 3 Wi-Fi/CDMA";
        
	}
	
	NSString *device = [UIDevice device];
	friendlyDeviceName = devices[device];
	return (friendlyDeviceName) ? friendlyDeviceName : device;
}

//http://iphonedevelopertips.com/device/determine-if-iphone-is-3g-or-3gs-determine-if-ipod-is-first-or-second-generation.html
+ (NSString *) device {
	size_t size;
	
	// Set 'oldp' parameter to NULL to get the size of the data
	// returned so we can allocate appropriate amount of space
	sysctlbyname("hw.machine", NULL, &size, NULL, 0); 
	
	// Allocate the space to store name
	char *name = malloc(size);
	
	// Get the platform name
	sysctlbyname("hw.machine", name, &size, NULL, 0);
	
	// Place name into a string
	NSString *machine = @(name);
	
	// Done with this
	free(name);
	
	return machine;
}

+ (BOOL) isOSLessThanVersion:(NSString*)versionString {	
	NSString *currentVersion = [UIDevice currentDevice].systemVersion;
	NSComparisonResult result = [NSString compareVersions:currentVersion rightVersion:versionString];
	
	if (result == NSOrderedAscending) {
		//The current device is less than version 4.0
		return YES;
	}else {
		return NO;
	}
}

+ (BOOL) isOSGreaterThanVersion:(NSString*)versionString {	
	NSString *currentVersion = [UIDevice currentDevice].systemVersion;
	NSComparisonResult result = [NSString compareVersions:currentVersion rightVersion:versionString];
	
	if (result == NSOrderedAscending) {
		//The current device is less than version 4.0
		return NO;
	}else {
		return YES;
	}
}

+ (BOOL) isOSLessThanVersion3_2 {
	return [self isOSLessThanVersion:@"3.2"];
}

+ (BOOL) isOSLessThanVersion4 {	
	return [self isOSLessThanVersion:@"4.0"];
}

+ (BOOL) isOSGreaterThanVersion5 {	
	return [self isOSGreaterThanVersion:@"5.0"];
}

+ (BOOL) is3GDevice {
	NSString *device = [self device];
	if ([device isEqualToString:@"iPhone1,2"]) {
		return YES;
	} else {
		return NO;
	}	
}

+ (BOOL) isIPad {
	NSString *device = [self device];
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
        return YES;
    } else  {
        return NO;
    }
}

+ (BOOL) isIPadOriginal {
    static BOOL result = NO;
    static NSInteger determined = -1;
    if (determined < 0) {
        NSString *device = [self device];
        if ([device isEqualToString:@"iPad1,1"]) {
            result = YES;
        } else {
            result = NO;
        }
        determined = 1;
    }
	return result;
}

+ (UIDeviceOrientation) deviceOrientation {
	// The status bar is always showing in the correct orientation for the view being displayed so we rely on that
	// to tell us the devices current orientation
	return (UIDeviceOrientation) [[UIApplication sharedApplication] statusBarOrientation];
}


/*
 
 Pre ios 5
 Caches dir for caches - won't be backed up
 Documents dir for documents - will be backed up
 
 ios 5 (cloud introduction)
 Caches dir will be purged on low memeory
 if you want your cache to persist, put stuff in Documents - but this is backed up to iCloud and your app will be rejected
 
 ios 5.0.1
 Caches dir is still purged 
 Documents can store lots of stuff, and you can mark files as not being backed up to iCloud
 
 
 */

+ (NSString *) cachesDirectory {
    static NSString *cachesFolder = nil;
    if (!cachesFolder) {
        cachesFolder = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    } 
	return cachesFolder;
}

+ (NSString *) documentsDirectory {
    static NSString *documentsFolder = nil;
    if (!documentsFolder) {
        documentsFolder = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    }
	return documentsFolder;
}

+ (BOOL) isRetinaDevice {
    static BOOL isRetina = NO;
    static BOOL checked = NO;
    if (!checked) {
        if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
            ([UIScreen mainScreen].scale == 2.0)) {
            // Retina display
            isRetina = YES;
        } else {
            // non-Retina display
            isRetina = NO;
        }
        checked = YES;
    }
    return isRetina;
}


//+ (NSString *) dataFolder{
//    if ([UIDevice isOSGreaterOrEqualTo5_0_1]) {
//        return [self documentsFolder];
//    } else {
//        return [self cachesFolder];
//    }
//}

//+ (NSString *) dataPathForFile: (NSString *) file{
//    return [[self dataFolder] stringByAppendingPathComponent: file];
//}
//
//+ (NSString *) dataPathForFile: (NSString *) file inSubfolder: (NSString *) subfolderName{
//    return [[self dataPathForFile: subfolderName] stringByAppendingPathComponent: file];
//}


// - NEED TO SKIP BACKUPS - THIS GIVES AN ANNOYING COMPILER WARNING
//+ (void) addSkipBackupAttributeToFilePath: (NSString *) filePath{
//    u_int8_t b = 1;
//    setxattr([filePath fileSystemRepresentation], "com.apple.MobileBackup", &b, 1, 0, 0);
//}

@end

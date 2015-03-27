//
//  DUKeychain.m
//  DevedUp
//
//  Created by David Casserly on 21/06/2013.
//  Copyright 2011 DevedUp Ltd. All rights reserved.
//

#import "DUKeychain.h"
#import <Security/Security.h>
#import "DUFileLogger.h"

@implementation DUKeychain

+ (DUKeychain *) sharedKeyChain {
	static dispatch_once_t onceToken;
    static DUKeychain * __sharedManager = nil;
    
    dispatch_once(&onceToken, ^{
        __sharedManager = [[self alloc] init];
    });
    
    return __sharedManager;
}

- (void) setBool:(BOOL)boolean forKey:(NSString *)key {
	[self setString:[@(boolean) stringValue]  forKey:key];
}

- (void) setString:(NSString *)string forKey:(NSString *)key {
	NSAssert(key != nil, @"Invalid key");
	NSAssert(string != nil, @"Invalid string");
	
    if (!string || !key) {
        //Safeguard against crash
        return;
    }
    
    // Going to call remove first as we have changed the permissions of kSecAttrAccessible
    [self removeObjectForKey:key];
    
#ifdef DEBUG
    [[DUFileLoggerFactory fileLoggerForFile:@"Auth.log"] append:[NSString stringWithFormat:@"Setting credentials, Key: [%@] Value: [%@]", key, string]];
#endif
    
	NSMutableDictionary *query = [NSMutableDictionary dictionary];
	
	query[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
	query[(__bridge id)kSecAttrAccount] = key;
    // This allows you to access data even when phone is locked in the background (only after the device is unlocked after a reboot)
	query[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleAfterFirstUnlock;
	
	OSStatus error = SecItemCopyMatching((__bridge CFDictionaryRef)query, NULL);
	if (error == errSecSuccess) {
		// do update
		NSDictionary *attributesToUpdate = @{(__bridge id)kSecValueData: [string dataUsingEncoding:NSUTF8StringEncoding]};
		
		error = SecItemUpdate((__bridge CFDictionaryRef)query, (__bridge CFDictionaryRef)attributesToUpdate);
		NSAssert1((int)error == errSecSuccess, @"SecItemUpdate failed: %d", (int) error);
        if (error != errSecSuccess) {
            DULog(@"SecItemUpdate failed: %d", (int)error);
        }
	} else if (error == errSecItemNotFound) {
		// do add
		query[(__bridge id)kSecValueData] = [string dataUsingEncoding:NSUTF8StringEncoding];
		
		error = SecItemAdd((__bridge CFDictionaryRef)query, NULL);
		NSAssert1(error == errSecSuccess, @"SecItemAdd failed: %d", (int)error);
        if (error != errSecSuccess) {
            DULog(@"SecItemAdd failed: %d", (int)error);
        }
	} else {
		NSAssert1(NO, @"SecItemCopyMatching failed: %d", (int)error);
	}
}

- (BOOL) boolForKey:(NSString *)key {
	return [[self stringForKey:key] boolValue];
}

- (NSString *)stringForKey:(NSString *)key {
	NSAssert(key != nil, @"Invalid key");
	
    if (!key) {
        //Safeguard against crash
        return nil;
    }
    
	NSMutableDictionary *query = [NSMutableDictionary dictionary];

	query[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
	query[(__bridge id)kSecAttrAccount] = key;
	query[(__bridge id)kSecReturnData] = (__bridge id)kCFBooleanTrue;
    
	NSData *dataFromKeychain = nil;

	OSStatus error = SecItemCopyMatching((__bridge CFDictionaryRef)query, (void *)&dataFromKeychain);
	
	NSString *stringToReturn = nil;
	if (error == errSecSuccess) {
		stringToReturn = [[NSString alloc] initWithData:dataFromKeychain encoding:NSUTF8StringEncoding];
	}
	
#ifdef DEBUG
    [[DUFileLoggerFactory fileLoggerForFile:@"Auth.log"] append:[NSString stringWithFormat:@"Credentials returned, Key: [%@] Value: [%@]", key, stringToReturn]];
#endif
    
	return stringToReturn;
}

- (void) removeObjectForKey:(NSString *)key {
	NSAssert(key != nil, @"Invalid key");

	NSMutableDictionary *query = [NSMutableDictionary dictionary];
	
	query[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
	query[(__bridge id)kSecAttrAccount] = key;
		
	OSStatus status = SecItemDelete((__bridge CFDictionaryRef)query);
	if (status != errSecSuccess) {
		DULog(@"SecItemDelete failed: %d", (int)status);
	}
}

@end
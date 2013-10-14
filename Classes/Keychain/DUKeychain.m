//
//  DUKeychain.m
//  DevedUp
//
//  Created by David Casserly on 21/06/2013.
//  Copyright 2011 DevedUp Ltd. All rights reserved.
//

#import "DUKeychain.h"
#import <Security/Security.h>

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
    
	NSMutableDictionary *query = [NSMutableDictionary dictionary];
	
	[query setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
	[query setObject:key forKey:(__bridge id)kSecAttrAccount];
	[query setObject:(__bridge id)kSecAttrAccessibleWhenUnlocked forKey:(__bridge id)kSecAttrAccessible];
	
	OSStatus error = SecItemCopyMatching((__bridge CFDictionaryRef)query, NULL);
	if (error == errSecSuccess) {
		// do update
		NSDictionary *attributesToUpdate = [NSDictionary dictionaryWithObject:[string dataUsingEncoding:NSUTF8StringEncoding]
																	  forKey:(__bridge id)kSecValueData];
		
		error = SecItemUpdate((__bridge CFDictionaryRef)query, (__bridge CFDictionaryRef)attributesToUpdate);
		NSAssert1((int)error == errSecSuccess, @"SecItemUpdate failed: %d", (int) error);
        if (error != errSecSuccess) {
            DULog(@"SecItemUpdate failed: %d", (int)error);
        }
	} else if (error == errSecItemNotFound) {
		// do add
		[query setObject:[string dataUsingEncoding:NSUTF8StringEncoding] forKey:(__bridge id)kSecValueData];
		
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

	[query setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
	[query setObject:key forKey:(__bridge id)kSecAttrAccount];
	[query setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];

	NSData *dataFromKeychain = nil;

	OSStatus error = SecItemCopyMatching((__bridge CFDictionaryRef)query, (void *)&dataFromKeychain);
	
	NSString *stringToReturn = nil;
	if (error == errSecSuccess) {
		stringToReturn = [[NSString alloc] initWithData:dataFromKeychain encoding:NSUTF8StringEncoding];
	}
		
	return stringToReturn;
}

- (void) removeObjectForKey:(NSString *)key {
	NSAssert(key != nil, @"Invalid key");

	NSMutableDictionary *query = [NSMutableDictionary dictionary];
	
	[query setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
	[query setObject:key forKey:(__bridge id)kSecAttrAccount];
		
	OSStatus status = SecItemDelete((__bridge CFDictionaryRef)query);
	if (status != errSecSuccess) {
		DULog(@"SecItemDelete failed: %ld", status);
	}
}

@end
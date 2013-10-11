//
//  DUKeychain.h
//  DevedUp
//
//  Created by David Casserly on 21/06/2013.
//  Copyright 2011 DevedUp Ltd. All rights reserved.
//

@interface DUKeychain : NSObject

+ (DUKeychain *) sharedKeyChain;

#pragma mark - Setters

- (void) setString:(NSString *)string forKey:(NSString *)key;
- (void) setBool:(BOOL)boolean forKey:(NSString *)key;

#pragma mark - Getters

- (NSString *) stringForKey:(NSString *)key;
- (BOOL) boolForKey:(NSString *)key;

#pragma mark - Deleters

- (void) removeObjectForKey:(NSString *)key;

@end 
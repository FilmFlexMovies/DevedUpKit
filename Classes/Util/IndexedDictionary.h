//
//  IndexedDictionary.h
//  DevedUp
//
//  Created by David Casserly on 01/02/2012.
//  Copyright (c) 2012 DevedUp Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IndexedDictionary : NSObject 

- (void) setObject:(id)object forKey:(NSString *)key;
- (void) setObject:(id)object atIndex:(NSUInteger)idx;
- (void) insertObject:(id)object forKey:(NSString *)key atIndex:(NSUInteger)index;
- (id) objectAtIndex:(NSUInteger)index;
- (NSString *) keyAtIndex:(NSUInteger)index;
- (NSUInteger) count;
- (BOOL) containsKey:(NSString *)key;
- (void) moveObjectToIndexZero:(NSString *)key;
- (NSArray *) allKeys;
- (id) valueForKey:(NSString *)key;
- (NSArray *) allValues;

@end

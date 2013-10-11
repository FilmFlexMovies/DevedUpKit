//
//  Settings.h
//  DevedUp
//
//  Created by igmac0001 on 12/01/2010.
//  Copyright 2010 IGIndex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderedMutableDictionary : NSObject {

@private
	NSMutableArray *orderedKeys;
	NSMutableDictionary *dictionary;
}


@property (nonatomic, strong) NSMutableArray *orderedKeys;
@property (nonatomic, strong) NSMutableDictionary *dictionary;


- (id) init;
- (id) initWithCapacity:(NSUInteger)numItems;
- (id) initWithObjectsAndKeys:(id)firstObject, ... NS_REQUIRES_NIL_TERMINATION;

- (NSArray *) allKeys;
- (id) firstObject;
- (id) lastObject;
- (void) setObject:(id)anObject forKey:(id)aKey;
- (void) removeObjectForKey:(id)aKey;
- (NSUInteger) count;
- (id) objectForKey:(id)aKey;
- (NSInteger) indexOfKey:(id)aKey;

@end

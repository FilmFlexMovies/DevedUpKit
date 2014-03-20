//
//  IndexedDictionary.m
//  DevedUp
//
//  Created by David Casserly on 01/02/2012.
//  Copyright (c) 2012 DevedUp Ltd. All rights reserved.
//

#import "IndexedDictionary.h"

@interface IndexedDictionary () {
    NSMutableArray *keys;
    NSMutableArray *values;
}
@end

@implementation IndexedDictionary

- (void)dealloc {
     keys = nil;
     values = nil;
}

- (id)init {
    self = [super init];
    if (self) {
        keys = [NSMutableArray array];
        values = [NSMutableArray array];
    }
    return self;
}

- (NSString *) description {
    NSMutableString *desc = [[NSMutableString alloc] init];
    [desc appendString:keys.description];
    [desc appendString:values.description];
    return desc;
}

- (void) setObject:(id)object forKey:(NSString *)key {
    if (!object) {
        object = @"";
    }
    [keys addObject:key];
    [values addObject:object];
}

- (void) setObject:(id)object atIndex:(NSUInteger)idx {
    if (!object) {
        object = @"";
    }
    [values removeObjectAtIndex:idx];
    [values insertObject:object atIndex:idx];
}

- (void) insertObject:(id)object forKey:(NSString *)key atIndex:(NSUInteger)index {
    if (!object) {
        object = @"";
    }
    [keys insertObject:key atIndex:index];
    [values insertObject:object atIndex:index];
}

- (void) moveObjectToIndexZero:(NSString *)key {
    NSInteger index = [keys indexOfObject:key];
    [keys removeObjectAtIndex:index];        
    id value = [values objectAtIndex:index];
    [values removeObjectAtIndex:index];
    
    [values insertObject:value atIndex:0];
    [keys insertObject:key atIndex:0];
    
}

- (BOOL) containsKey:(NSString *)key {
    if ([keys containsObject:key]) {
        return YES;
    } else {
        return NO;
    }
}

- (id) valueForKey:(NSString *)key {
    if ([keys count] == 0) {
        return nil;
    }
    if ([keys containsObject:key]) {
        NSInteger index = [keys indexOfObject:key];
        return [values objectAtIndex:index];
    } else {
        return nil;
    }
}

- (id) objectAtIndex:(NSUInteger)index {
    return [values objectAtIndex:index];
}

- (NSString *) keyAtIndex:(NSUInteger)index {
    return [keys objectAtIndex:index];
}

- (NSUInteger) count {
    return [keys count];
}

- (NSArray *) allKeys {
    return [NSArray arrayWithArray:keys];
}

- (NSArray *) allValues {
    return [NSArray arrayWithArray:values];
}
@end

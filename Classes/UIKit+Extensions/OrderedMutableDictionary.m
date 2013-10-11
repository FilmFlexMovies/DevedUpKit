#import "OrderedMutableDictionary.h"


@implementation OrderedMutableDictionary

@synthesize orderedKeys;
@synthesize dictionary;


- (id) init {
	if (self = [super init]) {
		orderedKeys = [[NSMutableArray alloc] init];
		dictionary = [[NSMutableDictionary alloc] init];
	}
	
	return self;
}

- (id) initWithCapacity:(NSUInteger)numItems {
	if (self = [super init]) {
		orderedKeys = [[NSMutableArray alloc] initWithCapacity:numItems];
		dictionary = [[NSMutableDictionary alloc] initWithCapacity:numItems];
	}
	
	return self;
}

- (id) initWithObjectsAndKeys:(id)firstObject, ... {
	if (self = [super init]) {
		orderedKeys = [[NSMutableArray alloc] init];
		dictionary = [[NSMutableDictionary alloc] init];
		
		va_list args;
		va_start(args, firstObject);
		
		for (id obj = firstObject; obj != nil; obj = va_arg(args, id)) {
			id key = va_arg(args, id);
			
			[self setObject:obj forKey:key];
		}
		va_end(args);
	}
	
	return self;
}


- (NSArray *) allKeys {
	return [NSArray arrayWithArray:orderedKeys];
}

- (id) firstObject {
	if([orderedKeys count] == 0) return nil;
	return [dictionary objectForKey:[orderedKeys objectAtIndex:0]];
}

- (id) lastObject {
	if (0<[self count]) {
		return [dictionary objectForKey:[orderedKeys lastObject]];
	} else {
		return nil;
	}
}

- (void) setObject:(id)anObject forKey:(id)aKey {
	[dictionary setObject:anObject forKey:aKey];
	if (![orderedKeys containsObject:aKey]) {
		[orderedKeys addObject:[NSString stringWithString:aKey]];
	}
}

- (void) removeObjectForKey:(id)aKey {
	[dictionary removeObjectForKey:aKey];
	[orderedKeys removeObject:aKey];
}

- (NSUInteger) count {
	return [dictionary count];
}

- (id) objectForKey:(id)aKey {
	return [dictionary objectForKey:aKey];
}

- (NSInteger) indexOfKey:(id)aKey {
	return [orderedKeys indexOfObject:aKey];
}

@end

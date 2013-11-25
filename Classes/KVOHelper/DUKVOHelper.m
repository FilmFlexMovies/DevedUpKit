//
//  DUKVOHelper.m
//
//  Created by taylors on 24/01/2011.
//

#import "DUKVOHelper.h"
#import "NSString+Extensions.h"

@interface DUKVOHelper ()
- (SEL)handlerSelectorForKeyPath:(NSString*)keyPath;
@property (nonatomic,assign) SEL observerHandler;
@end

@implementation DUKVOHelper

@synthesize object = _object;
@synthesize observer = _observer;
@synthesize keyPath = _keyPath;
@synthesize observerHandler = _observerHandler;

- (id)initWithObserver:(id)observer forKeyPath:(NSString*)keyPath onObject:(id)object options:(NSKeyValueObservingOptions)options context:(void*)context {
	self = [super init];
	if (self){
		self.object = object;
		self.observer = observer;
		self.keyPath = keyPath;
		const SEL handler = [self handlerSelectorForKeyPath:keyPath];
		if ([observer respondsToSelector:handler]){
			self.observerHandler = handler;
			[self.object addObserver:self forKeyPath:self.keyPath options:options context:context];
		}
		else {
			[self.object addObserver:self.observer forKeyPath:self.keyPath options:options context:context];
		}
	}
	return self;
}

- (void) invalidate {
    if (self.observerHandler){
		[_object removeObserver:self forKeyPath:_keyPath];
	}
	else {
		[_object removeObserver:_observer forKeyPath:_keyPath];
	}
	// not releasing observer and object as they are assigned, not retained
}

- (SEL)handlerSelectorForKeyPath:(NSString*)keyPath {
	NSArray* paths = [keyPath componentsSeparatedByString:@"."];
	if ([paths count]){
		NSMutableString* processedKeyPath = [NSMutableString string];
		for (NSString* path in paths) {
			if (![processedKeyPath length]){
				[processedKeyPath appendString:[path camelCasedString]];
			}
			else {
				[processedKeyPath appendString:[path capitalisedCamelCasedString]];
			}
		}
		keyPath = processedKeyPath;
	}
	return NSSelectorFromString([NSString stringWithFormat:@"object:%@DidChange:",[keyPath camelCasedString]]);
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.object) {
		
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
		[self.observer performSelector:self.observerHandler withObject:object withObject:change];
#pragma clang diagnostic pop
		
	}
	else {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}

+ (id)addObserver:(id)observer forKeyPath:(NSString*)keyPath onObject:(id)object {
	return [[DUKVOHelper alloc] initWithObserver:observer forKeyPath:keyPath onObject:object options:NSKeyValueObservingOptionNew context:nil];
}

+ (id)addObserver:(id)observer forKeyPath:(NSString*)keyPath onObject:(id)object options:(NSKeyValueObservingOptions)options context:(void*)context {
	return [[DUKVOHelper alloc] initWithObserver:observer forKeyPath:keyPath onObject:object options:options context:context];
}

+ (NSSet*)addObserver:(id)observer forKeyPaths:(NSArray*)keyPaths onObject:(id)object {
	NSMutableArray* helpers = [NSMutableArray arrayWithCapacity:[keyPaths count]];
	for (NSString* keyPath in keyPaths) {
		[helpers addObject:[[self class] addObserver:observer forKeyPath:keyPath onObject:object options:NSKeyValueObservingOptionNew context:nil]];
	}
	return [NSSet setWithArray:helpers];
}

+ (NSSet*)addObserver:(id)observer forKeyPaths:(NSArray*)keyPaths onObject:(id)object options:(NSKeyValueObservingOptions)options context:(void*)context {
	NSMutableArray* helpers = [NSMutableArray arrayWithCapacity:[keyPaths count]];
	for (NSString* keyPath in keyPaths) {
		[helpers addObject:[[self class] addObserver:observer forKeyPath:keyPath onObject:object options:options context:context]];
	}
	return [NSSet setWithArray:helpers];
}

- (NSString*) description {
	return [NSString stringWithFormat:@"KVOHelper - observing %@ for %@",_keyPath,_observer];
}

@end

@implementation NSObject (DUKVOHelper)

- (id)igObserveKeyPath:(NSString*)keyPath onObject:(id)object {
    return [DUKVOHelper addObserver:self forKeyPath:keyPath onObject:object];
}

- (id)igObserveKeyPaths:(NSArray*)keyPaths onObject:(id)object {
    return [DUKVOHelper addObserver:self forKeyPaths:keyPaths onObject:object];
}

@end

@interface DUKVOHelperSet ()
@property (nonatomic,strong) NSMutableSet* helpers;
@end

@implementation DUKVOHelperSet

@synthesize helpers = _helpers;

- (id)init {
    self = [super init];
    if (self) {
        _helpers = [[NSMutableSet alloc] initWithCapacity:5];
    }
    return self;
}


- (void)addHelper:(DUKVOHelper*)helper {
    @synchronized(_helpers) {
        if (![self.helpers containsObject:helper]) {
            [self.helpers addObject:helper];
        }
    }
}

- (void)addHelpers:(NSSet*)helpers {
    @synchronized(_helpers) {
        [self.helpers unionSet:helpers];
    }
}

- (void)removeHelper:(DUKVOHelper*)helper {
    @synchronized(_helpers) {
        [self.helpers removeObject:helper];
    }
}

- (void)removeHelpers:(NSSet*)helpers {
    @synchronized(_helpers) {
        [self.helpers minusSet:helpers];
    }
}

- (void)removeObservedObject:(id)object {
    @synchronized(_helpers) {
        NSMutableSet* helpers = [NSMutableSet setWithCapacity:[self.helpers count]];
        for (DUKVOHelper* helper in self.helpers) {
            if (helper.object == object){
                [helpers addObject:helper];
            }
        }
        if ([helpers count]){
            [self removeHelpers:helpers];
        }
    }
}

- (void)invalidateHelpers {
    @synchronized(_helpers) {
        for (DUKVOHelper* helper in self.helpers) {
            [helper invalidate];
        }
        [self.helpers removeAllObjects];
    }
}

@end

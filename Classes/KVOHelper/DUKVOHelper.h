//
//  DUKVOHelper.h
//
//  Created by taylors on 24/01/2011.
//
//  Removing an observer from an object more than once results in an exception
//  and since we may well want to do this in a view controller's -viewDidUnload
//  and -dealloc methods this can be a problem. So, rather than add another flag
//  along the lines of _observingFoo to the observing object, just wrap the KVO
//  mechanism in a helper object that we can safely release in both places and
//  only unregister once.
//
//  This class also provides a mechanism for supporting convenient key path-specific
//  callbacks on the observer. For instance, if the observer wants to observe the 
//  key path 'status', it can implement a method called -object:statusDidChange: and
//  that will be called in preference to the usual -(void)observeValueForKeyPath:etc
//
//  This can avoid the need for overly verbose implementations of the standard callback
//  which are normally required when observing multiple key paths on multiple objects.
//
//  The key path-specific method is passed the object that posted the KVO notification
//  and the change dictionary, the full prototype being:
//
//  - (void)object:(id)object <key path>DidChange:(NSDictionary*)change
//

#import <Foundation/Foundation.h>

@interface DUKVOHelper : NSObject {
	id __weak _object;
	id __weak _observer;
	NSString* _keyPath;
	SEL _observerHandler;
}

@property (nonatomic,weak) id object;			// Note: assign, not retain so that we don't cause retain loops
@property (nonatomic,weak) id observer;		// Note: assign, not retain so that we don't cause retain loops
@property (nonatomic,copy) NSString* keyPath;

+ (id)addObserver:(id)observer forKeyPath:(NSString*)keyPath onObject:(id)object; // options == NSKeyValueObservingOptionNew, context = nil

+ (id)addObserver:(id)observer forKeyPath:(NSString*)keyPath onObject:(id)object options:(NSKeyValueObservingOptions)options context:(void*)context;

+ (NSSet*)addObserver:(id)observer forKeyPaths:(NSArray*)keyPaths onObject:(id)object; // options == NSKeyValueObservingOptionNew, context = nil

+ (NSSet*)addObserver:(id)observer forKeyPaths:(NSArray*)keyPaths onObject:(id)object options:(NSKeyValueObservingOptions)options context:(void*)context;

- (void) invalidate;

@end

@interface NSObject (DUKVOHelper)

- (id)igObserveKeyPath:(NSString*)keyPath onObject:(id)object;
- (id)igObserveKeyPaths:(NSArray*)keyPaths onObject:(id)object;

@end

@interface DUKVOHelperSet : NSObject {
    NSMutableSet* _helpers;
}
- (void)addHelper:(DUKVOHelper*)helper;
- (void)addHelpers:(NSSet*)helpers;
- (void)removeHelper:(DUKVOHelper*)helper;
- (void)removeHelpers:(NSSet*)helpers;
- (void)removeObservedObject:(id)object;
- (void)invalidateHelpers;

@end

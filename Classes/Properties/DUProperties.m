//
//  DUProperties.m
//  DevedUp
//
//  Created by David Casserly on 01/02/2009.
//  Copyright 2010 devedup.com. All rights reserved.
//

#import "DUProperties.h"

NSString * const PropertyFlurryKey = @"FlurryKey";
NSString * const PropertyFlurryKeyDEBUG = @"FlurryKeyDev";
NSString * const PropertyReachabilityDomain = @"ReachabilityDomain";
NSString * const PropertyCoreDataFile = @"CoreDataFile";
NSString * const PropertyCrittercismAppID = @"CrittercismAppID";
NSString * const PropertyTestFlightAppID = @"TestFlightAppID";
NSString * const PropertyAppID = @"AppID";
NSString * const PropertyFlickrKey = @"FlickrKey";
NSString * const PropertyFlickrSecret = @"FlickrSecret";
NSString * const PropertyFlickrAuthCallback = @"FlickrAuthCallback";
NSString * const PropertyCrashlyticsID = @"CrashlyticsID";
NSString * const PropertyEnvironment = @"Environment";

@interface DUProperties ()
@property (nonatomic, retain) NSDictionary *properties;
@end

@implementation DUProperties


+ (DUProperties *) sharedInstance {
    static DUProperties * _sharedInstance = nil;    
    if (!_sharedInstance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _sharedInstance = [[DUProperties alloc] init];
        });
    }    
    return _sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        [self loadProperties];
    }
    return self;
}

- (void) loadProperties {
	// Default Properties
	NSString *defaultPropsPath = [[NSBundle mainBundle] pathForResource:@"properties" ofType:@"plist"];	
	if (![[NSFileManager defaultManager] fileExistsAtPath:defaultPropsPath]) {
		@throw [NSException exceptionWithName:@"File not found" reason:@"File properties.plist not found" userInfo:nil];
	}
	
	self.properties = [[NSDictionary alloc] initWithContentsOfFile:defaultPropsPath];
}

- (NSString *) getProperty:(NSString *) key {
	NSString *name = [self.properties valueForKey:key];
	return name;
}

@end

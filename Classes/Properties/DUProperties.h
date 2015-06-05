//
//  DUProperties.h
//  DevedUp
//
//  Created by David Casserly on 01/02/2009.
//  Copyright 2010 devedup.com. All rights reserved.
//

extern NSString * const PropertyFlurryKey;
extern NSString * const PropertyFlurryKeyDEBUG;
extern NSString * const PropertyReachabilityDomain;
extern NSString * const PropertyCoreDataFile;
extern NSString * const PropertyCrittercismAppID;
extern NSString * const PropertyTestFlightAppID;
extern NSString * const PropertyAppID;
extern NSString * const PropertyFlickrKey;
extern NSString * const PropertyFlickrSecret;
extern NSString * const PropertyFlickrAuthCallback;
extern NSString * const PropertyCrashlyticsID;
extern NSString * const PropertyFlickrAuthCallback;
extern NSString * const PropertyEnvironment;
extern NSString * const PropertyTsAndCsURL;
extern NSString * const PropertyBuildDate;

@interface DUProperties : NSObject 

+ (DUProperties *) sharedInstance;

- (NSString *) getProperty:(NSString *)key;

@end

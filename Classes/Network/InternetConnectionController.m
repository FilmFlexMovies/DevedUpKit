//
//  InternetConnectionController.m
//  InternetConnectivity
//
//  Created by David Casserly on 30/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InternetConnectionController.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "Reachability.h"
#import "DUProperties.h"
#import "UIAlertView+Extensions.h"
#import "DULocalisation.h"

NSString * const NoInternetConnectionNotification = @"NoInternetConnectionNotification";
NSString * const InternetConnectionActiveNotification = @"InternetConnectionActiveNotification";

@interface InternetConnectionController () 
@property (nonatomic, strong) Reachability *internetReachable;
@property (nonatomic, strong) Reachability *localWifiReachable;
@property (nonatomic, retain) Reachability *hostReachable; //broken in iOS 5
@end

@implementation InternetConnectionController

+ (InternetConnectionController *) sharedInstance {
    static InternetConnectionController * _sharedInstance = nil;    
    if (!_sharedInstance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _sharedInstance = [[InternetConnectionController alloc] init];
        });
    }    
    return _sharedInstance;
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id) init  {
    self = [super init];
	if (self) {                
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBecameActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
        [self startListener];
	}
	return self;
}

/*
 Connectivity testing code pulled from Apple's Reachability Example: http://developer.apple.com/library/ios/#samplecode/Reachability
 */
- (BOOL) isConnected {
	struct sockaddr_in zeroAddress;
	bzero(&zeroAddress, sizeof(zeroAddress));
	zeroAddress.sin_len = sizeof(zeroAddress);
	zeroAddress.sin_family = AF_INET;
	
	SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)&zeroAddress);
	if(reachability != NULL) {
		//NetworkStatus retVal = NotReachable;
		SCNetworkReachabilityFlags flags;
		
		if (SCNetworkReachabilityGetFlags(reachability, &flags)) {
			
			BOOL isConnected = NO;
			
			if (0 == (flags & kSCNetworkReachabilityFlagsReachable)) {
				// if target host is not reachable
				isConnected = NO;
			} else if (0 == (flags & kSCNetworkReachabilityFlagsConnectionRequired)) {
				// if target host is reachable and no connection is required
				//  then we'll assume (for now) that your on Wi-Fi
				isConnected = YES;
			} else if ( (0 != (flags & kSCNetworkReachabilityFlagsConnectionOnDemand) ) ||
					   (0 != (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) ) ) {
				// ... and the connection is on-demand (or on-traffic) if the
				//     calling application is using the CFSocketStream or higher APIs
				
				if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0) {
					// ... and no [user] intervention is needed
					isConnected = YES;
				}
			} else if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN) {
				// ... but WWAN connections are OK if the calling application
				//     is using the CFNetwork (CFSocketStream?) APIs.
				isConnected = YES;
			}
			
			CFRelease(reachability);
			return isConnected;
		}
		
	}
	return NO;
}

- (BOOL) isConnected_old {
	BOOL connected = [self isConnectedToNetwork];
	BOOL wifiAvail = [self isWorkingWifiAvailable];
	BOOL hostReachable = [self isHostReachable];
	return connected && wifiAvail && hostReachable;
}

- (BOOL) isConnectedToNetwork {
    BOOL internetActive = NO;
    
    // called after network status changes
    NetworkStatus internetStatus = [self.internetReachable currentReachabilityStatus]; //[Reachability reachabilityForInternetConnection].currentReachabilityStatus;  
    switch (internetStatus) {
        case NotReachable: {
            //DULog(@"The internet is down!");
            internetActive = NO;            
            break;
        }
        case ReachableViaWiFi:{
            //DULog(@"The internet is working via WIFI.");
            internetActive = YES;            
            break;
        }
        case ReachableViaWWAN:{
            //DULog(@"The internet is working via WWAN.");
            internetActive = YES;            
            break;
        }
    }

    return internetActive;
}

- (BOOL) isWorkingWifiAvailable {
    BOOL hostActive = NO;
    NetworkStatus hostStatus = [self.localWifiReachable currentReachabilityStatus];
    switch (hostStatus) {
        case NotReachable:{
            //DULog(@"A gateway to the host server is down.");
            hostActive = NO;            
            break;
        }
        case ReachableViaWiFi:  {
            //DULog(@"A gateway to the host server is working via WIFI.");
            hostActive = YES;            
            break;
        }
        case ReachableViaWWAN:{
            //DULog(@"A gateway to the host server is working via WWAN.");
            hostActive = YES;            
            break;
        }
    }
    
    return hostActive;
}

- (BOOL) isHostReachable {
	NetworkStatus hostStatus = [Reachability reachabilityWithHostName:@"www.flickr.com"].currentReachabilityStatus;
	if (hostStatus == NotReachable) {
		return NO;
	} else {
		return YES;
	}
}

- (void) reachabilityChanged:(NSNotification *)notification {   
    if ([self isConnected]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:InternetConnectionActiveNotification object:nil];        
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:NoInternetConnectionNotification object:nil];
    }    
}



- (void) initializeNetworkReachability {
    //Listen for network state changes
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    //Reach for the internet
    self.internetReachable = [Reachability reachabilityForInternetConnection];
    [self.internetReachable startNotifier];
    
    //Reach for the host
    NSString *domain = [[DUProperties sharedInstance] getProperty:PropertyReachabilityDomain];
    self.hostReachable = [Reachability reachabilityWithHostName:domain] ;
    [self.hostReachable startNotifier];
    
    //Reach for local wifi
    self.localWifiReachable = [Reachability reachabilityForLocalWiFi];
    [self.localWifiReachable stopNotifier];
    
    [self reachabilityChanged:nil];
}

- (void) startListener {
    static BOOL started = NO;
    if (!started) {
        [self initializeNetworkReachability];
        started = YES;
    }
    
}

- (void) appBecameActive:(NSNotification *)notification {
    
}



/* 
 Connectivity testing code pulled from Apple's Reachability Example: http://developer.apple.com/library/ios/#samplecode/Reachability
 */
//+(BOOL)hasConnectivity {
//    struct sockaddr_in zeroAddress;
//    bzero(&zeroAddress, sizeof(zeroAddress));
//    zeroAddress.sin_len = sizeof(zeroAddress);
//    zeroAddress.sin_family = AF_INET;
//    
//    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)&zeroAddress);
//    if(reachability != NULL) {
//        //NetworkStatus retVal = NotReachable;
//        SCNetworkReachabilityFlags flags;
//        if (SCNetworkReachabilityGetFlags(reachability, &flags)) {
//            if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)
//            {
//                // if target host is not reachable
//                return NO;
//            }
//            
//            if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0)
//            {
//                // if target host is reachable and no connection is required
//                //  then we'll assume (for now) that your on Wi-Fi
//                return YES;
//            }
//            
//            
//            if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
//                 (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0))
//            {
//                // ... and the connection is on-demand (or on-traffic) if the
//                //     calling application is using the CFSocketStream or higher APIs
//                
//                if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0)
//                {
//                    // ... and no [user] intervention is needed
//                    return YES;
//                }
//            }
//            
//            if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)
//            {
//                // ... but WWAN connections are OK if the calling application
//                //     is using the CFNetwork (CFSocketStream?) APIs.
//                return YES;
//            }
//        }
//    }
//    
//    return NO;
//}

@end
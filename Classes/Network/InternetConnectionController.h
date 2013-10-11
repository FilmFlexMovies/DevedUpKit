//
//  InternetConnectionController.h
//  InternetConnectivity
//
//  Created by David Casserly on 30/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

extern NSString * const NoInternetConnectionNotification;
extern NSString * const InternetConnectionActiveNotification;

@interface InternetConnectionController : NSObject

@property (nonatomic, readonly) BOOL isConnected;
//@property (nonatomic, readonly) BOOL isWorkingWifiAvailable;


+ (InternetConnectionController *) sharedInstance;

//- (BOOL) willShowAlertForNoNetworkConnection;

@end
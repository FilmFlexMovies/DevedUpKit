//
//  DUNetworkController.h
//
//  Created by Casserly on 24/04/2013.
//

extern NSString * const kNetworkConnectionCountNotification;

typedef void(^asyncCompletionBlock)(BOOL success, id result, NSError *error);

typedef enum {
	HTTPMethodGET = 0,
	HTTPMethodPOST,
	HTTPMethodPUT,
	HTTPMethodDELETE
} HTTPMethod;

@class DUNetworkRequestOperation;

@interface DUNetworkController : NSObject

+ (DUNetworkController *) sharedController;

- (void) execute:(NSOperation *)operation;


@end

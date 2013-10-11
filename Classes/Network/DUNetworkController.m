//
//  DUNetworkController.m
//
//  Created by Casserly on 24/04/2013.
//

#import "DUNetworkController.h"
#import "DUNetworkRequestOperation.h"
#import "DUNetworkAuthenticatorFactory.h"

NSString * const kNetworkConnectionCountNotification = @"kNetworkConnectionCountNotification";

@interface DUNetworkController ()
@property (nonatomic, retain) NSOperationQueue *operationQueue;
@end

@implementation DUNetworkController

+ (DUNetworkController *) sharedController {
	static dispatch_once_t onceToken;
	static DUNetworkController *sharedManager = nil;
	
	dispatch_once(&onceToken, ^{
		sharedManager = [[self alloc] init];
	});
	
	return sharedManager;
}

- (id) init {
    self = [super init];
    if (self) {
        self.operationQueue = [[NSOperationQueue alloc] init];
    }
    return self;
}

- (void) execute:(NSOperation *)operation {
    [self.operationQueue addOperation:operation];
}


@end

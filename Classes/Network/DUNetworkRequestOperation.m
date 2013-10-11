//
//  FFXNetworkRequest.m
//
//  Created by Casserly on 19/04/2013.
//

#import "DUNetworkRequestOperation.h"
#import "UIDevice+Extensions.h"
#import "DUBlocks.h"
#import "DUNetworkAuthenticatorFactory.h"

//#ifdef DEBUG
//static NSUInteger dataDownloadedSize;
//#endif
static int __connectionCount = 0;

const NSInteger kTimeOut = 60;

@interface DUNetworkRequestOperation ()
@property (nonatomic, copy) asyncCompletionBlock completion;
@property (nonatomic, retain) NSURLConnection *httpConnection;
@property (nonatomic, retain) NSMutableData *receivedData;
@property (nonatomic, retain) NSURL *url;
@property (nonatomic, retain) NSMutableURLRequest *request;
@property (nonatomic, retain) NSHTTPURLResponse *response;
@property (nonatomic, assign) HTTPMethod method;
@property (nonatomic, assign) BOOL authenticate;
@property (nonatomic, retain) NSData *body;
@property (nonatomic, retain) NSDictionary *headers;
@end

@implementation DUNetworkRequestOperation

#pragma mark - Semaphore

static dispatch_semaphore_t sema = nil;

+ (void) createActivitySemaphore {
    if (!sema) {
        //The idea is that when the semaphore value is less than 0, it blocks and waits for a notify
        sema = dispatch_semaphore_create(0);
    }
}

+ (void) releaseActivitySemaphore {
    //dispatch_release(sema);
    sema = nil;
}

void waitForNotification_network() {
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}

void notifyToContinue_network() {
    dispatch_semaphore_signal(sema);
}

#pragma mark - Connection Count and Network activity indicator

void decrementConnectionCount() {
	waitForNotification_network();
    __connectionCount--;
    //(@"network connection count %i", __connectionCount);
    if (__connectionCount == 0) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
#ifdef DEBUG
    [[NSNotificationCenter defaultCenter] postNotificationName:kNetworkConnectionCountNotification object:@(__connectionCount) userInfo:nil];
#endif
	notifyToContinue_network();
}

void incrementConnectionCount() {
	waitForNotification_network();
    static int totalConnectionsMade = 0;
    totalConnectionsMade++;
    __connectionCount++;
    //(@"network connection count %i", __connectionCount);
    if (__connectionCount > 0) {
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	}
#ifdef DEBUG
    NSLog(@"Total Connections Made: %i", totalConnectionsMade);
    [[NSNotificationCenter defaultCenter] postNotificationName:kNetworkConnectionCountNotification object:@(__connectionCount) userInfo:nil];
#endif
	notifyToContinue_network();
}


+ (void) initialize {
	if (self == [DUNetworkRequestOperation class]) {
        [DUNetworkRequestOperation createActivitySemaphore];
		notifyToContinue_network();
    }	
}

//Default constructor
- (id) initWithURL:(NSURL *)url method:(HTTPMethod)method auth:(BOOL)auth body:(NSData *)body headers:(NSDictionary *)headers completion:(asyncCompletionBlock)completion {
    self = [super init];
    if (self) {
        self.completion = completion;
        self.url = url;
        self.method = method;
        self.authenticate = auth;
        self.body = body;
        self.headers = headers;
    }
    return self;
}

- (id) initWithURL:(NSURL *)url method:(HTTPMethod)method auth:(BOOL)auth body:(NSData *)body completion:(asyncCompletionBlock)completion {
    return [self initWithURL:url method:method auth:auth body:body headers:nil completion:completion];
}

- (id) initWithURL:(NSURL *)url method:(HTTPMethod)method auth:(BOOL)auth completion:(asyncCompletionBlock)completion {
    return [self initWithURL:url method:method auth:auth body:nil headers:nil completion:completion];
}

#pragma mark - Network Thread

+ (void) networkRequestThreadEntryPoint:(id)object {
    do {
        @autoreleasepool {
            [[NSThread currentThread] setName:@"FFXNetworkingThread"];
            [[NSRunLoop currentRunLoop] run];
        }
    } while (YES);
}

+ (NSThread *) networkRequestThread {
    static NSThread *_networkRequestThread = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _networkRequestThread = [[NSThread alloc] initWithTarget:self selector:@selector(networkRequestThreadEntryPoint:) object:nil];
        [_networkRequestThread start];
    });
    
    return _networkRequestThread;
}

#pragma mark - Cancelling

- (void) cancel {
	self.completion = nil;
    [self.httpConnection cancel];
	[super cancel];
}

#pragma mark - NSOperation Methods

- (void) start {
	//Show Progress
    incrementConnectionCount();
	
	if (self.isCancelled) {
        // Must move the operation to the finished state if it is canceled.
        [self finish];
        return;
    }
	
    [super start];
    
//    if (![[Reachability reachabilityForInternetConnection] isReachable]) {
//        if (self.completion) {
//            self.completion(NO, nil, nil);
//        }
//        [self finish];
//        return;
//	}
    
    //Need to start this on the networking thread because we create a NSURLConnection, and we would lose
    //the delegate callbacks because the thread would die. Alternatively, we could create a network thread.
    executeBlockOnThread([DUNetworkRequestOperation networkRequestThread], ^{
        
        self.request = [self createRequest];
        
		//Authenticate
        if (self.authenticate) {
			if (!self.authenticator) {
				self.authenticator = [DUNetworkAuthenticatorFactory defaultAuthenticator];
			}
            [self.authenticator authenticationHeaderForURLRequest:self.request];
        }
        
        self.receivedData = [NSMutableData data];
        
        self.httpConnection = [[NSURLConnection alloc] initWithRequest:self.request
                                                               delegate:self
                                                       startImmediately:NO];
        
        [self.httpConnection scheduleInRunLoop:[NSRunLoop currentRunLoop]
                                       forMode:NSRunLoopCommonModes];
        [self.httpConnection start];
        
    });
}

- (void) finish {
	decrementConnectionCount();
    self.completion = nil;
    self.httpConnection = nil;
    self.receivedData = nil;    
    [super finish];
}

#pragma mark - Build the request

- (NSMutableURLRequest *) createRequest {
    //Create Request
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.url];
	request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    request.timeoutInterval = kTimeOut;
    
    //HTTP Method
    switch (self.method) {
        case HTTPMethodGET:
            request.HTTPMethod = @"GET";
            break;
        case HTTPMethodPOST:
            request.HTTPMethod = @"POST";
            break;
        case HTTPMethodPUT:
            request.HTTPMethod = @"PUT";
            break;
        case HTTPMethodDELETE:
            request.HTTPMethod = @"DELETE";
            break;
        default:
            break;
    }
    
    //Headers
	for (NSString *key in [self.headers allKeys]) {
		[request setValue:[self.headers objectForKey:key] forHTTPHeaderField:key];
	}
    
    //Add Body
    if (self.body) {
        [request setHTTPBody:self.body];
    }
    
    return request;
}

#pragma mark - NSURLConnection Delegate methods

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.receivedData appendData:data];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if (self.completion) {
		self.completion(NO, nil, error);
    }
    [self finish];
}

- (NSURLRequest *) connection:(NSURLConnection *)connection
              willSendRequest:(NSURLRequest *)request
             redirectResponse:(NSURLResponse *)redirectResponse {
    return request;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse.
    
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    
    // receivedData is an instance variable declared elsewhere.
    [self.receivedData setLength:0];
    self.response = (NSHTTPURLResponse *) response;
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		[self processResponse];
	});    
}

#pragma mark - Process Response


- (void) processResponse {
	if (self.isCancelled) {
		[self finish];
		return;
	}

//#ifdef DEBUG
//	static NSMutableArray *failedURLs = nil;
//	if (!failedURLs) {
//		failedURLs = [[NSMutableArray alloc] init];	
//	}	
//	dataDownloadedSize += [self.receivedData length];
//	DLog(@"Data downloaded: %i", dataDownloadedSize);
//#endif
	
	if (self.completion) {
		self.completion(YES, self.receivedData, nil);
		[self finish];
	}
}

@end

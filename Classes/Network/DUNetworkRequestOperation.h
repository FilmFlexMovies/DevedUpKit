//
//  DUNetworkRequest.h
//
//  Created by Casserly on 19/04/2013.
//

#import "DUConcurrentOperation.h"
#import "DUNetworkController.h"

@protocol DUNetworkAuthenticator;

typedef void(^NetworkCompletionBlock)(BOOL success, id result, NSError *error);

/*
    Usage notes:
 
    When you create one of these and add it to an NSOperationQueue it will execute on a custom Thread, DUNetworkingThread
    which lives the life of the app.
 
    Responses from the network also come back on this DUNetworkingThread, not the main thread, so the completion block will NOT
    be run on the main thread. If you want it on the main thread, then dispatch it onto there when you need to.
 
 */
@interface DUNetworkRequestOperation : DUConcurrentOperation <NSURLConnectionDelegate>


/*
 You can set this to a custom authenticator, otherwise it used the default authenticator.
 */
@property (nonatomic, retain) id<DUNetworkAuthenticator> authenticator;

//Init without headers or body
- (id) initWithURL:(NSURL *)url method:(HTTPMethod)method auth:(BOOL)auth completion:(NetworkCompletionBlock)completion;

//Init with body, without headers
- (id) initWithURL:(NSURL *)url method:(HTTPMethod)method auth:(BOOL)auth body:(NSData *)body completion:(NetworkCompletionBlock)completion;

//Init with headers and body
- (id) initWithURL:(NSURL *)url method:(HTTPMethod)method auth:(BOOL)auth body:(NSData *)body headers:(NSDictionary *)headers completion:(NetworkCompletionBlock)completion;

@end

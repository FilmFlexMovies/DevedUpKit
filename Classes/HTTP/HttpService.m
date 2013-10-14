//
//  HttpService.m
//  iDeal
//
//  Created by David Casserly on 15/03/2010.
//  Copyright 2010 IGIndex.com. All rights reserved.
//
// http://developer.apple.com/mac/library/documentation/cocoa/Conceptual/URLLoadingSystem/Tasks/UsingNSURLConnection.html
//

#import <Foundation/Foundation.h>
#import "HttpService.h"
#import "DUProperties.h"
#import "Reachability.h"

static float sPostTimeout = 60.0; //This is updated in initialize 

NSString *const NSHTTPPropertyStatusCodeKey=@"HTTPPropertyStatusCode";

/**
 *
 */
@interface HttpService ()

-(void)httpRequestToUrlWithBodyAndRequestType:(NSString*)url requestBody:(NSString*)requestBody requestType:(NSString*)requestType withHeaders:(NSDictionary *)headers; 

@property (nonatomic,strong) NSURLConnection* theConnection;
@property (nonatomic,strong) NSMutableData* receivedData;
@property (nonatomic,strong) NSError* connectionError;

@end


/**
 *
 */
@implementation HttpService

@synthesize delegate, theConnection, receivedData, connectionError;

#pragma mark -
#pragma mark Release


- (void) cancelTheConnection {
	if (theConnection) {
		[theConnection cancel];
		self.theConnection = nil;
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	}
}

#pragma mark -
#pragma mark Init

- (id) initWithDelegate:(id<HttpServiceDelegate>)_delegate {
	if ((![_delegate conformsToProtocol:@protocol(HttpServiceDelegate)])) {
		@throw [NSException exceptionWithName:@"Invalid Delegate" reason:@"Delegate does not conform to HttpServiceDelegate:" userInfo:nil];
		return nil;
	}
	
	if ((self = [super init])) {
		delegate = _delegate;
	}
	return self;
}

#pragma mark -
#pragma mark Logging


- (void) logTheRequest:(NSMutableURLRequest *)urlRequest {
#ifdef DEBUG   
		NSMutableString *requestLog = [[NSMutableString alloc] init];
		
		//Log the request
		[requestLog appendFormat:@"%@", @"\n\n>>>>>>>>>> START OF REQUEST >>>>>>>>>>\n"];
		
		//Log URL
		NSString *url = [[urlRequest URL] absoluteString];		
		[requestLog appendFormat:@"%@ %@", [urlRequest HTTPMethod], url];
		
		//Log the body
		NSData *theBodyData = [urlRequest HTTPBody];
		NSString *theBody = [[NSString alloc] initWithData:theBodyData encoding:NSUTF8StringEncoding];
		[requestLog appendFormat:@"\nBody:\n%@", theBody];
		
		//Log the Headers
		NSDictionary *allHeaders = [urlRequest allHTTPHeaderFields];
		[requestLog appendFormat:@"\nHeaders:\n%@", allHeaders];
		
		[requestLog appendFormat:@"\n>>>>>>>>>> END OF REQUEST >>>>>>>>>>\n\n"];
		DULog(@"%@", requestLog);
#endif
}

- (void) logTheResponse:(NSURLResponse *)urlResponse {
#ifdef DEBUG
        NSHTTPURLResponse *httpUrlResponse = (NSHTTPURLResponse *)urlResponse;
		NSMutableString *requestLog = [[NSMutableString alloc] init];
		
		//Log the request
		[requestLog appendFormat:@"%@", @"\n\n<<<<<<<<<< START OF RESPONSE <<<<<<<<<<\n"];
		
		//Log URL
		NSString *url = [[httpUrlResponse URL] absoluteString];		
		[requestLog appendFormat:@"Response from: %@", url];
		
		
		//Log the Headers
		NSDictionary *allHeaders = [httpUrlResponse allHeaderFields];
		[requestLog appendFormat:@"\nHeaders:\n%@", allHeaders];
		
		[requestLog appendFormat:@"\n<<<<<<<<<< END OF RESPONSE <<<<<<<<<<\n\n"];
		DULog(@"%@", requestLog);
#endif
}

#pragma mark -
#pragma mark Http Request Methods


- (void) httpPOSTRequest:(NSString *)body toUrl:(NSString *)url {
	[self httpRequestToUrlWithBodyAndRequestType:url requestBody:body requestType:@"POST" withHeaders:nil];
}

- (void) httpPUTRequest:(NSString*)body toUrl:(NSString*)url {
	[self httpRequestToUrlWithBodyAndRequestType:url requestBody:body requestType:@"PUT" withHeaders:nil];
}

- (void) httpDELETERequest:(NSString*)body toUrl:(NSString*)url {
	[self httpRequestToUrlWithBodyAndRequestType:url requestBody:body requestType:@"DELETE" withHeaders:nil];
}

- (void) httpGETRequest:(NSString *)url withHeaders:(NSDictionary *) headers {
	//[self doHttpGETRequest:(NSString *)url withHeaders:headers];
	[self httpRequestToUrlWithBodyAndRequestType:url requestBody:nil requestType:@"GET" withHeaders:headers];
}	


- (void) httpGETRequest:(NSString *)url {
	[self httpRequestToUrlWithBodyAndRequestType:url requestBody:nil requestType:@"GET" withHeaders:nil];
	//[self doHttpGETRequest:(NSString *)url withHeaders:nil];
}


//PRIVATE METHOD -- ALL CONNECTIONS SHOULD GO THROUGH HERE
- (void) httpRequestToUrlWithBodyAndRequestType:(NSString *)url requestBody:(NSString *)requestBody requestType:(NSString *)requestType withHeaders:(NSDictionary *)headers{
	
	NSString *urlEncoded = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlEncoded]
															  cachePolicy:NSURLRequestUseProtocolCachePolicy
														  timeoutInterval:sPostTimeout];
	
	[urlRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[urlRequest setHTTPMethod:requestType];
		
	[urlRequest setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
	
	
	
	//If its a POST/PUT/DELETE it has a body
	if (requestBody != nil) {
		[urlRequest setHTTPBody:[ requestBody dataUsingEncoding:NSUTF8StringEncoding]];
		[urlRequest setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
	}
	
	//If there are headers, then add them
	if (headers != nil) {		
		NSArray *allKeys = [headers allKeys];
		for (id key in allKeys) {
			[urlRequest setValue:[headers valueForKey:key] forHTTPHeaderField:key];
		}	
	}

	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	theConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
		
    [self logTheRequest:urlRequest];
    
	if (theConnection) {
		// Create the NSMutableData that will hold
		// the received data
		// receivedData is declared as a method instance elsewhere
		self.receivedData = [NSMutableData data];
	} else {
		// inform the user that the download could not be made
	}

}




#pragma mark -
#pragma mark Http Delegate Methods

/*
 
 When the server has provided sufficient data to create an NSURLResponse object,
 the delegate receives a connection:didReceiveResponse: message. The delegate method 
 can examine the provided NSURLResponse and determine the expected content length of 
 the data, MIME type, suggested filename and other metadata provided by the server.
 
 It's important that the delegate be prepared to receive the connection:didReceiveResponse: 
 message multiple times for a connection. This message can be sent due to server redirects, 
 or in rare cases multi-part MIME documents. Each time the delegate receives the connection:didReceiveResponse:
 message, it should reset any progress indication and discard all previously received data.
 
 */
- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	// this method is called when the server has determined that it
    // has enough information to create the NSURLResponse

	[self logTheResponse:response];
		
    // it can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    // receivedData is declared as a method instance elsewhere
	
	[receivedData setLength:0];
		
	//int statusCode = [((NSHTTPURLResponse *)response) statusCode];

}

/*
 
 As the connection progresses the delegate is sent connection:didReceiveData: messages as the data is received. 
 The delegate implementation is responsible for storing the newly received data.
 
 You can also use the connection:didReceiveData: method to provide an indication of the connection’s progress to the user.
 
 */
- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	//As the connection progresses the delegate is sent connection:didReceiveData: messages as 
	//the data is received. The delegate implementation is responsible for storing the newly received data
	// append the new data to the receivedData
    // receivedData is declared as a method instance elsewhere
    [receivedData appendData:data];
	
	/*
		How much bandwidth?
	 */
}

/*
 
 If an error is encountered during the download, the delegate receives a connection:didFailWithError: message. 
 The NSError object passed as the parameter specifies the details of the error. It also provides the URL of the request
 that failed in the user info dictionary using the key NSErrorFailingURLStringKey.
 
 After the delegate receives a message connection:didFailWithError:, it receives no further
 delegate messages for the specified connection.
 
 */
- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	
	// release the connection, and the data object
	self.theConnection = nil;
	self.receivedData = nil;

	// inform the user

//          [error localizedDescription],
//          [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
	
	if ([delegate conformsToProtocol:@protocol(HttpServiceDelegate)]) {
		[delegate httpService:self didFailWithError:error];
	} else {
		//DULog(@"Why is it here?");
	}

	
}

/*
 
 Finally, if the connection succeeds in downloading the request, the delegate receives the 
 connectionDidFinishLoading: message. The delegate will receive no further messages for the
 connection and the NSURLConnection object can be released.
 
 */
- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
	// do something with the data
    // receivedData is declared as a method instance elsewhere
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
    
	//Was there an error?
	if (connectionError) {
		//Yes there was
		//We now have the error details in receivedData
		NSString *dataString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
		DULog(@"Connection Error With HTTP Response Code:%li \n\n %@", (long)[connectionError code], dataString);
        
        if ([delegate respondsToSelector:@selector(httpService:didFailWithError:dataString:)]){
            [delegate httpService:self didFailWithError:connectionError dataString:dataString];
        }
        else{
            [delegate httpService:self didFailWithError:connectionError];
        }

		self.connectionError = nil;
	} else {
		//No errors	
		[delegate httpService:self didRespondWithData:receivedData];

	}
	
    // release the connection, error and the data object
	self.theConnection = nil;
	self.receivedData = nil;
}

-(void)callDelayedService:(id)data {
    [delegate httpService:self didRespondWithData:(NSData*)data];
}


@end

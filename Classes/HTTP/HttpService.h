//
//  HttpService.h
//  iDeal
//
//  Created by David Casserly on 15/03/2010.
//  Copyright 2010 IGIndex.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HttpService;

@protocol HttpServiceDelegate <NSObject>

- (void) httpService:(HttpService *)httpService didRespondWithData:(NSData *)response;
- (void) httpService:(HttpService *)httpService didFailWithError:(NSError *)error;

@optional

- (void) httpService:(HttpService *)httpService didFailWithError:(NSError *)error dataString:(NSString*)dataString;

@end


@interface HttpService : NSObject {

	id<HttpServiceDelegate> __weak delegate;
	
	NSURLConnection *theConnection;
	NSMutableData *receivedData;
	
	NSError *connectionError; //used to store 400+ response errors

    
}

@property (nonatomic, weak) id<HttpServiceDelegate> delegate;

#pragma mark -
#pragma mark Init

- (id) initWithDelegate:(id)delegate;

#pragma mark -
#pragma mark Http Request Methods

- (void) httpPOSTRequest:(NSString *)body toUrl:(NSString *)url;
- (void) httpPUTRequest:(NSString *)body toUrl:(NSString *)url;
- (void) httpDELETERequest:(NSString *)body toUrl:(NSString *)url;
- (void) httpGETRequest:(NSString *)url;
- (void) httpGETRequest:(NSString *)url withHeaders:(NSDictionary *) headers;

#pragma mark -
#pragma mark Release

- (void) cancelTheConnection;

@end

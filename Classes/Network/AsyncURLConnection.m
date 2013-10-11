//
//  AsyncURLConnection.m
//  DevedUp
//
//  Created by David Casserly on 19/01/2012.
//  Copyright (c) 2012 DevedUp Ltd. All rights reserved.
//

#import "AsyncURLConnection.h"

@implementation AsyncURLConnection

+ (id)request:(NSString *)requestUrl completeBlock:(completeBlock_t)completeBlock errorBlock:(errorBlock_t)errorBlock
{
    return [[self alloc] initWithRequest:requestUrl
                            completeBlock:completeBlock errorBlock:errorBlock];
}

- (id)initWithRequest:(NSString *)requestUrl completeBlock:(completeBlock_t)completeBlock errorBlock:(errorBlock_t)errorBlock
{
    
    if ((self=[super init])) {
        data_ = [[NSMutableData alloc] init];
        
        completeBlock_ = [completeBlock copy];
        errorBlock_ = [errorBlock copy];
        
        NSURL *url = [NSURL URLWithString:requestUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [NSURLConnection connectionWithRequest:request delegate:self];
    }
    
    return self;
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [data_ setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [data_ appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    completeBlock_(data_);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    errorBlock_(error);
}

@end

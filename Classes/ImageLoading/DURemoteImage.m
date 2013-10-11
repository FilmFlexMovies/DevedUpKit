//
//  RemoteImage.m
//
//  Created by David Casserly on 02/06/2011.
//  Copyright 2011 DevedUp Ltd. All rights reserved.
//

#import "DURemoteImage.h"
#import "DUImageCache.h"

@interface DURemoteImage ()
@property (nonatomic, retain) NSURL *imageURL;
@property (nonatomic, retain) NSURLConnection *httpConnection;
@property (nonatomic, retain) NSMutableData *receivedData;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) NSURLRequest *request;
@property (nonatomic, retain) NSURLResponse *response;
@end

@implementation DURemoteImage


- (id) initWithURLString:(NSString *)imageURLString {
    self = [super init];
    if (self) {
        _imageURL = [NSURL URLWithString:imageURLString];
        _status = DURequestStatusNone;
    }
    return self;
}

#pragma mark - Downloading Image

- (void) cancelDownload {
    if (self.status == DURequestStatusInProgress) {
        [self.httpConnection cancel];
    }
    self.httpConnection = nil;
    self.receivedData = nil;
    self.image = nil;
    self.status = DURequestStatusNone;
}

- (void) download {    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{        
        if (DURequestStatusInProgress == self.status) {
            return;
        } else if (DURequestStatusSuccess == self.status) {
            if (self.image) {
                return;
            }
        }
        
        self.status = DURequestStatusInProgress;
        self.receivedData = nil;
        
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:self.imageURL
                                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                              timeoutInterval:60]; 
        self.request = urlRequest;
                
        //Try and get the image out of the cache first
        NSData *imageData = [[DUImageCache sharedController]
                             imageDataInCacheForURLString:[[urlRequest URL] absoluteString]];
        if (imageData) {            
            self.image = [UIImage imageWithData:imageData];            
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.image) {
                self.status = DURequestStatusSuccess;
            } else {
                //The reason the connection delegate messages aren't firing until you stop scrolling is because
                //during scrolling, the run loop is in UITrackingRunLoopMode. By default, NSURLConnectio  schedules
                //itself in NSDefaultRunLoopMode only, so you don't get any messages while scrolling.
                //Here's how to schedule the connection in the "common" modes, which includes UITrackingRunLoopMode:
                
                self.httpConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self startImmediately:NO];
                [self.httpConnection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
                [self.httpConnection start];
                if (self.httpConnection) {
                    self.receivedData = [NSMutableData data];
                }
            }        
        });
    });
}

#pragma mark - Http Delegate Methods

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.receivedData appendData:data];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	// release the connection, and the data object
	self.httpConnection = nil;
    self.receivedData = nil;    
    
    DURequestStatus newStatus;
//    if (![InternetConnectionController sharedInstance].isConnected) {
//        newStatus = DURequestStatusOffline;
//    } else {
        newStatus = DURequestStatusError;
//    }
    
    ErrorLog(@"Error downloading the image %@ from url [%@]", error, _imageURL.absoluteString);
    self.status = newStatus;
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
    self.response = response;
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {    
    //We have the _receivedData
    UIImage *downloadImage = [UIImage imageWithData:self.receivedData];
    
    NSData *theData = self.receivedData;
    NSURLRequest *theRequest = self.request;
    NSURLResponse *theResponse = self.response;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (!downloadImage) {
            [[DUImageCache sharedController] clearCachedDataForRequest:theRequest];
        } else {
            [[DUImageCache sharedController] cacheImageData:theData
                                                      request:theRequest
                                                     response:theResponse];
        }
    });
    
    if (downloadImage) {
        self.image = downloadImage;
        self.status = DURequestStatusSuccess;
    } else {
        self.status = DURequestStatusError;
    }
    
    // release the connection, and the data object
	self.httpConnection = nil;
    self.receivedData = nil;
}

@end

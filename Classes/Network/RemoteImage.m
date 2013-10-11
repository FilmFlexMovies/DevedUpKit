//
//  RemoteImage.m
//  Flickr
//
//  Created by David Casserly on 02/06/2011.
//  Copyright 2011 DevedUp Ltd. All rights reserved.
//

#import "RemoteImage.h"
#import "URLDiskCache.h"
#import "AsyncURLConnection.h"
#import "UIDevice+Extensions.h"
#import "InternetConnectionController.h"

static NSInteger downloadCount;
NSString * const RemoteImageDownloadCountChangedNotification = @"RemoteImageDownloadCountChangedNotification";

@interface RemoteImage ()
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, strong) NSURLResponse *response;
@property (nonatomic, assign) BOOL fromCache;
@property (nonatomic, assign) NSUInteger totalBytes;
@property (nonatomic, assign) NSUInteger bytesLoaded;
@property (nonatomic, assign) CGFloat downloadProgress;
@property (nonatomic, retain) NSURL *imageURL;
@end

@implementation RemoteImage

@synthesize image = __image;
@synthesize downloadStatus = _requestStatus;

- (void)dealloc {
     _imageURL = nil;
     _httpConnection = nil;
     _receivedData = nil;
}

- (id) initWithURL:(NSURL *)theImageURL {
    NSAssert(theImageURL, @"Need a url");
    NSAssert(theImageURL.absoluteString.length, @"URL needs to have content");
    self = [super init];
    if (self) {
        _requestStatus = DURequestStatusNone;
        _imageURL = theImageURL;
    }
    return self;
}

#pragma mark - Download 220

- (void) unloadImage {
    
	//#ifdef DEBUG
	//    if (self.image) {
	//        size_t imageSize = CGImageGetBytesPerRow(self.image.CGImage) * CGImageGetHeight(self.image.CGImage);
	//        imageMemory -= imageSize;
	//        imagesInMemory--;
	//    }
	//#endif
    
    if (self.downloadStatus != DURequestStatusInProgress) {
        _requestStatus = DURequestStatusNone;
        self.image = nil;
    } else {
        [_httpConnection cancel];
        _requestStatus = DURequestStatusNone;
        self.image = nil;
    }
    
	//#ifdef DEBUG
	//    (@"Total memory used by images is %lu", imageMemory);
	//    (@"Total images in memory is %i", imagesInMemory);
	//#endif
    
    //TODO if it's in progress, does this leak
}

- (void) download {
    long priority = self.highPriority ? DISPATCH_QUEUE_PRIORITY_HIGH : DISPATCH_QUEUE_PRIORITY_DEFAULT;
    
    dispatch_async(dispatch_get_global_queue(priority, 0), ^{
        
        if (_requestStatus == DURequestStatusInProgress) {
            return;
        } else if (_requestStatus == DURequestStatusSuccess) {
            if (self.image) {
                return;
            }
        }
        
        _requestStatus = DURequestStatusInProgress;
		_receivedData = nil;
        
        [RemoteImage incrementDownloadCount];
        
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:self.imageURL
                                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                              timeoutInterval:60]; //TODO WHAT SHOULD THIS BE
        self.request = urlRequest;
        
		
        NSData *imageData = [[URLDiskCache sharedURLDiskCache] imageDataInCacheForURLString:[[urlRequest URL] absoluteString]];
        if (imageData) {
            self.fromCache = YES;
            self.image = [UIImage imageWithData:imageData];
			//#ifdef DEBUG
			//            size_t imageSize = CGImageGetBytesPerRow(self.image.CGImage) * CGImageGetHeight(self.image.CGImage);
			//            imageMemory += imageSize;
			//            imagesInMemory++;
			//#endif
        }
		
        
        if (self.image) {
            //Do this to detach it like how it would behave if you created the NSURLConnection
            dispatch_async(dispatch_get_main_queue(), ^{
                //[self performSelector:@selector(imageReadyToDeliver) withObject:nil afterDelay:0];
                if ([UIDevice isIPadOriginal]) {
                    [self performSelector:@selector(imageReadyToDeliver) withObject:nil afterDelay:0];
                } else {
                    [self performSelector:@selector(imageReadyToDeliver) withObject:nil afterDelay:0 inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
                }
                
            });
        } else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //The reason the connection delegate messages aren't firing until you stop scrolling is because
                //during scrolling, the run loop is in UITrackingRunLoopMode. By default, NSURLConnectio  schedules
                //itself in NSDefaultRunLoopMode only, so you don't get any messages while scrolling.
                //Here's how to schedule the connection in the "common" modes, which includes UITrackingRunLoopMode:
                
                _httpConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self startImmediately:NO];
                if (![UIDevice isIPadOriginal]) {
                    [_httpConnection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
                }
                [_httpConnection start];
                if (_httpConnection) {
                    _receivedData = [NSMutableData data];
                }
                
            });
			
        }
    });
}

- (void) cancelDownload {
    if (DURequestStatusInProgress == _requestStatus) {
        [_httpConnection cancel];
        _httpConnection = nil;
        _receivedData = nil;
        _requestStatus = DURequestStatusNone;
        [RemoteImage decrementDownloadCount];
    }
}

#pragma mark - Download Count

+ (void) incrementDownloadCount {
    downloadCount++;
#ifdef DEBUG
    [[NSNotificationCenter defaultCenter] postNotificationName:RemoteImageDownloadCountChangedNotification object:@(downloadCount) userInfo:nil];
#endif
}

+ (void) decrementDownloadCount {
    downloadCount--;
#ifdef DEBUG
    [[NSNotificationCenter defaultCenter] postNotificationName:RemoteImageDownloadCountChangedNotification object:@(downloadCount) userInfo:nil];
#endif
}

#pragma mark - Http Delegate Methods

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_receivedData appendData:data];
    
    self.bytesLoaded += [data length];
    
    self.downloadProgress = self.bytesLoaded / (float)self.totalBytes;
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	
	// release the connection, and the data object
	if (_httpConnection) {
		_httpConnection = nil;
	}
    // receivedData is declared as a method instance elsewhere
    _receivedData = nil;
    
    
    DURequestStatus newStatus;
    if (![InternetConnectionController sharedInstance].isConnected) {
        newStatus = DURequestStatusOffline;
    } else {
        newStatus = DURequestStatusError;
    }
    
    DULog(@"Error downloading the image %@ from url [%@]", error, self.imageURL.absoluteString);
    if ([self.delegate respondsToSelector:@selector(errorDownloadingRemoteImage:status:)]) {
        [self.delegate errorDownloadingRemoteImage:self status:newStatus];
    }
    _requestStatus = newStatus;
    
    [RemoteImage decrementDownloadCount];
}

//TODO NEED TO GET THIS ONTO IT'S OWN THREAD!!

- (NSURLRequest *) connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse {
    
    //TODO DEBUG THIS AND SEE WHY ALL THE REDIRECTS ON STARTUP
    //http://l.yimg.com/g/images/photo_unavailable.gif
    NSString *redirectURL = [[request URL] absoluteString];
    if ([redirectURL hasSuffix:@"photo_unavailable.gif"] || [redirectURL hasSuffix:@"buddyicon.jpg"]) {
        [connection cancel];
        [self connection:connection didFailWithError:nil];
        return nil;
    }
    
    return request;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse.
    
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
	
    // receivedData is an instance variable declared elsewhere.
    [_receivedData setLength:0];
    self.response = response;
    
    self.totalBytes = response.expectedContentLength;
}


//- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
//
//    if (self.failedOnce) {
//        [self connectionDidFinishLoading_good:connection];
//    }
//
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//
//        [NSThread sleepForTimeInterval:5];
//        DURequestStatus timeout = DURequestStatusTimeout;
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if ([delegate respondsToSelector:@selector(errorDownloadingRemoteImage:status:)]) {
//                [delegate errorDownloadingRemoteImage:self status:timeout];
//            }
//        });
//
//        _requestStatus = timeout;
//        self.failedOnce = YES;
//    });
//}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    //DULog(@"DONE: Remote Image Download Count: %i", downloadCount);
    
    NSData *theData = _receivedData;
    NSURLRequest *theRequest = self.request;
    NSURLResponse *theResponse = self.response;
    
    //We have the _receivedData
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *downloadImage = [UIImage imageWithData:theData];
        
        //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		if (!downloadImage) {
			[[URLDiskCache sharedURLDiskCache] clearCachedDataForRequest:theRequest];
		} else {
			[[URLDiskCache sharedURLDiskCache] cacheImageData:theData
													  request:theRequest
													 response:theResponse];
		}
        //});
        
        if (downloadImage) {
            self.image = downloadImage;
            
			//#ifdef DEBUG
			//            size_t imageSize = CGImageGetBytesPerRow(self.image.CGImage) * CGImageGetHeight(self.image.CGImage);
			//            imageMemory += imageSize;
			//            imagesInMemory++;
			//#endif
            
            [self imageReadyToDeliver];
        } else {
            if ([self.delegate respondsToSelector:@selector(errorDownloadingRemoteImage:status:)]) {
                [self.delegate errorDownloadingRemoteImage:self status:DURequestStatusError];
            }
            _requestStatus = DURequestStatusError;
        }
        
        
    });
    
    // release the connection, and the data object
    if (_httpConnection) {
        _httpConnection = nil;
    }
    _receivedData = nil;
}

- (void) imageReadyToDeliver {
    _requestStatus = DURequestStatusSuccess;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSAssert([NSThread isMainThread], @"were not on main thread");
        if ([self.delegate respondsToSelector:@selector(remoteImageDownloaded:)]) {
            [self.delegate remoteImageDownloaded:self];
        }
    });
    [RemoteImage decrementDownloadCount];
}

@end

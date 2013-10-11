//
//  RemoteImage.h
//  Flickr
//
//  Created by David Casserly on 02/06/2011.
//  Copyright 2011 DevedUp Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DUConstants.h"

extern NSString * const RemoteImageDownloadCountChangedNotification;

@protocol RemoteImageDelegate <NSObject>

- (void) remoteImageDownloaded:(id)remoteImage;
//- (void) remoteImage:(id)remoteImage downloadedImage:(UIImage *)image fromCache:(BOOL)fromCache;
- (void) errorDownloadingRemoteImage:(id)remoteImage status:(DURequestStatus)errorStatus;

@end

@interface RemoteImage : NSObject {
	    
@private
    DURequestStatus _requestStatus;
    	
    //http object
    NSURLConnection *_httpConnection;
    NSMutableData *_receivedData;
	
}

@property (nonatomic, assign) BOOL highPriority;
@property (nonatomic, assign, readonly) CGFloat downloadProgress;
@property (nonatomic, weak) id<RemoteImageDelegate> delegate;
@property (nonatomic, strong, readonly) UIImage *image;
@property (nonatomic, readonly) DURequestStatus downloadStatus;
@property (nonatomic, retain, readonly) NSURL *imageURL;

- (id) initWithURL:(NSURL *)imageURL;

- (void) download;
- (void) unloadImage;
- (void) cancelDownload;

@end

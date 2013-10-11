//
//  RemoteImage.h
//
//  Created by David Casserly on 02/06/2011.
//  Copyright 2011 DevedUp Ltd. All rights reserved.
//

@interface DURemoteImage : NSObject

@property (nonatomic, assign) DURequestStatus status;
@property (nonatomic, retain, readonly) UIImage *image;


- (id) initWithURLString:(NSString *)imageURLString;
- (void) cancelDownload;
- (void) download;

@end

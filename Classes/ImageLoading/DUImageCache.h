//
//  DUImageCache.h
//
//  Created by David Casserly on 02/06/2011.
//  Copyright 2011 DevedUp Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DUImageCache : NSObject

+ (DUImageCache *) sharedController;

- (NSUInteger)sizeOfCache;

- (NSData *)imageDataInCacheForURLString:(NSString *)urlString;

- (void)cacheImageData:(NSData *)imageData
			   request:(NSURLRequest *)request
			  response:(NSURLResponse *)response;

- (void)clearCachedDataForRequest:(NSURLRequest *)request;

- (NSString *)trimDiskCache;

- (void) clearDiskCache;

@end


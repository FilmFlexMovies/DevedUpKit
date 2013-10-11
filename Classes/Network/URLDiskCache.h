//
//  DiskCache.h
//  happyhours
//
//  Created by David Golightly on 2/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


@interface URLDiskCache : NSObject {
    
    @private
	NSString *_cacheDir;
	NSUInteger _cacheSize;
}

@property (nonatomic, readonly) NSUInteger sizeOfCache;
@property (weak, nonatomic, readonly) NSString *cacheDir;

+ (URLDiskCache *) sharedURLDiskCache;

- (NSUInteger)sizeOfCache;

- (NSData *)imageDataInCacheForURLString:(NSString *)urlString;
- (void)cacheImageData:(NSData *)imageData   
			   request:(NSURLRequest *)request
			  response:(NSURLResponse *)response;
- (void)clearCachedDataForRequest:(NSURLRequest *)request;

- (NSString *)trimDiskCache;
- (void) clearDiskCache;

- (NSArray *) largeImagesCached;

@end

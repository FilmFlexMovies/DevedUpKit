//
//  DUImageCache.m
//
//  Created by David Casserly on 02/06/2011.
//  Copyright 2011 DevedUp Ltd. All rights reserved.
//

#import "Macros.h"

const NSUInteger kMaxDiskCacheSize = 400000000;

#import "DUImageCache.h"

@interface DUImageCache () 
@property (nonatomic, assign) NSUInteger cacheSize;
@end

@implementation DUImageCache

+ (DUImageCache *) sharedController {
    static dispatch_once_t onceToken;
    static DUImageCache *sharedManager = nil;
    
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    
    return sharedManager;
}

- (NSString *) cachesDirectory {
    static NSString *cachesFolder = nil;
    if (!cachesFolder) {
        cachesFolder = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    }
	return cachesFolder;
}

- (NSString *) cacheDir {
    static NSString *cachesDirectory = nil;
    
	if (cachesDirectory == nil) {
		NSString *cacheDir = [self cachesDirectory];
		cachesDirectory = [[NSString alloc] initWithString:[cacheDir stringByAppendingPathComponent:@"imagecache"]];
        
        /* check for existence of cache directory */
        if (![[NSFileManager defaultManager] fileExistsAtPath:cachesDirectory]) {
            
            /* create a new cache directory */
            if (![[NSFileManager defaultManager] createDirectoryAtPath:cachesDirectory
                                           withIntermediateDirectories:NO
                                                            attributes:nil
                                                                 error:nil]) {
                
                cachesDirectory = nil;
            }
        }
    }
	return cachesDirectory;
}


- (NSString *)localPathForURL:(NSURL *)url {
	NSString *filename = [[[url path] componentsSeparatedByString:@"/"] lastObject];
	
	return [[self cacheDir] stringByAppendingPathComponent:filename];
}



- (NSData *)imageDataInCacheForURLString:(NSString *)urlString {
	NSString *localPath = [self localPathForURL:[NSURL URLWithString:urlString]];
	
    NSData *data = nil;
    data = [[NSFileManager defaultManager] contentsAtPath:localPath];
    if (data) {
        // "touch" the file so we know when it was last used
		[[NSFileManager defaultManager] setAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[NSDate date], NSFileModificationDate, nil]
										 ofItemAtPath:localPath
												error:nil];
    }
    return data;
}


- (void)cacheImageData:(NSData *)imageData
			   request:(NSURLRequest *)request
			  response:(NSURLResponse *)response {
	if (request != nil &&
		response != nil &&
		imageData != nil) {
        //		NSCachedURLResponse *cachedResponse = [[NSCachedURLResponse alloc] initWithResponse:response
        //                                                                                       data:imageData];
        //
        //		[[NSURLCache sharedURLCache] storeCachedResponse:cachedResponse forRequest:request];
		
		
		NSString *localPath = [self localPathForURL:[request URL]];
		
		[[NSFileManager defaultManager] createFileAtPath:localPath
												contents:imageData
											  attributes:nil];
		
		if (![[NSFileManager defaultManager] fileExistsAtPath:localPath]) {
			ErrorLog(@"ERROR: Could not create file at path: %@", localPath);
		} else {
			self.cacheSize += [imageData length];
		}
        
        //        [cachedResponse release];
	}
}


- (void)clearCachedDataForRequest:(NSURLRequest *)request {
    //	[[NSURLCache sharedURLCache] removeCachedResponseForRequest:request];
	NSData *data = [self imageDataInCacheForURLString:[[request URL] path]];
	self.cacheSize -= [data length];
	[[NSFileManager defaultManager] removeItemAtPath:[self localPathForURL:[request URL]]
											   error:nil];
}


- (NSUInteger)sizeOfCache {
	NSString *cacheDir = [self cacheDir];
	if (self.cacheSize <= 0 && cacheDir != nil) {
		NSArray *dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:cacheDir error:nil];
		NSString *file;
		NSDictionary *attrs;
		NSNumber *fileSize;
		NSUInteger totalSize = 0;
		
		for (file in dirContents) {
			//if ([[file pathExtension] isEqualToString:@"jpg"]) {
            NSError *error = nil;
            attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:[cacheDir stringByAppendingPathComponent:file] error:&error];
            
            fileSize = [attrs objectForKey:NSFileSize];
            totalSize += [fileSize integerValue];
			//}
		}
		
		self.cacheSize = totalSize;
		DULog(@"cache size is: %lu", (unsigned long)self.cacheSize);
	}
	return self.cacheSize;
}


NSInteger dateModifiedSort(id file1, id file2, void *reverse) {
	NSDictionary *attrs1 = [[NSFileManager defaultManager] attributesOfItemAtPath:file1 error:nil];
	NSDictionary *attrs2 = [[NSFileManager defaultManager] attributesOfItemAtPath:file2 error:nil];
	
	if ((NSInteger *)reverse == NO) {
		return [[attrs2 objectForKey:NSFileModificationDate] compare:[attrs1 objectForKey:NSFileModificationDate]];
	}
	
	return [[attrs1 objectForKey:NSFileModificationDate] compare:[attrs2 objectForKey:NSFileModificationDate]];
}


- (void) clearDiskCache {
    NSError *error = nil;
    NSArray *dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self cacheDir] error:&error];
    for (NSString *file in dirContents) {
        NSString *path = [[self cacheDir] stringByAppendingPathComponent:file];
        [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    }
    self.cacheSize = 0;
}


- (NSString *) trimDiskCache {
    NSAssert(![NSThread currentThread].isMainThread, @"should be in background");
    
    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
    // NSUInteger targetBytes = MIN(kMaxDiskCacheSize, MAX(0, targetBytes));
    NSUInteger targetBytes = kMaxDiskCacheSize * 0.75;
    DULog(@"Checking disk cache size. Limit %lu bytes", (unsigned long)targetBytes);
    NSString *size = [NSString stringWithFormat:@"%lu", (unsigned long)[self cacheSize]];
    if ([self cacheSize] > targetBytes) {
        DULog(@"Time to clean the cache! size is: %@, %lu", [self cacheDir], (unsigned long)[self cacheSize]);
        NSError *error = nil;
        NSArray *dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self cacheDir] error:&error];
        DULog(@"There are %lu contents in dir", (unsigned long)[dirContents count]);
        if (!error) {
            NSMutableArray *filteredArray = [[NSMutableArray alloc] init];
            for (NSString *file in dirContents) {
                //if ([[file pathExtension] isEqualToString:@"jpg"]) {
                [filteredArray addObject:[[self cacheDir] stringByAppendingPathComponent:file]];
                DULog(@"adding");
                //}
            }
            
            int reverse = YES;
            NSMutableArray *sortedDirContents = [NSMutableArray arrayWithArray:[filteredArray sortedArrayUsingFunction:dateModifiedSort context:&reverse]];
            while (self.cacheSize > targetBytes && [sortedDirContents count] > 0) {
                DULog(@"removing ");
                self.cacheSize -= [[[[NSFileManager defaultManager] attributesOfItemAtPath:[sortedDirContents lastObject] error:nil] objectForKey:NSFileSize] integerValue];
                [[NSFileManager defaultManager] removeItemAtPath:[sortedDirContents lastObject] error:nil];
                [sortedDirContents removeLastObject];
                DULog(@"removing ");
            }
            DULog(@"Remaining cache size: %lu, target size: %lu", (unsigned long)self.cacheSize, (unsigned long)targetBytes);
        }
    }
    DULog(@"Finished checking disk cache");
    
    return size;
    //});
}

@end

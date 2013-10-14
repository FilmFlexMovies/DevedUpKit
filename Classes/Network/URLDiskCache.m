//
//  DiskCache.m
//  happyhours
//
//  Created by David Golightly on 2/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "URLDiskCache.h"
#import "UIDevice+Extensions.h"
#import "NSMutableArray+Extensions.h"

const NSUInteger kMaxDiskCacheSize3			= 400000000;

@implementation URLDiskCache

@dynamic sizeOfCache;
@dynamic cacheDir;

+ (URLDiskCache *) sharedURLDiskCache {
    static dispatch_once_t onceToken;
    static URLDiskCache * __sharedManager = nil;
    
    dispatch_once(&onceToken, ^{
        __sharedManager = [[self alloc] init];
    });
    
    return __sharedManager;
}


- (NSString *)cacheDir {
	if (_cacheDir == nil) {
		NSString *cacheDir = [UIDevice cachesDirectory];
		_cacheDir = [[NSString alloc] initWithString:[cacheDir stringByAppendingPathComponent:@"imagecache"]];

        /* check for existence of cache directory */
        if (![[NSFileManager defaultManager] fileExistsAtPath:_cacheDir]) {

            /* create a new cache directory */
            if (![[NSFileManager defaultManager] createDirectoryAtPath:_cacheDir 
                                           withIntermediateDirectories:NO
                                                            attributes:nil 
                                                                 error:nil]) {
                DULog(@"Error creating cache directory");

                _cacheDir = nil;
            }
        }
    }
	return _cacheDir;
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
		[[NSFileManager defaultManager] setAttributes:@{NSFileModificationDate: [NSDate date]} 
										 ofItemAtPath:localPath 
												error:nil];
    }
    return data;
    
    /* version 1
	if ([[NSFileManager defaultManager] fileExistsAtPath:localPath]) {
		// "touch" the file so we know when it was last used
		[[NSFileManager defaultManager] setAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[NSDate date], NSFileModificationDate, nil] 
										 ofItemAtPath:localPath 
												error:nil];
		return [[NSFileManager defaultManager] contentsAtPath:localPath];
	}
	
	return nil;
     */
    
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
			DULog(@"ERROR: Could not create file at path: %@", localPath);
		} else {
			_cacheSize += [imageData length];
		}

//        [cachedResponse release];
	}
}


- (void)clearCachedDataForRequest:(NSURLRequest *)request {
//	[[NSURLCache sharedURLCache] removeCachedResponseForRequest:request];
	NSData *data = [self imageDataInCacheForURLString:[[request URL] path]];
	_cacheSize -= [data length];
	[[NSFileManager defaultManager] removeItemAtPath:[self localPathForURL:[request URL]] 
											   error:nil];
}


- (NSUInteger)sizeOfCache {
	NSString *cacheDir = [self cacheDir];
	if (_cacheSize <= 0 && cacheDir != nil) {
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
		
		_cacheSize = totalSize;
		DULog(@"cache size is: %lu", (unsigned long)_cacheSize);
	}
	return _cacheSize;
}

NSInteger dateModifiedSort3(id file1, id file2, void *reverse);
NSInteger dateModifiedSort3(id file1, id file2, void *reverse) {
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
    _cacheSize = 0;
}


- (NSString *) trimDiskCache {
    NSAssert(![NSThread currentThread].isMainThread, @"should be in background");
    
    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{  
       // NSUInteger targetBytes = MIN(kMaxDiskCacheSize3, MAX(0, targetBytes));
        NSUInteger targetBytes = kMaxDiskCacheSize3 * 0.75;
        DULog(@"Checking disk cache size. Limit %lu bytes", (unsigned long)targetBytes);
    NSString *size = [NSString stringWithFormat:@"%lu", (unsigned long)[self sizeOfCache]];
        if ([self sizeOfCache] > targetBytes) {
            DULog(@"Time to clean the cache! size is: %@, %lu", [self cacheDir], (unsigned long)[self sizeOfCache]);
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
                NSMutableArray *sortedDirContents = [NSMutableArray arrayWithArray:[filteredArray sortedArrayUsingFunction:dateModifiedSort3 context:&reverse]];
                while (_cacheSize > targetBytes && [sortedDirContents count] > 0) {
                    DULog(@"removing ");
                    _cacheSize -= [[[[NSFileManager defaultManager] attributesOfItemAtPath:[sortedDirContents lastObject] error:nil] objectForKey:NSFileSize] integerValue];
                    [[NSFileManager defaultManager] removeItemAtPath:[sortedDirContents lastObject] error:nil];
                    [sortedDirContents removeLastObject];
                    DULog(@"removing ");
                }
                DULog(@"Remaining cache size: %lu, target size: %lu", (unsigned long)_cacheSize, (unsigned long)targetBytes);
            }	
        }
        DULog(@"Finished checking disk cache");
    
    return size;
    //});
}

- (NSArray *) largeImagesCached {
    NSError *error = nil;
    NSArray *dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self cacheDir] error:&error];
    if (!error) {
        NSMutableArray *filteredArray = [[NSMutableArray alloc] init];
        for (NSString *file in dirContents) {
            if ([file hasSuffix:@"_b.jpg"]) {
                [filteredArray addObject:[[self cacheDir] stringByAppendingPathComponent:file]];
            }
        }
        
        [filteredArray shuffle];
        return filteredArray;
    }
    return nil;
}

@end

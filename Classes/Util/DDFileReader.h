//
//  DDFileReader.h
//  DevedUp
//
//  Created by David Casserly on 20/03/2011.
//  Copyright 2011 devedup.com. All rights reserved.
//

#import <Foundation/Foundation.h>


//DDFileReader.h

@interface DDFileReader : NSObject {
    NSString * filePath;
	
    NSFileHandle * fileHandle;
    unsigned long long currentOffset;
    unsigned long long totalFileLength;
	
    NSString * lineDelimiter;
    NSUInteger chunkSize;
}

@property (nonatomic, copy) NSString * lineDelimiter;
@property (nonatomic) NSUInteger chunkSize;

- (id) initWithFilePath:(NSString *)aPath;

- (NSString *) readLine;
- (NSString *) readTrimmedLine;

#if NS_BLOCKS_AVAILABLE
- (void) enumerateLinesUsingBlock:(void(^)(NSString*, BOOL *))block;
#endif

@end
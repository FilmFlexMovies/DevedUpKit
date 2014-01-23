//
//  DUFileLogger.m
//  DevedUpKit
//
//  Created by David Casserly on 21/01/2014.
//  Copyright (c) 2014 DevedUp. All rights reserved.
//

#import "DUFileLogger.h"

static NSMutableDictionary *loggers;

@interface DUFileLogger ()
- (id) initWithFileName:(NSString *)filename;
@property (nonatomic, retain) NSString *filename;
@end

@implementation DUFileLogger

+ (void) initialize {
    if (self == [DUFileLogger class]) {
        loggers = [NSMutableDictionary.alloc init];
    }
}

+ (DUFileLogger *) fileLoggerForFile:(NSString *)filename {
    DUFileLogger *logger = [loggers objectForKey:filename];
    if (!logger) {
        logger = [DUFileLogger.alloc initWithFileName:filename];
        [loggers setObject:logger forKey:filename];
    }
    return logger;
}

- (id) initWithFileName:(NSString *)filename {
    self = [super init];
    if (self) {
#if defined(TEST_FLIGHT) || (DEBUG)
        //Get file path
        NSString *documentsDirectory = [[NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"logs"];
        NSError *error = nil;
        if (![[NSFileManager defaultManager] fileExistsAtPath:documentsDirectory]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:&error];
        }

        //create file if it doesn't exist
        self.filename = [documentsDirectory stringByAppendingPathComponent:filename];
        if(![[NSFileManager defaultManager] fileExistsAtPath:self.filename])
            [[NSFileManager defaultManager] createFileAtPath:self.filename contents:nil attributes:nil];
#endif
    }
    return self;
}

- (void) blankLine {
#if defined(TEST_FLIGHT) || (DEBUG)
    NSFileHandle *file = [NSFileHandle fileHandleForUpdatingAtPath:self.filename];
    [file seekToEndOfFile];
    [file writeData:[@"\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [file closeFile];
#endif
}

- (void) append:(NSString *)logMessage {
#if defined(TEST_FLIGHT) || (DEBUG)
    static NSDateFormatter *dateFormat = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormat = [[NSDateFormatter alloc] init];
        dateFormat.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
        dateFormat.timeZone = [NSTimeZone timeZoneWithName: @"GMT"];
    });
    
    logMessage = [NSString stringWithFormat:@"\n%@ %@", [dateFormat stringFromDate:[NSDate date]], logMessage];
    
    NSFileHandle *file = [NSFileHandle fileHandleForUpdatingAtPath:self.filename];
    [file seekToEndOfFile];
    [file writeData:[logMessage dataUsingEncoding:NSUTF8StringEncoding]];
    [file closeFile];
#endif
}

@end

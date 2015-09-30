//
//  DUFileLogger.m
//  DevedUpKit
//
//  Created by David Casserly on 21/01/2014.
//  Copyright (c) 2014 DevedUp. All rights reserved.
//

#import "DUFileLogger.h"
@import MessageUI;
#import "NSData+Compression.h"

static NSMutableDictionary *loggers;

@interface DUFileLoggerImpl : NSObject <DUFileLogger>
@end

@interface DUFileLoggerImpl ()
+ (id<DUFileLogger>) fileLoggerForFile:(NSString *)filename;
- (instancetype) initWithFileName:(NSString *)filename;
@property (nonatomic, retain) NSString *filename;
@property (nonatomic, strong) UIViewController *mailPresenter;
@end

@implementation DUFileLoggerImpl

+ (void) initialize {
    if (self == [DUFileLoggerImpl class]) {
        loggers = [NSMutableDictionary.alloc init];
    }
}

+ (id<DUFileLogger>) fileLoggerForFile:(NSString *)filename {
    DUFileLoggerImpl *logger = loggers[filename];
    if (!logger) {
        logger = [DUFileLoggerImpl.alloc initWithFileName:filename];
        loggers[filename] = logger;
    }
    return logger;
}

- (instancetype) initWithFileName:(NSString *)filename {
    self = [super init];
    if (self) {
#if defined(ENTERPRISE) || defined(DEBUG)
        //Get file path
        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"logs"];
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

- (void) clearLogFile {
    [[NSFileManager defaultManager] createFileAtPath:self.filename contents:nil attributes:nil];
}


- (void) blankLine {
#if defined(ENTERPRISE) || defined(DEBUG)
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSFileHandle *file = [NSFileHandle fileHandleForUpdatingAtPath:self.filename];
        [file seekToEndOfFile];
        [file writeData:[@"\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [file closeFile];
    });
#endif
}

- (void) append:(NSString *)logMessage {
    //NSLog(@"%@", logMessage);
#if defined(ENTERPRISE) || defined(DEBUG)
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        static NSDateFormatter *dateFormat = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            dateFormat = [[NSDateFormatter alloc] init];
            dateFormat.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
            dateFormat.timeZone = [NSTimeZone timeZoneWithName: @"GMT"];
        });
        
        NSString *message = [NSString stringWithFormat:@"\n%@ %@", [dateFormat stringFromDate:[NSDate date]], logMessage];
        
        NSFileHandle *file = [NSFileHandle fileHandleForUpdatingAtPath:self.filename];
        [file seekToEndOfFile];
        [file writeData:[message dataUsingEncoding:NSUTF8StringEncoding]];
        [file closeFile];
    });
#endif
}

- (void) emailLogFileFromViewController:(UIViewController *)viewController {
    NSFileHandle *file = [NSFileHandle fileHandleForUpdatingAtPath:self.filename];
    
    
    
    
    NSData *allData = [file readDataToEndOfFile];
    NSData *zipped = [allData gzippedData];
    [self emailExport:zipped viewController:viewController];
}

- (void) emailExport:(NSData *)logFileData viewController:(UIViewController *)viewController {
    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
    mailComposer.mailComposeDelegate = self;
    
    // Set the subject of email
    [mailComposer setSubject:@"System Log File"];
    
    // Add email addresses
    // Notice three sections: "to" "cc" and "bcc"

    [mailComposer setToRecipients:[NSArray arrayWithObjects:@"eircomlogs@devedup.com", nil]];

    // Fill out the email body text
    NSString *emailBody = @"The current log file";
    
    // This is not an HTML formatted email
    [mailComposer setMessageBody:emailBody isHTML:NO];
    
    // Attach image data to the email
    [mailComposer addAttachmentData:logFileData mimeType:@"application/x-gzip" fileName:@"logfile.gzip"];
   
    // Show email view
    self.mailPresenter = viewController;
    [viewController presentViewController:mailComposer animated:YES completion:nil];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(nullable NSError *)error  {
 
    switch (result) {
        case MFMailComposeResultSent:
            [self clearLogFile];
            break;
        case MFMailComposeResultCancelled:
        case MFMailComposeResultFailed:
            
            break;
        default:
            break;
    }
    [self.mailPresenter dismissViewControllerAnimated:YES completion:nil];
}

@end



@implementation DUFileLoggerFactory : NSObject

+ (id<DUFileLogger>) fileLoggerForFile:(NSString *)filename {
    return [DUFileLoggerImpl fileLoggerForFile:filename];
}

@end



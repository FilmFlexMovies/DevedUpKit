//
//  DUExtendedNSLog.m
//  DevedUpKit
//
//  Created by David Casserly on 30/09/2015.
//  Copyright © 2015 DevedUp. All rights reserved.
//

#import "DUExtendedNSLog.h"
#import "DUFileLogger.h"

/*
 Example of standard NSLog:
 2015-08-06 16:12:08.916 Elbi-app[31191:19415190] *** FIC Warning: growing desired maximumCount (3) for format NHCampaignThumbnail to fill a chunk (4)
 
 Old FFX One:
 2015-08-06 16:23:01.084 Eircom[35470:19484770] <0xf91fe90 FFXAppDelegate+ThirdParty.m:(36)> Starting Flurry session with the development key - Dev Sandbox
 
 Example of DUExtendedNSLog
 
 
 */
void DUExtendedNSLog(const char *file, int lineNumber, const char *functionName, NSString *format, ...)
{
    // Type to hold information about variable arguments.
    va_list ap;
    
    // Initialize a variable argument list.
    va_start (ap, format);
    
    // NSLog only adds a newline to the end of the NSLog format if
    // one is not already there.
    // Here we are utilizing this feature of NSLog()
    if (![format hasSuffix: @"\n"])  {
        format = [format stringByAppendingString: @"\n"];
    }
    
    // This is the body of the message of what you are logging
    NSString *body = [[NSString alloc] initWithFormat:format arguments:ap];
    
    // End using variable argument list.
    va_end (ap);
    
    // Get the time
    static NSDateFormatter *dateFormat = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormat = [[NSDateFormatter alloc] init];
        dateFormat.dateFormat = @"HH:mm:ss.SSS";
    });
    NSString *date = [dateFormat stringFromDate:[NSDate date]];
    
    NSString *fileName = [[NSString stringWithUTF8String:file] lastPathComponent];
    // If you want to add the function name, add (%s) and functionName
    
#if defined(ENTERPRISE)
    NSString *log = [NSString stringWithFormat:@"%s <%s:%d> - %s", [date UTF8String], [fileName UTF8String], lineNumber, [body UTF8String]];
    [[DUFileLoggerFactory fileLoggerForFile:@"System.log"] append:log];
#elif defined(DEBUG)
    fprintf(stderr, "%s <%s:%d> - %s", [date UTF8String], [fileName UTF8String], lineNumber, [body UTF8String]);
#endif
    
}

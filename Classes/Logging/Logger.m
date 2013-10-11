//
//  Logger.m
//  Flickr
//
//  Created by David Casserly on 01/06/2011.
//  Copyright 2011 DevedUp Ltd. All rights reserved.
//

#import "Logger.h"


static BOOL loggingEnabled = YES;

@implementation Logger
+ (void)log:(NSString*)prefix, ... {
	if (loggingEnabled) {
		va_list args;
		va_start(args, prefix);
		NSString* arg = va_arg(args, NSString*);
		if (nil != arg && [arg rangeOfString:@"%"].location != NSNotFound) {
			NSLog([prefix stringByAppendingString:@" %@"], [[NSString alloc] initWithFormat:arg arguments:args]);
		} else {
			NSLog([prefix stringByAppendingString:@" %@"], arg);
		}
		va_end(args);
	}
}

+ (void)setLoggingEnabled {
	loggingEnabled = YES;
}
 
@end

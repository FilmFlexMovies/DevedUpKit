//
//  Logger.h
//  Flickr
//
//  Created by David Casserly on 01/06/2011.
//  Copyright 2011 DevedUp Ltd. All rights reserved.
//


@interface Logger : NSObject {
    
}
+ (void)log:(NSString*)prefix, ...;
+ (void)setLoggingEnabled;
@end
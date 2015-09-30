//
//  NSData+Compression.h
//  DevedUpKit
//
//  Created by David Casserly on 30/09/2015.
//  Copyright © 2015 DevedUp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Compression)

- (nullable NSData *)gzippedDataWithCompressionLevel:(float)level;
- (nullable NSData *)gzippedData;
- (nullable NSData *)gunzippedData;
- (BOOL)isGzippedData;

@end

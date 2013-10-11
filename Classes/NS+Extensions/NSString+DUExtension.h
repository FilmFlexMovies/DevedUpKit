//
//  NSString+DUExtension.h
//  FilmFlexMovies
//
//  Created by Casserly on 28/08/2012.
//  Copyright (c) 2012 FilmFlex Movies Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DUExtension)

- (NSComparisonResult) compareVersionToVersion:(NSString *)otherVersion;

@end

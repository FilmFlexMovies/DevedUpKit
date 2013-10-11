//
//  NSString+DUExtension.m
//  FilmFlexMovies
//
//  Created by Casserly on 28/08/2012.
//  Copyright (c) 2012 FilmFlex Movies Ltd. All rights reserved.
//

#import "NSString+DUExtension.h"

@implementation NSString (DUExtension)

/*
 * compareVersions(@"10.4",             @"10.3")             returns NSOrderedDescending (1)
 * compareVersions(@"10.5",             @"10.5.0")           returns NSOrderedSame (0)
 * compareVersions(@"10.4 Build 8L127", @"10.4 Build 8P135") returns NSOrderedAscending (-1)
 */
- (NSComparisonResult) compareVersionToVersion:(NSString *)otherVersion {
	int i;
	
	// Break version into fields (separated by '.')
	NSMutableArray *leftFields  = [[NSMutableArray alloc] initWithArray:[self componentsSeparatedByString:@"."]];
	NSMutableArray *rightFields = [[NSMutableArray alloc] initWithArray:[otherVersion componentsSeparatedByString:@"."]];
	
	// Implict ".0" in case version doesn't have the same number of '.'
	if ([leftFields count] < [rightFields count]) {
		while ([leftFields count] != [rightFields count]) {
			[leftFields addObject:@"0"];
		}
	} else if ([leftFields count] > [rightFields count]) {
		while ([leftFields count] != [rightFields count]) {
			[rightFields addObject:@"0"];
		}
	}
	
	// Do a numeric comparison on each field
	for(i = 0; i < [leftFields count]; i++) {
		NSComparisonResult result = [[leftFields objectAtIndex:i] compare:[rightFields objectAtIndex:i] options:NSNumericSearch];
		if (result != NSOrderedSame) {
			return result;
		}
	}
	
	return NSOrderedSame;
}


@end

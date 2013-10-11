//
//  Version.m
//  DevedUp
//
//  Created by David Casserly on 20/03/2011.
//  Copyright 2011 devedup.com. All rights reserved.
//

#import "Version.h"
#import "DDFileReader.h"

@implementation Version


+ (NSString *) svnBuildNumber {
	NSString *pathToMyFile = [[NSBundle mainBundle] pathForResource:@"entries" 
													 ofType:@""];
	
	DDFileReader *reader = [[DDFileReader alloc] initWithFilePath:pathToMyFile];
	
	//the build number is on the 4th line
	[reader readLine];[reader readLine];[reader readLine];
	NSString *line = [reader readLine];
	
	return line;
}

@end

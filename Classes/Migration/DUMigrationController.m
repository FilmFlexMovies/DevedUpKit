//
//  MigrationController.m
//
//  Created by David Casserly on 09/12/2011.
//  Copyright (c) 2011 DevedUp Ltd. All rights reserved.
//

#import "DUMigrationController.h"
#import "NSString+DUExtension.h"

#define kSavedVersion @"DUSavedVersion"

@interface DUMigrationController ()
@property (nonatomic, retain) NSString *previousVersionString;
@property (nonatomic, retain) NSString *currentVersionString;
@end

@implementation DUMigrationController


#pragma mark - Init

- (id)init {
    self = [super init];
    if (self) {
        //Current App Version - last time the app was run
		NSString *savedVersion = [[NSUserDefaults standardUserDefaults] objectForKey:kSavedVersion];
        self.previousVersionString = (savedVersion) ? savedVersion : @"0";
        
        //New App Version
        self.currentVersionString = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
                
    }
    return self;
}

#pragma mark - Migration Methods

//This will just delete the current version so it will be recreated
//- (void) migrateCoreData {
//    NSURL *storeURL = [NSPersistentStore MR_urlForStoreName:@"FilmFlex"];
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSError *error = nil;
//    if ([fileManager fileExistsAtPath:[storeURL path]]) {
//        [fileManager removeItemAtURL:storeURL error:&error];
//    }
//}


#pragma mark - Migration

- (BOOL) hasMigratedAlready {
	if (NSOrderedAscending == [self.previousVersionString compareVersionToVersion:self.currentVersionString]) {
		return NO;
	} else {
		return YES;
	}
}

- (void) finishMigration {
    //Save the current version for the next time we want to do a migration
    [[NSUserDefaults standardUserDefaults] setObject:_currentVersionString forKey:kSavedVersion];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end

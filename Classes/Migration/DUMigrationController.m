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


+ (DUMigrationController *) sharedController {
    static dispatch_once_t onceToken;
    static DUMigrationController * __sharedManager = nil;
    
    dispatch_once(&onceToken, ^{
        __sharedManager = [[self alloc] init];
    });
    
    return __sharedManager;
}

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

- (void) migrateToNewVersion
{
	
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

/*
  TODO --- COMMENTED THIS OUT, DO WE NEED TO DO THIS ANYMORE IT WAS MIGRATING OLD VERSION
 
// Migrate absolute paths in Media to relative
- (void) migrateMediaAssets {
    
	NSManagedObjectContext *context = MainContext;
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	request.entity = [NSEntityDescription entityForName:[FFXMedia entityName] inManagedObjectContext:context];
	
    NSError *error = nil;
    NSArray *mediaArray = [context executeFetchRequest:request error:&error];
    
	if (!error)
	{
		for (FFXMedia *media in mediaArray)
		{
            // Absolute to relative
            if (media.assetPath.length > 0) {
                if (![media.assetPath hasPrefix:@"offine"]) {
                    media.assetPath = [@"offline" stringByAppendingPathComponent:media.filename];
                }
            }
            
            if (media.temporaryPath.length > 0) {
                if (![media.temporaryPath hasPrefix:@"temp"]) {
                    media.temporaryPath = [@"temp" stringByAppendingPathComponent:media.filename];
                }
            }
		}
	}
    [FFXCoreDataManager saveMainContext];
}

 */

////This will just delete the current version so it will be recreated
//- (void) migrateCoreData {
//    NSURL *storeURL = [NSPersistentStore MR_urlForStoreName:@"FilmFlex"];
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSError *error = nil;
//    if ([fileManager fileExistsAtPath:[storeURL path]]) {
//        [fileManager removeItemAtURL:storeURL error:&error];
//    }
//}

@end

//
//  MigrationController.m
//
//  Created by David Casserly on 09/12/2011.
//  Copyright (c) 2011 DevedUp Ltd. All rights reserved.
//

#import "DUMigrationController.h"
#import "NSString+DUExtension.h"
#import "DUVersion.h"

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

- (instancetype)init {
    self = [super init];
    if (self) {
        //Current App Version - last time the app was run
		NSString *savedVersion = [[NSUserDefaults standardUserDefaults] objectForKey:kSavedVersion];
        self.previousVersionString = (savedVersion) ? savedVersion : @"0.0.0";
        if (NSNotFound == [savedVersion rangeOfString:@"."].location) {
            //i.e. when we were using the build version
            self.previousVersionString = @"1.1.1"; // The last version we used this
        }
        
        //New App Version
        self.currentVersionString = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
        
        NSLog(@"Vendor ID %@", [UIDevice currentDevice].identifierForVendor);
        
        // Check subclass conforms to protocol
        if (self != [DUMigrationController class]) {
            if (![self conformsToProtocol:@protocol(DUMigrator)]) {
                NSAssert(NO ,@"You must conform to DUMigrator if you subclass");
            }
        }
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

- (void) migrateToNewVersion {
	if ([self hasMigratedAlready]) {
		return;
	}
    
    DUVersion *lastVersion = [DUVersion.alloc initWithVersionString:self.previousVersionString];
    DUVersion *newVersion =[DUVersion.alloc initWithVersionString:self.currentVersionString];
    
    if ([self respondsToSelector:@selector(performMigrationToVersion:fromVersion:)]) {
        [self performSelector:@selector(performMigrationToVersion:fromVersion:) withObject:newVersion withObject:lastVersion];
    }
	
	[self finishMigration];
}

@end

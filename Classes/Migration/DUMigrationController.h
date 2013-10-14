//
//  MigrationController.h
//
//  Created by David Casserly on 09/12/2011.
//  Copyright (c) 2011 DevedUp Ltd. All rights reserved.
//

/*
 
 This class will be used to help perform any migrations from one version of the app to another.

 */

@interface DUMigrationController : NSObject 

@property (nonatomic, retain, readonly) NSString *previousVersionString;
@property (nonatomic, retain, readonly) NSString *currentVersionString;

+ (DUMigrationController *) sharedController;

- (BOOL) hasMigratedAlready;
- (void) finishMigration;

- (void) migrateToNewVersion;


@end

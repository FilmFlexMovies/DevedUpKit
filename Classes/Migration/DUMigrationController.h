//
//  MigrationController.h
//
//  Created by David Casserly on 09/12/2011.
//  Copyright (c) 2011 DevedUp Ltd. All rights reserved.
//

/*
 
 This class will be used to help perform any migrations from one version of the app to another.

 */

@class DUVersion;

@interface DUMigrationController : NSObject 

@property (nonatomic, retain, readonly) NSString *previousVersionString;
@property (nonatomic, retain, readonly) NSString *currentVersionString;

+ (DUMigrationController *) sharedController;

- (void) migrateToNewVersion;

@end


/*
    Subclasses must conform to this protocol
 */

@protocol DUMigrator <NSObject>

@required
- (void) performMigrationToVersion:(DUVersion *)toVersion fromVersion:(DUVersion *)fromVersion;

@end

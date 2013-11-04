//
//  DUCoreDataManager.h
//
//  Created by David Casserly on 23/07/2012.
//

#import <CoreData/CoreData.h>
#import "MagicalRecord.h" //NOTE: If you get MagicalRecord.h file not found... you haven't checked out the submodules properly, you are on a detached HEAD.

extern NSString * const CoreDataUpdatedExternally;

@interface DUCoreDataManager : NSObject 

+ (DUCoreDataManager *) sharedManager;

/*
    This will save the context on the main thread in memory, and also
    persist the changes to disk on a background thread
 */
+ (void) saveMainContext;

/*
    This will save the current context, which is a child of main - and propagate the saves
    up to main, and persist (in background)
 */
+ (void) saveContext:(NSManagedObjectContext *)context;


+ (void) performBlockAndWaitOnContext:(NSManagedObjectContext *)context block:( void (^)(void) )block;

/*
    Setup
 */
- (void) setupWithStoreName:(NSString *)storeName inBundle:(NSBundle *)bundle;
- (void) setupWithStoreName:(NSString *)storeName inBundle:(NSBundle *)bundle modelsToMerge:(NSArray *)otherModels;
- (void) setupWithStoreName:(NSString *)storeName;
- (void) setupWithStoreName:(NSString *)storeName iCloudID:(NSString *)key;

// Delete the version in iCloud
- (void) setupClearingRemoteStorWithStoreName:(NSString *)storeName iCloudID:(NSString *)key;

// Recreate from iCloud, deleting local version
- (void) setupRecreatingFromRemoteStorWithStoreName:(NSString *)storeName iCloudID:(NSString *)key;

@end

#pragma mark - Core Data Utilities - to make the code a little more succinct

// A defind to reference the main managed object context
#define MainContext [NSManagedObjectContext MR_defaultContext]

// This creates a background context with PrivateConcurrency that is linked to the main context
NSManagedObjectContext* createBackgroundContext();

// In a background context, you can load an object by id. In debug it asserts it's not a tempID and
// that an actual object is returned. This is fail fast in development mode!
id existingObjectWithID(NSManagedObjectID *objectID, NSManagedObjectContext *context);

//Ensure the objectID is not temporary
//I believe this is a consequence of using a background context for the persistent store instead of
//having the persistent store on the main context - sometimes you don't have the persistent object id's
//in a timely manner...maybe
void obtainObjectPermanentID(NSManagedObject *object, NSManagedObjectContext *context);

typedef DUCoreDataManager FFXCoreDataManager;

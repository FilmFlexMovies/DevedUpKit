//
//  DUCoreDataManager.h
//
//  Created by David Casserly on 23/07/2012.
//

#import "DUCoreDataManager.h"
#import "CoreData+MagicalRecord.h"

NSString * const CoreDataUpdatedExternally = @"CoreDataUpdatedExternally";

@interface NSManagedObjectContext (MagicalRecordsDirtyHack)
+ (void) MR_setDefaultContext:(NSManagedObjectContext *)moc;
@end

NSManagedObjectContext* createBackgroundContext() {
	return [NSManagedObjectContext MR_context];
}

id existingObjectWithID(NSManagedObjectID *objectID, NSManagedObjectContext *context) {
	NSError *error = nil;
	id object = [context existingObjectWithID:objectID error:&error];
	NSCAssert(![objectID isTemporaryID], @"This objectID is from a temporary object not saved yet");
	if (!object) {
		NSString *errorString = [NSString stringWithFormat:@"logCoreDataErrorIfNil: %@ for object %@", error, object];
		NSLog(@"%@", errorString);
	}
	// If you are crashing here it's because you are trying to access an object in a context,
	// probably a background context, by it's objectID but it can't find it yet. More than likely
	// it's because you haven't saved the main context with new objects before
	NSCAssert(object, @"Debug Mode, why is this object nil");
	return object;
}

//Ensure the objectID is not temporary
void obtainObjectPermanentID(NSManagedObject *object, NSManagedObjectContext *context) {
	if ([object.objectID isTemporaryID]) {
		NSError *error = nil;
		BOOL success = [context obtainPermanentIDsForObjects:@[object] error:&error];
		if (!success) {
			//If we have a temp id and try and load objects into a different context, then we will
			//run into problems. We should ensure we save the MainContext before using temp IDs.
			//You get a temp object id when an object is first created, it becomes permanent when the
			//object is persisted to a persistent store.
			NSLog(@"obtainObjectPermanentID Error %@", error);
		}
		NSCAssert(success, @"We have a temp ID and couldn't get a permanent one. Problem.");
	}
}

@interface DUCoreDataManager ()
@property (nonatomic, retain) NSManagedObjectContext *diskWritingContext;
@end

@implementation DUCoreDataManager

+ (DUCoreDataManager *) sharedManager {
    static DUCoreDataManager * __sharedCDManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // Make sure the init is done on the main queue
        __sharedCDManager = [[DUCoreDataManager alloc] init];
    });
	
	return __sharedCDManager;
}

- (id) init {
    self = [super init];
    if (self) {        
    }
    return self;
}


- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void) setupWithStoreName:(NSString *)storeName inBundle:(NSBundle *)bundle {
    [self setupWithStoreName:storeName inBundle:bundle modelsToMerge:nil];
}

- (void) setupWithStoreName:(NSString *)storeName inBundle:(NSBundle *)bundle modelsToMerge:(NSArray *)otherModels {
    NSAssert(bundle, @"You must pass a bundle");
    NSAssert(![storeName hasSuffix:@".momd"], @"The store name must NOT end in .momd");
    
    
    
    NSString *path = [bundle pathForResource:[storeName stringByDeletingPathExtension]
                                                     ofType:@"momd"];
    NSURL *modelUrl = [NSURL fileURLWithPath:path];
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelUrl];
    
    if (otherModels) {
        NSMutableArray *allModels = [NSMutableArray arrayWithArray:otherModels];
        [allModels addObject:model];
        
        NSMutableArray *finalModels = [NSMutableArray arrayWithCapacity:0];
        
        NSMutableArray *updatedEntities = [NSMutableArray arrayWithCapacity:0];
        for (NSManagedObjectModel *immutableModel in allModels) {
            NSManagedObjectModel *model = [immutableModel mutableCopy];
            for (NSEntityDescription *entity in [model entities]) {
                if ([[[entity userInfo] objectForKey:@"TempPlaceholder"] boolValue]) {
                    // Ignore placeholder.
                    DULog(@"Ignoring: %@", entity.name);
                } else {
                    [updatedEntities addObject:entity];
                }
            }
            [model setEntities:updatedEntities];
            [updatedEntities removeAllObjects];
            [finalModels addObject:model];
        }
        
        model = [NSManagedObjectModel modelByMergingModels:finalModels];
    }

    [NSManagedObjectModel MR_setDefaultManagedObjectModel:model];
    
    [self setupWithStoreName:storeName];
}

- (void) setupWithStoreName:(NSString *)storeName {
    
    //Set up core data
    NSPersistentStoreCoordinator *coordinator = [NSPersistentStoreCoordinator MR_coordinatorWithAutoMigratingSqliteStoreNamed:storeName];
    [NSPersistentStoreCoordinator MR_setDefaultStoreCoordinator:coordinator];
    
    //Now create a background context that saves to disk
    _diskWritingContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [_diskWritingContext setPersistentStoreCoordinator:[NSPersistentStoreCoordinator MR_defaultStoreCoordinator]];
    
    //Now setup main one
    NSManagedObjectContext *mainManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    mainManagedObjectContext.parentContext = self.diskWritingContext;
    //        NSMergePolicy *mergePolicy = [[[NSMergePolicy alloc] initWithMergeType:NSMergeByPropertyObjectTrumpMergePolicyType] autorelease];
    //        mainManagedObjectContext.mergePolicy = mergePolicy;
    [NSManagedObjectContext MR_setDefaultContext:mainManagedObjectContext];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextDidSave:) name:NSManagedObjectContextDidSaveNotification object:nil];
}


#pragma mark - Core Data Stack

- (NSPersistentStoreCoordinator *) coordinator {
    NSManagedObjectModel *model = [NSManagedObjectModel MR_defaultManagedObjectModel];
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    [NSPersistentStoreCoordinator MR_setDefaultStoreCoordinator:coordinator];
    return coordinator;
}

#pragma mark - iCloud Setup

- (void) setupRecreatingFromRemoteStorWithStoreName:(NSString *)storeName iCloudID:(NSString *)key {
//    [self setupWithStoreName:storeName iCloudID:key options:@{NSPersistentStoreRebuildFromUbiquitousContentOption: [NSNumber numberWithBool:YES]}];
}

- (void) setupClearingRemoteStorWithStoreName:(NSString *)storeName iCloudID:(NSString *)key {
    
//    NSString *contentName = [key stringByReplacingOccurrencesOfString:@"." withString:@"~"];
//    NSDictionary *options = @{
//                              NSPersistentStoreUbiquitousContentNameKey: contentName,
//                              NSPersistentStoreUbiquitousContainerIdentifierKey: key,
//                              NSPersistentStoreRemoveUbiquitousMetadataOption: [NSNumber numberWithBool:YES]};
//    
//    
//    //First remove
//    NSError *error = nil;
//    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:storeName];
    
//    @try {
//        BOOL deleted = [NSPersistentStoreCoordinator removeUbiquitousContentAndPersistentStoreAtURL:storeURL options:options error:&error];
//    }
//    @catch (NSException *exception) {
//        
//    }
//    @finally {
//        
//    }
    
    
    
    [self setupWithStoreName:storeName iCloudID:key];
}

- (void) setupWithStoreName:(NSString *)storeName iCloudID:(NSString *)key {
    
    //Set up core data
    NSPersistentStoreCoordinator *coordinator = [self coordinator];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextDidSave:) name:NSManagedObjectContextDidSaveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(iCloudStoreDidChange:) name:NSPersistentStoreCoordinatorStoresDidChangeNotification object:coordinator];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(iCloudStoreWillChange:) name:NSPersistentStoreCoordinatorStoresWillChangeNotification object:coordinator];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(iCloudStoreContentDidChange:) name:NSPersistentStoreDidImportUbiquitousContentChangesNotification object:coordinator];
    
    
    
    
    NSString *contentName = [key stringByReplacingOccurrencesOfString:@"." withString:@"~"];
    NSDictionary *options = @{NSInferMappingModelAutomaticallyOption : @YES,
                              NSMigratePersistentStoresAutomaticallyOption : @YES,
                              NSPersistentStoreUbiquitousContentNameKey: contentName,
                              NSPersistentStoreUbiquitousContainerIdentifierKey: key};
//    if (extraOptions) {
//        NSMutableDictionary *moreOptions = [NSMutableDictionary.alloc initWithDictionary:options];
//        [moreOptions addEntriesFromDictionary:extraOptions];
//        options = [moreOptions mutableCopy];
//    }
    
    
    NSError *error = nil;
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:storeName];
    NSPersistentStore *store = [coordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                         configuration:nil
                                                                   URL:storeURL
                                                               options:options
                                                                 error:&error];
    if (!store) {
        //What went wrong
        NSLog(@"Error %@", error);
    }
    
    
    // Context
    NSManagedObjectContext *mainManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [mainManagedObjectContext setPersistentStoreCoordinator:coordinator];
    [NSManagedObjectContext MR_setDefaultContext:mainManagedObjectContext];
    
    
}

#pragma mark - iCloud

- (void) iCloudStoreContentDidChange:(NSNotification *)notification {
    // merge changes from managed object
    [MainContext performBlock:^{
        [MainContext mergeChangesFromContextDidSaveNotification:notification];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:CoreDataUpdatedExternally object:nil userInfo:nil];
        });
    }];
}

- (void) iCloudStoreWillChange:(NSNotification *)notification {
    // You might like to block any user saves at this point
    
    // I you log into another iCloud account, this is still called and you should save. If you log back into
    // that iCloud account - the changes will be pushed up
    [DUCoreDataManager saveMainContext];
    [MainContext reset];
    // Now reset the UI
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:CoreDataUpdatedExternally object:nil userInfo:nil];
    });
}

- (void) iCloudStoreDidChange:(NSNotification *)notification {
    // This is also called if you log into another iCloud account
    
    // ...you can call save again
    
    // Need to notify the app to reload a page... etc
    
    // You might like to re-enable user saves at this point
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:kMagicalRecordPSCDidCompleteiCloudSetupNotification object:nil userInfo:nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:CoreDataUpdatedExternally object:nil userInfo:nil];
    });    
}

#pragma mark - Saving Context


+ (void) saveMainContext {
    DUCoreDataManager *coreData = [DUCoreDataManager sharedManager];
    
    NSManagedObjectContext *mainContext = MainContext;
	if ([mainContext hasChanges]) {
		[mainContext performBlockAndWait:^{
			
			NSError *error = nil;
			NSSet *insertedObjects = [mainContext insertedObjects];
			if (insertedObjects.count) {
				BOOL success = [mainContext obtainPermanentIDsForObjects:[insertedObjects allObjects] error:&error];
				if (!success) {
					ErrorLog(@"Couldn't get the permanent id's %@", error);
				}
			}
			
			[coreData performSaveOfContext:mainContext];
			
			[coreData.diskWritingContext performBlock:^{
				[coreData performSaveOfContext:coreData.diskWritingContext];
			}];
			
		}];
	}
}

- (void) performSaveOfContext:(NSManagedObjectContext *)context {
    NSError *error = nil;
    BOOL savedOK = [context save:&error];
    
    if (!savedOK) {
        //  *** STOP, LOOK AND LISTEN ***
        //
        //  Don't comment this out. If it's throwing an exception here, then there is a problem. Fix it fool.
        
        ErrorLog(@"There is an error with saving core data %@", error);
        
#ifdef DEBUG
        
        NSSet __unused *registeredObjects = [context registeredObjects];
        NSSet __unused *insertedObjects = [context insertedObjects];
        NSSet __unused *deletedObjects = [context deletedObjects];
        NSSet __unused *updatedObjects = [context updatedObjects];
        
        @throw [NSException exceptionWithName:@"Core Data Save Error" reason:@"Look at the logs, this only crashes in DEBUG mode, but you should figure out what is going wrong" userInfo:nil];
#endif
        
        ErrorLog(@"Failed to save to data store: %@", [error localizedDescription]);
        NSArray *detailedErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
        if (detailedErrors != nil && [detailedErrors count] > 0) {
            for (NSError *detailedError in detailedErrors) {
                ErrorLog(@"  DetailedError: %@", [detailedError userInfo]);
            }
        } else {
            ErrorLog(@"  %@", [error userInfo]);
        }

    }    
}

+ (void) saveContext:(NSManagedObjectContext *)context {
    DUCoreDataManager *coreData = [DUCoreDataManager sharedManager];
    if (context == MainContext) {
        [DUCoreDataManager saveMainContext];
    } else {
        
		if ([context hasChanges]) {
									
			[context performBlockAndWait:^{
				
				NSError *error = nil;
				NSSet *insertedObjects = [context insertedObjects];
				if (insertedObjects.count) {
					BOOL success = [context obtainPermanentIDsForObjects:[insertedObjects allObjects] error:&error];
					if (!success) {
						ErrorLog(@"Couldn't get the permanent id's %@", error);
					}
				}				
				
				[coreData performSaveOfContext:context];				
				[DUCoreDataManager saveMainContext];
			}];
		}
    }
}

- (void) contextDidSave:(NSNotification *)notification {
    //The userInfo dictionary contains the following keys: NSInsertedObjectsKey, NSUpdatedObjectsKey, and NSDeletedObjectsKey.
	
#ifdef DEBUG
//	NSArray *deletedObjects = [notification.userInfo objectForKey:NSDeletedObjectsKey];
//	NSArray *insertedObjects = [notification.userInfo objectForKey:NSInsertedObjectsKey];
//	NSArray *updatedObjects = [notification.userInfo objectForKey:NSUpdatedObjectsKey];
//	
//	DLog(@"%i Updated %i Inserted %i Deleted", updatedObjects.count, insertedObjects.count, deletedObjects.count);
#endif
	
}

// The useful of this method is that if you are performing a block of code on the main thread on the main
// context, then you don't actually need to use the performBlockAndWait method - which could potentially
// have blocking side effects (which i've noticed) when you have lots of busy threads
+ (void) performBlockAndWaitOnContext:(NSManagedObjectContext *)context block:( void (^)(void) )block {
	if ([NSThread isMainThread] && context == MainContext) {
		block();
	} else {
		[context performBlockAndWait:block];
	}
}


//- (void)cleanAndResetupStore
//{
//    NSError *error = nil;
//	
//    NSURL *storeURL = [NSPersistentStore MR_urlForStoreName:@"CoreData"];
//	
//    [MagicalRecord cleanUp];
//	
//    if([[NSFileManager defaultManager] removeItemAtURL:storeURL error:&error]){
//        [self setup];
//    }
//    else{
//        NSLog(@"An error has occurred while deleting store");
//        NSLog(@"Error description: %@", error.description);
//    }
//}

@end

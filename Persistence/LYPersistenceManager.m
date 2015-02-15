//
//  LYPersistenceManager.m
//  LYCoreDataModule
//
//  Created by Jin Lingyun on 15-2-15.
//  Copyright (c) 2015年 LY. All rights reserved.
//

#import "LYPersistenceManager.h"

@interface LYPersistenceManager ()

@property (nonatomic, strong) NSManagedObjectContext *persistentStoreMOC;

@end

@implementation LYPersistenceManager

- (instancetype)initWithUserID:(long long)userID
{
    if (self = [super init]) {
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                                 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];

        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"LYCoreDataModuleDemo" withExtension:@"momd"];
        NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        NSPersistentStoreCoordinator *coordinator =
        [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        NSError *error;

        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *userPath = [LYPersistenceUtility userDirectoryForUserID:@(userID)];

        BOOL isDirectory = NO;
        BOOL isDirectoryExist = [fileManager fileExistsAtPath:userPath isDirectory:&isDirectory];
        if (!(isDirectoryExist && isDirectory)) {
            if (![fileManager createDirectoryAtPath:userPath withIntermediateDirectories:YES attributes:nil error:nil]) {
                NSAssert(NO, @"Failed to create home directory for user:%lld at path:%@", userID, userPath);
                return nil;
            }
            LYLogInfo(@"Home directory for user:%lld has created at path:%@", userID, userPath);
        }
        NSString *DBFilePath = [userPath stringByAppendingPathComponent:@"RMChat.db"];
        NSURL *DBFileURL = [NSURL fileURLWithPath:DBFilePath];
        NSPersistentStore *store = [coordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                             configuration:nil
                                                                       URL:DBFileURL
                                                                   options:options
                                                                     error:&error];
        if (error) {
            error = nil;
            // If failed to create store, remove the old DB file, then try again.
            [[NSFileManager defaultManager] removeItemAtPath:DBFilePath error:nil];
            store = [coordinator addPersistentStoreWithType:NSSQLiteStoreType
                                              configuration:nil
                                                        URL:DBFileURL
                                                    options:options
                                                      error:&error];
        }
        NSAssert(store, @"Unresolved error %@, %@", error, [error userInfo]);

        self.persistentStoreMOC = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [self.persistentStoreMOC setPersistentStoreCoordinator:coordinator];
        self.persistentStoreMOC.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;

        self.mainMOC = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        self.mainMOC.parentContext = self.persistentStoreMOC;
        self.mainMOC.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;

        self.privateMOC = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        self.privateMOC.parentContext = self.mainMOC;
        self.privateMOC.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mocDidSave:) name:NSManagedObjectContextDidSaveNotification object:self.mainMOC];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)mocDidSave:(NSNotification *)notify
{
    if (notify.object == self.mainMOC) {
        [self.privateMOC performBlock:^{
            [self.privateMOC mergeChangesFromContextDidSaveNotification:notify];
        }];
    }
}

- (id)createObjectForEntityForName:(NSString *)name InManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    __block NSManagedObject *object;
    [managedObjectContext performBlockAndWait:^{
       object = [managedObjectContext insertNewObjectForEntityForName:name];
    }];
    return object;
}

- (id)refetchedValue:(id)value InManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    __block id refetchedValue;
    [managedObjectContext performBlockAndWait:^{
        refetchedValue = RefetchedValueInManagedObjectContext(value, managedObjectContext);
    }];
    return refetchedValue;
}

static id RefetchedValueInManagedObjectContext(id value, NSManagedObjectContext *managedObjectContext)
{
    if (! value) {
        return value;
    } else if ([value isKindOfClass:[NSArray class]]) {
        NSMutableArray *newValue = [[NSMutableArray alloc] initWithCapacity:[value count]];
        for (__strong id object in value) {
            if ([object isKindOfClass:[NSManagedObject class]]) object = RefetchManagedObjectInContext(object, managedObjectContext);
            if (object) [newValue addObject:object];
        }
        return newValue;
    } else if ([value isKindOfClass:[NSSet class]]) {
        NSMutableSet *newValue = [[NSMutableSet alloc] initWithCapacity:[value count]];
        for (__strong id object in value) {
            if ([object isKindOfClass:[NSManagedObject class]]) object = RefetchManagedObjectInContext(object, managedObjectContext);
            if (object) [newValue addObject:object];
        }
        return newValue;
    } else if ([value isKindOfClass:[NSOrderedSet class]]) {
        NSMutableOrderedSet *newValue = [NSMutableOrderedSet orderedSet];
        [(NSOrderedSet *)value enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
            if ([object isKindOfClass:[NSManagedObject class]]) object = RefetchManagedObjectInContext(object, managedObjectContext);
            if (object) [newValue setObject:object atIndex:index];
        }];
        return newValue;
    } else if ([value isKindOfClass:[NSManagedObject class]]) {
        return RefetchManagedObjectInContext(value, managedObjectContext);
    }

    return value;
}

static NSManagedObject *RefetchManagedObjectInContext(NSManagedObject *managedObject, NSManagedObjectContext *managedObjectContext)
{
    __block NSManagedObjectID *managedObjectID;
    managedObjectID = managedObject.objectID;
    if (!managedObjectID || [managedObjectID isTemporaryID]) {
        return nil;
    }
    NSError *error = nil;
    NSManagedObject *refetchedObject = [managedObjectContext existingObjectWithID:managedObjectID error:&error];
    if (! refetchedObject) {
        LYLogError(@"Failed to refetch managed object with ID %@: %@", managedObjectID, error);
    }
    return refetchedObject;
}

@end

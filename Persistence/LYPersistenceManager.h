//
//  LYPersistenceManager.h
//  LYCoreDataModule
//
//  Created by Jin Lingyun on 14-8-15.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYPersistenceGlobalHeader.h"

@interface LYPersistenceManager : NSObject

@property (nonatomic, strong) NSManagedObjectContext *mainMOC;
@property (nonatomic, strong) NSManagedObjectContext *privateMOC;

- (instancetype)initWithUserID:(long long)userID;
- (id)createObjectForEntityForName:(NSString *)name InManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

- (id)refetchedValue:(id)value InManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end

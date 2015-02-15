//
//  LYPersistenceManager+MessageService.h
//  LYCoreDataModuleDemo
//
//  Created by Jin Lingyun on 15-2-15.
//  Copyright (c) 2015年 LY. All rights reserved.
//

#import "LYPersistenceManager.h"

@class LYChatMessage;
@class LYChatSession;

@interface LYPersistenceManager (MessageService)

- (LYChatMessage *)messageWithMsgKey:(int64_t)MsgKey InManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
- (LYChatMessage *)messageWithLocalID:(int64_t)localID InManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end

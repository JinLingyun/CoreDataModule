//
//  LYPersistenceManager+MessageService.m
//  LYCoreDataModuleDemo
//
//  Created by Jin Lingyun on 15-2-15.
//  Copyright (c) 2015年 LY. All rights reserved.
//

#import "LYPersistenceManager+MessageService.h"
#import "LYChatMessage.h"
#import "LYChatSession.h"

NSString * const kChatMessageMsgKey = @"msgKey";
NSString * const kChatMessageLocalIDKey = @"localID";

@implementation LYPersistenceManager (MessageService)

- (LYChatMessage *)messageWithMsgKey:(int64_t)MsgKey InManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    __block NSError *error = nil;
    __block NSArray *results = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:LYChatMessage.class.description];
    NSPredicate *query = [NSPredicate predicateWithFormat:@"(%K == %lld)",kChatMessageMsgKey, MsgKey];
    request.predicate = query;
    [managedObjectContext performBlockAndWait:^{
        results = [managedObjectContext executeFetchRequest:request error:&error];
    }];
    NSAssert(!error, @"fetch message by '%@' failed. %@",kChatMessageMsgKey, error.userInfo);
    if ([results count]) {
        return results[0];
    }
    return nil;
}

- (LYChatMessage *)messageWithLocalID:(int64_t)localID InManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    __block NSError *error = nil;
    __block NSArray *results = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:LYChatMessage.class.description];
    NSPredicate *query = [NSPredicate predicateWithFormat:@"(%K == %lld)", kChatMessageLocalIDKey, localID];
    request.predicate = query;
    [managedObjectContext performBlockAndWait:^{
        results = [managedObjectContext executeFetchRequest:request error:&error];
    }];
    NSAssert(!error, @"fetch message by '%@' failed. %@",kChatMessageLocalIDKey, error.userInfo);
    if ([results count]) {
        return results[0];
    }
    return nil;
}


@end

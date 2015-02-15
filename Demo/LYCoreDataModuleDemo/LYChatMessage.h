//
//  LYChatMessage.h
//  LYCoreDataModuleDemo
//
//  Created by Jin Lingyun on 15-2-15.
//  Copyright (c) 2015年 LY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class LYChatSession;

@interface LYChatMessage : NSManagedObject

@property (nonatomic) int32_t chatType;
@property (nonatomic) int32_t contentType;
@property (nonatomic, retain) NSString * fromUserID;
@property (nonatomic) BOOL hidden;
@property (nonatomic) int32_t identity;
@property (nonatomic) int64_t lastMsgKey;
@property (nonatomic) int32_t legal;
@property (nonatomic) int64_t localID;
@property (nonatomic) int64_t msgKey;
@property (nonatomic) int32_t sendState;
@property (nonatomic, retain) NSString * sessionID;
@property (nonatomic) int32_t strongWeakType;
@property (nonatomic) int64_t time;
@property (nonatomic, retain) NSString * toUserID;
@property (nonatomic, retain) LYChatSession *session;

@end

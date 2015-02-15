//
//  LYChatSession.h
//  LYCoreDataModuleDemo
//
//  Created by Jin Lingyun on 15-2-15.
//  Copyright (c) 2015年 LY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class LYChatMessage;

@interface LYChatSession : NSManagedObject

@property (nonatomic) int32_t completeState;
@property (nonatomic, retain) NSString * draft;
@property (nonatomic) NSTimeInterval draftDate;
@property (nonatomic, retain) NSString * feedContent;
@property (nonatomic) int64_t feedID;
@property (nonatomic, retain) NSString * feedSystemBackgroundImageTemplate;
@property (nonatomic, retain) NSString * feedUserBackgroundImageURL;
@property (nonatomic) int32_t feedVoiceLength;
@property (nonatomic) BOOL isInBlackList;
@property (nonatomic) BOOL isRead;
@property (nonatomic) NSTimeInterval lastActiveDate;
@property (nonatomic) int64_t latestMsgKey;
@property (nonatomic, retain) NSString * randomChatImageURL;
@property (nonatomic, retain) NSString * sessionID;
@property (nonatomic, retain) NSString * sessionName;
@property (nonatomic) int32_t sessionType;
@property (nonatomic, retain) NSString * targetHeadURL;
@property (nonatomic, retain) NSString * targetID;
@property (nonatomic, retain) NSString * targetName;
@property (nonatomic, retain) NSOrderedSet *messages;
@end

@interface LYChatSession (CoreDataGeneratedAccessors)

- (void)insertObject:(LYChatMessage *)value inMessagesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromMessagesAtIndex:(NSUInteger)idx;
- (void)insertMessages:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeMessagesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInMessagesAtIndex:(NSUInteger)idx withObject:(LYChatMessage *)value;
- (void)replaceMessagesAtIndexes:(NSIndexSet *)indexes withMessages:(NSArray *)values;
- (void)addMessagesObject:(LYChatMessage *)value;
- (void)removeMessagesObject:(LYChatMessage *)value;
- (void)addMessages:(NSOrderedSet *)values;
- (void)removeMessages:(NSOrderedSet *)values;
@end

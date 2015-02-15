//
//  ViewController.m
//  LYCoreDataModuleDemo
//
//  Created by Jin Lingyun on 15-2-15.
//  Copyright (c) 2015年 LY. All rights reserved.
//

#import "ViewController.h"
#import "LYPersistenceGlobalHeader.h"
#import "LYPersistenceManager.h"
#import "LYPersistenceManager+MessageService.h"
#import "LYChatMessage.h"

@interface ViewController ()

@property (nonatomic, strong) LYPersistenceManager *persistenceManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // test number of userID, input your own userID
    long long userID = 10010;
    self.persistenceManager = [[LYPersistenceManager alloc] initWithUserID:userID];
    
    int64_t localID = [[NSDate date] timeIntervalSince1970];
    LYChatMessage *chatMessage = [self.persistenceManager createObjectForEntityForName:NSStringFromClass(LYChatMessage.class) InManagedObjectContext:self.persistenceManager.mainMOC];
    chatMessage.localID = localID;
    chatMessage.msgKey = 1008;
    [self.persistenceManager.mainMOC performBlockAndWait:^{
        [self.persistenceManager.mainMOC saveToPersistentStore:nil];
    }];
    
    LYChatMessage *testMessage = [self.persistenceManager messageWithLocalID:localID InManagedObjectContext:self.persistenceManager.mainMOC];
    if (chatMessage == testMessage) {
        NSLog(@"LYChatMessage insert and select success");
    } else {
        NSLog(@"LYChatMessage insert and select fail");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

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

@interface ViewController ()

@property (nonatomic, strong) LYPersistenceManager *persistenceManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // test number of userID, input your own userID
    long long userID = 10010;
    self.persistenceManager = [[LYPersistenceManager alloc] initWithUserID:userID];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

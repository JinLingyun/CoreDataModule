//
//  LYPersistenceGlobalHeader.h
//  LYCoreDataModule
//
//  Created by Jin Lingyun on 15-2-15.
//  Copyright (c) 2015年 LY Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#ifdef DEBUG
#define LYLogError(frmt, ...) NSLog(frmt, ##__VA_ARGS__)
#define LYLogInfo(frmt, ...) NSLog(frmt, ##__VA_ARGS__)
#else
#define LYLogError(frmt, ...) {}
#define LYLogInfo(frmt, ...) {}
#endif

@interface LYPersistenceUtility : NSObject

+ (NSString *)userDirectoryForUserID:(NSNumber *)userID;

@end

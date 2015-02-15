//
//  LYPersistenceGlobalHeader.m
//  LYCoreDataModule
//
//  Created by Jin Lingyun on 15-2-15.
//  Copyright (c) 2015年 LY Inc. All rights reserved.
//

#import "LYPersistenceGlobalHeader.h"

@implementation LYPersistenceUtility

+ (NSString *)userDirectoryForUserID:(NSNumber *)userID
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = paths[0];

    NSString      *userPath = [documentDirectory stringByAppendingPathComponent:userID.stringValue];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL          isDirectory = NO;
    BOOL          isDirectoryExist = [fileManager fileExistsAtPath:userPath isDirectory:&isDirectory];
    
    if (!(isDirectoryExist && isDirectory)) {
        if (![fileManager createDirectoryAtPath:userPath withIntermediateDirectories:YES attributes:nil error:nil]) {
            NSAssert(NO, @"Failed to create home directory for user:%@ at path:%@", userID, userPath);
            return userPath;
        }
        
        LYLogInfo(@"Home directory for user:%@ has created at path:%@", userID, userPath);
    }
    
    return userPath;
}

@end
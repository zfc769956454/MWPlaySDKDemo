//
//  DateBaseHelper.m
//  SouthChina
//
//  Created by creator_lq on 14/12/3.
//  Copyright (c) 2014年 科创. All rights reserved.
//

#import "DataBaseHelper.h"

@implementation DataBaseHelper

+(FMDatabase*)openDateBase
{
    FMDatabase *db = [FMDatabase databaseWithPath:[NSString stringWithFormat:@"%@DBArray.sqlite",[[[DataBaseHelper alloc] init] dataPath]]];
    if (![db open]) {
        NSLog(@"数据库打开失败");
        return nil;
    }else{
        NSLog(@"数据库打开成功=%@",[NSString stringWithFormat:@"%@DBArray.sqlite",[[[DataBaseHelper alloc] init] dataPath]]);

    }
    return db;
}

-(NSString*)appPath
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [NSString stringWithFormat:@"%@/",[paths objectAtIndex:0]];
}

-(NSString*)mainPath
{
    NSString* path = [NSString stringWithFormat:@"%@%@/",self.appPath,mw_mineUserId];
    if ( ![self checkPath:path] )
    {
        [self createDir:path];
    }
    return path;
}

-(NSString*)dataPath
{
    NSString* path = [NSString stringWithFormat:@"%@%@/",self.mainPath,@"data"];
    if ( ![self checkPath:path] )
    {
        [self createDir:path];
    }
    return path;
}

-(BOOL)checkPath:(NSString*)path
{
    BOOL isDir = NO;
    NSFileManager* fm = [NSFileManager defaultManager];
    BOOL ret = [fm fileExistsAtPath:path isDirectory:&isDir];
    return ret || isDir;
}

-(BOOL)createDir:(NSString*)path
{
    NSFileManager* fm = [NSFileManager defaultManager];
    return [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
}

@end

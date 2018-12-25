//
//  BKVideoDao.m
//  MontnetsLiveKing
//
//  Created by 谢敏 on 2017/11/29.
//  Copyright © 2017年 facebac.com. All rights reserved.
//

#import "MWVideoDBManger.h"
#import "FMDatabaseQueue.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"

//录像数据库常量
#define TABLE_VIDEO        @"videoTable"
#define DB_TABLE_VIDEO     @"/video.db"
#define BKVIDEOTableID     @"_id"

#define BKVideoID           @"video_id"
#define BKLastWatchTime     @"lastWatchTime"

@interface MWVideoDBManger ()


@end

@implementation MWVideoDBManger

+ (BOOL)insertOrReplaceVideo:(MWVideoDetailModel*)videoInfo
{
    if (!videoInfo.liveId || [videoInfo.liveId isKindOfClass:[NSNull class]] || videoInfo.liveId.length<=1) {
        return NO;
    }
    
    FMDatabase *_dataBase = [DataBaseHelper openDateBase];
    [self checkTableCreatedInDb:_dataBase];
    
    NSString * delsql = [NSString stringWithFormat:@"DELETE from %@ where %@ ='%@'",TABLE_VIDEO,BKVideoID,videoInfo.liveId];
    [_dataBase executeUpdate:delsql];
    
    NSString *insertSql = [[NSString alloc] initWithFormat:@"INSERT INTO %@ ('%@', '%@') values (?, ?)",TABLE_VIDEO, BKVideoID,BKLastWatchTime];

    BOOL worked = [_dataBase executeUpdate:insertSql, videoInfo.liveId,[NSNumber numberWithInt:videoInfo.lastWatchTime]];
    
    [_dataBase close];
    return worked;
}

+ (MWVideoDetailModel*)queryVideoInfoWithVideoID:(NSString*)videoID{

    if (!videoID || [videoID isKindOfClass:[NSNull class]] || videoID.length<=1) {
        return nil;
    }
    
    FMDatabase *_dataBase = [DataBaseHelper openDateBase];
    [self checkTableCreatedInDb:_dataBase];
    
    NSString *sql = [[NSString alloc] initWithFormat:@"select * from %@ where %@ = %@", TABLE_VIDEO,BKVideoID,videoID];

    FMResultSet *rs = [_dataBase executeQuery:sql];
    
    MWVideoDetailModel *model;
    while ([rs next]) {
        model = [[MWVideoDetailModel alloc] initWithResult:rs];
    };

    [rs close];
    [_dataBase close];
    return model;
}

+(BOOL)deleteVideoById:(NSString*)videoID{
    FMDatabase *_dataBase = [DataBaseHelper openDateBase];
    [self checkTableCreatedInDb:_dataBase];
    
    NSString * delsql = [NSString stringWithFormat:@"DELETE from %@ where %@ ='%@'",TABLE_VIDEO,BKVideoID,videoID];
    [_dataBase executeUpdate:delsql];
    [_dataBase close];
    return NO;
}

+(BOOL)checkTableCreatedInDb:(FMDatabase *)db

{
    NSString *createTable = [[NSString alloc] initWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT,'%@' TEXT, '%@' INTEGER)", TABLE_VIDEO,BKVIDEOTableID, BKVideoID, BKLastWatchTime];
    
    BOOL worked = [db executeUpdate:createTable];
    FMDBQuickCheck(worked);
    return worked;
    
}

//删除旧数据信息
- (void)deleteDatabse
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:self.DBPath])
    {
        NSError *error = nil;
        if (![fileManager removeItemAtPath:self.DBPath error:nil])
        {
            NSAssert1(0, @"Failed to delete old database file with videoTable '%@'.", [error localizedDescription]);
        }
    }
}

- (NSString *)getArchiveFilePath:(NSString*)pathName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths firstObject];
    NSString *filePath = [cachePath stringByAppendingFormat:@"/%@",pathName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        BOOL result = [[NSFileManager defaultManager] createDirectoryAtPath:filePath
                                                withIntermediateDirectories:NO
                                                                 attributes:nil
                                                                      error:nil];
        if (!result)
            return cachePath;
    }
    
    return filePath;
}

@end

//
//  BKVideoDao.m
//  MontnetsLiveKing
//
//  Created by 谢敏 on 2017/11/29.
//  Copyright © 2017年 facebac.com. All rights reserved.
//

#import "BKVideoDao.h"
#import "MWKingMyVideoModel.h"
#import "FMDatabaseQueue.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"

@interface BKVideoDao ()


@end

@implementation BKVideoDao

+ (BOOL)insertOrReplaceVideo:(MWKingMyVideoModel*)videoInfo
{
    if (!videoInfo.video_id || [videoInfo.video_id isKindOfClass:[NSNull class]] || videoInfo.video_id.length<=1) {
        return NO;
    }
    
    FMDatabase *_dataBase = [DataBaseHelper openDateBase];
    [self checkTableCreatedInDb:_dataBase];
    
    NSString * delsql = [NSString stringWithFormat:@"DELETE from %@ where %@ ='%@'",TABLE_VIDEO,BKVideoID,videoInfo.video_id];
    [_dataBase executeUpdate:delsql];
    
    NSString *insertSql = [[NSString alloc] initWithFormat:@"INSERT INTO %@ ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@') values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",TABLE_VIDEO, BKVideoID, BKRecordTime, BKFilePath, BKVideoName, BKVideoCoverUrl, BKLiveId, BKVideoDuration, BKShareurl, BKLiveName, BKLiveText, BKLiveCoverUrl, BKLiveTextImgs, BKLivePermit, BKVideoDirec, BKVbitrate, BKUserId, BKHeadUrl, BKPlayCount, BKUserTitle, BKViewPass, BKLastWatchTime];

    BOOL worked = [_dataBase executeUpdate:insertSql, videoInfo.video_id, videoInfo.record_time, videoInfo.file_path, videoInfo.video_name, videoInfo.video_cover_url,videoInfo.live_id,[NSNumber numberWithDouble:videoInfo.duration],videoInfo.share_url,videoInfo.live_name,videoInfo.live_text,videoInfo.live_cover_url,videoInfo.live_text_imgs,[NSNumber numberWithInteger:videoInfo.live_permit],videoInfo.video_direc,videoInfo.vbitrate,videoInfo.user_id,videoInfo.head_url,videoInfo.play_count,videoInfo.user_title,videoInfo.view_pass,[NSNumber numberWithInt:videoInfo.lastWatchTime]];
    
    [_dataBase close];
    return worked;
}

+ (MWKingMyVideoModel*)queryVideoInfoWithVideoID:(NSString*)videoID{

    if (!videoID || [videoID isKindOfClass:[NSNull class]] || videoID.length<=1) {
        return nil;
    }
    
    FMDatabase *_dataBase = [DataBaseHelper openDateBase];
    [self checkTableCreatedInDb:_dataBase];
    
    NSString *sql = [[NSString alloc] initWithFormat:@"select * from %@ where %@ = %@", TABLE_VIDEO,BKVideoID,videoID];

    FMResultSet *rs = [_dataBase executeQuery:sql];
    
    MWKingMyVideoModel *model;
    while ([rs next]) {
        model = [[MWKingMyVideoModel alloc] initWithResult:rs];
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
    NSString *createTable = [[NSString alloc] initWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT,'%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' FLOAT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' INTEGER, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' INTEGER)", TABLE_VIDEO,BKVIDEOTableID, BKVideoID, BKRecordTime, BKFilePath, BKVideoName, BKVideoCoverUrl, BKLiveId, BKVideoDuration, BKShareurl, BKLiveName, BKLiveText, BKLiveCoverUrl, BKLiveTextImgs, BKLivePermit, BKVideoDirec, BKVbitrate, BKUserId, BKHeadUrl, BKPlayCount, BKUserTitle, BKViewPass, BKLastWatchTime];
    
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

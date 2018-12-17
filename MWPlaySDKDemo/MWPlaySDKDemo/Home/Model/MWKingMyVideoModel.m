//
//  BKLiveFirstModel.m
//  BaiKeLive
//
//  Created by chendb on 16/3/30.
//  Copyright © 2016年 simope. All rights reserved.
//

#import "MWKingMyVideoModel.h"


@implementation MWKingMyVideoModel

/**
 *  使用MJExtension解析的网络数据,如果数据中有系统关键字的字段,转模型的时候需要实现这个方法
 */
- (NSDictionary *)replacedKeyFromPropertyName{
    
    return @{@"video_id":@"video_id",@"video_cover_url":@"video_cover_url"};
}



- (id)initWithResult:(FMResultSet *)rs{
    self = [super init];
    if (self) {
        self.video_id = [rs stringForColumn:BKVideoID];
        self.record_time = [rs stringForColumn:BKRecordTime];
        self.file_path = [rs stringForColumn:BKFilePath];
        self.video_name = [rs stringForColumn:BKVideoName];
        self.video_cover_url = [rs stringForColumn:BKVideoCoverUrl];
        self.live_id = [rs stringForColumn:BKLiveId];
        self.duration = [rs doubleForColumn:BKVideoDuration];
        self.share_url = [rs stringForColumn:BKShareurl];
        self.live_name = [rs stringForColumn:BKLiveName];
        self.live_text = [rs stringForColumn:BKLiveText];
        self.live_cover_url = [rs stringForColumn:BKLiveCoverUrl];
        self.live_text_imgs = [rs stringForColumn:BKLiveTextImgs];
        self.live_permit = [rs intForColumn:BKLivePermit];
        self.video_direc = [rs stringForColumn:BKVideoDirec];
        self.vbitrate = [rs stringForColumn:BKVbitrate];
        self.user_id = [rs stringForColumn:BKUserId];
        self.head_url = [rs stringForColumn:BKHeadUrl];
        self.play_count = [rs stringForColumn:BKPlayCount];
        self.user_title = [rs stringForColumn:BKUserTitle];
        self.view_pass = [rs stringForColumn:BKViewPass];
        self.lastWatchTime = [rs intForColumn:BKLastWatchTime];
    }
    return self;
}

@end

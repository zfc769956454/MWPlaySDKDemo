//
//  BKVideoDao.h
//  MontnetsLiveKing
//
//  Created by 谢敏 on 2017/11/29.
//  Copyright © 2017年 facebac.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataBaseHelper.h"
#import "MWVideoDetailModel.h"

@class FMDatabaseQueue;


@interface MWVideoDBManger : NSObject

@property (nonatomic, readonly, strong) FMDatabaseQueue *dataBaseQueue;
@property (nonatomic, readonly, copy  ) NSString        *DBPath;

+ (BOOL)insertOrReplaceVideo:(MWVideoDetailModel*)videoInfo;

+ (MWVideoDetailModel*)queryVideoInfoWithVideoID:(NSString*)videoID;

+ (BOOL)deleteVideoById:(NSString*)videoID;

@end

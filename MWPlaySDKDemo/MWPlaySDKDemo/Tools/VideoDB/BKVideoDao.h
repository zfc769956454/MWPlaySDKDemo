//
//  BKVideoDao.h
//  MontnetsLiveKing
//
//  Created by 谢敏 on 2017/11/29.
//  Copyright © 2017年 facebac.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataBaseHelper.h"

@class FMDatabaseQueue;
@class MWKingMyVideoModel;

@interface BKVideoDao : NSObject

@property (nonatomic, readonly, strong) FMDatabaseQueue *dataBaseQueue;
@property (nonatomic, readonly, copy  ) NSString        *DBPath;

+ (BOOL)insertOrReplaceVideo:(MWKingMyVideoModel*)videoInfo;

+ (MWKingMyVideoModel*)queryVideoInfoWithVideoID:(NSString*)videoID;

+ (BOOL)deleteVideoById:(NSString*)videoID;

@end

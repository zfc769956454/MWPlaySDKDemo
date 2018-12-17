//
//  BKMontUserCenter.h
//  MontnetsLiveKing
//
//  Created by 谢敏 on 2017/7/17.
//  Copyright © 2017年 facebac.com. All rights reserved.
//

#import <Foundation/Foundation.h>


#ifdef DEBUG
//#define BKMontTimeShiftBaseUrl @"http://testtms.facebac.com"
#define BKMontTimeShiftBaseUrl @"http://tms.mvaas.cn"
#else
#define BKMontTimeShiftBaseUrl @"http://tms.mvaas.cn"
#endif

#define BKMontUserCenterBaseUrl [NSString stringWithFormat:@"%@",BKMONTNETS_DNS_USERCENTER]
#define BKMontLiveCenterBaseUrl [NSString stringWithFormat:@"%@",BKMONTNETS_DNS_LIVE]
#define BKMontSetupBaseUrl  [NSString stringWithFormat:@"%@",BKMONTNETS_DNS_SETUP]


typedef void (^CompleteBlock)(id responseObject, NSError *error);


@interface MWMontUserCenter : NSObject


/**
 查询socket相关

 @param liveId 直播id
 */
+ (void)querySocketInfoWithLiveId:(NSString *)liveId
                         complete:(CompleteBlock)complete;


/**
 获取直播列表
 */
+ (void)queryLiveListComplete:(CompleteBlock)complete;

/**
 获取直播详情
 */
+ (void)queryLiveDetailInfoWithLiveId:(NSString *)liveId
                               userId:(NSString *)userId
                             complete:(CompleteBlock)complete;


/**
 获取短视频列表
 */
+ (void)queryVideoListComplete:(CompleteBlock)complete;

/**
 获取短视频详情
 */
+ (void)queryVideoDetailInfoWithVideoId:(NSString *)videoId
                               complete:(CompleteBlock)complete ;

@end

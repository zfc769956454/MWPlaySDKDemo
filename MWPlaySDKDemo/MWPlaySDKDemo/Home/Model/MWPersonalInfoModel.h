//
//  BKPersonalInfoModel.h
//  MontnetsLiveKing
//
//  Created by lzp on 2017/10/30.
//  Copyright © 2017年 facebac.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MWPersonalInfo : NSObject<NSCoding>
@property(nonatomic,copy)NSString *userID;//用户ID
@property(nonatomic,copy)NSString *imgUrl;//头像地址
@property(nonatomic,copy)NSString *userName;//昵称
@property(nonatomic,copy)NSString *userIntro;//用户描述
@property(nonatomic,copy)NSString *fansNum;//粉丝个数
@property(nonatomic,copy)NSString *followNum;//关注个数
@property(nonatomic,copy)NSString *videoNum;//视频个数
@property(nonatomic,copy)NSString *isFollow;//是否关注
@property(nonatomic,copy)NSString *isBeFollow;//是否被关注
@property(nonatomic,copy)NSString *isDefaultFollow;//字段是否默认关注 0否1是
@property(nonatomic,copy)NSString *userNumber;//梦网id
@property(nonatomic,copy)NSString *qualify;//是否认证
@property(nonatomic,assign)NSInteger silence; //是否禁言 1 该用户被禁言 0没有被禁言
@property(nonatomic,assign)NSInteger blacklistUser;//是否加入了黑名单 1 黑名单 0 没有加入黑名单
@property(nonatomic,copy)NSString *releaseUrl;

@property (nonatomic,copy)NSString *surplus;
@property (nonatomic,copy)NSString *rate;

@end

@interface MWPersonalLiveInfo : NSObject<NSCoding>
@property(nonatomic,copy)NSString *liveID;//直播ID
@property(nonatomic,copy)NSString *activeId;//activeID
@property(nonatomic,copy)NSString *picUrl;//直播封面
@property(nonatomic,copy)NSString *liveName;//直播名称
@property(nonatomic,copy)NSString *totalViewers;//总观看次数
@property(nonatomic,copy)NSString *liveStartTime;//直播开始时间
@property(nonatomic,copy)NSString *curViewers;//当前在线人数
@property(nonatomic,assign)BKLiveStatus liveStatus;//直播状态，0 预约 1 正在直播 2回放 3直播异常 4预告过期 5录像删完，显示直播已结束
@property(nonatomic,copy)NSString *appointCount;//预约人数
@property(nonatomic,copy)NSString *livePermit;//加密	0:免费,1:私密,2付费
@property(nonatomic,assign)BKLivePermitType permitType;//加密    0:免费,1:私密,2付费

@property(nonatomic,copy)NSString *viewPass;//密码 livePermit 为加密时是密码，付费时是金额
@property(nonatomic,copy)NSString *releaseUrl;//分享地址
@property(nonatomic,copy)NSString *createTime;//时间戳，记录操作时间
@property(nonatomic,weak)UIImage *liveCorver;//封面，非后台回传字段


//历史记录接口新增字段
@property(nonatomic,copy)NSString *userID;//用户ID
@property(nonatomic,copy)NSString *imgUrl;//头像地址
@property(nonatomic,copy)NSString *userName;//昵称
@property(nonatomic,copy)NSString *peopleCount;//根据liveStatus确定是预约还是观看人数
@property(nonatomic,copy)NSString *videoID;//根据liveStatus确定是预约还是观看人数
@property(nonatomic,copy)NSString *isDefaultFollow;//字段是否默认关注 0否1是
@property(nonatomic,copy)NSString *qualify;//是否认证
@property(nonatomic,assign)BKLiveSwitch liveSwitch;//封禁状态 0：正常 1：欠费 2：封禁 3:下线（4.23新增）

@property (nonatomic, assign)  BKPersonalInfoType infoType;

/*********************************************
 2018-04-11新增的字段
 
 */

@property (nonatomic, assign) CGFloat surplus;
@property (nonatomic, assign) CGFloat rate;
@property (nonatomic,assign) int onlineCount;

/**
 观看权限：0是无权限 1有权限  2门票过期，已被注销或重置(v2.1.1新增)
 */
@property (nonatomic, assign) NSInteger isWatch;
/*
 end
 **********************************************/


//************************2.0新增 **********************
/**录像生成*/
@property (nonatomic, copy) NSString *isrecord;

/**创建直播间时的当前时间*/
@property (nonatomic, copy) NSString  *create_time;

/**直播间预定的开始时间*/
@property (nonatomic, copy) NSString  *begin_time;

/**开始直播的开始时间*/
@property (nonatomic, copy) NSString  *notify_begin_time;

/**直播结束的时间*/
@property (nonatomic, copy) NSString  *notify_end_time;


@end

@interface MWPersonalInfoModel : NSObject<NSCoding>
@property(nonatomic,copy)NSString *resultCode;//01:受理成功,02:参数错误
@property(nonatomic,copy)NSString *resultMsg;//返回结果信息描述
@property(nonatomic,copy)NSDictionary *params;
@property(nonatomic)MWPersonalInfo *userInfo;
@property(nonatomic)NSDictionary *liveParams;
@property(nonatomic,copy)NSArray<MWPersonalLiveInfo *> *liveInfoArray;
@end

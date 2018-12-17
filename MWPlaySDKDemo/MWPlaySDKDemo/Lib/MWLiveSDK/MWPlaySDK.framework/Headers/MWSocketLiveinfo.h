//
//  MWSocketLiveinfo.h
//  BaiKeMiJiaLive
//
//  Created by simope on 16/8/9.
//  Copyright © 2016年 facebac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MWSocketLiveinfo : NSObject

@property (nonatomic, assign) int total_views;//观看总次数
@property (nonatomic, assign) int room_online_users;//在线用户
@property (nonatomic, strong) NSString *msgbody;//消息体

//礼物
@property (nonatomic, copy) NSString  *giftName;//礼物名称
@property (nonatomic, copy) NSString  *giftImg;//礼物图片
@property (nonatomic, assign) int      giftID;//礼物id
@property (nonatomic, assign) int      giftNum;//礼物数量

//禁言
@property (nonatomic, assign) int       silence;   // 1 该用户被禁言  0 该用户没有被禁言
@property (nonatomic, copy) NSString    *user_id;
@property (nonatomic, copy) NSString    *nickname;  //禁言用户昵称
@property (nonatomic, copy) NSString    *silence_user_id;  //禁言用户ID
@property (nonatomic, copy) NSString    *msg_id;
@property (nonatomic, assign) int       silence_all;//全体禁言


/**主流直播状态
 0：直播预告或视频未审核
 1：直播中或视频上线
 2：直播结束或视频下线
 3：直播异常中断或视频审核不通过
 4：直播过期
 */
@property (nonatomic, assign) int       live_status;

/**次流直播状态
 0：直播预告或视频未审核
 1：直播中或视频上线
 2：直播结束或视频下线
 3：直播异常中断或视频审核不通过
 4：直播过期
 */
@property (nonatomic, assign) int       slave_status;


@property (nonatomic, copy)   NSString  *liveID;      //直播ID

@property (nonatomic, assign) int       customize_type; //自定义类型
@property (nonatomic, assign) int       back_run;//主播状态，1代表在后台运行  0代表恢复到前台推流

@end

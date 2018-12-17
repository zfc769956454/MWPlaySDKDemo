//
//  BKSocketLiveinfo.h
//  BaiKeMiJiaLive
//
//  Created by simope on 16/8/9.
//  Copyright © 2016年 facebac. All rights reserved.
//

#import <Foundation/Foundation.h>

#define     BKCustomizeMsgType_endLiveNotice     800;//主播结束直播
#define     BKCustomizeMsgType_compereStepOut    801; //主播暂离与恢复请求与通知   (前后台)


@interface BKSocketLiveinfo : NSObject

//观众加入房间的信息字段
@property (nonatomic, assign) int flowers_to_send;//本次收到的花朵数
@property (nonatomic, assign) int room_reviced_flowers;//收到的总花朵数
@property (nonatomic, assign) int total_views;//观看总次数
@property (nonatomic, assign) int total_amount;//好卷(主播获取的所有虚拟币余额)
@property (nonatomic, copy) NSArray *roommate;//已存在的观众
//主播加入房间的信息字段
@property (nonatomic, assign) int      room_online_users;//在线用户
@property (nonatomic, assign) int      is_live_online;//主播在线状态   0 不在线  1在线
@property (nonatomic, copy) NSString *live_start_time;//直播开始时间
@property (nonatomic, copy) NSString *live_end_time;//live_end_time

//主播、观众加入房间的公有信息字段
@property (nonatomic, strong) NSString *msgbody;//消息体
@property (nonatomic, assign) int       msgtype;//系统消息公告类型   0 系统公告  1 红包提示
@property (nonatomic, copy) NSString *play_url_rtmp;//rtmp播放地址
@property (nonatomic, copy) NSString *play_url_m3u8;//m3u8播放地址
@property (nonatomic, copy) NSString *head_img_url; //主播头像地址
@property (nonatomic, copy) NSString *live_img_url;//直播pc端观看提取码
@property (nonatomic, copy) NSString *location;//直播所在地
@property (nonatomic, copy) NSString *access_code;//直播pc端观看提取码
@property (nonatomic, copy) NSString *master_nikename;//主播名称
@property (nonatomic, assign) int      master_userid;//主播id
@property (nonatomic, copy) NSData   *head_img_data;//自写制字段，存放主播的头像
@property (nonatomic, assign) int      focus;//关注主播 1代表关注 0取消关注
//礼物字段
@property (nonatomic, copy) NSString  *giftName;
@property (nonatomic, assign) NSInteger currencyValue;//礼物价值
@property (nonatomic, copy) NSString  *giftImg;//礼物图片
@property (nonatomic, assign) int      giftID;//礼物id
@property (nonatomic, assign) int      giftNum;//礼物数量
@property (nonatomic, assign) int      giftSum; //直播间礼物总个数
@property (nonatomic, assign) long long   giftAmount;  //直播间总金额数数
@property (nonatomic, assign) int      praiseNum; //点赞数

@property (nonatomic, copy  ) NSString *bg_id;//贴纸id
@property (nonatomic, copy  ) NSString *bg_img;//贴纸url
@property (nonatomic, copy  ) NSArray  *itemlist;//豪华礼物列表

@property (nonatomic, copy) NSString *show_msg;   //红包吉祥话
@property (nonatomic, copy) NSString *rp_id;      //红包ID
@property (nonatomic, assign) int      rp_value;   //红包价值
@property (nonatomic, copy) NSString *rp_child_id;//红包价值序列
@property (nonatomic, copy) NSArray  *rp_list;    //红包列表
@property (nonatomic, copy) NSString *rp_blessing_words;

@property (nonatomic, copy) NSString *rp_from_ID;  //领取红包(发送红包者ID)
@property (nonatomic, copy) NSString *rp_from_user_id;
@property (nonatomic, copy) NSString *rp_from_imgUrl; //领取红包(发送红包者头像)
@property (nonatomic, copy) NSString *rp_from_img_url;
@property (nonatomic, copy) NSString *rp_from_nikeName; //领取红包（发送红包者昵称）
@property (nonatomic, copy) NSString *rp_from_nickName;

//以下两参数需要客户端累计，服务器未做累计
@property (nonatomic, assign) NSInteger    newlyAddFons;//新增粉丝
@property (nonatomic, assign) NSInteger    newlyAddAidou;//新增爱豆

//新加用户禁言状态字段
@property (nonatomic, assign) int         silence;   // 1 该用户被禁言  0 该用户没有被禁言
@property (nonatomic, copy) NSString    *user_id;
@property (nonatomic, copy) NSString    *nickname;  //禁言用户昵称
@property (nonatomic, copy) NSString    *silence_user_id;  //禁言用户ID
@property (nonatomic, copy) NSString    *msg_id;

/**2.0.1新增 */
@property (nonatomic, assign) int    silence_all;//全体禁言


@property (nonatomic, copy) NSString    *black_user_id;//黑名单用户
@property (nonatomic, assign)NSInteger    black_status;//应答状态  0失败  1成功

/**直播状态
 0：直播创建
 1：直播开始，推流中
 2：直播结束
 3：直播异常，即直播中断
 10：直播被禁止
 11:直播余额不足
 */
@property (nonatomic, assign) int         live_status;


@property (nonatomic, copy) NSString    *liveID;      //直播ID

@property (nonatomic, assign) int         customize_type; //自定义类型       800直播结束  801前后台  802重要人物入场

@property (nonatomic, assign) int      back_run;//主播状态，1代表在后台运行  0代表恢复到前台推流

//重要人物入场相关
@property (nonatomic,copy)NSString *phoneNumber;//电话号码
@property (nonatomic,copy)NSString *content;//重要人物入场描述
@property (nonatomic,copy)NSString *corverUrl;//封面
@property (nonatomic,copy)NSString *job;//职位

/**2.0.1新增*/
@property (nonatomic, copy)NSString *admin_tag;//管理员名称


@end

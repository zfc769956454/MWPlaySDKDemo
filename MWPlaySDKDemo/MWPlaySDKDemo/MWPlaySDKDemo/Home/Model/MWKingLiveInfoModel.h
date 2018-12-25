//
//  BKKingLiveInfoModel.h
//  MontnetsLiveKing
//
//  Created by 谢敏 on 2017/7/19.
//  Copyright © 2017年 facebac.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@class BKDefinitionDetailModel;

@interface MWKingLiveInfoModel : NSObject<NSCoding,NSCopying>

@property (nonatomic,copy) NSString *ID; //直播ID
@property (nonatomic,copy) NSString *live_name; //直播名称
@property (nonatomic,copy) NSString *live_text; //直播描述
@property (nonatomic,copy) NSString *begin_time;

/**
 begin_time 的拷贝值，主要用于编辑回放、预约的时候传给后台用
 */
@property (nonatomic,copy) NSString *begin_timeCopy;
@property (nonatomic,copy) NSString *end_time;
@property (nonatomic,assign) int    live_status; //直播状态
@property (nonatomic,copy) NSString *live_cover_url; //直播封面
@property (nonatomic,copy) NSString *live_cover_id; //直播封面ID

@property (nonatomic,copy) NSString *live_text_imgsid; //描述图片ID
@property (nonatomic,copy) NSString *live_text_imgsurl; //描述图片

@property (nonatomic,copy) NSString *push_url; //推流地址
@property (nonatomic,copy) NSString *play_m3u8_url;
@property (nonatomic,copy) NSString *play_url; //播放地址地址

@property (nonatomic,copy) NSString *share_url; //分享地址
@property (nonatomic,copy) NSString *definition; //清晰度

@property (nonatomic,copy) NSString *view_pass; //根据live_permit的类型，可能为密码或者金额或者门票数量
@property (nonatomic,copy) NSData   *liveCoverData; //直播封面

//二期新增字段
@property (nonatomic,copy) NSString *live_text_imgs; //多直播描述数组JSON
@property (nonatomic,copy) NSString *video_direc; //拍摄方式
@property (nonatomic,copy) NSString *vbitrate; //视频码率
@property (nonatomic,copy) NSString *live_permit; //观看权限
@property (nonatomic,copy) NSString *live_Logo;
@property (nonatomic,copy) NSString *video_id;

//三期新添
@property (nonatomic,copy) NSString *user_id; //主播ID
@property (nonatomic,copy) NSString *head_url; //头像url
@property (nonatomic,copy) NSString *play_count;//播放次数
@property (nonatomic,copy) NSString *user_title;//主播名称

@property (nonatomic,copy) NSString *notifyBeginTime;//直播开始时间

@property (nonatomic,copy) NSString *show_status;//是否在大厅显示
@property (nonatomic,copy) NSString *live_notify;//是否通知粉丝
@property (nonatomic,copy) NSString *qualify;//是否认证

@property (nonatomic,copy) NSString *lastTicketsNumber;///之前生成的门票数量

//@property (nonatomic, assign) BOOL isOpenLive;//免费直播
//1.6时移
@property (nonatomic,copy) NSString *timeshiftM3u8Url;//时移播放地址  后变为流ID
@property (nonatomic,copy) NSString *timeshift_time;//时移服务器准确的直播开始时间，但是有可能返回空，此时用notifyBeginTime代替
@property (nonatomic,assign) BKLiveSwitch live_switch;//封禁状态 0：正常 1：欠费 2：封禁 3:下线（4.23新增）
@property (nonatomic, assign) CGFloat surplus;//用户余额
@property (nonatomic, assign) NSInteger cur_viewers;//在线人数
@property (nonatomic, assign) CGFloat rate;//费率
@property (nonatomic,assign) int onlineCount;//直播间人数限制

@property (nonatomic, assign) NSInteger isWatch;//观看权限

@property (nonatomic, copy) NSArray<BKDefinitionDetailModel *> *detailsList;//清晰度列表

/**2.0版本*/
@property (nonatomic, copy) NSString *isrecord;//录像生成

@property (nonatomic, strong) NSString *giftSwitch; /**< 是否显示礼物icon 默认为1 即打开      0为关闭*/

/// ***************************v2.1.1新增****************************
/**门票付费价格*/
@property (nonatomic,copy)NSString *ticket_price;


@end


@interface BKDefinitionDetailModel : NSObject<NSCoding,NSCopying>

@property (nonatomic, assign) NSInteger vtype;//清晰度代表值
@property (nonatomic,copy) NSString *height;
@property (nonatomic,copy) NSString *m3u8_url;
@property (nonatomic,copy) NSString *show_name;//清晰度名称
@property (nonatomic,copy) NSString *url;//播放地址

@end

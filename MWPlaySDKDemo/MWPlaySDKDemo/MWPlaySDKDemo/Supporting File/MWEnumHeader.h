//
//  MWEnumHeader.h
//  MWPlaySDKDemo
//
//  Created by mac on 2018/11/19.
//  Copyright © 2018年 mac. All rights reserved.
//

#ifndef MWEnumHeader_h
#define MWEnumHeader_h


typedef enum : NSInteger{
    BKLiveDefinitionLow = 0,    //低清晰度
    BKLiveDefinitionHeight = 1 ,    //高清晰度
    BKLiveDefinitionBetter = 2,     //超清晰度
    BKLiveDefinitionCustom = 3,     //自定义
    
} BKLiveDefinitionType;


//贴纸位置
typedef enum: NSInteger{
    BKStikerPostionRightTop,
    BKStikerPostionRightMiddle,
    BKStikerPostionRightButtom,
    BKStikerPostionLeftTop,
    BKStikerPostionLeftMiddle,
    BKStikerPostionLeftButtom,
    BKStikerPostionMiddle,
}BKStikerPostion;

//直播详情页
typedef NS_ENUM(NSInteger,BKLiveInfoType){
    BKLiveInfoTypePersonalOrder,//个人预约
    BKLiveInfoTypePersonalLiving,//个人直播推流中
    BKLiveInfoTypePersonalPlayBack,//个人回放
    BKLiveInfoTypeOtherOrder,//他人预约
    BKLiveInfoTypeOtherLiving,//他人正在直播
    BKLiveInfoTypeOtherPlayBack,//他人回放
    BKLiveInfoTypeOrderPushing,//自己用手机在直播推流
    BKLiveInfoTypePersonalPlayBackFullScreen,//个人回放全屏
    BKLiveInfoTypeOtherLiveEnd,//他人直播已结束
    
    BKLiveInfoTypeOnlyShare,//只有分享
};

//观看直播的权限,0~4不能随便更改，要保证其值的准确无误
typedef NS_ENUM(NSInteger,BKLivePermitType){
    BKLivePermitTypePublic = 0 ,//免费
    BKLivePermitTypePrivate = 1,//私密
    BKLivePermitTypePay = 2,//付费
    BKLivePermitTypeTicketCode = 3,//门票码
    BKLivePermitTypeWhileList = 4,//专属直播间
    BKLivePermitTypeMyNoMoney,//我自己没钱了
    BKLivePermitTypeAnchorNoMoney,//主播没钱了
    BKLivePermitTypeNotVerify,//未认证
    BKLivePermitTypeLiveOffline,//直播下线
    BKLivePermitTypeVideoOffline,//视频下线
    BKLivePermitTypeBlackUser,//被拉黑的用户
    BKLivePermitTypeRoomAudienceLimit,//主播限制直播间人数
};


//个人中心数据
typedef NS_ENUM(NSInteger, BKSettingModelType) {
    
    BKSettingModelNormal,//常规：右边带箭头
    BKSettingModelMyWallet,//我的梦币
    BKSettingModelPushStream,//推流
    BKSettingModelAboutUs,//关于我们
    BKSettingModelLoginOut,//登出
    BKSettingModelReport,//举报
    BKSettingModelSetting,//设置
    BKSettingModelClearCache,//清除缓存
    BKSettingModelSlide,//滑块缓存
    BKSettingModelChoose,//选项
    BKSettingModelNone,//右边无任何插件视图
    BKSettingModelTextView,//textView textField
    
};


//个人主页类型
typedef NS_ENUM(NSInteger, BKPersonalInfoType){
    BKPersonalInfoTypeSelf ,
    BKPersonalInfoTypeOther
};


typedef NS_ENUM (NSInteger, BKLiveMethodType){
    BKLiveMethodType_Commond,    //免费的
    BKLiveMethodType_Method,     //需要密码的
    BKLiveMethodType_Money,      //付费
    BKLiveMethodType_Tickets,    //门票
    BKLiveMethodType_WhiteList,    //专属直播间
};


//直播类型
typedef enum : NSInteger {
    BKCurrentRoomTypeLive = 0,  //播放直播
    BKCurrentRoomTypeVideo = 1,      //播放回放
    BKCurrentRoomTypeOrder = 2,   //预约
    
} BKCurrentRoomType;

//直播状态
typedef enum : NSUInteger {
    BKLiveStatusSubscribe = 0,
    BKLiveStatusLiveing = 1,
    BKLiveStatusBackPlay = 2,
    BKLiveStatusError = 3,
    BKLiveStatusOrderOutOfDate = 4,/**< 预告已过期 == 4 */
    BKLiveStatusNoVideo = 5,/**< 没有录像 == 5 */
    BKLiveStatusDelete  = 6, /**< 删除 == 6 */
} BKLiveStatus;


/** 封禁状态 */
typedef enum : NSUInteger {
    BKLiveSwitchNormal = 0, /**< 正常 == 0 */
    BKLiveSwitchArrears = 1,/**< 欠费 == 1 */
    BKLiveSwitchBan = 2,/**< 封禁 == 2 */
    BKLiveSwitchOffline = 3,/**< 下线 == 3 */
} BKLiveSwitch;

typedef NS_ENUM (NSInteger, BKUserGender) {
    BKUserGenderMan = 0,
    BKUserGenderWoman = 1,
};

/**
 第三方绑定、解绑类型
 */
typedef NS_ENUM(NSInteger, BKRegistType) {
    BKRegistDevice  = 1,/**< 设备注册 */
    BKRegistPhone   = 2,/**< 手机注册 */
    BKRegistWeiBo   = 3,/**< 微博注册 */
    BKRegistUnknown = 4,/**< 未知，2.1版本之前微信登录用的是4，2.1开始后台要求改成6 */
    BKRegistQQ      = 5,/**< 腾讯QQ */
    BKRegistWechat  = 6,/**< 微信注册 */
};

typedef NS_ENUM(NSInteger, BKBeginWatchType) {
    BKBeginWatchLive = 1,//直播
    BKBeginWatchVideo  = 2,//录播
    BKBeginWatchActivityLive,//直播活动
};

typedef NS_ENUM(NSInteger, BKUpLoadImageType) {
    
    BKUpLoadImageType_Temporary     = 0,//临时图片
    BKUpLoadImageType_UserHead      = 1,//用户头像
    BKUpLoadImageType_LiveCover     = 2,//直播封面
    BKUpLoadImageType_LiveDescri    = 3,//直播描述图片
};


#endif /* MWEnumHeader_h */

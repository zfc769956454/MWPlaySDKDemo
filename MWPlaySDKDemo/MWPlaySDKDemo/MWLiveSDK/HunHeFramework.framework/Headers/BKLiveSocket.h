//
//  BKLiveSocket.h
//  BaiKeLive
//
//  Created by chendb on 16/5/13.
//  Copyright © 2016年 simope. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BKLiveSocketData.h"

//SOCKET 的连接状态
UIKIT_EXTERN NSString *const BKSocketState;
UIKIT_EXTERN NSString *const BKSocket_Connect;
UIKIT_EXTERN NSString *const BKSocket_Release;

UIKIT_EXTERN NSString *const BKLiveSocket_emit_msg;    //发送消息
UIKIT_EXTERN NSString *const BKLiveSocket_emit_join;   //加入房间
UIKIT_EXTERN NSString *const BKLiveSocket_emit_leave;  //离开房间

//消息字段解析 - 常量
UIKIT_EXTERN NSInteger const BKLiveSocket_joinRoom; //系统消息-加入房间
UIKIT_EXTERN NSInteger const BKLiveSocket_leaceRoom; //系统消息-离开房间
UIKIT_EXTERN NSInteger const BKLiveSocket_chatMessage; //普通聊天消息请求与通知
UIKIT_EXTERN NSInteger const BKLiveSocket_customMessage; //聊天室自定义消息
UIKIT_EXTERN NSInteger const BKLiceSocket_roommate; //已存观众
UIKIT_EXTERN NSInteger const BKLiceSocket_messageZip; //聚包消息

//mijia中用到的一些命令
UIKIT_EXTERN NSInteger const BKLiveSocket_presentGift; //赠送礼品请求与通知
UIKIT_EXTERN NSInteger const BKLiveSocket_concern; //关注与取关通知接口 1关注 0取消关注
UIKIT_EXTERN NSInteger const BKLiveSocket_praise; //点赞
UIKIT_EXTERN NSInteger const BKLiveSocket_lighten; //点亮主播
UIKIT_EXTERN NSInteger const BKLiveSocket_barrageMessage; //付费弹幕消息请求与通知
UIKIT_EXTERN NSInteger const BKLiveSocket_stikerMessage; //聊天室贴图设置消息
UIKIT_EXTERN NSInteger const BKLiveSocket_presentEnvelope; //用户发送红包请求(多人红包)
UIKIT_EXTERN NSInteger const BKLiveSocket_singleEnvelope; //用户发送红包请求(单人红包)
UIKIT_EXTERN NSInteger const BKLiveSocket_groupEnvelope; //服务器群发红包请求
UIKIT_EXTERN NSInteger const BKLiveSocket_getEnvelopeRequest; //用户领取红包请求
UIKIT_EXTERN NSInteger const BKLiveSocket_getEnvelopeSucceed; //用户领取红包成功
UIKIT_EXTERN NSInteger const BKLiveSocket_getEnvelopeFailed; //红包领取失败
UIKIT_EXTERN NSInteger const BKLiveSocket_requestEnvelopeInfo; //请求红包手气详情
UIKIT_EXTERN NSInteger const BKLiveSocket_receiveEnvelopeInfo; //收到红包手气详情
UIKIT_EXTERN NSInteger const BKLiveSocket_sysMessage; //系统消息通知
UIKIT_EXTERN NSInteger const BKLiveSocket_headbeatResponse;//心跳应答消息
UIKIT_EXTERN NSInteger const BKLiveSocket_notSufficientFunds; //送礼余额不足消息
UIKIT_EXTERN NSInteger const BKLiveSocket_luxuryGiftList; //豪华礼品清单通知消息
UIKIT_EXTERN NSInteger const BKLiveSocket_compereStepOut; //主播暂离与恢复请求与通知
UIKIT_EXTERN NSInteger const BKLiveSocket_error;        //错误应答
UIKIT_EXTERN NSInteger const BKLiveSocket_LiveNotice;//公告栏消息


//聊天室管理接口
UIKIT_EXTERN NSInteger const BKLiveSocket_shutupUsersList;//获取禁言用户列表
UIKIT_EXTERN NSInteger const BKLiveSocket_shutupUser;//将用户拉入禁言列表
UIKIT_EXTERN NSInteger const BKLiveSocket_removeShutupToList;//将用户从禁言列表中移除
UIKIT_EXTERN NSInteger const BKLiveSocket_querySilinceUserState;//查询用户禁言状态
UIKIT_EXTERN NSInteger const BKLiveSocket_obtainChatRecord;//分段获取聊天室聊天记录
UIKIT_EXTERN NSInteger const BKLiveSocket_deletChatRecord; //删除聊天室聊天记录
UIKIT_EXTERN NSInteger const BKliveSocket_deletSingleChatRecord;//清除单条聊天记录
UIKIT_EXTERN NSInteger const BKliveSocket_cleanScreenShutup;//清屏禁言请求
UIKIT_EXTERN NSInteger const BKliveSocket_shutupUserAll;//全体禁言
UIKIT_EXTERN NSInteger const BKliveSocket_obtainBlacklistUsers;//获取拉黑用户列表
UIKIT_EXTERN NSInteger const BKLiveSocket_blacklistUser;//将用户拉入黑名单,并踢出房间
UIKIT_EXTERN NSInteger const BKLiveSocket_removeUserToBlacklist;//将用户从黑名单中移除
UIKIT_EXTERN NSInteger const BKLiveSocket_queryUserBlackState;//查询用户黑名单状态
UIKIT_EXTERN NSInteger const BKLiveSocket_customNotice ;//直播结束
UIKIT_EXTERN NSInteger const BKLiveSocket_changeAdminTag ;//更改管理员头衔

typedef enum : NSInteger{
    BKPresentGifiMogu = 14,
    BKPresentGifiFlower = 15,
}BKPresentGifiType;

typedef enum : NSInteger{
    BKMsgChat,
    BKMsgShare,
}BKMsgType;

//直播类型
typedef enum : NSInteger {
    BKPhoneLivePlay_Living = 1,  //直播观看
    BKPhoneLive_Living = 2,      //直播
    BKPhoneLivePlay_Video = 3,   //播放回放
    BKPhoneLivePlayScreen = 4,   //筛选直播
    BKPhoneLiveIsPush,           //rtmp地址直接推流
    
} BKPhonePlayType;

#define kCMD        @"cmd"
#define kAppID      @"appID"
#define kAppIDNum   @(3)


/**
 socket消息代理
 */
@protocol BKLiveSocketDelegate <NSObject>

- (void)receiveSocketMessage:(BKLiveSocketData *)scoketData;

@end

@interface BKLiveSocket : NSObject
//{
//    BKMontLiveInfoStateModel *statisticsModel; //计费
//}
@property (nonatomic ,weak) id<BKLiveSocketDelegate> delegate;
@property (strong, nonatomic) NSString *out_roomID;
@property (nonatomic, copy  ) NSString *out_room_ServerAddress;
@property (nonatomic, copy  ) NSString *join_notice;  //直播聊天系统提示语
//@property (nonatomic ,copy) void (^liveStatisticsBlock)(BKMontLiveInfoStateModel *model);


/**
 初始化socket

 @param roomId 直播间id
 @param liveID 直播id
 @param out_room_ServerAddress socket地址
 @param join_notice 初始消息
 @param playType 直播类型
 @param user_id 用户id
 @param nickName 用户昵称
 @param headPic 用户头像
 */
- (instancetype)initWithRoomId:(NSString *)roomId
                        liveID:(NSString *)liveID
        out_room_ServerAddress:(NSString *)out_room_ServerAddress //socket地址
                   join_notice:(NSString *)join_notice //加入房间提示
                      playType:(BKPhonePlayType)playType
                       user_id:(NSString *)user_id
                      nickName:(NSString *)nickName
                       headPic:(NSString *)headPic;

/**
 销毁socket
 */
- (void)releaseSocketIO;

/**
 发送文本、分享消息

 @param text 消息内容
 @param qualify 认证状态
 @param nickName 用户昵称
 @param userID 用户id
 @param headPic 用户头像
 @param msgType 消息类型
 */
- (void)sendMessageWithText:(NSString *)text
                    qualify:(NSInteger)qualify //认证状态
                   nickName:(NSString *)nickName
                     userId:(NSString *)userID
                    headPic:(NSString *)headPic
                    msgType:(BKMsgType)msgType;

/**
 发弹幕消息

 @param text 消息内容
 @param nickName 用户昵称
 @param userID 用户id
 @param headPic 用户头像
 */
- (void)sendBarrageWithText:(NSString *)text
                   nickName:(NSString *)nickName
                     userId:(NSString *)userID
                    headPic:(NSString *)headPic;

/**
 主播发送暂离与恢复消息

 @param isStepOut YES代表在后台运行  NO代表恢复到前台推流
 @param nickName 用户昵称
 @param userID 用户id
 @param headPic 用户头像
 */
- (void)sendCompereStepOut:(BOOL)isStepOut
                  nickName:(NSString *)nickName
                    userId:(NSString *)userID
                   headPic:(NSString *)headPic;

/**
 * 心跳响应
 *
 *  @param isBeat 是否强制下线0否，1强制下线，收到强制下线的心跳，客户端要主动发起离线请求
 */
- (void)responseHeadbeat:(BOOL)isBeat;

/**
 发送离开房间消息

 @param playType 直播类型
 @param userID 用户id
 */
- (void)leaveRoomWithPlayType:(BKPhonePlayType)playType
                       userId:(NSString *)userID;

/**
 发送直播结束消息

 @param nickName 用户昵称
 @param userID 用户id
 @param headPic 用户头像
 */
- (void)sendEndLiveNoticeNickName:(NSString *)nickName
                           userId:(NSString *)userID
                          headPic:(NSString *)headPic;;

/**
 禁言用户

 @param silenceUserID 禁言用户ID
 @param silenceName 禁言用户昵称
 */
- (void)requestUserShutupWithUserID:(NSString *)silenceUserID
                        silenceName:(NSString *)silenceName;

/**
 将用户从禁言列表中移除

 @param silenceUserID 禁言用户ID
 @param silenceName 禁言用户昵称
 */
- (void)relieveUserShutupWithUserID:(NSString *)silenceUserID
                        silenceName:(NSString *)silenceName;

/**
 查询用户禁言状态

 @param silenceUserID 禁言用户ID
 */
- (void)querySilinceUserState:(NSString *)silenceUserID;

/**
 将用户加入黑名单

 @param userId 加入黑名单用户ID
 @param userName 加入黑名单用户昵称
 */
- (void)requestBlacklistUserWithUserID:(NSString *)userId
                              userName:(NSString *)userName;

/**
  将用户从黑名单中移除

 @param userId 加入黑名单用户ID
 @param userName 加入黑名单用户昵称
 */
- (void)relieveBlacklistUserWithUserID:(NSString *)userId
                              userName:(NSString *)userName;

/**
 查询用户黑名单状态

 @param userId 黑名单用户ID
 */
- (void)queryBlackUserState:(NSString *)userId;

/**
 送礼

 @param nickName 用户昵称
 @param userID 用户id
 @param headPic 用户头像
 @param giftID 礼物id
 @param qualify 认证状态
 @param giftCount 礼物数量
 @param giftAmount 礼物价值
 @param giftName 礼物名称
 @param giftUrl 礼物对应的Uel
 @param totalAmount 总的价值
 @param giftSum 总的数量
 */
- (void)presentGiftWithNickName:(NSString *)nickName
                         userId:(NSString *)userID
                        headPic:(NSString *)headPic
                         giftID:(NSInteger)giftID
                        qualify:(NSInteger)qualify //认证状态
                      giftCount:(NSInteger)giftCount
                     giftAmount:(NSInteger)giftAmount
                       giftName:(NSString *)giftName
                    giftImagUrl:(NSString *)giftUrl
                giftTotalAmount:(int)totalAmount
                        giftSum:(int)giftSum;


/**
 重要人物入场消息

 @param userInfo 重要人物信息
 */
- (void)sendImportantPersonEnterNotice:(NSDictionary *)userInfo;

/**
 获取直播间的消息记录
 
 @param lastMessageID 最后一条的消息id
 */
- (void)getChatRoomHistoryMessageWithLastMessageID:(NSString *)lastMessageID ;

@end

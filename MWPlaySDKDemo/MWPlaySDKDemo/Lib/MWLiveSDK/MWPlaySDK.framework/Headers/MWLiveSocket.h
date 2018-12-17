//
//  MWLiveSocket.h
//  BaiKeLive
//
//  Created by chendb on 16/5/13.
//  Copyright © 2016年 simope. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWLiveSocketData.h"


//SOCKET 的连接状态
UIKIT_EXTERN NSString *const MWSocketState;
UIKIT_EXTERN NSString *const MWSocket_Connect;
UIKIT_EXTERN NSString *const MWSocket_Release;

UIKIT_EXTERN NSString *const MWLiveSocket_emit_msg;    //发送消息
UIKIT_EXTERN NSString *const MWLiveSocket_emit_join;   //加入房间
UIKIT_EXTERN NSString *const MWLiveSocket_emit_leave;  //离开房间

static NSInteger const MWLiveSocket_joinRoom            = 1001; //系统消息-加入房间
static NSInteger const MWLiveSocket_leaceRoom           = 1002; //系统消息-离开房间
static NSInteger const MWLiveSocket_chatMessage         = 1004; //普通聊天消息请求与通知
static NSInteger const MWLiveSocket_presentGift         = 1005; //聊天室自定义消息 （其中包含：赠送礼品请求与通知  以及其他自定义消息）
static NSInteger const MWLiveSocket_praise              = 1006; //点赞
static NSInteger const MWLiveSocket_customNotice        = 1055;//自定义消息

static NSInteger const MWLiveSocket_sysMessage          = 2001;//系统消息通知
static NSInteger const MWLiveSocket_headbeatResponse    = 2002;//直播状态通知消息

//聊天室管理接口
static NSInteger const MWLiveSocket_shutupUsersList        = 2010;//获取禁言用户列表
static NSInteger const MWLiveSocket_shutupUser             = 2011;//将用户单个禁言
static NSInteger const MWLiveSocket_removeShutupToList     = 2012;//将用户从禁言列表中移除
static NSInteger const MWLiveSocket_querySilinceUserState  = 2013;//查询用户禁言状态
static NSInteger const MWLiveSocket_obtainChatRecord       = 2020;//分段获取聊天室聊天记录
static NSInteger const MWliveSocket_deletSingleChatRecord  = 2022;//清除单条聊天记录
static NSInteger const MWliveSocket_shutupUserAll          = 2024;//全体禁言


static NSInteger const MWLiveSocket_LiveNotice             = 5001;//公告栏消息


/**
 socket消息代理
 */
@protocol MWLiveSocketDelegate <NSObject>

- (void)receiveSocketMessage:(MWLiveSocketData *)scoketData;

@end

@interface MWLiveSocket : NSObject


/**
 初始化socket
 
 @param roomId 直播间id
 @param liveID 直播id
 @param out_room_ServerAddress socket地址
 @param join_notice 初始消息
 @param user_id 用户id
 @param nickName 用户昵称
 @param headPic 用户头像
 @param delegate 代理
 @param response 回调block,成功success = YES msg:回调信息
 */
- (instancetype)initWithRoomId:(NSString *)roomId
                        liveID:(NSString *)liveID
        out_room_ServerAddress:(NSString *)out_room_ServerAddress
                   join_notice:(NSString *)join_notice
                       user_id:(NSString *)user_id
                      nickName:(NSString *)nickName
                       headPic:(NSString *)headPic
                      delegate:(id<MWLiveSocketDelegate>)delegate
                      response:(void(^)(BOOL success,NSString *msg))response;

/**
 销毁socket
 */
- (void)releaseSocketIO;



/**
 发送离开房间消息
 
 @param nickName 用户昵称
 @param userID 用户id
 @param headPic 用户头像
 */
- (void)leaveRoomWithNickName:(NSString *)nickName
                       userId:(NSString *)userID
                      headPic:(NSString *)headPic;


/**
 发送文本消息
 @param text 消息内容
 @param nickName 用户昵称
 @param userID 用户id
 @param headPic 用户头像
 */
- (void)sendMessageWithText:(NSString *)text
                   nickName:(NSString *)nickName
                     userId:(NSString *)userID
                    headPic:(NSString *)headPic;

/**
 送礼
 
 @param nickName 用户昵称
 @param userID 用户id
 @param headPic 用户头像
 @param giftID 礼物id
 @param giftCount 礼物数量
 @param giftName 礼物名称
 @param giftUrl 礼物对应的Uel
 */
- (void)presentGiftWithNickName:(NSString *)nickName
                         userId:(NSString *)userID
                        headPic:(NSString *)headPic
                         giftID:(NSInteger)giftID
                      giftCount:(NSInteger)giftCount
                       giftName:(NSString *)giftName
                    giftImagUrl:(NSString *)giftUrl;


/**
 发点赞消息
 
 @param nickName 用户昵称
 @param userID 用户id
 @param headPic 用户头像
 */
- (void)sendPraiseWithNickName:(NSString *)nickName
                        userId:(NSString *)userID
                       headPic:(NSString *)headPic;





/**
 发送自定义消息
 
 @param nickName 用户昵称
 @param userID 用户id
 @param headPic 用户头像
 @param customDic 自定义消息的字典
 */
- (void)sendCustomWithNickName:(NSString *)nickName
                        userId:(NSString *)userID
                       headPic:(NSString *)headPic
                     customDic:(NSDictionary *)customDic;



/**
 获取禁言列表
 */
- (void)getShutupUserList; //2010

/**
 禁言用户
 
 @param silenceUserID 禁言用户ID
 @param silenceName 禁言用户昵称
 @param headPic 用户头像
 */
- (void)requestUserShutupWithUserID:(NSString *)silenceUserID
                        silenceName:(NSString *)silenceName
                            headPic:(NSString *)headPic;

/**
 将用户从禁言列表中移除
 
 @param silenceUserID 禁言用户ID
 @param silenceName 禁言用户昵称
 @param headPic 用户头像
 */
- (void)relieveUserShutupWithUserID:(NSString *)silenceUserID
                        silenceName:(NSString *)silenceName
                            headPic:(NSString *)headPic;

/**
 全体禁言、解禁
 
 @param isSilence YES:开启全体禁言 NO:解禁
 */
- (void)silenceAllUser:(BOOL)isSilence;



/**
 获取直播间的消息记录
 
 @param lastMessageID 最后一条的消息id
 */
- (void)getChatRoomHistoryMessageWithLastMessageID:(NSString *)lastMessageID ;

/**
 查询用户禁言状态
 
 @param silenceUserID 禁言用户ID
 */
- (void)querySilinceUserState:(NSString *)silenceUserID;


/**
 删除单条聊天记录
 
 @param messageId 消息id
 @param userId 消息id所属用户id
 */
- (void)deletSingleChatRecordWithMessageId:(NSString *)messageId
                                    userId:(NSString *)userId;



@end

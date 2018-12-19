//
//  MWLiveSocketData.h
//  BaiKeLive
//
//  Created by chendb on 16/5/14.
//  Copyright © 2016年 simope. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MWSocketLiveinfo.h"

@interface MWLiveSocketData : NSObject

/** 消息类型 */
@property (nonatomic ,assign) int      code;
/** 用户昵称 */
@property (nonatomic ,copy  ) NSString *nickName;
/** 消息内容 */
@property (nonatomic ,copy  ) NSString *message;
/** 用户id */
@property (nonatomic, copy  ) NSString *user_id;
/** 用户头像 */
@property (nonatomic, copy  ) NSString *imgUrl;
/** 消息原始发送者头像 */
@property (nonatomic, copy  ) NSString *sender_head;
/** 是否禁言 1该用户被禁言 0没有被禁言 */
@property (nonatomic, assign) int      silence;
/** 接收消息时间 */
@property (nonatomic, copy  ) NSString *send_time ;
/** 消息ID */
@property (nonatomic, copy)   NSString *msg_id;
/** 消息集合 */
@property (nonatomic, strong) MWSocketLiveinfo *liveinfo;
@property (nonatomic, copy)   NSDictionary     *data;
/** 是否是系统消息 */
@property (nonatomic, assign) BOOL      isSystemMessage;


@end

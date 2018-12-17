//
//  BKLiveSocketData.h
//  BaiKeLive
//
//  Created by chendb on 16/5/14.
//  Copyright © 2016年 simope. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BKSocketLiveinfo.h"


@interface BKLiveSocketData : NSObject

@property (nonatomic ,assign) int      code;//cmd
@property (nonatomic, assign) int      user_type;//用户类型
@property (nonatomic, assign) int      gender;
@property (nonatomic ,copy  ) NSString *nickName;
@property (nonatomic ,copy  ) NSString *message;//msg
@property (nonatomic, copy  ) NSString *messagebody;
@property (nonatomic, copy  ) NSString *user_id;
@property (nonatomic, copy  ) NSString *show_id;
@property (nonatomic, copy  ) NSString *imgUrl;     //用户头像链接
@property (nonatomic, copy  ) NSString *sender_head; //礼物发送者头像
@property (nonatomic, assign) NSInteger err_code;   //错误码
@property (nonatomic, copy  ) NSString *err_msg;    //错误信息
@property (nonatomic, assign) int       offline;    //是否为历史消息  0 当前即时消息  1 历史离线消息
@property (nonatomic, assign) int       barrage;    //是否为弹幕
@property (nonatomic, assign) int       silence;    //是否禁言 1 该用户被禁言 0没有被禁言
@property (nonatomic, assign) int       black;    //是否加入了黑名单 1 黑名单 0没有加入黑名单
@property (nonatomic, copy  ) NSString *send_time ;//接收消息时间
@property (nonatomic, assign) BOOL      isSystemMessage;  //  2001 时确定是否为系统警示消息  yes  是  no 不是  （云播需要手动设置该参数）
@property (nonatomic, copy) NSString    *msg_id;    //消息ID
@property (nonatomic, assign) NSInteger qualify;//认证状态

@property (nonatomic, strong) BKSocketLiveinfo *liveinfo;

@property (nonatomic, copy) NSDictionary    *data;

/**2.0.1新增*/
@property (nonatomic, copy)NSString *isAdmin;//是否设置了主播的身份

@end

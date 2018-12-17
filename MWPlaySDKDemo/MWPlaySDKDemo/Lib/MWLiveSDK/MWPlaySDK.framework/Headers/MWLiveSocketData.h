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

@property (nonatomic ,assign) int      code;      //cmd
@property (nonatomic ,copy  ) NSString *nickName;
@property (nonatomic ,copy  ) NSString *message;  //msg
@property (nonatomic, copy  ) NSString *user_id;
@property (nonatomic, copy  ) NSString *imgUrl;   //用户头像链接
@property (nonatomic, copy  ) NSString *sender_head; //消息原始发送者头像
@property (nonatomic, assign) int       silence;     //是否禁言 1该用户被禁言 0没有被禁言
@property (nonatomic, copy  ) NSString *send_time ;  //接收消息时间
@property (nonatomic, copy)   NSString    *msg_id;    //消息ID
@property (nonatomic, strong) MWSocketLiveinfo *liveinfo;
@property (nonatomic, copy)   NSDictionary    *data;
@property (nonatomic, assign) BOOL      isSystemMessage;  // 是否是系统消息



@end

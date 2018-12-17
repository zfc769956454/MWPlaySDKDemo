//
//  MWHomeListModel.h
//  MWPlaySDKDemo
//
//  Created by mac on 2018/11/27.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MWLiveListModel : NSObject

//直播id
@property (nonatomic,copy)NSString *liveId;

//直播封面地址
@property (nonatomic,copy)NSString *liveCover;

//直播名称
@property (nonatomic,copy)NSString *liveName;

//直播状态；0.预告；1.直播中；2.结束
@property (nonatomic,copy)NSString *liveStatus;

//计划开播时间
@property (nonatomic,copy)NSString *planTime;


@end



//
//  BKLiveFirstModel.h
//  BaiKeLive
//
//  Created by chendb on 16/3/30.
//  Copyright © 2016年 simope. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMResultSet.h"

@interface MWKingMyVideoModel : NSObject

@property (nonatomic,strong) NSString *video_id;

@property (nonatomic,strong) NSString *record_time;

@property (nonatomic,strong) NSString *file_path;

@property (nonatomic,strong) NSString *video_name;

@property (nonatomic,strong) NSString *video_cover_url;

@property (nonatomic,strong) NSString *live_id;

@property (nonatomic,assign) double   duration;

@property (nonatomic,assign) double size;

@property (nonatomic,copy) NSString *resolution;

@property (nonatomic,strong) UIImage  *share_image;

@property (nonatomic,strong) NSString *share_url;

@property (nonatomic,strong) NSString *live_name;

@property (nonatomic,strong) NSString *live_text;

@property (nonatomic,strong) NSString *live_cover_url;

//新增字段
@property (nonatomic,copy  ) NSString *live_text_imgs;

@property (nonatomic,assign) NSInteger live_permit;
@property (nonatomic,copy  ) NSString *video_direc;
@property (nonatomic,copy  ) NSString *vbitrate;

@property (nonatomic,copy  ) NSString *user_id;
@property (nonatomic,copy  ) NSString *head_url;
@property (nonatomic,copy  ) NSString *play_count;
@property (nonatomic,copy  ) NSString *user_title;

@property (nonatomic,copy  ) NSString *view_pass;

@property (nonatomic,strong) NSNumber *user_status;//用户状态  0 正常  1欠费   2  封禁   3  冻结

@property (nonatomic,assign) NSTimeInterval lastWatchTime;

@property (nonatomic,copy) NSString *top;//是否是置顶视频

/**1.7新增 0.正常 1.下线*/
@property (nonatomic,copy) NSString *video_switch;

/**1.7新增字段*/
@property (nonatomic,copy)NSString *live_after_type;//0.录像 1.自定义图片 2.自定义视频 

//非后台返回字段
@property(nonatomic,assign)BOOL isCurrentPlay ;


@property (nonatomic, assign) BOOL isRecord;

- (instancetype)initWithResult:(FMResultSet *)rs;


@end

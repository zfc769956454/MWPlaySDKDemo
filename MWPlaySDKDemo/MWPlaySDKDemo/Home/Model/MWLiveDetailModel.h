//
//Created by ESJsonFormatForMac on 18/11/27.
//

#import <Foundation/Foundation.h>

@interface MWLiveDetailModel : NSObject

@property (nonatomic, assign) NSInteger isrecord;

@property (nonatomic, copy) NSString *beginTime;


/** 直播id */
@property (nonatomic, copy) NSString *liveId;

@property (nonatomic, assign) NSInteger liveSwitch;

@property (nonatomic, copy) NSString *playUrl720;

@property (nonatomic, copy) NSString *playUrl;

@property (nonatomic, assign) NSInteger thumbsUp;

@property (nonatomic, assign) NSInteger istranscode;

@property (nonatomic, copy) NSString *liveCover;

@property (nonatomic, copy) NSString *currentTime;

@property (nonatomic, assign) NSInteger liveAfterType;

@property (nonatomic, copy) NSString *endTime;

@property (nonatomic, copy) NSString *m3u8Url720;

@property (nonatomic, copy) NSString *slavePushUrl;

@property (nonatomic, copy) NSString *updateTime;

@property (nonatomic, copy) NSString *liveAfterUrl; //当直播结束的时候，如果有自定义视频，返回的是自定义视频的地址；如果没有自定义视频，就返回录像的地址

@property (nonatomic, copy) NSString *liveAfter; //录像或自定义视频id

@property (nonatomic, copy) NSString *liveTextImgs;

@property (nonatomic, assign) NSInteger appointNum;

@property (nonatomic, copy) NSString *shareUrl;

@property (nonatomic, copy) NSString *playUrl480;

@property (nonatomic, assign) NSInteger preventRecordScreen;

@property (nonatomic, copy) NSString *pushUrl;

@property (nonatomic, copy) NSString *shiftTime;

@property (nonatomic, copy) NSString *copyrightContent;

@property (nonatomic, assign) NSInteger liveWay;

@property (nonatomic, copy) NSString *m3u8Url;

@property (nonatomic, assign) NSInteger liveStatus;

@property (nonatomic, assign) NSInteger totalViews;

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, assign) NSInteger del;

@property (nonatomic, copy) NSString *m3u8Url480;

@property (nonatomic, copy) NSString *planTime;

@property (nonatomic, copy) NSString *liveName;

@property (nonatomic, copy) NSString *userId;


/** 如果有次流，这个字段才有值 */
@property (nonatomic,copy)  NSDictionary *slaveLiveInfo;

@end


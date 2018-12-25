//
//Created by ESJsonFormatForMac on 18/11/27.
//

#import <Foundation/Foundation.h>

//清晰度模型
@interface MWDefinitionModel : NSObject

@property (nonatomic, copy) NSString *playUrl720;

@property (nonatomic, assign) NSInteger size;

@property (nonatomic, copy) NSString *playUrl;

@property (nonatomic, copy) NSString *playUrl480;

@property (nonatomic, assign) NSInteger duration;

@end

@interface MWVideoDetailModel : NSObject

@property (nonatomic, copy) NSString *liveId;

@property (nonatomic, assign) NSInteger videoStates;

@property (nonatomic, copy) NSString *videoText;

@property (nonatomic, strong) MWDefinitionModel *videoSource;

@property (nonatomic, assign) NSInteger totalViews;

@property (nonatomic, copy) NSString *videoSourceId;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, assign) NSInteger del;

@property (nonatomic, assign) NSInteger thumbsUp;

@property (nonatomic, copy) NSString *labelName;

@property (nonatomic, copy) NSString *videoName;

@property (nonatomic, copy) NSString *videoCover;

@property (nonatomic, copy) NSString *updateTime;

@property (nonatomic,assign) NSTimeInterval lastWatchTime;

- (id)initWithResult:(FMResultSet *)rs;

@end




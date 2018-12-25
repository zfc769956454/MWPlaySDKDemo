//
//  MWPlayViewController.h
//  MWPlaySDKDemo
//
//  Created by mac on 2018/11/20.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWVideoDetailModel.h"


@interface MWPlayViewController : UIViewController

/**直播id*/
@property (nonatomic,copy)NSString *liveId;
/**是否是直播*/
@property (nonatomic,assign)BOOL isLive;
/**主播id*/
@property (nonatomic,copy) NSString *anchorId;
/**主流清晰度模型*/
@property (nonatomic,strong)MWDefinitionModel *mainDefinitionModel;
/**次流清晰度模型*/
@property (nonatomic,strong)MWDefinitionModel *secondaryDefinitionModel;

/**直播间封面*/
@property (nonatomic,strong)NSString *liveCover;

/** 防录屏 */
@property (nonatomic,assign)BOOL preventRecordScreen;


/**是否是预约*/
@property (nonatomic,assign)BOOL isOrder;

/**回放的model*/
@property (nonatomic,strong)MWVideoDetailModel *videoModel;

/**
 @return 播放时长
 */
- (CGFloat)playerItemDuration ;

@end



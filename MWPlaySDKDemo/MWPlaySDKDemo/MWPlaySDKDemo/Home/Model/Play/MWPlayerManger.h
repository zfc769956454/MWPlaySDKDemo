//
//  MWPlayMainModel.h
//  MWPlaySDKDemo
//
//  Created by mac on 2018/12/7.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWVideoDetailModel.h"

@interface MWPlayerManger : NSObject

/** 是否开始播放 */
@property (nonatomic, assign) BOOL isStartPlay;

/** 主屏当前选择清晰度 */
@property (nonatomic, assign) NSInteger definitionChooseCurrentIndex;

/** 是否播放完成 */
@property (nonatomic, assign) BOOL isCompletePlay;

/** 是否暂停*/
@property (nonatomic, assign) BOOL isPause;

/** 播放器 */
@property (nonatomic, strong) MWVideoPlayer *player;

/**次流清晰度模型*/
@property (nonatomic, strong) MWDefinitionModel *definitionModel;

/**当前播放的Url*/
@property (nonatomic, copy)   NSString *currentPlayUrl;

@end



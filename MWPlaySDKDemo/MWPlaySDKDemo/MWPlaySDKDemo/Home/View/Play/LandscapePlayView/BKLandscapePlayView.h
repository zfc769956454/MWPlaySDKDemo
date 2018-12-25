//
//  BKLandscapePlayView.h
//  MontnetsLiveKing
//
//  Created by chendb on 2017/10/31.
//  Copyright © 2017年 facebac.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BKPlayBottomView.h"
#import "BKPlayTopView.h"
#import "BKBarrageView.h"


@protocol BKLandscapePlayViewDelegate  <NSObject>

- (void)landscapePlayViewClickWithButton:(UIButton *)button;

- (void)changeBottomViewSliderProgress:(BKSliderProgress*)sliderProgress;  //持续的动作

- (void)beginBottomViewSliderProgress:(BKSliderProgress*)sliderProgress;

- (void)endBottomViewSliderProgress:(BKSliderProgress*)sliderProgress;

- (void)showUserInfoViewWithID:(NSString*)userID;

- (void)showDefinitionView;


@end

@interface BKLandscapePlayView : UIView

/**头部直播间信息的试图*/
@property (nonatomic, strong) BKPlayTopView     *topView;

/**弹幕试图*/
@property (nonatomic, strong) BKBarrageView     *barrageView;

/**锁屏按钮*/
@property (nonatomic, strong) UIButton          *lockBtn; //锁屏

/**编辑消息按钮*/
@property (nonatomic, strong) UIButton          *editBtn;

/**是否隐藏所有的试图*/
@property (nonatomic, assign) BOOL              isHideAllView;

@property (nonatomic, strong) NSString      *headImg;

@property (nonatomic, strong) NSString      *videoTitle;

/**在线人数*/
@property (nonatomic, strong) NSString      *lookingVideoNum;

/**观看总数*/
@property (nonatomic, strong) NSString      *lookingTotal;

/**底部试图*/
@property (nonatomic, strong) BKPlayBottomView  *bottomView;

/**socket*/
@property (nonatomic, weak) MWLiveSocket  *socket;

@property (nonatomic, weak) id<BKLandscapePlayViewDelegate>   delegate;

/**是否暂停*/
@property (nonatomic, assign) BOOL      isPause;

/**是否锁屏*/
@property (nonatomic, getter = isLockScreen)  BOOL    lockScreen;


/**
 初始化

 @param frame frame
 @param isLive 是否在直播
 @param masterID 主播id
 */
- (instancetype)initWithFrame:(CGRect)frame playType:(BOOL)isLive masterID:(NSString *)masterID;

/**
 *  聊天室数据处理
 *
 *  @param socketData 聊天室数据模型
 */
- (void)manageReceiveSocketMessage:(MWLiveSocketData *)socketData;

/**
 隐藏所有子视图
 */
- (void)hideAllView;

/**
  添加公告信息

 @param notice 功告内容
 */
- (void)showNotice:(NSString*)notice;

- (void)hideVideoProgressView;

@end

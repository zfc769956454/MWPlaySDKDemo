//
//  BKBottomView.h
//  MontnetsLiveKing
//
//  Created by chendb on 2017/10/31.
//  Copyright © 2017年 facebac.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BKSliderProgress.h"

@protocol BKPlayBottomViewDelegate <NSObject>

- (void)closeBarrage:(UIButton *)sender;
- (void)clickPlayStopButton:(UIButton*)sender;
- (void)sendChatMessage:(NSString *)message;
- (void)sliderPopoverView:(BKSliderProgress*)sliderProgress;  //持续的动作
- (void)clickEndDrag:(BKSliderProgress*)sliderProgress;       //滑块结束后得事件，主要用来设置播放的时间
- (void)clickBeginDrag:(BKSliderProgress*)sliderProgress;
- (void)giftBtnClicked:(UIButton *)button;//点击了礼物按钮

@end


@interface BKPlayBottomView : UIView

@property (nonatomic, weak) id<BKPlayBottomViewDelegate> delegate;

@property (nonatomic, strong) UIButton      *pauseBtn;  //暂停按钮

@property (nonatomic, strong) UITextField   *inputText;

@property (nonatomic, strong) BKSliderProgress  *sliderProgress;

@property (nonatomic, strong) UILabel       *timeLabel;
@property (nonatomic, strong) UILabel       *currentTimeLabel;

@property (nonatomic, assign) NSTimeInterval videoEndTime;  //录像播放长
@property (nonatomic, assign) NSTimeInterval videoPlayTime; //录像播放时长
@property (nonatomic, strong) UIImage *videoPlayBtnImg; //播放按钮图片显示
@property (nonatomic, assign) BOOL keepSilence;//是否被禁言  YES 禁言  NO 未被禁言
@property (nonatomic, assign) BOOL silence_all;//是否被全体禁言  YES 禁言  NO 未被禁言

@property (nonatomic, strong) UIButton      *liveGiftBtn;//观看直播时的礼物按钮

@property (nonatomic, strong) NSString          *masterID; //主播ID

- (instancetype)initWithIsLive:(BOOL)isLive;

- (void)hideKeybord;

- (void)resetViderPlayTimer;  //恢复播放时长状态


/**
 实时更新播放进度条
 */
- (void)preparePlayTimerWithValue:(NSTimeInterval)value duration:(NSTimeInterval)duration;

- (void)watchLiveAdjustViewsWhenKeyboard:(BOOL)isShow;

- (void)setIsLive:(BOOL)isLive;

- (void)setSliderTransValue:(NSInteger)transValue;

@end

//
//  BKPlayerView.h
//  BaiKeMiJiaLive
//
//  Created by chendb on 16/8/22.
//  Copyright © 2016年 facebac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BKIndicatorView.h"
#import "BKEndPlayShareView.h"
#import "BKSliderProgress.h"

@class BKSliderProgress;

@protocol BKPlayerViewDelegate <NSObject>
- (void)clickBeginDrag:(BKSliderProgress*)sliderProgress; //开始拖拽
- (void)sliderPopoverView:(BKSliderProgress*)sliderProgress;  //持续的动作，用于改变播放的开始时间
- (void)clickEndDrag:(BKSliderProgress*)sliderProgress;       //滑块结束后得事件，主要用来设置播放的时间
- (void)clickPlayStopButton:(UIButton*)button;       //开始或暂停视频
- (void)clickResetPlayButton;//重新播放视频

- (void)closePlayerVideo;
- (void)fullScreenClick;

- (void)showOrHideTopButton:(BOOL)isHidden;//是否隐藏顶部的返回和分享按钮

- (void)shareVideoWithType:(NSInteger)type;

@end

@interface BKPlayerView : UIView

@property (nonatomic, weak) id<BKPlayerViewDelegate> delegate;
@property (strong, nonatomic) NSString *videoName;
@property (assign,nonatomic) BOOL isShowProgressView;
@property (nonatomic, strong) BKIndicatorView *indicatorView;
@property (nonatomic,assign)BOOL isLive;
@property(nonatomic,strong)BKEndPlayShareView *shareView;


/**播放暂停*/
@property (nonatomic,strong) UIButton  *playStopBtn;

/**回放播放完成重置按钮*/
- (void)resetSliderValue;



- (void)prepareWithValue:(NSTimeInterval)value duration:(NSTimeInterval)duration;
- (CGFloat)sliderMaxValue;
- (void)prepareWithprogress:(NSTimeInterval)progress;
- (void)loadThumbnailImage:(UIImage*)thumbnailImage;
- (void)killTargetAndAction;
-(void)setVideoName:(NSString *)videoName;
- (void)showSubWidgetStatusTopAndButtomView:(BOOL)top playButton:(BOOL)play;

/** 显示回放按钮 */
- (void)showBackPlayButton:(BOOL)show image:(UIImage *)image;

- (void)hideProgressView:(BOOL)hidden ;

- (void)showProgressView;



/**
 设置播放、全屏按钮是否可用
 */
- (void)setBtnsEnable:(BOOL)enable;

- (void)anchorStopLiveShowEndShareView:(UIImage*)cover;//主播停止直播，显示分享封面

- (void)hideCenterBtn:(BOOL)hide;//隐藏中间的播放暂停按钮

- (void)setEndShareViewCover:(UIImage*)cover;

- (void)hideVideoProgressView;
@end

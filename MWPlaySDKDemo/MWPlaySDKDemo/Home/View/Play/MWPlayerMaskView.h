//
//  BKPlayerView.h
//  BaiKeMiJiaLive
//
//  Created by chendb on 16/8/22.
//  Copyright © 2016年 facebac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BKEndPlayShareView.h"
#import "BKSliderProgress.h"

@class BKSliderProgress;

@protocol BKPlayerViewDelegate <NSObject>
- (void)clickBeginDrag:(BKSliderProgress*)sliderProgress; //开始拖拽
- (void)sliderPopoverView:(BKSliderProgress*)sliderProgress;  //持续的动作
- (void)clickEndDrag:(BKSliderProgress*)sliderProgress;       //滑块结束后得事件，主要用来设置播放的时间
- (void)clickPlayStopButton:(UIButton*)button;       //开始或暂停视频
- (void)clickResetPlayButton;//重新播放视频
- (void)fullScreenClick;

@end

@interface MWPlayerMaskView : UIView

@property (nonatomic, weak) id<BKPlayerViewDelegate> delegate;
@property (strong, nonatomic) NSString *videoName;
@property (assign,nonatomic) BOOL isShowProgressView;
@property (nonatomic,assign)BOOL isLive;

/**结束分享试图*/
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

/** 显示回放按钮 */
- (void)showBackPlayButton:(BOOL)show image:(UIImage *)image;



/**
 隐藏进度view
 */
- (void)hideProgressView:(BOOL)hidden ;


/**
 设置播放、全屏按钮是否可用
 */
- (void)setBtnsEnable:(BOOL)enable;

/**
 某些情况可能一开始没获取到封面，此时调该方法重置
 */
- (void)setEndShareViewCover:(UIImage*)cover;


- (void)hideVideoProgressView;
@end

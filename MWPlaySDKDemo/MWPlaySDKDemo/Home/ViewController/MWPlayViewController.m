//
//  MWPlayViewController.m
//  MWPlaySDKDemo
//
//  Created by mac on 2018/11/20.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "MWPlayViewController.h"
#import "MWNetworkHelper.h"
#import "BKPageSegmentStyle.h"
#import "BKPageScrollPageView.h"
#import "MWLiveChatViewController.h"
#import "MWLiveIntroViewController.h"
#import "MWLiveGifViewController.h"
#import "MWPlayerMaskView.h"
#import "MWGCDTimerManager.h"
#import "BKLandscapePlayView.h"
#import "BKEndLiveCorverView.h"
#import "MWMontUserCenter.h"
#import "MWSecondaryPlayerMaskView.h"
#import "MWPreventScreenRecordingScrollView.h"
#import "BKDefinitionChooseView.h"
#import "MWPlayerManger.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>
#import <MRDLNA/MRDLNA.h>
#import "MWDLNADeviceShowAlertView.h"
#import "MWEnterIntoLiveRoomAnimationManger.h"


#define SecondaryVideoPlayerWidth  120   //次屏播放器宽
#define SecondaryVideoPlayerHeight (120*9/16) //次屏播放器高
#define SecondaryVideoPlayerTop 75  //次屏播放器顶部距离


#define MainVideoPlayerHeight_vertical  (kScreenWidth*9/16)  //主屏播放器竖屏高

static NSString *const timer = @"timer";//更新进度条的定时器
static NSString *const psrTimer = @"psrTimer";//防录屏滚动的定时器

@interface MWPlayViewController ()
<MWPlayerCallbackDelegate,
MWLiveSocketDelegate,
BKPageScrollPageViewDelegate,
MWLiveChatViewControllerDelegate,
BKPlayerViewDelegate,
BKLandscapePlayViewDelegate,
DLNADelegate,
MWDLNADeviceShowAlertViewDelegate>

/** 下部分段试图 */
@property (nonatomic, strong) BKPageScrollPageView *scrollPageView;
@property (nonatomic, strong) NSArray<UIViewController *> *childVcs;
@property (nonatomic, strong) NSArray<NSString *> *titles;


/** socket*/
@property (nonatomic, strong) MWLiveSocket *socket;

/** 聊天的试图控制器 */
@property (nonatomic,strong) MWLiveChatViewController *chatViewController;

/** 加在小屏上的手势 */
@property (nonatomic,strong) UITapGestureRecognizer *secondaryTap;

/** 主屏播放的manger */
@property (nonatomic, strong) MWPlayerManger *pmsManger;

/** 次屏播放的manger */
@property (nonatomic, strong) MWPlayerManger *pssManger;

/** 主屏播放器上的遮罩层 */
@property (nonatomic, strong) MWPlayerMaskView *playerMaskView;

/** 次屏播放器上的遮罩层 */
@property (nonatomic, strong) MWSecondaryPlayerMaskView *secondaryPlayerMaskView;

/** 横屏交互view */
@property (nonatomic, strong) BKLandscapePlayView  *landscapePlayView;

/** 返回按钮 */
@property (nonatomic, strong) UIButton *backButton;

/** 预告展示的试图 */
@property (nonatomic, strong) UIImageView *liveCoverImageView;

/** 主播结束直播 */
@property (nonatomic, assign) BOOL anchorStopLive;

/** 主播端退到后台信号中断 */
@property (nonatomic, assign) BOOL liveNoSignal;

/** 结束观看显示的end试图 */
@property (nonatomic, strong) BKEndLiveCorverView *endLiveCorverView;

/** 直播时显示在右上角的全屏按钮 */
@property (nonatomic, strong) UIButton *fullScreenButton;

/** 防录屏view */
@property (nonatomic, strong) MWPreventScreenRecordingScrollView *srScollView;

//**** AirPlay部分 ****
/** 投屏可点击按钮 */
@property (nonatomic, strong) UIButton *airPlayClickButton;

/** 当前投屏的设备名称 */
@property (nonatomic, copy)   NSString *airplayDeviceName;

/** 投屏后显示的操作view */
@property (nonatomic, strong) UIView  *airPlayView;

//**** DLNA部分 ****
/** DLNA投屏管理者 */
@property (nonatomic, strong) MRDLNA *dlnaManager;

/** DLNA搜索到的可投屏的设备 */
@property (nonatomic, strong) NSMutableArray *dlnaDeviceDataSource;

/** DLNA设备显示弹框 */
@property (nonatomic, strong) MWDLNADeviceShowAlertView *dlnaAlertView;

/** 当前DLNA设备的名称 */
@property (nonatomic, strong) NSString *currentDLNADeviceName;

/** 聊天室进入动画 */
@property (nonatomic, strong) MWEnterIntoLiveRoomAnimationManger *enterIntoLiveRoomAnimationManger;

@end

@implementation MWPlayViewController


#pragma mark - ******************life 部分*******************
- (instancetype)init
{
    if(self=[super init]){
        
        _pmsManger = [MWPlayerManger new];
        _pmsManger.isStartPlay = NO;
        _pmsManger.isCompletePlay = NO;
        _pmsManger.isPause = NO;
        _pmsManger.definitionChooseCurrentIndex = 0;
       
        
        _pssManger = [MWPlayerManger new];
        _pssManger.isStartPlay = NO;
        _pssManger.isCompletePlay = NO;
        _pssManger.isPause = NO;
        _pssManger.definitionChooseCurrentIndex = 0;
       
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    if (!self.isOrder) {
        [self startPlay];
    }
    
    [self connectSocket];
    
    [self layoutUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationChange) name:UIDeviceOrientationDidChangeNotification object:nil];
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    
}

- (void)dealloc {
    
    if(self.pmsManger.player) {
        [self.pmsManger.player stop];
        self.pmsManger.player = nil;
    }
    
    if(self.pssManger.player) {
        [self.pssManger.player stop];
        self.pssManger.player = nil;
    }
    if (_socket) {
        [_socket releaseSocketIO];
        _socket = nil;
    }
    
    [[MWGCDTimerManager sharedInstance] cancelTimerWithName:timer];
    if(self.preventRecordScreen) {
        [[MWGCDTimerManager sharedInstance] cancelTimerWithName:psrTimer];
    }
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}



- (void)setMainDefinitionModel:(MWDefinitionModel *)mainDefinitionModel {
    
    self.pmsManger.definitionModel = mainDefinitionModel;
    self.pmsManger.currentPlayUrl  =  mainDefinitionModel.playUrl;
    
}

- (void)setSecondaryDefinitionModel:(MWDefinitionModel *)secondaryDefinitionModel {
    
    self.pssManger.definitionModel = secondaryDefinitionModel;
    self.pssManger.currentPlayUrl  = secondaryDefinitionModel.playUrl;
}


#pragma mark - ******************UI部分*******************
- (void)layoutUI {
    
    if (self.isOrder) {
        [self.view addSubview:self.liveCoverImageView];
        [self.liveCoverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.view);
            make.width.mas_equalTo(kScreenWidth);
            make.height.mas_equalTo(kScreenWidth*9/16);
        }];
        [self.liveCoverImageView sd_setImageWithURL:[NSURL URLWithString:self.liveCover] placeholderImage:[UIImage imageNamed:@"live_cover"]];
    }
    [self.view addSubview:self.backButton];
    [self.view addSubview:self.fullScreenButton];
    
    if (self.isLive) {
        self.fullScreenButton.hidden = NO;
    }
    
    
    [self.backButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        if (kiPhone_X) {
            make.top.mas_offset(44);
        } else {
            make.top.mas_offset(15);
        }
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    
    BKPageSegmentStyle *style = [[BKPageSegmentStyle alloc] init];
    style.showLine                = YES;
    style.gradualChangeTitleColor = YES;
    style.scrollTitle             = NO;
    style.adjustCoverOrLineWidth  = YES;
    style.segmentViewBounces      = NO;
    style.contentViewBounces      = NO;
    style.showLine                = YES;
    style.showBottomLine          = YES;
    style.scrollContentView       = YES;
    style.badgeViewShow           = YES;
    style.scrollLineHeight        = 3;
    style.scrollLineWidth         = 20;
    style.bottomLineColor         = [UIColor colorWithHexString:@"#E5E5E5"];
    style.bottomLineHeight        = 1;
    style.titleFont               = kFont(16);
    style.normalTitleColor        = [UIColor colorWithHexString:@"#999999"];
    style.selectedTitleColor      = [UIColor colorWithHexString:@"#2B94FF"];
    style.scrollLineColor         = [UIColor colorWithHexString:@"#2B94FF"];
    self.titles = @[@"聊天",@"详情",@"礼物"];
    self.scrollPageView = [[BKPageScrollPageView alloc] initWithFrame:CGRectMake(0, MainVideoPlayerHeight_vertical, self.view.bounds.size.width, self.view.bounds.size.height - MainVideoPlayerHeight_vertical) segmentStyle:style titles:self.titles parentViewController:self delegate:self];
    [self.view addSubview:_scrollPageView];
    
    if (self.preventRecordScreen) {
        [self.view addSubview:self.srScollView];
        [self handlePreventRecordScreen];
    }
}



- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    UIViewController<ZJScrollPageViewChildVcDelegate> *childVc = reuseViewController;
    if (!childVc) {
        if(index == 0){
            childVc = [[MWLiveChatViewController alloc]init];
            self.chatViewController = (MWLiveChatViewController *)childVc;
            self.chatViewController.delegate = self;
            self.chatViewController.isMainPlay = YES;
            self.chatViewController.definitionChooseCurrentIndex_mvp = self.pmsManger.definitionChooseCurrentIndex;
            self.chatViewController.definitionChooseCurrentIndex_svp = self.pssManger.definitionChooseCurrentIndex;
        }else if (index == 1){
            childVc = [[MWLiveIntroViewController alloc] init];
        }else {
            childVc = [[MWLiveGifViewController alloc] init];
        }
    }
    return childVc;
}

- (BOOL)scrollPageController:(UIViewController *)scrollPageController contentScrollView:(BKPageCollectionView *)scrollView shouldBeginPanGesture:(UIPanGestureRecognizer *)panGesture
{
    if (scrollView.contentOffset.x == 0) {
        CGPoint point = [panGesture translationInView:self.view];
        if (point.x > 0) {
            return NO;
        }
    }
    return YES;
}

- (NSInteger)numberOfChildViewControllers {
    return  self.titles.count;
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}

#pragma mark - ————————————————————————  转屏相关  ————————————————————————
- (BOOL)shouldAutorotate{
    return YES;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    //主屏未开始、主屏竖屏播放结束
    if (((!self.pmsManger.isStartPlay || (self.pmsManger.isCompletePlay && self.landscapePlayView.hidden)) && [self returnIsMainVideoPlayer])||
        ((!self.pssManger.isStartPlay || (self.pssManger.isCompletePlay && self.landscapePlayView.hidden)) && ![self returnIsMainVideoPlayer])) {
        return UIInterfaceOrientationMaskPortrait;
    }else {
        return UIInterfaceOrientationMaskLandscapeRight|UIInterfaceOrientationMaskPortrait|UIInterfaceOrientationMaskLandscapeLeft;
    }
}


//设置样式
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

//设置是否隐藏
- (BOOL)prefersStatusBarHidden {
    return NO;
}

//设置隐藏动画
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationNone;
}


- (void)deviceOrientationChange {
    
    //主屏未开始、主屏竖屏播放结束
    if (((!self.pmsManger.isStartPlay || (self.pmsManger.isCompletePlay && self.landscapePlayView.hidden)) && [self returnIsMainVideoPlayer])||
        ((!self.pssManger.isStartPlay || (self.pssManger.isCompletePlay && self.landscapePlayView.hidden)) && ![self returnIsMainVideoPlayer])) {
        return;
    }
    
    //横屏
    if (kScreenWidth > kScreenHeight) {
        self.scrollPageView.hidden = YES;
        self.playerMaskView.hidden = YES;
        self.fullScreenButton.hidden = YES;
        self.landscapePlayView.hidden = NO;
        self.backButton.hidden = YES;
        
        if (!self.isLive) {
            
            [self.landscapePlayView.bottomView preparePlayTimerWithValue:[self returnIsMainVideoPlayer] ? self.pmsManger.player.getCurrentTime : self.pssManger.player.getCurrentTime duration:[self returnIsMainVideoPlayer] ?self.pmsManger.player.getDuration : self.pssManger.player.getDuration];
        }
        
        if ([self returnIsMainVideoPlayer]) {
            
            self.pssManger.player.left = kScreenWidth - SecondaryVideoPlayerWidth;
            self.pssManger.player.top = SecondaryVideoPlayerTop;
            
            self.pmsManger.player.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
            
        }else {
            self.pssManger.player.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
            
            self.pmsManger.player.left = kScreenWidth - SecondaryVideoPlayerWidth;
            self.pmsManger.player.top = SecondaryVideoPlayerTop;
        }
        
    }else { //竖屏
        
        self.scrollPageView.hidden = NO;
        self.playerMaskView.hidden = NO;
        if (self.isLive) {
            self.fullScreenButton.hidden = NO;
        }
        self.landscapePlayView.hidden = YES;
        self.backButton.hidden = NO;
        
        if (!self.isLive) {
            [self.playerMaskView prepareWithValue:[self returnIsMainVideoPlayer] ? self.pmsManger.player.getCurrentTime : self.pssManger.player.getCurrentTime duration:self.pmsManger.player.getDuration];
        }
        
        if ([self returnIsMainVideoPlayer]) {
            self.pmsManger.player.frame = CGRectMake(0, 0, kScreenWidth, MainVideoPlayerHeight_vertical);
            self.pssManger.player.left = kScreenWidth - SecondaryVideoPlayerWidth;
            self.pssManger.player.top = SecondaryVideoPlayerTop;
            
        }else {
            self.pssManger.player.frame = CGRectMake(0, 0, kScreenWidth, MainVideoPlayerHeight_vertical);
            self.pmsManger.player.left = kScreenWidth - SecondaryVideoPlayerWidth;
            self.pmsManger.player.top =  SecondaryVideoPlayerTop;
        }
    }
    
    _secondaryPlayerMaskView.frame = [self returnIsMainVideoPlayer] ? self.pssManger.player.frame : self.pmsManger.player.frame;
    
    //放录屏转屏处理
    if (self.preventRecordScreen) {
        [[MWGCDTimerManager sharedInstance]cancelTimerWithName:psrTimer];
        [self.srScollView stopScrollWithAnimation];
        [self handlePreventRecordScreen];
    }
}



#pragma mark - ******************private action部分*******************
#pragma mark - 结束DLNA的投屏
- (void)endDLNA {
    [self.dlnaManager endDLNA];
    self.airPlayView.hidden = YES;
    
//    self.dlnaManager.device = nil;
//    self.dlnaManager.playUrl = nil;
}


#pragma mark - 处理防录屏
- (void)handlePreventRecordScreen {
    [self.srScollView beginScrollWithAnimation];
    [[MWGCDTimerManager sharedInstance]scheduledDispatchTimerWithName:psrTimer  timeInterval:4.0 queue:nil repeats:YES action:^{
        [self.srScollView beginScrollWithAnimation];
    }];
}

#pragma mark - 返回是否是主播放器在大屏
- (BOOL)returnIsMainVideoPlayer {
    
    return self.pmsManger.player.mj_w > self.pssManger.player.mj_w;
    
}


#pragma mark - 返回
- (void)back {
    
    if(self.pmsManger.player) {
        [self.pmsManger.player stop];
        self.pmsManger.player = nil;
    }
    
    if(self.pssManger.player) {
        [self.pssManger.player stop];
        self.pssManger.player = nil;
    }
    if (_socket) {
        [_socket releaseSocketIO];
        _socket = nil;
    }
    
    [[MWGCDTimerManager sharedInstance] cancelTimerWithName:timer];
    if(self.preventRecordScreen) {
        [[MWGCDTimerManager sharedInstance] cancelTimerWithName:psrTimer];
    }
    
    if (!self.isLive) {
        [MWVideoDBManger insertOrReplaceVideo:self.videoModel];//存入续播时间
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self.enterIntoLiveRoomAnimationManger removeEnterIntoView];
    
    
}


#pragma mark -  退出全屏
- (void)exitFullScreen {
    
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationPortrait] forKey:@"orientation"];
    
}

#pragma mark - 开始定时器
- (void)startTimer {
    if (!self.isLive) {
    
        [[MWGCDTimerManager sharedInstance]scheduledDispatchTimerWithName:timer  timeInterval:0.5 queue:nil repeats:YES action:^{
            if ((self.pmsManger.isStartPlay && !self.pmsManger.isCompletePlay) ||
                (self.pssManger.isStartPlay && !self.pssManger.isCompletePlay) ) {
                
                if (isnan(self.pmsManger.player.getDuration)) {
                    return ;
                }
                //记录播放的时间
                self.videoModel.lastWatchTime = self.pmsManger.player.getCurrentTime;
                
                if ([self returnIsMainVideoPlayer]) {
                   
                    //处理播放进度条
                    [self.playerMaskView prepareWithValue:self.pmsManger.player.getCurrentTime duration:self.pmsManger.player.getDuration];
                    [self.landscapePlayView.bottomView preparePlayTimerWithValue:self.pmsManger.player.getCurrentTime duration:self.pmsManger.player.getDuration];
                    
                }else {
                    
                    //处理播放进度条
                    [self.playerMaskView prepareWithValue:self.pssManger.player.getCurrentTime duration:self.pmsManger.player.getDuration];
                    [self.landscapePlayView.bottomView preparePlayTimerWithValue:self.pssManger.player.getCurrentTime duration:self.pmsManger.player.getDuration];
                }
                
            }
        }];
    }
}


- (void)stopTimer {
    [[MWGCDTimerManager sharedInstance] cancelTimerWithName:timer];
}

#pragma mark - 双屏切换
- (void)doubleScreenPlay {
    
    //小屏播放完成，点击小屏
    if (kScreenWidth > kScreenHeight) {
        if (self.secondaryPlayerMaskView.hidden == NO) {
            [self exitFullScreen];
        }
    }
    
    //先隐藏
    self.secondaryPlayerMaskView.hidden = YES;
    
    //两个都播放完成，点击不切换
    if (self.pssManger.isCompletePlay && self.pmsManger.isCompletePlay) {
        
        self.secondaryPlayerMaskView.hidden = NO;
        return;
    }
    
    CGRect frame = self.pmsManger.player.frame;
    CGRect frame2 = self.pssManger.player.frame;
    
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.pmsManger.player.frame = frame2;
    self.pssManger.player.frame = frame;
    [CATransaction commit];
    
    
    NSInteger index = [self.view.subviews indexOfObject:self.pmsManger.player];
    NSInteger smallIndex = [self.view.subviews indexOfObject:self.pssManger.player];
    
    [self.view exchangeSubviewAtIndex:index withSubviewAtIndex:smallIndex];
    
    [self.pssManger.player removeGestureRecognizer:self.secondaryTap];
    [self.pmsManger.player removeGestureRecognizer:self.secondaryTap];
    
    
    if ([self returnIsMainVideoPlayer]) {
        
        [self.pssManger.player addGestureRecognizer:self.secondaryTap];
        self.chatViewController.isMainPlay = YES;
    }else {
        [self.pmsManger.player addGestureRecognizer:self.secondaryTap];
        self.chatViewController.isMainPlay = NO;
    }
    
    
    [self showSecondaryPlayerMaskView];
    
    //处理有一个播放器结束的情况
    if (([self returnIsMainVideoPlayer] && self.pmsManger.isCompletePlay) ||
        (![self returnIsMainVideoPlayer] && self.pssManger.isCompletePlay)) { //大屏上的结束
        
        [self.playerMaskView showBackPlayButton:YES image:[UIImage imageNamed:@"live_cover"]];
        self.playerMaskView.playStopBtn.selected = NO;
        self.landscapePlayView.bottomView.pauseBtn.selected = NO;
        
    }else {
        [self.playerMaskView showBackPlayButton:NO image:nil];
        self.playerMaskView.playStopBtn.selected = YES;
        self.landscapePlayView.bottomView.pauseBtn.selected = YES;
    }
    
    //处理手动触发的暂停暂停
    if (([self returnIsMainVideoPlayer] && self.pmsManger.isPause) ||
        (![self returnIsMainVideoPlayer] && self.pssManger.isPause)) {
        self.playerMaskView.playStopBtn.selected = NO;
        self.landscapePlayView.bottomView.pauseBtn.selected = NO;
    }
    
}

#pragma mark - 处理小屏遮盖试图的显示和隐藏
- (void)showSecondaryPlayerMaskView {
    
    self.secondaryPlayerMaskView.hidden = YES;
    
    //小屏结束,没有切换到大屏
    if ([self returnIsMainVideoPlayer] && self.pssManger.isCompletePlay) {
        
        _secondaryPlayerMaskView.hidden = NO;
    }
    
    //小屏结束,切换到大屏
    //    if (![self returnIsMainVideoPlayer] && self.secondaryScreenModel.isCompletePlay) {
    //        _secondaryPlayerMaskView.hidden = YES;
    //    }
    
    //大屏结束，切换到小屏
    if (![self returnIsMainVideoPlayer] && self.pmsManger.isCompletePlay) {
        _secondaryPlayerMaskView.hidden = NO;
    }
    
    //大屏结束,没有切换到大屏
    //    if ([self returnIsMainVideoPlayer] && self.mainScreenModel.isCompletePlay) {
    //        _secondaryPlayerMaskView.hidden = YES;
    //    }
    
}

#pragma mark - 主播主动结束直播
- (void)anchorStopLiving:(BOOL)isMain{
    
    self.anchorStopLive = YES;
    self.fullScreenButton.hidden = YES;
    
    if (isMain) {
        [self.pmsManger.player stop];
        self.pmsManger.isCompletePlay = YES;
    }else {
        [self.pssManger.player stop];
        self.pssManger.isCompletePlay = YES;
    }
    
    //处理小屏
    [self showSecondaryPlayerMaskView];
    
    //大屏结束直播
    if (([self returnIsMainVideoPlayer] && isMain) ||
        (![self returnIsMainVideoPlayer] && !isMain)) {
        //退出全屏
        [self exitFullScreen];
        //显示
        [self.playerMaskView showBackPlayButton:YES image:[UIImage imageNamed:@"live_cover"]];
        [self.view bringSubviewToFront:self.backButton];
    }
    
}


#pragma mark - 信号中断
- (void)signalInterrupt{
    
    [self.pmsManger.player pause];//信号中断暂停直播
    
    [self.pssManger.player pause];
    
    self.liveNoSignal = YES;//信号中断
    
    [self.endLiveCorverView setCorverImage:[UIImage imageNamed:@"live_cover"]];
    [self.endLiveCorverView setIsEndLive:NO];
    [self.playerMaskView addSubview:self.endLiveCorverView];
    [self.playerMaskView hideProgressView:YES];
    [self.endLiveCorverView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.playerMaskView);
    }];
}


#pragma mark - 信号恢复
- (void)signalRecover{
    
    self.liveNoSignal = NO;//信号恢复
    
    self.endLiveCorverView.hidden = YES;
    [self.endLiveCorverView removeFromSuperview];
    self.endLiveCorverView = nil;
    
    self.playerMaskView.isShowProgressView = NO;
    
}

#pragma mark - ******************public action部分*******************
- (CGFloat)playerItemDuration
{
    return [self returnIsMainVideoPlayer] ? [self.pmsManger.player getDuration] : [self.pssManger.player getDuration];
}


#pragma mark - ******************delegate部分*******************

#pragma mark - ******************MWDLNADeviceShowAlertViewDelegate*******************
//DLNA去投屏
- (void)DLNAStartPlay:(CLUPnPDevice *)device; {
    
    //@"http://wvideo.spriteapp.cn/video/2016/0328/56f8ec01d9bfe_wpd.mp4"
    self.dlnaManager.device = device;
    self.dlnaManager.playUrl = [self returnIsMainVideoPlayer] ? self.pmsManger.currentPlayUrl : self.pssManger.currentPlayUrl;
    //self.dlnaManager.playUrl = @"http://wvideo.spriteapp.cn/video/2016/0328/56f8ec01d9bfe_wpd.mp4";
    [self.dlnaManager startDLNA];
    self.currentDLNADeviceName = device.friendlyName;
}


#pragma mark - ******************DLNADelegate*******************
- (void)searchDLNAResult:(NSArray *)devicesArray{
    if (devicesArray.count == 0) {
        NSLog(@"请保证网络通畅，并保持设备在同一WiFi下~");
        return;
    }
    [self.dlnaAlertView showWithDevices:devicesArray];
}


- (void)dlnaStartPlay{
    NSLog(@"投屏成功 开始播放");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.dlnaAlertView removeSelf];
         self.airPlayView.hidden = NO;
        for (UIView *subView in self.airPlayView.subviews) {
            if ([subView isKindOfClass:[UILabel class]]) {
                ((UILabel *)subView).text = [NSString stringWithFormat:@"与%@连接中...",self.currentDLNADeviceName];
                break;
            }
        }
    });
}


#pragma mark - MWLiveChatViewControllerDelegate
-(void)sendMsg:(NSString *)inputText {
    [self.socket sendMessageWithText:inputText nickName:@"测试" userId:mw_mineUserId headPic:@""];
}


- (void)sendGif {
    [self.socket presentGiftWithNickName:@"测试" userId:mw_mineUserId headPic:@"" giftID:2 giftCount:1 giftName:@"礼物" giftImagUrl:@""];
}


- (void)sendParas {
    [self.socket sendPraiseWithNickName:@"测试" userId:mw_mineUserId headPic:@""];
}

- (void)changeShortVideo {
    
    //以下代码测试切换播放短视频的url
    [self stopTimer];
    static NSString *currentPlayUrl = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        currentPlayUrl = @"http://qvw.facebac.com/hls/581daa97b4723c20df9e/x36s8kr6gtbl9qto53mp/n_n/025851fb1e5c5a748bcccf9e7fff9140.m3u8?xstToken=00728f15";
    });
    
    [self.pmsManger.player stop];
    [self.pmsManger.player start:currentPlayUrl bufferTime:0 offset:0];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([currentPlayUrl hasSuffix:@"xstToken=00728f15"]) {
            currentPlayUrl = self.pmsManger.definitionModel.playUrl;
        }else {
            currentPlayUrl = @"http://qvw.facebac.com/hls/581daa97b4723c20df9e/x36s8kr6gtbl9qto53mp/n_n/025851fb1e5c5a748bcccf9e7fff9140.m3u8?xstToken=00728f15";
        }
    });
    
}

#pragma mark - 切换清晰度
- (void)definitionChoose:(NSInteger)currentIndex {
    NSString *mainDefUrl = self.pmsManger.definitionModel.playUrl;
    NSString *secondaryDefUrl = self.pssManger.definitionModel.playUrl;
    switch (currentIndex) {
        case 0:
            
            break;
        case 1:
            mainDefUrl = self.pmsManger.definitionModel.playUrl720;
            secondaryDefUrl = self.pssManger.definitionModel.playUrl720;
            break;
        case 2:
            mainDefUrl = self.pmsManger.definitionModel.playUrl480;
            secondaryDefUrl = self.pssManger.definitionModel.playUrl480;
            break;
            
        default:
            break;
    }
    
    CGFloat mainPTime = .0;
    if ([self returnIsMainVideoPlayer]) {
        if (mainDefUrl.length == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该清晰度返回的url为空" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        mainPTime = self.pmsManger.player.getCurrentTime;
        [self.pmsManger.player stop];
        [self.pmsManger.player start:mainDefUrl bufferTime:0 offset:mainPTime];
        
        self.pmsManger.definitionChooseCurrentIndex = currentIndex;
        //同步chatViewController
        self.chatViewController.definitionChooseCurrentIndex_mvp = currentIndex;
    }else {
        if (secondaryDefUrl.length == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该清晰度返回的url为空" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        mainPTime = self.pssManger.player.getCurrentTime;
        [self.pssManger.player stop];
        [self.pssManger.player start:secondaryDefUrl bufferTime:0 offset:mainPTime];
        
        self.pssManger.definitionChooseCurrentIndex = currentIndex;
        //同步chatViewController
        self.chatViewController.definitionChooseCurrentIndex_svp = currentIndex;
    }
    
    self.pmsManger.currentPlayUrl = mainDefUrl;
    self.pssManger.currentPlayUrl = secondaryDefUrl;
    
    [self stopTimer];
}


- (void)getChatRoomHistoryMessage:(NSString *)lastMessageID {\
  
    [self.socket getChatRoomHistoryMessageWithLastMessageID:lastMessageID];
}



#pragma mark - BKLandscapePlayViewDelegate
-(void)landscapePlayViewClickWithButton:(UIButton *)button{
    
    NSInteger buttonTag = button.tag % 5000;
    
    switch (buttonTag) {
        case 1:
            [self clickPlayStopButton:button];
            break;
        case 2:
            [self exitFullScreen];
            break;
        case 3:
            NSLog(@"点击了横屏的分享");
            break;
        case 4:
            NSLog(@"点击了横屏的礼物按钮");
            break;
            
        default:
            break;
    }
}


#pragma mark - 开始拖动进度条 -->横屏
- (void)beginBottomViewSliderProgress:(BKSliderProgress*)sliderProgress {
    
    //主屏未开始 或者主屏竖屏播放结束
    if (!self.pmsManger.isStartPlay || (self.pmsManger.isCompletePlay && self.landscapePlayView.hidden)) {
        return ;
    }
    if ([self returnIsMainVideoPlayer]) {
        
        [self.pmsManger.player pause];
    }else {
        [self.pssManger.player pause];
    }
    [self stopTimer];
}


#pragma mark - 持续的动作
- (void)changeBottomViewSliderProgress:(BKSliderProgress*)sliderProgress {
    
    if (sliderProgress.maxValue - sliderProgress.value < 5 && sliderProgress.maxValue >= 5) {//直接拖动到末尾时，让他至少播放5S，否则马上点重播可能会播放失败
        if ([self returnIsMainVideoPlayer]) {
            [self.pmsManger.player seekTo:sliderProgress.maxValue - 5];
        }else {
            [self.pssManger.player seekTo:sliderProgress.maxValue - 5];
        }
    }else{
        if ([self returnIsMainVideoPlayer]) {
            [self.pmsManger.player seekTo:sliderProgress.value];
        }else {
            [self.pssManger.player seekTo:sliderProgress.value];
        }
    }
    
}

#pragma mark - 结束拖动进度条 -->横屏
- (void)endBottomViewSliderProgress:(BKSliderProgress*)sliderProgress{
    if (sliderProgress.maxValue - sliderProgress.value < 5 && sliderProgress.maxValue >= 5) {//直接拖动到末尾时，让他至少播放5S，否则马上点重播可能会播放失败
        if ([self returnIsMainVideoPlayer]) {
            [self.pmsManger.player seekTo:sliderProgress.maxValue - 5];
        }else {
            [self.pssManger.player seekTo:sliderProgress.maxValue - 5];
        }
    }else{
        if ([self returnIsMainVideoPlayer]) {
            [self.pmsManger.player seekTo:sliderProgress.value];
        }else {
            [self.pssManger.player seekTo:sliderProgress.value];
        }
    }
}



- (void)showUserInfoViewWithID:(NSString*)userID{
    NSLog(@"点击了主播头像");
}


#pragma mark - 横屏的清晰度选择
- (void)showDefinitionView {
    
    BKDefinitionChooseView *chooseView = [[BKDefinitionChooseView alloc]initWithFrame:[UIScreen mainScreen].bounds buttons:@[@"原画",@"高清",@"标清"] currentChooseIndex:[self returnIsMainVideoPlayer] ? self.pmsManger.definitionChooseCurrentIndex : self.pssManger.definitionChooseCurrentIndex playDirection:PlayDirectionVertical];
    [chooseView setDefinitionButtonActionBlock:^(NSString *definition,NSInteger currentIndex) {
        
        [self definitionChoose:currentIndex];
        
    }];
    [chooseView show:kWindow];
    
}


#pragma mark - BKPlayerViewDelegate
#pragma mark - 开始或暂停视频
- (void)clickPlayStopButton:(UIButton*)button
{
    if (([self returnIsMainVideoPlayer] && !self.pmsManger.isStartPlay) ||
        ([self returnIsMainVideoPlayer] && !self.pssManger.isStartPlay)) {
        NSLog(@"视频缓冲中");
        return;
    }
    if (button.selected) {
        if ([self returnIsMainVideoPlayer]) {
            [self.pmsManger.player pause];
            self.pmsManger.isPause = YES;
        }else {
            [self.pssManger.player pause];
            self.pssManger.isPause = YES;
        }
    }else {
        if ([self returnIsMainVideoPlayer]) {
            [self.pmsManger.player resume];
            self.pmsManger.isPause = NO;
        }else {
            [self.pssManger.player resume];
            self.pssManger.isPause = NO;
        }
    }
    
    BOOL selected = !button.selected;
    self.playerMaskView.playStopBtn.selected = selected;
    self.landscapePlayView.bottomView.pauseBtn.selected = selected;
    
}


#pragma mark - 开始拖动进度条 -->竖屏
- (void)clickBeginDrag:(BKSliderProgress*)sliderProgress {
    
    //主屏未开始 或者主屏竖屏播放结束
    if (!self.pmsManger.isStartPlay || (self.pmsManger.isCompletePlay && self.landscapePlayView.hidden)) {
        return ;
    }
    if([self returnIsMainVideoPlayer]) {
        [self.pmsManger.player pause];
    }else {
        [self.pssManger.player pause];
    }
    [self stopTimer];
}


#pragma mark - 持续的动作
- (void)sliderPopoverView:(BKSliderProgress *)sliderProgress {
    
    if (sliderProgress.maxValue - sliderProgress.value < 5 && sliderProgress.maxValue >= 5) {//直接拖动到末尾时，让他至少播放5S，否则马上点重播可能会播放失败
        if ([self returnIsMainVideoPlayer]) {
            [self.pmsManger.player seekTo:sliderProgress.maxValue - 5];
        }else {
            [self.pssManger.player seekTo:sliderProgress.maxValue - 5];
        }
    }else{
        if ([self returnIsMainVideoPlayer]) {
            [self.pmsManger.player seekTo:sliderProgress.value];
        }else {
            [self.pssManger.player seekTo:sliderProgress.value];
        }
    }
    
}

#pragma mark - 结束拖动进度条 -->竖屏
- (void)clickEndDrag:(BKSliderProgress *)sliderProgress {
    if (sliderProgress.maxValue - sliderProgress.value < 5 && sliderProgress.maxValue >= 5) {//直接拖动到末尾时，让他至少播放5S，否则马上点重播可能会播放失败
        if ([self returnIsMainVideoPlayer]) {
            [self.pmsManger.player seekTo:sliderProgress.maxValue - 5];
        }else {
            [self.pssManger.player seekTo:sliderProgress.maxValue - 5];
        }
    }else{
        if ([self returnIsMainVideoPlayer]) {
            [self.pmsManger.player seekTo:sliderProgress.value];
        }else {
            [self.pssManger.player seekTo:sliderProgress.value];
        }
    }
}

#pragma mark - 重新播放
- (void)clickResetPlayButton {
    if([self returnIsMainVideoPlayer]) {
        [self.pmsManger.player seekTo:0];
    }else {
        [self.pssManger.player seekTo:0];
    }
}




#pragma mark - 全屏
- (void)fullScreenClick {
    UIDeviceOrientation devOri = [[UIDevice currentDevice] orientation];
    if (devOri == UIDeviceOrientationLandscapeLeft){
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationPortrait] forKey:@"orientation"];
    }
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationLandscapeRight] forKey:@"orientation"];
}


#pragma mark - ******************投屏部分*******************
- (void)setupAirPlayOrDLNA {
    
    //投屏部分 **** AirPlay投屏 ****
    [self.playerMaskView addSubview:self.airPlayView];
    [self.playerMaskView addSubview:self.airPlayClickButton];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteHasChangedNotification:) name:AVAudioSessionRouteChangeNotification object:[AVAudioSession sharedInstance]];
    
}


//投屏部分 **** AirPlay投屏 ****
- (void)audioRouteHasChangedNotification:(NSNotification *)notification{
    NSString *airplayDeviceName = [self activeAirplayOutputRouteName];
    self.airplayDeviceName = airplayDeviceName;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (airplayDeviceName.length > 0) {
            NSLog(@"投屏中");
            self.airPlayView.hidden = NO;
            for (UIView *subView in self.airPlayView.subviews) {
                if ([subView isKindOfClass:[UILabel class]]) {
                    ((UILabel *)subView).text = [NSString stringWithFormat:@"与%@连接中",self.airplayDeviceName];
                    break;
                }
            }
        }else {
            self.airPlayView.hidden = YES;
            NSLog(@"关闭投屏");
        }
    });
    
}

//投屏部分 **** AirPlay投屏 ****
- (NSString*)activeAirplayOutputRouteName
{
    AVAudioSession* audioSession = [AVAudioSession sharedInstance];
    AVAudioSessionRouteDescription* currentRoute = audioSession.currentRoute;
    for (AVAudioSessionPortDescription* outputPort in currentRoute.outputs){
        NSLog(@"outputPort:%@",outputPort);
        if ([outputPort.portType isEqualToString:AVAudioSessionPortAirPlay])
            return outputPort.portName;
    }
    
    return nil;
}



#pragma mark - ******************player部分*******************
- (void)startPlay {
    
    self.pmsManger.player = [[MWVideoPlayer alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, MainVideoPlayerHeight_vertical) andType:self.isLive ? MWPlayerTypeLive : MWPlayerTypeRecord andDelegate:self response:^(BOOL success, NSString *msg) {
        NSLog(@"%@",msg);
    }];
    self.pmsManger.player.backgroundColor = [UIColor blackColor];
    [self.pmsManger.player setVideoScale:(MWPlayerScaleModeTypeResize) redraw:YES];
    
    if (!self.isLive && self.videoModel.lastWatchTime > 0) {
        //开始播放
        [self.pmsManger.player start:self.pmsManger.definitionModel.playUrl bufferTime:0 offset:self.videoModel.lastWatchTime];
    }else {
        [self.pmsManger.player start:self.pmsManger.definitionModel.playUrl bufferTime:0 offset:0]; //开始播放
    }
    self.pmsManger.player.tag = 1;
    [self.view addSubview:self.pmsManger.player];
    [self.view addSubview:self.playerMaskView];
    
    NSLog(@"%@",self.pmsManger.definitionModel.playUrl);
    
    //有次流
    if (self.pssManger.definitionModel.playUrl.length > 0) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            self.secondaryTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleScreenPlay)];
            
            self.pssManger.player = [[MWVideoPlayer alloc] initWithFrame:CGRectMake(kScreenWidth - SecondaryVideoPlayerWidth , SecondaryVideoPlayerTop, SecondaryVideoPlayerWidth, SecondaryVideoPlayerHeight) andType:self.isLive ? MWPlayerTypeLive : MWPlayerTypeRecord  andDelegate:self response:^(BOOL success, NSString *msg) {
                NSLog(@"%@",msg);
            }];
            self.pssManger.player.tag = 2;
            self.pssManger.player.backgroundColor = [UIColor blackColor];
            [self.view addSubview:self.pssManger.player];
            
            [self.pssManger.player setVideoScale:(MWPlayerScaleModeTypeResize) redraw:YES];
            [self.pssManger.player start:self.pssManger.definitionModel.playUrl bufferTime:0 offset:0]; //开始播放
            [self.pssManger.player addGestureRecognizer:self.secondaryTap];
            
            
            self.secondaryPlayerMaskView.frame = self.pssManger.player.frame;
            [self.view addSubview:self.secondaryPlayerMaskView];
            
        });
    }
    
    [self setupAirPlayOrDLNA];
}



- (void)playerCallbackWithMessage:(id)playerid msgCode:(MWCallbackType)code player:(MWVideoPlayer *)player{ //播放器各种状态回调
    
    switch (code) {
        case MWCallbackTypeOK:
            NSLog(@"MWCallbackTypeOK");
            break;
        case MWCallbackTypeOutOfMemory:
            NSLog(@"内存不足");
            break;
        case MWCallbackTypeNoSourceDemux:
            NSLog(@"无法处理播放地址");
            
            break;
        case MWCallbackTypeNoAudioCodec:
            NSLog(@"无音频解码器");
            break;
        case MWCallbackTypeNoVideoCodec:
            NSLog(@"无视频解码器");
            break;
        case MWCallbackTypeConnectServer:
            NSLog(@"正在连接服务器");
            
            break;
        case MWCallbackTypeNetworkError:
            NSLog(@"网络错误");
            
            break;
        case MWCallbackTypeMediaSpecError:
            NSLog(@"媒体格式错误");
            break;
        case MWCallbackTypeNoPlayObject:
            NSLog(@"无播放对象");
            
            break;
        case MWCallbackTypeNetTimeOut:
            NSLog(@"网络超时");
            
            break;
        case MWCallbackTypeOpenAVDevice:
            NSLog(@"MWCallbackTypeOpenAVDevice");
            break;
        case MWCallbackTypeNotifyMediaInfo:
            NSLog(@"媒体信息获取完毕");
            
            break;
        case MWCallbackTypeStartBufferData:
            NSLog(@"开始缓冲数据");
            
            
            break;
        case MWCallbackTypePrePlay:
            NSLog(@"即将开始播放");
            if (player.tag == 1) {
                self.pmsManger.isStartPlay = YES;
                self.pmsManger.isCompletePlay = NO;
            }else {
                self.pssManger.isStartPlay = YES;
                self.pssManger.isCompletePlay = NO;
            }
            break;
        case MWCallbackTypeStartPlay:
            //回放
            self.playerMaskView.playStopBtn.selected = YES;
            self.landscapePlayView.bottomView.pauseBtn.selected = YES;
            //处理播放进度条
            [self startTimer];

        //处理投屏
//        {
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                NSString *airplayDeviceName = [self activeAirplayOutputRouteName];
//                if(airplayDeviceName.length > 0) {
//                    self.airplayDeviceName = airplayDeviceName;
//                    self.airPlayView.hidden = NO;
//                    for (UIView *subView in self.airPlayView.subviews) {
//                        if ([subView isKindOfClass:[UILabel class]]) {
//                            ((UILabel *)subView).text = [NSString stringWithFormat:@"与%@连接中...",self.airplayDeviceName];
//                            break;
//                        }
//                    }
//                }else {
//                    self.airPlayView.hidden = YES;
//                }
//            });
//        }
            
            break;
        case MWCallbackTypePlayFinish:
            NSLog(@"播放完成");
            if (player.tag == 1) {
                self.pmsManger.isCompletePlay = YES;
            }else {
                self.pssManger.isCompletePlay = YES;
            }
            
            if (!self.isLive) {
                
                [self showSecondaryPlayerMaskView];
            }
            //大屏播放完成
            if (([self returnIsMainVideoPlayer] && player.tag == 1) ||
                (![self returnIsMainVideoPlayer] && player.tag == 2)) {
                
                //退出全屏
                [self exitFullScreen];
                //回放播放完成
                [self.playerMaskView resetSliderValue];
                //显示
                [self.playerMaskView showBackPlayButton:YES image:[UIImage imageNamed:@"live_cover"]];
                
                
                self.playerMaskView.playStopBtn.selected = NO;
                
                [self.view bringSubviewToFront:self.backButton];
                
            }
            //记录播放的时间
            self.videoModel.lastWatchTime = 0;
            if (!self.isLive) {
                [MWVideoDBManger insertOrReplaceVideo:self.videoModel];//存入续播时间
            }
            break;
        case MWCallbackTypeLiveBuffering:
            NSLog(@"直播缓冲中");
            
            break;
        default:
            break;
    }
}



#pragma mark - ******************socket部分*******************
- (void)connectSocket {
    
    [MWMontUserCenter querySocketInfoWithLiveId:self.liveId complete:^(id responseObject, NSError *error) {
        if ([responseObject[@"code"] integerValue] == 200) {
            NSDictionary *dataDic = responseObject[@"data"];
            self.socket = [[MWLiveSocket alloc] initWithRoomId:[NSString stringWithFormat:@"%@",dataDic[@"out_roomID"]] liveID:self.liveId out_room_ServerAddress:dataDic[@"out_room_ServerAddress"] join_notice:dataDic[@"join_notice"]  user_id:mw_mineUserId nickName:@"sss" headPic:@"" delegate:self response:^(BOOL success, NSString *msg) {
                
            }];
            self.socket.isPrintSocketInfo = YES;
        }
    }];
    
}

- (void)receiveSocketMessage:(NSDictionary *)socketDic {
    
    MWLiveSocketData  *socketData = [MWLiveSocketData mj_objectWithKeyValues:socketDic];
    
    [self.landscapePlayView manageReceiveSocketMessage:socketData];
    
    NSInteger code = socketData.code;
    if (code == MWLiveSocket_chatMessage) {
        
        [self.chatViewController reviceMsgWithSocketData:socketData];
    }else if (code == MWLiveSocket_joinRoom /**加入房间*/) {
        
        //用于模拟多人同时进入
//        NSArray *niceName = @[@"撒大声地所",@"dd",@"dddaa",@"啊但是所大付所多撒多所多撒",@"多试试",@"是的撒所",@"大多数",@"的"];
//        [[MWGCDTimerManager sharedInstance] scheduledDispatchTimerWithName:@"sdsds"  timeInterval:0.1 queue:nil repeats:YES action:^{
//            static int index = 0;
//            if (index < 10) {
//                 NSLog(@"进来了");
//                 [self.enterIntoLiveRoomAnimationManger showEnterIntoAnimationWithNickName:niceName[arc4random()%8]];
//            }
//            index ++;
//            if (index > 20) {
//                index = 0;
//            }
//        }];
       
        [self.enterIntoLiveRoomAnimationManger showEnterIntoAnimationWithNickName:socketData.nickName];
       
    }else if (code == MWLiveSocket_leaceRoom /**离开房间*/) {
        
    }else if (code == MWLiveSocket_presentGift /**接收到礼物*/) {
        [self.chatViewController reviceMsgWithSocketData:socketData];
        
    }else if (code == MWLiveSocket_shutupUser /**某个用户被禁言*/){
        
        [self.chatViewController reviceMsgWithSocketData:socketData];
        
    }else if (code == MWLiveSocket_removeShutupToList /**某个用户被解除禁言*/){
        
        [self.chatViewController reviceMsgWithSocketData:socketData];
        
    }else if(code == MWLiveSocket_sysMessage){//系统消息
        
        if (socketData.isSystemMessage){
            [self.chatViewController reviceMsgWithSocketData:socketData];
        }
        
    }else if (code == MWLiveSocket_querySilinceUserState){
        
    }else if(code == MWliveSocket_deletSingleChatRecord){
        
        [self.chatViewController reviceMsgWithSocketData:socketData];
        
    }else if(code == MWLiveSocket_obtainChatRecord) {
        
        [self.chatViewController reviceMsgWithSocketData:socketData];
        
    }else if (code == MWliveSocket_shutupUserAll) {//全体禁言
        
        [self.chatViewController reviceMsgWithSocketData:socketData];
        
    }else if (code == MWLiveSocket_headbeatResponse){//直播状态消息
        //主流直播状态
        if(socketData.liveinfo.live_status == 1){//直播中/恢复正常播放
            //FIXME:直播暂停或恢复
            if (self.liveNoSignal && [self returnIsMainVideoPlayer]) {
                [self signalRecover];
            }
        }else if (socketData.liveinfo.live_status == 2){//直播结束（主播端直接杀死APP过两分钟会收到这个消息）
            [self anchorStopLiving:YES];
        }else if (socketData.liveinfo.live_status == 3){//直播异常
            //FIXME:直播暂停或恢复
            if (!self.liveNoSignal && !self.anchorStopLive && [self returnIsMainVideoPlayer]) {
                [self signalInterrupt];
            }
        }
        
        //次流直播状态
        if (socketData.liveinfo.slave_status == 1) {
            //FIXME:直播暂停或恢复
            if (self.liveNoSignal && ![self returnIsMainVideoPlayer]) {
                [self signalRecover];
            }
        }else if (socketData.liveinfo.slave_status == 2){//直播结束（主播端直接杀死APP过两分钟会收到这个消息）
            [self anchorStopLiving:NO];
        }else if (socketData.liveinfo.slave_status == 3){//直播异常
            //FIXME:直播暂停或恢复
            if (!self.liveNoSignal && !self.anchorStopLive && ![self returnIsMainVideoPlayer]) {
                [self signalInterrupt];
            }
        }
        
    }else if(code == MWLiveSocket_customNotice){//自定义消息
        //FIXME:此处的800、801暂停
        if (socketData.liveinfo.customize_type == 800) {//直播结束
            //[self anchorStopLiving];
        }else if (socketData.liveinfo.customize_type == 801){//主播暂离与恢复通知
            if(socketData.liveinfo.back_run == NO){
                [self signalRecover];
            }else{
                [self signalInterrupt];
            }
        }
    }else if (code == MWLiveSocket_LiveNotice){//公告栏消息
        if (socketData.data) {
            NSString *notice = socketData.data[@"msgbody"];
            id JSONObject = notice.mj_JSONObject;
            if ([JSONObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = (NSDictionary*)JSONObject;
                notice = dict[@"msg"];
            }
            [self.landscapePlayView showNotice:notice];
        }
    }else if (code == MWLiveSocket_praise){ //点赞
        [self.chatViewController reviceMsgWithSocketData:socketData];
    }else if (code == MWliveSocket_receiveQuestionnaire) { //问卷
        //webview加载此url http://nx.facebac.com/H5/survey.html?examineId=9
        NSLog(@"问卷url:%@",socketData.liveinfo.url);
    }
}



#pragma mark - ******************lazy部分*******************
- (UIButton *)backButton{
    if(!_backButton){
        _backButton = ({
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setBackgroundColor:[UIColor clearColor]];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
            [btn setImage:[UIImage imageNamed:@"liveBroadcastIcBack"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
            btn;
        });
    }
    return _backButton;
}

- (UIImageView *)liveCoverImageView {
    
    if (_liveCoverImageView == nil) {
        _liveCoverImageView = [UIImageView new];
    }
    return _liveCoverImageView;
}


- (BKLandscapePlayView *)landscapePlayView{// 横屏观看播放交互层
    
    if (!_landscapePlayView) {
        
        _landscapePlayView = [[BKLandscapePlayView alloc]initWithFrame:CGRectMake(0, 0, 667, 375)
                                                              playType:self.isLive
                                                              masterID:self.anchorId];
        _landscapePlayView.delegate = self;
        _landscapePlayView.hidden = YES;
        _landscapePlayView.socket = self.socket;
        [self.view addSubview:self.landscapePlayView];
    }
    return _landscapePlayView;
}

- (MWPlayerMaskView *)playerMaskView{//二级详情页工具层
    if (!_playerMaskView) {
        _playerMaskView = [[MWPlayerMaskView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, MainVideoPlayerHeight_vertical)];
        [_playerMaskView setVideoName:@"测试"];
        _playerMaskView.delegate = self;
        _playerMaskView.isLive = self.isLive;
    }
    return _playerMaskView;
}

- (BKEndLiveCorverView *)endLiveCorverView{
    if(!_endLiveCorverView){
        _endLiveCorverView = ({
            BKEndLiveCorverView *view = [BKEndLiveCorverView new];
            view ;
        });
    }
    return _endLiveCorverView;
}


- (UIButton *)fullScreenButton{
    if (!_fullScreenButton) {
        _fullScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullScreenButton setFrame:CGRectMake(kScreenWidth-64, 20, 44, 44)];
        [_fullScreenButton setImage:[UIImage imageNamed:@"liveBroadcastIcFull"] forState:UIControlStateNormal];
        [_fullScreenButton addTarget:self action:@selector(fullScreenClick) forControlEvents:UIControlEventTouchUpInside];
        _fullScreenButton.hidden = YES;
    }
    return _fullScreenButton;
}


- (MWSecondaryPlayerMaskView *)secondaryPlayerMaskView {
    
    if (_secondaryPlayerMaskView == nil) {
        _secondaryPlayerMaskView = [MWSecondaryPlayerMaskView new];
        _secondaryPlayerMaskView.hidden = YES;
    }
    return _secondaryPlayerMaskView;
    
}

- (MWPreventScreenRecordingScrollView *)srScollView {
    
    if (_srScollView == nil) {
        
        _srScollView = [[MWPreventScreenRecordingScrollView alloc] initWithFrame:CGRectMake(kScreenWidth + 60, 45, 60, 30)];
        
    }
    return _srScollView;
}


- (UIButton *)airPlayClickButton{

    if (_airPlayClickButton == nil) {
        
        _airPlayClickButton = ({
            
            MPVolumeView *volumeV = [[MPVolumeView alloc] initWithFrame:CGRectMake(0, 100, 44, 44)];
            volumeV.showsVolumeSlider = NO;
            [volumeV sizeToFit];
            [self.playerMaskView addSubview:volumeV];
            UIButton *airPlayButton = nil;
            for (UIView *subView in volumeV.subviews) {
                if ([subView isKindOfClass:[UIButton class]]) {
                    airPlayButton = (UIButton *)subView;
                    break;
                }
            }
            [airPlayButton setImage:nil forState:UIControlStateNormal];
            [airPlayButton setImage:nil forState:UIControlStateHighlighted];
            [airPlayButton setImage:nil forState:UIControlStateSelected];
            [airPlayButton setBounds:CGRectZero];
         
            UIButton *button = [UIButton ZFC_ButtonChainedCreater:^(ZFC_ButtonChainedCreater *creater) {
                creater.frame(CGRectMake(0, 100, 44, 44))
                .image([UIImage imageNamed:@"airPlay"], UIControlStateNormal)
                .actionBlock(^(UIButton *button) {
                    //airPlay搜索投屏
                    //[airPlayButton sendActionsForControlEvents:UIControlEventTouchUpInside];
                    
                    //dlna搜索投屏
                    [self.dlnaManager startSearch];
                });
            }];
        
            button;
        });
    }
    return _airPlayClickButton;

}

- (UIView *)airPlayView {
    
    if (_airPlayView == nil) {
        
        _airPlayView = [UIView new];
        _airPlayView.frame = self.playerMaskView.frame;
        _airPlayView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        [_playerMaskView addSubview:_airPlayView];
        _airPlayView.hidden = YES;
        
        
        kWeakSelf(self);
        UILabel *deviceLabel = [UILabel ZFC_LabelChainedCreater:^(ZFC_LabelChainedCreater *creater) {
            creater.font([UIFont systemFontOfSize:15])
            .textColor([UIColor redColor])
            .textAlignment(NSTextAlignmentCenter)
            .addIntoView(weakself.airPlayView);
        }];
        
        [deviceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.airPlayView).offset(40);
            make.centerX.equalTo(self.airPlayView);
        }];

        UIButton *stopAirPlayButton = [UIButton ZFC_ButtonChainedCreater:^(ZFC_ButtonChainedCreater *creater) {
            
            creater.title(@"停止投屏", UIControlStateNormal)
            .backgroundColor([UIColor redColor])
            .addIntoView(weakself.airPlayView)
            .titleLabelFont([UIFont systemFontOfSize:15])
            .actionBlock(^(UIButton *button) {
            
                //airPlay停止
               //[weakself.airPlayClickButton sendActionsForControlEvents:UIControlEventTouchUpInside];
                
                //DLNA停止
                
                 [self endDLNA];
            });
        }];
        
        [stopAirPlayButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_airPlayView);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(30);
        }];
        
    }
    return _airPlayView;
    
}


- (MRDLNA *)dlnaManager {
    
    if (_dlnaManager == nil) {
        _dlnaManager = [MRDLNA sharedMRDLNAManager];
        _dlnaManager.delegate = self;
        _dlnaManager.searchTime = 1;
    }
    return _dlnaManager;
    
}

- (MWDLNADeviceShowAlertView *)dlnaAlertView {
    
    if (_dlnaAlertView == nil) {
        _dlnaAlertView = [MWDLNADeviceShowAlertView new];
        _dlnaAlertView.delegate = self;
    }
    return _dlnaAlertView;
}

- (MWEnterIntoLiveRoomAnimationManger *)enterIntoLiveRoomAnimationManger {
    
    if (_enterIntoLiveRoomAnimationManger == nil) {
        _enterIntoLiveRoomAnimationManger = [[MWEnterIntoLiveRoomAnimationManger alloc] init];
    }
    return _enterIntoLiveRoomAnimationManger;
}

@end


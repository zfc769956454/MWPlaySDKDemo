//
//  BKPlayerView.m
//  BaiKeMiJiaLive
//
//  Created by chendb on 16/8/22.
//  Copyright © 2016年 facebac. All rights reserved.
//

#import "BKPlayerView.h"
#import "NSTimer+AutoRetain.h"
#import "BKVoiceAndBrightView.h"
#import "BKVideoProgressView.h"
#import "BKVideoProgressView.h"
#import "MWPlayViewController.h"
#import "BKQuickCreate.h"


#define bigPlayButtonTag  100



@interface BKPlayerView ()<BKEndPlayShareViewDelegate>
{
    UILabel          *_endLabel;
    UIButton         *_fullScreenBtn;
    CGFloat          _sliderValue;
    BOOL             _isTouch;
    UITapGestureRecognizer *_showViewTap;
}


/**底部操作试图*/
@property (nonatomic, strong)UIView  *bottomOperationView;
/**左侧进度时间*/
@property (nonatomic, strong)UILabel *leftProgressTimeLabel;
/**右侧总时间*/
@property (nonatomic, strong)UILabel *rightTotalTimeLabel;
/**进度条*/
@property (nonatomic, strong) BKSliderProgress *sliderProgress;

@property (nonatomic, strong) UIImageView *backPlayCover;
/**拖动时显示的视图*/
@property (nonatomic, strong) BKVideoProgressView *videoProgressView;

/**中间播放按钮*/
@property (nonatomic, strong) UIButton  *centerPlayButton;;

@property (nonatomic, strong) BKVoiceAndBrightView *vbView;

@end

@implementation BKPlayerView

- (UIView *)bottomOperationView {
    
    if (_bottomOperationView == nil) {
        
        _bottomOperationView = [[UIView alloc]initWithFrame:CGRectMake(0,self.bounds.size.height  - 50 , self.bounds.size.width , 50)];
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"#000000" Alpha:0.6].CGColor,(__bridge id)[UIColor colorWithHexString:@"#000000" Alpha:0].CGColor];
        gradientLayer.locations = @[@0.0, @1.0];
        gradientLayer.startPoint = CGPointMake(0, 1.0);
        gradientLayer.endPoint = CGPointMake(0, 0);
        gradientLayer.frame =  self.bottomOperationView.bounds;
        [_bottomOperationView.layer addSublayer:gradientLayer];


        _playStopBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, 40, 40)];
        [_playStopBtn setImage:[UIImage imageNamed:@"liveBroadcastIcPlay"] forState:UIControlStateNormal];
        [_playStopBtn setImage:[UIImage imageNamed:@"liveBroadcastIcSuspend"] forState:UIControlStateSelected];
        [_playStopBtn addTarget:self action:@selector(tapPlayStopButton:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomOperationView addSubview:_playStopBtn];
        
        _fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullScreenBtn setFrame:CGRectMake(self.bounds.size.width - 40, 5 , 40, 40)];
        [_fullScreenBtn setImage:[UIImage imageNamed:@"liveBroadcastIcFull"] forState:UIControlStateNormal];
        
        [_fullScreenBtn addTarget:self action:@selector(clickFullScreenButton:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomOperationView addSubview:_fullScreenBtn];
        
        _leftProgressTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_playStopBtn.frame) - 2, 0, 50, 16.0)];
        _leftProgressTimeLabel.centerY = _playStopBtn.centerY;
        _leftProgressTimeLabel.textColor = [UIColor whiteColor];
        _leftProgressTimeLabel.font = [UIFont fontWithName:@"Helvetica" size:11.f];
        _leftProgressTimeLabel.textAlignment = NSTextAlignmentCenter;
        _leftProgressTimeLabel.text = [NSString stringWithFormat:@"%@",[NSDate timeDescriptionOfTimeInterval:0.0]];
        [_bottomOperationView addSubview:_leftProgressTimeLabel];
        
        _rightTotalTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_fullScreenBtn.frame) - 48, 0, 50, 16.0)];
        _rightTotalTimeLabel.centerY = _playStopBtn.centerY;
        _rightTotalTimeLabel.textColor = [UIColor whiteColor];
        _rightTotalTimeLabel.font = [UIFont fontWithName:@"Helvetica" size:11.f];
        _rightTotalTimeLabel.textAlignment = NSTextAlignmentCenter;
        _rightTotalTimeLabel.text = [NSString stringWithFormat:@"%@",[NSDate timeDescriptionOfTimeInterval:0.0]];
        [_bottomOperationView addSubview:_rightTotalTimeLabel];
        
        _sliderProgress = [[BKSliderProgress alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_leftProgressTimeLabel.frame) + 10 , 12.5, CGRectGetMinX(_rightTotalTimeLabel.frame) - CGRectGetMaxX(_leftProgressTimeLabel.frame) - 20, 20.f)];
        _sliderProgress.centerY = _playStopBtn.centerY;
        _sliderProgress.contentMode = UIViewContentModeScaleToFill;
        _sliderProgress.minimumTrackTintColor = kcallColor(kBasicAppColor);
        _sliderProgress.middleTrackTintColor = kRGBAColor(255.f, 255.f, 255.f, 0.5);
        _sliderProgress.maximumTrackTintColor = kRGBAColor(255.f, 255.f, 255.f, 0.3);
        [_sliderProgress setThumbImage:[UIImage imageNamed:@"detailsProgressBarIcCurrent"] forState:UIControlStateNormal];
        [_sliderProgress setThumbImage:[UIImage imageNamed:@"detailsProgressBarIcCurrent"] forState:UIControlStateHighlighted];
        [_sliderProgress.slider addTarget:self action:@selector(tapBeginDrag:) forControlEvents:UIControlEventTouchDown];
        [_sliderProgress.slider addTarget:self action:@selector(tapSliderView:) forControlEvents:UIControlEventValueChanged];
        [_sliderProgress.slider addTarget:self action:@selector(tapEndDrag:) forControlEvents:UIControlEventTouchUpInside];
        [_sliderProgress.slider addTarget:self action:@selector(tapEndDrag:) forControlEvents:UIControlEventTouchUpOutside];
        [_sliderProgress.slider addTarget:self action:@selector(tapEndDrag:) forControlEvents:UIControlEventTouchDragExit];
        [_sliderProgress.slider addTarget:self action:@selector(tapEndDrag:) forControlEvents:UIControlEventTouchCancel];
        
        [_bottomOperationView addSubview:_sliderProgress];
        
    }
    return _bottomOperationView;
}

- (BKVideoProgressView *)videoProgressView {
    
    if (_videoProgressView == nil) {
        
        _videoProgressView = [BKVideoProgressView new];
        _videoProgressView.isSimpleType = YES;
        _videoProgressView.hidden = YES;
    }
    return _videoProgressView;
    
}

- (UIButton *)centerPlayButton {
    
    if (_centerPlayButton == nil) {
        _centerPlayButton = [BKQuickCreate addButtonWithFrame:CGRectMake(0, 0, 40, 40) titleColor:nil BGColor:nil Tag:bigPlayButtonTag Target:self Action:@selector(tapPlayStopButton:) Title:nil];
        [_centerPlayButton setFrame:CGRectMake(0, 0, 40, 40)];
        if (kiPhone_X) {
            _centerPlayButton.frame = CGRectMake(0, 75, 40, 40);
            _centerPlayButton.centerX = self.centerX;
        }else{
            _centerPlayButton.center = self.center;
        }
        [_centerPlayButton setImage:[UIImage imageNamed:@"liveBroadcastIcSuspend"] forState:UIControlStateNormal];
        _centerPlayButton.hidden = YES;
    }
    return _centerPlayButton;
}

- (BKVoiceAndBrightView *)vbView {
    
    if (_vbView == nil) {
        
        _vbView = [[BKVoiceAndBrightView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _vbView.isOnlyProgress = YES;
       
        kWeakSelf(self);
        _vbView.draggingBlock = ^(BOOL isDragEnd,NSInteger trans){
            kStrongSelf(weakself);
            if (strong_weakself.isLive) {
                return ;
            }
            
            if (self.sliderProgress.maxValue<2) {
                return ;
            }
            //[strong_weakself viewController].hasOperation = YES;
            if (isDragEnd) {
                [strong_weakself tapEndDrag:strong_weakself.sliderProgress];
                
                strong_weakself.videoProgressView.hidden = YES;
            }else{

                [strong_weakself setSliderTransValue:trans];
                
                strong_weakself.videoProgressView.hidden = NO;
                
                [strong_weakself.videoProgressView setTimeValue:strong_weakself.sliderProgress.value totalValue:strong_weakself.sliderProgress.maxValue trans:trans];
                //[[strong_weakself viewController] stopLoadAnimation];
            }
        };
    }
    return _vbView;
}

- (UIImageView *)backPlayCover {
    if (!_backPlayCover) {
        _backPlayCover = [[UIImageView alloc] init];
        [_backPlayCover setImage:[UIImage imageNamed:@"livecoverdefault"]];
        _backPlayCover.contentMode = UIViewContentModeScaleAspectFill;
        _backPlayCover.layer.masksToBounds = YES;
        [_backPlayCover setHidden:YES];
    }
    _backPlayCover.clipsToBounds = YES;
    return _backPlayCover;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self layoutUI];
    }
    return self;
}


- (void)layoutUI {
    
    [self addSubview:self.videoProgressView];
    [self.videoProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    
    [self addSubview:self.vbView];
    [self.vbView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    
    _showViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showProgressView)];
    [self addGestureRecognizer:_showViewTap];
    
    [self addSubview: self.bottomOperationView];
    
    [self addSubview:_centerPlayButton];
    
    [self addSubview:_backPlayCover];
    [_backPlayCover mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.bottomOperationView.mas_bottom);
    }];
    
}


- (void)showBackPlayButton:(BOOL)show image:(UIImage *)image{
    [self.backPlayCover setHidden:!show];
    [ self.bottomOperationView setHidden:show];
    if(_isLive){
        [self.bottomOperationView setHidden:YES];
        self.shareView.showReplayBtn = NO;
        
    }
    [_playStopBtn setHidden:show];
    if (image) {
        [self.backPlayCover setImage:image];
    }
    
    if(show){
        [self.shareView removeFromSuperview];
        self.shareView = nil ;
        self.shareView = [BKEndPlayShareView new];
        self.shareView.delegate = self;
        [self.shareView setShowReplayBtn:YES];
        [self addSubview:self.shareView];
        self.shareView.corverImage = image;
        [self.shareView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }else{
        [self.shareView removeFromSuperview];
        self.shareView = nil ;
    }
}

- (void)anchorStopLiveShowEndShareView:(UIImage*)cover{
    
    [ self.bottomOperationView setHidden:YES];
    [self.shareView removeFromSuperview];
    self.shareView = nil ;
    self.shareView = [BKEndPlayShareView new];
    [self.shareView setCorverImage:cover];
    if (!cover) {
        UIImageView *temp = [UIImageView new];
        kWeakSelf(self);
//        [temp sd_setImageWithURL:[NSURL URLWithString:[self viewController].liveCoverUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            if (image) {
//                [weakself.shareView setCorverImage:image];
//            }
//        }];
    }
    self.shareView.delegate = self;
    [self.shareView setShowReplayBtn:NO];
    [self addSubview:self.shareView];
    [self.shareView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.backPlayCover);
    }];
}

- (void)setEndShareViewCover:(UIImage*)cover{//某些情况可能一开始没获取到封面，此时调该方法重置
    [_shareView setCorverImage:cover];
}


- (BKIndicatorView *)indicatorView{

    return nil;
}



#pragma mark -- BKEndPlayShareViewDelegate

- (void)replayVideo{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickResetPlayButton)]){
        [self showBackPlayButton:NO image:nil];
        [self.delegate clickResetPlayButton];
    }
}

- (void)shareContentWithType:(NSInteger)type{
    if(self.delegate && [self.delegate respondsToSelector:@selector(shareVideoWithType:)]){
        [self.delegate shareVideoWithType:type];
    }
}

#pragma mark - 隐藏/显示播放控件
-(void)runLooptimer{
    //用于控制顶、底部视图当前是否为显示状态，是则隐藏
    if (!_isShowProgressView)[self showProgressView];
}

-(void)showSubWidgetStatusTopAndButtomView:(BOOL)top playButton:(BOOL)play{
    //Top 为YES时：顶部、底部视图将会显示
    //play 为YES时：中间的大button将会显示，并将定时器销毁，直到下次传NO的时候会重新创建
    _isShowProgressView = top;
    [self showProgressView];
    if (!_centerPlayButton.hidden) {//显示时，暂停状态
    }else{
        [self addGestureRecognizer:_showViewTap];
    }
}

-(void)showProgressView{
    
   
}

- (MWPlayViewController *)viewController
{
    for (UIView *next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponser = [next nextResponder];
        if ([nextResponser isKindOfClass:[MWPlayViewController class]]) {
            return (MWPlayViewController *)nextResponser;
        }
    }
    return nil;
}

- (void)hideProgressView:(BOOL)hidden{
     self.bottomOperationView.hidden = hidden ;
    if(_isLive){
        [ self.bottomOperationView setHidden:YES];
    }
}

- (BOOL)isShowProgressView{
    return ! self.bottomOperationView.hidden ;
}

- (void)clickBackButton:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(closePlayerVideo)])
    {
        [self.delegate closePlayerVideo];
    }
}

- (void)clickFullScreenButton:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(fullScreenClick)])
    {
        [self.delegate fullScreenClick];
    }
}

#pragma mark -- 直播类型，用于设置进度条和时间是否显示

- (void)setIsLive:(BOOL)isLive{
    _isLive = isLive ;

    if(_isLive){
        _sliderProgress.hidden = YES ;
        _rightTotalTimeLabel.hidden = YES ;
        _leftProgressTimeLabel.hidden = YES;
        _endLabel.hidden = YES ;
        
         self.bottomOperationView.hidden = YES;
        _centerPlayButton.hidden = NO;
    }else{
        
         self.bottomOperationView.hidden = _isShowProgressView;
        _sliderProgress.hidden = NO;
        _rightTotalTimeLabel.hidden = NO ;
        _leftProgressTimeLabel.hidden = NO;
        _endLabel.hidden = NO ;
        
        _centerPlayButton.hidden = YES;
        
    }
}

#pragma mark - UIButton Ttarget

- (void)tapBeginDrag:(id)sender
{
    if (!_sliderProgress.maxValue)
    {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickBeginDrag:)])
    {
        [self.delegate clickBeginDrag:_sliderProgress];
    }
}

- (void)tapSliderView:(id)sender
{
    if (!_sliderProgress.maxValue)
    {
        return;
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(sliderPopoverView:)])
    {
        [_sliderProgress popWithText:[NSDate timeDescriptionOfTimeInterval:_sliderProgress.value]];
        [self.delegate sliderPopoverView:_sliderProgress];
    }
}

- (void)tapEndDrag:(id)sender
{
    if (!_sliderProgress.maxValue)
    {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickEndDrag:)])
    {
        [_sliderProgress popWithText:[NSDate timeDescriptionOfTimeInterval:_sliderProgress.value]];
        [self.delegate clickEndDrag:_sliderProgress];
    }
}


- (void)tapPlayStopButton:(UIButton*)sender   
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickPlayStopButton:)])
    {
        [self showBackPlayButton:NO image:nil];
        [self.delegate clickPlayStopButton:sender];
    }
}


- (void)setSliderTransValue:(NSInteger)transValue{
    _sliderProgress.value += transValue;
    [_sliderProgress updatePopoverFrame];
    [_sliderProgress popWithText:[NSDate timeDescriptionOfTimeInterval:_sliderProgress.value]];
    
    _leftProgressTimeLabel.text = [NSString stringWithFormat:@"%@",[NSDate timeDescriptionOfTimeInterval:_sliderProgress.value]];
    _rightTotalTimeLabel.text = [NSString stringWithFormat:@"%@",[NSDate timeDescriptionOfTimeInterval:_sliderProgress.maxValue]];
}

- (void)resetSliderValue{
    _playStopBtn.selected = NO;
    _sliderProgress.value = 0;
    [_sliderProgress updatePopoverFrame];
    [_sliderProgress popWithText:[NSDate timeDescriptionOfTimeInterval:0]];
    _leftProgressTimeLabel.text = [NSString stringWithFormat:@"%@",[NSDate timeDescriptionOfTimeInterval:0]];
    _rightTotalTimeLabel.text = [NSString stringWithFormat:@"%@",[NSDate timeDescriptionOfTimeInterval:_sliderProgress.maxValue]];
}


- (CGFloat)sliderMaxValue{
    return _sliderProgress.maxValue;
}


- (void)prepareWithValue:(NSTimeInterval)value duration:(NSTimeInterval)duration{
    
    _sliderProgress.enabled = YES;
    _sliderProgress.value = value;
    _sliderProgress.maxValue = duration;
    
    _leftProgressTimeLabel.text = [NSDate timeDescriptionOfTimeInterval:value];
    _rightTotalTimeLabel.text = [NSDate timeDescriptionOfTimeInterval:duration];
}

- (void)loadThumbnailImage:(UIImage*)thumbnailImage
{
    [_sliderProgress loadThumbnailImage:thumbnailImage];
}

- (void)prepareWithprogress:(NSTimeInterval)progress
{
    if (!_sliderProgress.maxValue)
    {
        return;
    }
    
    _sliderValue = _sliderProgress.value + progress /_sliderProgress.maxValue;
    _sliderProgress.middleValue = _sliderValue;
//    NSLog(@"缓存时间%f",progress );
}

- (void)killTargetAndAction
{
    [_sliderProgress killTargetAndAction];
}

-(void)setVideoName:(NSString *)videoName{
    _videoName = videoName;
}

- (void)hideCenterBtn:(BOOL)hide{
    _centerPlayButton.hidden = hide;
}

- (void)hideVideoProgressView{
    self.videoProgressView.hidden = YES;
}

- (void)setBtnsEnable:(BOOL)enable {
    _playStopBtn.enabled = enable;
    _fullScreenBtn.enabled = enable;
    
}

-(void)dealloc{

}

@end

//
//  BKBottomView.m
//  MontnetsLiveKing
//
//  Created by chendb on 2017/10/31.
//  Copyright © 2017年 facebac.com. All rights reserved.
//

#define startValueOfTwinkle 0.2f
#define endValueOfTwinkle   0.8f

#import "BKPlayBottomView.h"


@interface BKPlayBottomView ()<UITextFieldDelegate>

/**输入框的父试图*/
@property (nonatomic, strong) UIView        *tallkView;

/**右侧竖线*/
@property (nonatomic, strong) UIView        *lineView;

/**右侧发送按钮*/
@property (nonatomic, strong) UIButton      *sendBtn;

@property (nonatomic, assign) BOOL   isLive;

@property (nonatomic, readwrite, weak) CAGradientLayer *gradientLayer; /** 渐变图层 */

@end

@implementation BKPlayBottomView

- (instancetype)initWithIsLive:(BOOL)isLive{
    self = [super init];
    if (self) {
        _isLive = isLive;
        
        //加入渐变颜色
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"#000000" Alpha:0.7].CGColor,(__bridge id)[UIColor colorWithHexString:@"#000000" Alpha:0].CGColor];
        gradientLayer.locations = @[@0.0, @1.0];
        gradientLayer.startPoint = CGPointMake(0, 1.0);
        gradientLayer.endPoint = CGPointMake(0, 0);
        [self.layer addSublayer:gradientLayer];
        [gradientLayer setFrame:CGRectMake(0, 0, kScreenWidth > kScreenHeight ? kScreenWidth : kScreenHeight, 60)];
        _gradientLayer = gradientLayer;
        
        [self loadView];
        [self loadViewFrame];
        
        self.backgroundColor = kClearColor;
    }
    return self;
}

#pragma mark  ckickButton
- (void)clickPausetButton:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickPlayStopButton:)]) {
        [self.delegate clickPlayStopButton:sender];
    }
}

- (void)clickSendButton:(UIButton *)sender{
    [self sendMessage];
}

- (void)clickBarrageButton:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(closeBarrage:)]) {
        [self.delegate closeBarrage:sender];
    }
}

#pragma mark  textFieldChange
- (void)inputTextEidt:(UITextField *)textField{
    NSString *toBeString = textField.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > 80) {
                textField.text = [toBeString substringToIndex:80];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > 80) {
            textField.text = [toBeString substringToIndex:80];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self sendMessage];
    return NO;
}

- (void)sendMessage{
    if (ObjIsEqualNullOrNil(_inputText.text)) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendChatMessage:)]) {
        [self.delegate sendChatMessage:_inputText.text];
    }
    _inputText.text = nil;
    [_inputText resignFirstResponder];//发送消息后隐藏键盘
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if(self.silence_all && ![self.masterID isEqualToString:mw_mineUserId]){ //主播自己不会被禁言
        NSLog(@"全体禁言中");
        return NO ;
    }else if (self.keepSilence){
        NSLog(@"禁言中");
        return NO ;
    }
    
    return YES ;
}

#pragma mark _sliderProgress

#pragma mark  --直播进度条

-(void)clickVideoPlayStopButton:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickPlayStopButton:)]) {
        [self.delegate clickPlayStopButton:sender];
    }
}

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

- (void)setVideoEndTime:(NSTimeInterval)videoEndTime{
    _videoEndTime = videoEndTime;
    [_sliderProgress setMaxValue:videoEndTime];
}

- (void)setVideoPlayTime:(NSTimeInterval)videoPlayTime{
    _videoPlayTime = videoPlayTime;
    
    _currentTimeLabel.text = [NSString stringWithFormat:@"%@",[NSDate timeDescriptionOfTimeInterval:0]];
    [_timeLabel setText:[NSString stringWithFormat:@"%@",[NSDate timeDescriptionOfTimeInterval:_sliderProgress.maxValue]]];
}

- (void)setVideoPlayBtnImg:(UIImage *)videoPlayBtnImg{
    [_pauseBtn setImage:videoPlayBtnImg forState:UIControlStateNormal];
}

- (void)preparePlayTimerWithValue:(NSTimeInterval)value duration:(NSTimeInterval)duration{
    
    _sliderProgress.enabled = YES;
    [_sliderProgress setMaxValue:duration];
    _sliderProgress.value = value;
    _sliderProgress.maxValue = duration;
    
    _currentTimeLabel.text = [NSString stringWithFormat:@"%@",[NSDate timeDescriptionOfTimeInterval:value]];
    [_timeLabel setText:[NSString stringWithFormat:@"%@",[NSDate timeDescriptionOfTimeInterval:duration]]];
}


- (void)setSliderTransValue:(NSInteger)transValue{
    _sliderProgress.value += transValue;
    _currentTimeLabel.text = [NSString stringWithFormat:@"%@",[NSDate timeDescriptionOfTimeInterval:_sliderProgress.value]];
    [_sliderProgress popWithText:[NSDate timeDescriptionOfTimeInterval:_sliderProgress.value]];
}

- (void)resetViderPlayTimer{
    _sliderProgress.value = 0;
    [_sliderProgress updatePopoverFrame];
    [_sliderProgress popWithText:[NSDate timeDescriptionOfTimeInterval:0]];
    
    _currentTimeLabel.text = [NSString stringWithFormat:@"%@",[NSDate timeDescriptionOfTimeInterval:0]];
    [_timeLabel setText:[NSString stringWithFormat:@"%@",[NSDate timeDescriptionOfTimeInterval:_sliderProgress.maxValue]]];
}

- (void)hideKeybord{
    [_inputText resignFirstResponder];
}

#pragma mark   loadView
- (void)loadView{
    [self addSubview:self.pauseBtn];
    [self addSubview:self.liveGiftBtn];
    
    [self addSubview:self.timeLabel];
    [self addSubview:self.currentTimeLabel];
    [self addSubview:self.sliderProgress];
    
    [self addSubview:self.tallkView];
    [_tallkView addSubview:self.inputText];
    [_tallkView addSubview:self.sendBtn];
    [_tallkView addSubview:self.lineView];
}

- (void)loadViewFrame{
    
    [_pauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(10);
        make.left.equalTo(self.mas_left).offset(5);
        make.width.height.equalTo(@(40));
    }];
    
    [_liveGiftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.pauseBtn);
        make.right.equalTo(self.mas_right).offset(-5);
        make.width.height.equalTo(@(40));
    }];
    
    if (_isLive) {
        
        [self setIsLive:YES];
    }else{
        [self setIsLive:NO];
    }
    
    [_tallkView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.height.equalTo(@40);
    }];
   
    [self loadTalkViewFramw];
}

- (void)setIsLive:(BOOL)isLive{
    
    if (isLive) {
        
        self.pauseBtn.hidden = YES;
        self.liveGiftBtn.hidden = YES;
        
        self.timeLabel.hidden = YES;
        self.currentTimeLabel.hidden = YES;
        self.sliderProgress.hidden = YES;
        
        self.gradientLayer.hidden = YES;
    }else{
        
        self.pauseBtn.hidden = NO;
        self.liveGiftBtn.hidden = NO;
        
        self.timeLabel.hidden = NO;
        self.currentTimeLabel.hidden = NO;
        self.sliderProgress.hidden = NO;
        
        self.gradientLayer.hidden = NO;

        [_timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_liveGiftBtn.mas_left).offset(-10);
            make.centerY.equalTo(_liveGiftBtn.mas_centerY);
            make.width.equalTo(@(65));
            make.height.equalTo(@(20));
        }];
        
        [_currentTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(_pauseBtn.mas_right).offset(10);
            make.centerY.equalTo(_liveGiftBtn.mas_centerY);
            make.width.equalTo(@(65));
            make.height.equalTo(@(20));
        }];
        
        [_sliderProgress mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_currentTimeLabel.mas_right).offset(5);
            make.right.equalTo(_timeLabel.mas_left).offset(-5);
            make.centerY.equalTo(_timeLabel.mas_centerY);
            make.height.equalTo(@(20));
        }];
    }
}

-(void)loadTalkViewFramw{
    
    [_sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(@0);
        make.width.equalTo(@98);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(_sendBtn.mas_left);
        make.top.bottom.equalTo(@0);
        make.width.equalTo(@1);
    }];
    
    [_inputText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tallkView.mas_top).offset(0);
        make.bottom.equalTo(self.tallkView.mas_bottom).offset(0);
        make.left.equalTo(self.tallkView.mas_left).offset(16);
        make.right.equalTo(self.lineView.mas_left).offset(-15);
    }];
}

#pragma mark  initView

- (UIButton *)pauseBtn{
    if (!_pauseBtn) {
        _pauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pauseBtn setImage:[UIImage imageNamed:@"liveBroadcastIcPlay"] forState:UIControlStateNormal];
        [_pauseBtn setImage:[UIImage imageNamed:@"liveBroadcastIcSuspend"] forState:UIControlStateSelected];
        [_pauseBtn addTarget:self action:@selector(clickPausetButton:) forControlEvents:UIControlEventTouchUpInside];
        _pauseBtn.tag = 5000 + 1;
    }
    return _pauseBtn;
}

- (UIView *)tallkView{
    if (!_tallkView) {
        _tallkView = [[UIView alloc] init];
        [_tallkView setBackgroundColor:kRGBAColor(0, 0, 0, 0.5)];
        [_tallkView setHidden:YES];
    }
    return _tallkView;
}

- (UITextField *)inputText{
    if (!_inputText) {
        _inputText = [[UITextField alloc]init];
        _inputText.font = kRegularFontIsB4IOS9(14);
        [_inputText setBackgroundColor:kClearColor];
        [_inputText setPlaceholder:NSLocalizedString(@"saySomething","")];
        [_inputText setValue:kRGBAColor(255, 255, 255, 0.5) forKeyPath:@"_placeholderLabel.textColor"];
        [_inputText setTintColor:kWhiteColor];
        [_inputText setReturnKeyType:UIReturnKeySend];
        [_inputText setTextColor:kWhiteColor];
        [_inputText setDelegate:self];
        _inputText.keyboardAppearance = UIKeyboardAppearanceDark;
        _inputText.clearButtonMode = UITextFieldViewModeAlways;
        [_inputText addTarget:self action:@selector(inputTextEidt:) forControlEvents:UIControlEventEditingChanged];
    }
    return _inputText;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        [_lineView setBackgroundColor:kRGBAColor(255, 255, 255, 0.3)];
    }
    return _lineView;
}

- (UIButton *)sendBtn{
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [_sendBtn.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_sendBtn setBackgroundColor:kClearColor];
        [_sendBtn addTarget:self action:@selector(clickSendButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBtn;
}

- (BKSliderProgress *)sliderProgress{
    if (!_sliderProgress) {
        _sliderProgress = [[BKSliderProgress alloc] init];
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
    }
    return _sliderProgress;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        [_timeLabel setBackgroundColor:kClearColor];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.shadowOffset = CGSizeMake(0.5, 0.5);
        _timeLabel.shadowColor = kBlackColor;
        _timeLabel.font = [UIFont boldSystemFontOfSize:12];
        _timeLabel.text = [NSString stringWithFormat:@"%@",[NSDate timeDescriptionOfTimeInterval:0.0]];
    }
    return _timeLabel;
}

- (UILabel *)currentTimeLabel{
    if (!_currentTimeLabel) {
        _currentTimeLabel = [[UILabel alloc] init];
        [_currentTimeLabel setBackgroundColor:kClearColor];
        _currentTimeLabel.textColor = [UIColor whiteColor];
        _currentTimeLabel.shadowOffset = CGSizeMake(0.5, 0.5);
        _currentTimeLabel.shadowColor = kBlackColor;
        _currentTimeLabel.font = [UIFont boldSystemFontOfSize:12];
        _currentTimeLabel.text = [NSString stringWithFormat:@"%@",[NSDate timeDescriptionOfTimeInterval:0.0]];
    }
    return _currentTimeLabel;
}

- (UIButton *)liveGiftBtn{
    
    if (!_liveGiftBtn) {
        
        _liveGiftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_liveGiftBtn setImage:[UIImage imageNamed:@"liveBroadcastIcGift"] forState:UIControlStateNormal];
        [_liveGiftBtn addTarget:self action:@selector(clickGiftButton:) forControlEvents:UIControlEventTouchUpInside];
        _liveGiftBtn.tag = 4;
    }
    return _liveGiftBtn;
}



- (void)watchLiveAdjustViewsWhenKeyboard:(BOOL)isShow{

    self.tallkView.hidden = !isShow;
    
    if (!_isLive) {
        
        self.pauseBtn.hidden = isShow;
        self.liveGiftBtn.hidden = isShow;
        
        self.sliderProgress.hidden = isShow;
        self.timeLabel.hidden = isShow;
        self.currentTimeLabel.hidden = isShow;
    }
}

- (void)clickGiftButton:(UIButton *)button{
 
    if (self.delegate && [self.delegate respondsToSelector:@selector(giftBtnClicked:)]) {
        
        [self.delegate giftBtnClicked:button];
    }
}


@end

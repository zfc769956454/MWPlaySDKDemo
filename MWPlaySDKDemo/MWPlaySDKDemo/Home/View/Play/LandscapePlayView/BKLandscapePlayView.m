//
//  BKLandscapePlayView.m
//  MontnetsLiveKing
//
//  Created by chendb on 2017/10/31.
//  Copyright © 2017年 facebac.com. All rights reserved.
//

#import "BKLandscapePlayView.h"
#import "NSDictionary+BKJSON.h"
#import "BKVoiceAndBrightView.h"
#import "BKVideoProgressView.h"
#import "BKQuickCreate.h"

@interface BKLandscapePlayView ()<BKPlayTopViewDelegate,BKPlayBottomViewDelegate>

/**是否直播*/
@property (nonatomic, assign) BOOL   isLive;

/**是否显示锁屏按钮*/
@property (nonatomic, assign) BOOL              isShowLock;

/**是否关闭弹幕*/
@property (nonatomic, assign) BOOL              isCloseBarrage;

/**是否弹出键盘*/
@property (nonatomic, assign) BOOL              isShowKeyboard;

/**主播ID*/
@property (nonatomic, strong) NSString          *masterID;

/**点击屏幕手势*/
@property (nonatomic, strong) UITapGestureRecognizer    *tapGesture;

/**是否编辑消息*/
@property (nonatomic, assign) BOOL isEidt;

/**全屏拖动时显示的视图*/
@property (nonatomic, strong) BKVideoProgressView *videoProgressView;

/**公告滚动的label*/
@property (nonatomic,strong) UILabel *noticeLabel;


@end

@implementation BKLandscapePlayView

- (instancetype)initWithFrame:(CGRect)frame playType:(BOOL)isLive masterID:(NSString *)masterID{
    self = [super initWithFrame:frame];
    if (self) {
        
        _isLive = isLive;
        _masterID = masterID;
        self.lockScreen = NO;
        self.clipsToBounds = YES;
        [self setBackgroundColor:kClearColor];
        
        self.videoProgressView = [BKVideoProgressView new];
        self.videoProgressView.hidden = YES;
        [self addSubview:self.videoProgressView];
        [self.videoProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(@0);
            make.width.equalTo(@160);
            make.height.equalTo(@88);
        }];
        
        BKVoiceAndBrightView *vbView = [[BKVoiceAndBrightView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [self addSubview:vbView];
        [vbView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@0);
        }];
        
        kWeakSelf(self);
        vbView.draggingBlock = ^(BOOL isDragEnd,NSInteger trans){
            kStrongSelf(weakself);
            if (strong_weakself.isLive) {
                return ;
            }
            
            if (isDragEnd) {
                [strong_weakself clickEndDrag:strong_weakself.bottomView.sliderProgress];
                
                strong_weakself.videoProgressView.hidden = YES;

            }else{
                [strong_weakself clickBeginDrag:strong_weakself.bottomView.sliderProgress];
                [strong_weakself.bottomView setSliderTransValue:trans];
                
                strong_weakself.videoProgressView.hidden = NO;
                [strong_weakself.videoProgressView setTimeValue:strong_weakself.bottomView.sliderProgress.value totalValue:strong_weakself.bottomView.sliderProgress.maxValue trans:trans];
                
            }
        };
        
        [self addSubview:self.topView];
        [self addSubview:self.bottomView];
        [self addSubview:self.barrageView];
        [self addSubview:self.lockBtn];
        [self addSubview:self.editBtn];
        [self loadFrame];
        [self setIsLive:isLive];
        
        [self addGestureRecognizer:self.tapGesture];
        //键盘通知
        [kNotificationCenter addObserver:self selector:@selector(keyboardNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
        
        [self addSubview:self.noticeLabel];
    }
    return self;
}



#pragma mark  GestureRecognizer
- (void)clickLandscapePlayView:(UITapGestureRecognizer *)tapGes{
    if (_isShowKeyboard) {
        return;
    }
    if (_isHideAllView) {
        if (_isShowLock) {
            [_lockBtn setHidden:NO];
            return;
        }
        _isHideAllView = NO;
        [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
        [_topView setHidden:NO];
        [_bottomView setHidden:NO];
        [_editBtn setHidden:NO];
        [_lockBtn setHidden:NO];
    }else{
        
        [self hideAllView];
    }
}

- (void)hideAllView{
    
    _isHideAllView = YES;
    if (_isShowLock) {
        [_lockBtn setHidden:YES];
        return;
    }
    
    [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
    [UIView animateWithDuration:0.5f animations:^{
        
        [_topView setHidden:YES];
        [_bottomView setHidden:YES];
        [_editBtn setHidden:YES];
        [_lockBtn setHidden:YES];
    }];
}


#pragma  mark  clickButton;
- (void)clickLockPlayerButton:(UIButton *)sender{

    if (_isShowLock) {
        
        [sender setImage:[UIImage imageNamed:@"liveBroadcastIcLock"] forState:UIControlStateNormal];
        [_topView setHidden:NO];
        [_bottomView setHidden:NO];

        [_editBtn setHidden:NO];
        
        _isShowLock = NO;
        self.lockScreen = NO;
        _isHideAllView = NO;
        
        [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    }else{
        [sender setImage:[UIImage imageNamed:@"liveBroadcastIcLocked"] forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.5f animations:^{
            
            [_topView setHidden:YES];
            [_bottomView setHidden:YES];

            [_editBtn setHidden:YES];
        }];
        
        _isShowLock = YES;
        self.lockScreen = YES;
        self.isHideAllView = YES;
        
        [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    }
}

- (void)clickEditBtn:(UIButton *)sender{
    
    if(self.bottomView.silence_all && ![self.masterID isEqualToString:mw_mineUserId]) { //主播自己不会被禁言
        NSLog(@"全体禁言中");
        return ;
    }else if (self.bottomView.keepSilence){
        NSLog(@"禁言中");
        return ;
    }
    
    _isEidt = YES;
    [_topView setHidden:YES];
    [_editBtn setHidden:YES];
    [_lockBtn setHidden:YES];
    _isHideAllView = YES;
    [self.bottomView.inputText becomeFirstResponder];
}

- (void)setHeadImg:(NSString *)headImg{
    _headImg = headImg;
    [_topView.coverImg sd_setImageWithURL:[NSURL URLWithString:headImg] placeholderImage:[UIImage imageNamed:@"placeholder_h"]];
}

- (void)setVideoTitle:(NSString *)videoTitle{
    _videoTitle = videoTitle;
    [_topView.titleLab setText:_videoTitle];
}

- (void)setLookingVideoNum:(NSString *)lookingVideoNum{
    _lookingVideoNum = lookingVideoNum;
    [_topView.numLabel setText:_lookingVideoNum];
}

- (void)setLookingTotal:(NSString *)lookingTotal{
    _lookingTotal = lookingTotal;
}

#pragma mark  BKPlayTopViewDelegate
//退出全屏
- (void)eixtFullScreenPlayer:(UIButton *)button{
    if (self.delegate && [self.delegate respondsToSelector:@selector(landscapePlayViewClickWithButton:)]) {
        [self.delegate landscapePlayViewClickWithButton:button];
    }
}

//分享
- (void)fullScreenSharePlay:(UIButton *)button{
    if (self.delegate && [self.delegate respondsToSelector:@selector(landscapePlayViewClickWithButton:)]) {
        [self.delegate landscapePlayViewClickWithButton:button];
    }
}

- (void)clickUserHeadImage{//点击直播间主播头像不用传用户ID
    if (self.delegate && [self.delegate respondsToSelector:@selector(showUserInfoViewWithID:)]) {
        [self.delegate showUserInfoViewWithID:nil];
    }
}

- (void)showDefinitionView {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(showDefinitionView)]) {
        [self.delegate showDefinitionView];
    }
    
}


- (void)closeBarrageTopView:(UIButton*)sender{
    
    [self closeBarrage:sender];
}


#pragma mark BKPlayBottomViewDelegate
- (void)sendChatMessage:(NSString *)message{

    if (_isCloseBarrage) {
        return;
    }
    [self.socket sendMessageWithText:message nickName:@"测试" userId:mw_mineUserId headPic:@""];

}

- (void)giftBtnClicked:(UIButton *)button{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(landscapePlayViewClickWithButton:)]) {
        
        [self hideAllView];
        [self.delegate landscapePlayViewClickWithButton:button];
    }
}

- (void)closeBarrage:(UIButton *)sender{
    if (!_isCloseBarrage) {
        [_barrageView setHidden:YES];
        _isCloseBarrage = YES;
        [sender setImage:[UIImage imageNamed:@"liveBroadcastIcBarrageClose"] forState:UIControlStateNormal];
      
    }else{
        [_barrageView setHidden:NO];
        _isCloseBarrage = NO;
        [sender setImage:[UIImage imageNamed:@"liveBroadcastIcBarrageOpen"] forState:UIControlStateNormal];
    }
}

- (void)clickPlayStopButton:(UIButton*)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(landscapePlayViewClickWithButton:)]) {
        [self.delegate landscapePlayViewClickWithButton:sender];
    }
}

- (void)setIsPause:(BOOL)isPause{
    _isPause = isPause;
}

#pragma mark -BKBottomViewDelegate
- (void)sliderPopoverView:(BKSliderProgress*)sliderProgress{  //持续的动作
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeBottomViewSliderProgress:)]) {
        [self.delegate changeBottomViewSliderProgress:sliderProgress];
    }
}

- (void)clickBeginDrag:(BKSliderProgress *)sliderProgress{
    self.tapGesture.enabled = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(beginBottomViewSliderProgress:)]) {
        [self.delegate beginBottomViewSliderProgress:sliderProgress];
    }
}

- (void)clickEndDrag:(BKSliderProgress *)sliderProgress{
    self.tapGesture.enabled = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(endBottomViewSliderProgress:)]) {
        [self.delegate endBottomViewSliderProgress:sliderProgress];
    }
}


#pragma mark ReceivSocket<essage
- (void)manageReceiveSocketMessage:(MWLiveSocketData *)socketData{
    NSInteger code = socketData.code;
    
    if (code == MWLiveSocket_sysMessage) {
        
    }else if (code == MWLiveSocket_joinRoom /**加入房间*/) {
        if (_isLive) {
            _topView.numLabel.text = [NSString stringWithFormat:@"%d",socketData.liveinfo.room_online_users ];
        }
    } if ( code == MWLiveSocket_chatMessage/**聊天*/) {
        
        [self showBarrageMessage:socketData];

    }
}


/**
 显示弹幕消息
 */
- (void)showBarrageMessage:(MWLiveSocketData *)socketData{
    
    BKBarrageModel *model = [[BKBarrageModel alloc] init];
    model.nickName = socketData.nickName;
    model.messageBody = socketData.liveinfo.msgbody;
    model.headImageUrl = socketData.sender_head;
    if (!ObjIsEqualNSNull(socketData.liveinfo.msgbody)) {
        [self.barrageView setContentModel:model];
    }
    
}


#pragma mark    keyboardNotification
- (void)keyboardNotification:(NSNotification *)notification{
    CGFloat screenHeigt = self.bounds.size.height;
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyBoardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat moveY = keyBoardFrame.origin.y - screenHeigt + 0;
    if ([[BKQuickCreate doDevicePlatform] isEqualToString:@"iPhone 4S"]) {
        moveY = keyBoardFrame.origin.y - screenHeigt + 0;
    }
    if (keyBoardFrame.origin.y == screenHeigt) {
        _isShowKeyboard = NO;
        _tapGesture.enabled = YES;
    }else{
        _isShowKeyboard = YES;
        _tapGesture.enabled = NO;
    }
    [UIView animateWithDuration:duration animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, moveY);
        [self.bottomView watchLiveAdjustViewsWhenKeyboard:_isShowKeyboard];
        if (_isEidt && !_isShowKeyboard) {
            [_topView setHidden:NO];
            [_editBtn setHidden:NO];
            [_lockBtn setHidden:NO];
            _isHideAllView = NO;
            _isEidt = NO;
            [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
        }
    }];
}

#pragma mark loadViewFrame
- (void)loadFrame{
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.height.equalTo(@(60));
    }];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.left.equalTo(self.mas_left).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.height.equalTo(@(60));
    }];
    
    
    [_lockBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY).offset(0);
        make.left.equalTo(self.mas_left).offset(5);
        make.width.equalTo(@(40));
        make.height.equalTo(@(40));
    }];
    
    [_editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY).offset(0);
        make.right.equalTo(self.mas_right).offset(-5);
        make.width.equalTo(@(40));
        make.height.equalTo(@(40));
    }];
}

#pragma  mark   initView

- (UILabel *)noticeLabel{
    
    if (!_noticeLabel) {
        _noticeLabel = [UILabel new];
        _noticeLabel.textColor = kWhiteColor;
        _noticeLabel.backgroundColor = kClearColor;
        _noticeLabel.font = kFont(13);
        _noticeLabel.textAlignment = NSTextAlignmentCenter;
        _noticeLabel.layer.cornerRadius = 15;
        _noticeLabel.backgroundColor = kRGBAColor(255, 78, 86, 0.85);//kcallColor(@"FF4E56");
        _noticeLabel.layer.masksToBounds = YES;
    }
    return _noticeLabel;
}

- (BKPlayTopView *)topView{
    if (!_topView) {
        _topView = [[BKPlayTopView alloc]initWithFrame:CGRectZero isLive:_isLive];
        _topView.delegate = self;
    }
    return _topView;
}

- (BKPlayBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[BKPlayBottomView alloc]initWithIsLive:_isLive];
        _bottomView.delegate = self;
        _bottomView.masterID = self.masterID;
    }
    return _bottomView;
}

- (UIButton *)lockBtn{
    if (!_lockBtn) {
        _lockBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lockBtn setFrame:CGRectMake(kNavBarTopOffset, 0, 40, 40)];
        _lockBtn.tag = 10;
        [_lockBtn setImage:[UIImage imageNamed:@"liveBroadcastIcLock"] forState:UIControlStateNormal];
        [_lockBtn addTarget:self action:@selector(clickLockPlayerButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lockBtn;
}



- (UIButton *)editBtn{
    if (!_editBtn) {
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editBtn setFrame:CGRectMake(0, 0, 40, 40)];
        [_editBtn setImage:[UIImage imageNamed:@"liveBroadcastIcEdit"] forState:UIControlStateNormal];
        [_editBtn addTarget:self action:@selector(clickEditBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editBtn;
}

/**
 弹幕view
 */
- (BKBarrageView *)barrageView{
    if (!_barrageView) {
        _barrageView = [[BKBarrageView alloc] initWithFrame:CGRectMake(0, 30, kScreenWidth, 70)];
        _barrageView.backgroundColor = kClearColor;
        _barrageView.userInteractionEnabled = NO;
    }
    return _barrageView;
}


- (UITapGestureRecognizer *)tapGesture{
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickLandscapePlayView:)];
        
    }
    return _tapGesture;
}

- (void)setIsLive:(BOOL)isLive{
    
    [self.bottomView setIsLive:isLive];
    self.topView.isLive = isLive;
    
    [_editBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY).offset(0);
        make.right.equalTo(self.mas_right).offset(-5);
        make.width.equalTo(@(40));
        make.height.equalTo(@(40));
    }];
}

- (void)hideVideoProgressView{
    self.videoProgressView.hidden = YES;
}

#pragma mark -- 公告栏

- (void)showNotice:(NSString*)notice{
    
    [self.noticeLabel removeFromSuperview];
    self.noticeLabel = nil;
    
    CGSize size =[notice sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];//计算文字宽度
    
    CGFloat  width = [UIScreen mainScreen].bounds.size.width>[UIScreen mainScreen].bounds.size.height ? [UIScreen mainScreen].bounds.size.width:[UIScreen mainScreen].bounds.size.height;
    
    [self addSubview:self.noticeLabel];
    self.noticeLabel.text = notice;
    
    self.noticeLabel.frame = CGRectMake(width, 64, size.width+20, 30);
    
    [UIView animateWithDuration:20 delay:0 options: UIViewAnimationOptionCurveLinear animations: ^{
        
        self.noticeLabel.frame = CGRectMake(-(size.width+20), 64, size.width+20, 30);
        
    } completion: ^(BOOL finished) {
    }];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UIControl class]]) {
        return NO;
    }
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [_bottomView hideKeybord];
}


- (void)dealloc {
    
    [kNotificationCenter removeObserver:self];
    kNSLog(@"");
}
@end


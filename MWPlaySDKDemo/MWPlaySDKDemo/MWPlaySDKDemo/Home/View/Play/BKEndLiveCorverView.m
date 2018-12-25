//
//  BKEndLiveCorverView.m
//  MontnetsLiveKing
//
//  Created by lzp on 2017/9/6.
//  Copyright © 2017年 facebac.com. All rights reserved.
//

#import "BKEndLiveCorverView.h"
#import "UIImage+BKExtension.h"

#define ButtonHeight 35
#define VeriSpace 30
#define LableHeight 20

@interface BKEndLiveCorverView ()
@property(nonatomic)UIImageView *coverImageView;
@property(nonatomic)UIView *bgView ;
@property(nonatomic)UILabel *titleLabel;
@property(nonatomic)UILabel *watchCountLabel;
@property(nonatomic)UILabel *watchLabel;
@property(nonatomic)UIButton *liveLeaveBtn;//主播退到后台
@property(nonatomic)UIButton *reloadVideoBtn;//重新获取视频

@end

@implementation BKEndLiveCorverView

- (instancetype)init{
    self = [super init];
    if(self){
        [self setupUI];
    }
    return self;
}

#pragma mark -- 设置UI

- (void)setupUI{
    [self addSubview:self.coverImageView];
    [self addSubview:self.bgView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.watchLabel];
    [self addSubview:self.watchCountLabel];
    [self addSubview:self.liveLeaveBtn];
    
    [self addSubview:self.reloadVideoBtn];
    
    [self.coverImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bgView);
        make.top.mas_equalTo(self.bgView.mas_centerY).mas_offset(- (3 * LableHeight + VeriSpace) / 2.0);
        make.width.mas_equalTo(self);
        make.height.mas_equalTo(LableHeight);
    }];
    
    [self.watchCountLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bgView);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_equalTo(VeriSpace);
        make.width.mas_equalTo(self.bgView);
        make.height.mas_equalTo(LableHeight);
    }];
    
    [self.watchLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.watchCountLabel.mas_bottom).mas_offset(10);
        make.centerX.mas_equalTo(self.bgView);
        make.width.mas_equalTo(self.bgView);
        make.height.mas_equalTo(LableHeight);
    }];
    
    [self.liveLeaveBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.bgView);
        make.width.mas_equalTo(170);
        make.height.mas_equalTo(ButtonHeight);
    }];
    
    [self.reloadVideoBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
        make.width.equalTo(@100);
        make.height.equalTo(@30);
    }];
}

- (void)setWatchCount:(NSInteger)watchCount{
    self.watchCountLabel.text = [NSString stringWithFormat:@"%ld",watchCount];
}

- (void)setWatchViewHidden:(BOOL)watchViewHidden{
    _watchViewHidden = watchViewHidden;
    self.watchLabel.hidden = _watchViewHidden;
    self.watchCountLabel.hidden = _watchViewHidden;
    if(_watchViewHidden){
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.bgView.mas_centerY).mas_offset(-LableHeight / 2.0);
        }];
    }else{
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.bgView.mas_centerY).mas_offset(- (3 * LableHeight + VeriSpace) / 2.0);
        }];
        
    }
}

- (void)setCorverImage:(UIImage *)corverImage{
    if(!corverImage){
        corverImage = [UIImage imageNamed:@"livecoverdefault"];
    }
    self.coverImageView.image = [UIImage blurryImage:corverImage withBlurLevel:5];
}

- (void)setIsEndLive:(BOOL)isEndLive{
    _isEndLive = isEndLive ;
    if(_isEndLive){
        self.liveLeaveBtn.hidden = YES ;
        self.watchLabel.hidden = NO ;
        self.titleLabel.hidden = NO ;
        self.watchCountLabel.hidden = NO ;

    }else{
        self.liveLeaveBtn.hidden = NO ;
        self.watchLabel.hidden = YES ;
        self.titleLabel.hidden = YES ;
        self.watchCountLabel.hidden = YES ;
    }
    self.reloadVideoBtn.hidden = YES;
    
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bgView);
        make.top.mas_equalTo(self.bgView.mas_centerY).mas_offset(- (3 * LableHeight + VeriSpace) / 2.0);
        make.width.mas_equalTo(self);
        make.height.mas_equalTo(LableHeight);
    }];
}

- (void)setIsReloadVideo:(BOOL)isReloadVideo{
    
    _isReloadVideo = isReloadVideo;
    if (_isReloadVideo) {
        self.liveLeaveBtn.hidden = YES ;
        self.watchLabel.hidden = YES ;
        self.watchCountLabel.hidden = YES ;
        self.titleLabel.hidden = NO ;
        self.titleLabel.text = NSLocalizedString(@"getVideoFail","");
        self.reloadVideoBtn.hidden = NO;
        
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.bgView);
            make.centerY.mas_equalTo(self.bgView.mas_centerY).mas_offset(-20);
            make.width.mas_equalTo(self);
            make.height.mas_equalTo(LableHeight);
        }];
    }
}

- (void)onlyCover{
    self.liveLeaveBtn.hidden = YES ;
    self.watchLabel.hidden = YES ;
    self.titleLabel.hidden = YES ;
    self.watchCountLabel.hidden = YES ;
}

#pragma mark -- @property

- (UIImageView *)coverImageView{
    if(!_coverImageView){
        _coverImageView = ({
            UIImageView *view = [UIImageView new];
            view.contentMode = UIViewContentModeScaleAspectFill;
            view.image = [UIImage blurryImage:[UIImage imageNamed:@"livecoverdefault"] withBlurLevel:10];
            view.layer.masksToBounds = YES ;
            view ;
        });
    }
    return _coverImageView;
}

- (UIView *)bgView{
    if(!_bgView){
        _bgView = ({
            UIView *view = [UIView new];
            view.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
            view;
        });
    }
    return _bgView;
}

- (UILabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel = ({
            UILabel *view = [UILabel new];
            view.text = @"直播已结束";
            view.textColor = [UIColor whiteColor];
            view.textAlignment = NSTextAlignmentCenter;
            view.font = [UIFont systemFontOfSize:20];
            view ;
        });
    }
    return _titleLabel;
}

- (UILabel *)watchLabel{
    if(!_watchLabel){
        _watchLabel = ({
            UILabel *view = [UILabel new];
            view.text = @"观看人数";
            view.textColor = [UIColor whiteColor];
            view.textAlignment = NSTextAlignmentCenter;
            view.font = [UIFont systemFontOfSize:17];
            view ;
        });
    }
    return _watchLabel;
}

- (UILabel *)watchCountLabel{
    if(!_watchCountLabel){
        _watchCountLabel = ({
            UILabel *view = [UILabel new];
            view.textColor = [UIColor whiteColor];
            view.textAlignment = NSTextAlignmentCenter;
            view.font = [UIFont systemFontOfSize:17];
            view ;
        });
    }
    return _watchCountLabel;
}

- (UIButton *)liveLeaveBtn{
    if(!_liveLeaveBtn){
        _liveLeaveBtn = ({
            UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
            [view setTitle:@"信号中断，稍等片刻..." forState:UIControlStateNormal];
            [view.titleLabel setFont:[UIFont systemFontOfSize:15]];
            [view setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            view ;
        });
    }
    return _liveLeaveBtn;
}

- (UIButton *)reloadVideoBtn{
    if(!_reloadVideoBtn){
        _reloadVideoBtn = ({

            UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
            [view setTitle:@"重新获取" forState:UIControlStateNormal];
            [view.titleLabel setFont:[UIFont systemFontOfSize:13]];
            [view setTitleColor:kcallColor(@"2B94FF") forState:UIControlStateNormal];
            view.layer.borderWidth = 1.f;
            view.layer.borderColor = kcallColor(@"2B94FF").CGColor;
            view.layer.cornerRadius = 15.f;
            [view addTarget:self action:@selector(reloadVideo) forControlEvents:UIControlEventTouchUpInside];
            
            view.hidden = YES;
            view ;
        });
    }
    return _reloadVideoBtn;
}

- (void)reloadVideo{
    if (self.reloadBlock) {
        self.reloadBlock();
    }
}

@end

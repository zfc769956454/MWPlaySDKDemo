//
//  BKPlayTopView.m
//  MontnetsLiveKing
//
//  Created by chendb on 2017/10/31.
//  Copyright © 2017年 facebac.com. All rights reserved.
//

#import "BKPlayTopView.h"

@interface BKPlayTopView ()

/**返回*/
@property (nonatomic, strong) UIButton      *backBtn;

@property (nonatomic, strong) UIImageView   *numImage;

@property (nonatomic, strong) UIImageView   *totalImage;

@property (nonatomic, strong) UIButton      *shareBtn;

@property (nonatomic, strong) UIView        *popoverView;

@property (nonatomic, strong) UIButton      *barrageBtn;//观看直播的时候才显示

@property (nonatomic, readwrite, weak) CAGradientLayer *gradientLayer; /** 渐变图层 */

@end

@implementation BKPlayTopView

-(instancetype)initWithFrame:(CGRect)frame isLive:(BOOL)isLive{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:kClearColor];
        
        //加入渐变颜色
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"#000000" Alpha:0.0].CGColor,(__bridge id)[UIColor colorWithHexString:@"#000000" Alpha:0.7].CGColor];
        gradientLayer.locations = @[@0.0, @1.0];
        gradientLayer.startPoint = CGPointMake(0, 1.0);
        gradientLayer.endPoint = CGPointMake(0, 0);
        gradientLayer.frame = CGRectMake(0, 0, kScreenWidth>kScreenHeight?kScreenWidth:kScreenHeight, 60);
        [self.layer addSublayer:gradientLayer];
        
        _isLive = isLive;
        
        [self addSubview:self.popoverView];
        [self addSubview:self.backBtn];
        [self addSubview:self.coverImg];
        [self addSubview:self.titleLab];

        [self addSubview:self.totalImage];
        [self addSubview:self.totalLabel];
        [self addSubview:self.shareBtn];
        
        [self addSubview:self.barrageBtn];

        [self addSubview:self.definitionBtn];

        [self loadFrame];

    }
    return self;
}

-(void)layoutSubviews{
    _gradientLayer.frame = self.frame;
    _gradientLayer.anchorPoint = CGPointMake(0.5, 0.5);

}

#pragma clickButton
- (void)clickPlayBackButton:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(eixtFullScreenPlayer:)]) {
        [self.delegate eixtFullScreenPlayer:sender];
    }
}

- (void)clickShareButton:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(fullScreenSharePlay:)]) {
        [self.delegate fullScreenSharePlay:sender];
    }
}

#pragma makr
- (void)loadFrame{
    
    [_popoverView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.width.equalTo(self.mas_width);
        make.height.equalTo(self.mas_height);
    }];
    
    [_backBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(8);
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.width.height.equalTo(@(40));
    }];
    
    [_coverImg mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backBtn.mas_right).offset(10);
        make.bottom.equalTo(self.backBtn.mas_bottom).offset(-6);
        make.width.height.equalTo(@(30));
    }];
    kViewBorderRadius(_coverImg, 15.f, 0, kClearColor);
    _coverImg.layer.masksToBounds = YES;
    
    [_shareBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-5);
        make.centerY.equalTo(self.backBtn);
        make.height.width.equalTo(@(40));
    }];
    
    [_barrageBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.shareBtn.mas_left).offset(-15);
        make.centerY.equalTo(self.backBtn);
        make.width.equalTo(@(20));
        make.height.equalTo(@(20));
    }];
    
    [_definitionBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.barrageBtn.mas_left).offset(-20);
        make.centerY.equalTo(self.backBtn);
        make.height.equalTo(@(30));
        make.width.equalTo(@40);
    }];
    
    [_totalLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.definitionBtn.mas_left).offset(-25);
        make.centerY.equalTo(self.backBtn);
        make.height.equalTo(@(20));
    }];
    
    [_totalImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.totalLabel.mas_left).offset(-5);
        make.centerY.equalTo(self.backBtn);
        make.width.equalTo(@(20));
        make.height.equalTo(@(20));
    }];
    
    [_titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(20));
        make.left.equalTo(self.coverImg.mas_right).offset(10);
        make.right.equalTo(self.totalImage.mas_left).offset(-80);
        make.centerY.equalTo(self.coverImg.mas_centerY);
    }];
}

- (void)hideDefinitionBtn:(BOOL)hide{
    
    if (hide) {
        [_totalLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.barrageBtn.mas_left).offset(-25);
            make.centerY.equalTo(self.backBtn);
            make.height.equalTo(@(20));
        }];
    }else{
        [_definitionBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.barrageBtn.mas_left).offset(-20);
            make.centerY.equalTo(self.backBtn);
            make.height.equalTo(@(30));
            make.width.equalTo(@40);
        }];
        
        [_totalLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.barrageBtn.mas_left).offset(-25);
            make.centerY.equalTo(self.backBtn);
            make.height.equalTo(@(20));
        }];
    }
}

#pragma mark  -initView

- (UIView *)popoverView{
    if (!_popoverView) {
        _popoverView = [[UIView alloc]init];
    }
    return _popoverView;
}

- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"liveBroadcastIcBack"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(clickPlayBackButton:) forControlEvents:UIControlEventTouchUpInside];
        _backBtn.tag = 5000 + 2;
    }
    return _backBtn;
}

- (UIImageView *)coverImg{
    if (!_coverImg) {
        _coverImg = [[UIImageView alloc]init];
        [_coverImg setImage:[UIImage imageNamed:@"placeholder_h"]];
        
        _coverImg.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickHeadImage)];
        [_coverImg addGestureRecognizer:singleTap];//为imageView添加点击手势
    }
    return _coverImg;
}



- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]init];
        [_titleLab setFont:[UIFont systemFontOfSize:15.f]];
        [_titleLab setTextAlignment:NSTextAlignmentLeft];
        [_titleLab setBackgroundColor:kClearColor];
        [_titleLab setTextColor:kWhiteColor];
        [_titleLab setText:@"直播"];
    }
    return _titleLab;
}

- (UIImageView *)totalImage{
    if (!_totalImage) {
        _totalImage = [[UIImageView alloc]init];
        [_totalImage setImage:[UIImage imageNamed:@"liveBroadcastIcWatch"]];
    }
    return _totalImage;
}

- (UILabel *)totalLabel{
    if (!_totalLabel) {
        _totalLabel = [[UILabel alloc]init];
        [_totalLabel setFont:[UIFont systemFontOfSize:14.f]];
        [_totalLabel setTextAlignment:NSTextAlignmentRight];
        [_totalLabel setBackgroundColor:kClearColor];
        [_totalLabel setTextColor:kWhiteColor];
        [_totalLabel setText:@"9999"];
    }
    return _totalLabel;
}

- (UIImageView *)numImage{
    if (!_numImage) {
        _numImage = [[UIImageView alloc]init];
        [_numImage setImage:[UIImage imageNamed:@"liveBroadcastIcOnline"]];
    }
    return _numImage;
}

- (UILabel *)numLabel{
    if (!_numLabel) {
        _numLabel = [[UILabel alloc]init];
        [_numLabel setFont:[UIFont systemFontOfSize:14.f]];
        [_numLabel setTextAlignment:NSTextAlignmentRight];
        [_numLabel setBackgroundColor:kClearColor];
        [_numLabel setTextColor:kWhiteColor];
        [_numLabel setText:@"9999"];
    }
    return _numLabel;
}

- (UIButton *)shareBtn{
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareBtn setImage:[UIImage imageNamed:@"live_broadcast_ic_share2"] forState:UIControlStateNormal];
        [_shareBtn addTarget:self action:@selector(clickShareButton:) forControlEvents:UIControlEventTouchUpInside];
        _shareBtn.tag = 3;
    }
    return _shareBtn;
}

- (UIButton *)barrageBtn{
    if (!_barrageBtn) {
        _barrageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_barrageBtn setImage:[UIImage imageNamed:@"liveBroadcastIcBarrageOpen"] forState:UIControlStateNormal];
        [_barrageBtn addTarget:self action:@selector(clickBarrageButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _barrageBtn;
}

- (UIButton *)definitionBtn{
    
    if (!_definitionBtn) {
        _definitionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_definitionBtn setTitle:@"原画" forState:UIControlStateNormal];
        _definitionBtn.titleLabel.font = kMediumFontIsB4IOS9(14.f);
        _definitionBtn.titleLabel.shadowOffset = CGSizeMake(0.5, 0.5);
        _definitionBtn.titleLabel.shadowColor = [UIColor blackColor];
        [_definitionBtn setBackgroundColor:kClearColor];
        [_definitionBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [_definitionBtn addTarget:self action:@selector(showDefinition) forControlEvents:UIControlEventTouchUpInside];
    }
    return _definitionBtn;
}

- (void)setDefinition:(NSString *)definition{
    _definition = definition;
    [_definitionBtn setTitle:definition forState:UIControlStateNormal];
}

- (void)clickBarrageButton:(UIButton*)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(closeBarrageTopView:)]) {
        
        [self.delegate closeBarrageTopView:sender];
    }
}

- (void)clickHeadImage{

    if (self.delegate && [self.delegate respondsToSelector:@selector(clickUserHeadImage)]) {
        
        [self.delegate clickUserHeadImage];
    }
}

- (void)showDefinition{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(showDefinitionView)]) {
        
        [self.delegate showDefinitionView];
    }
}

@end

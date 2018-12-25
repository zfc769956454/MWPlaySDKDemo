//
//  BKVideoProgressView.m
//  MontnetsLiveKing
//
//  Created by 谢敏 on 2018/7/27.
//  Copyright © 2018年 facebac.com. All rights reserved.
//

#import "BKVideoProgressView.h"

@interface BKVideoProgressView()

@property (nonatomic,strong)UIImageView  *imageV;
@property (nonatomic,strong)UIView  *spiltLine;
@property (nonatomic,strong)UIView  *progressView;
@property (nonatomic,strong)UILabel  *time;
@property (nonatomic,strong)UILabel  *totalTime;

@end

@implementation BKVideoProgressView

-(instancetype)init{
    
    self = [super init];
    if (self) {
        
        self.backgroundColor = kRGBAColor(0, 0, 0, 0.5);
        self.layer.cornerRadius = 4.f;
        
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    
    [self addSubview:self.imageV];
    [self addSubview:self.spiltLine];
    [self.spiltLine addSubview:self.progressView];
    [self addSubview:self.time];
    [self addSubview:self.totalTime];
    
    [self makeConstraints];
}

- (void)makeConstraints{
    
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(@0);
        make.top.equalTo(@12);
        make.width.equalTo(@35);
        make.height.equalTo(@23);
    }];
    
    [self.spiltLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@51);
        make.height.equalTo(@3);
        make.left.right.equalTo(@0);
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.bottom.equalTo(@0);
        make.width.equalTo(@0);
    }];
    
    [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.mas_centerX);
        make.height.equalTo(@20);
        make.bottom.equalTo(@-8);
    }];
    
    [self.totalTime mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_centerX).offset(3);
        make.centerY.equalTo(self.time);
        make.height.equalTo(@20);
    }];
}

- (UIImageView *)imageV{
    
    if (!_imageV) {
        
        _imageV = [UIImageView new];
        _imageV.backgroundColor = kClearColor;
        _imageV.image = [UIImage imageNamed:@"ic_speed"];
    }
    return _imageV;
}

- (UIView *)spiltLine{
    
    if (!_spiltLine) {
        
        _spiltLine = [UIView new];
        _spiltLine.backgroundColor = kRGBAColor(255, 255, 255, 0.3);
    }
    return _spiltLine;
}

- (UIView *)progressView{
    
    if (!_progressView) {
        _progressView = [UIView new];
        _progressView.backgroundColor = kcallColor(kBasicAppColor);
    }
    return _progressView;
}

- (UILabel *)time{
    
    if (!_time) {
        
        _time = [UILabel new];
        _time.textColor = kcallColor(kBasicAppColor);
        _time.text = @"00:00:00 /";
        _time.textAlignment = NSTextAlignmentLeft;
        _time.font = [UIFont boldSystemFontOfSize:15];
    }
    return _time;
}

- (UILabel *)totalTime{
    
    if (!_totalTime) {
        
        _totalTime = [UILabel new];
        _totalTime.textColor = kWhiteColor;
        _totalTime.text = @"00:00:00";
        _totalTime.textAlignment = NSTextAlignmentLeft;
        _totalTime.font = [UIFont boldSystemFontOfSize:15];
    }
    return _totalTime;
}

- (void)setTimeValue:(NSInteger)timeValue totalValue:(NSInteger)totalValue trans:(NSInteger)trans{

    if (trans>=0) {
        _imageV.image = [UIImage imageNamed:@"ic_speed"];
    }else{
        _imageV.image = [UIImage imageNamed:@"ic_rewind_down"];
    }
    
    self.time.text = [NSString stringWithFormat:@"%@ /",[NSDate timeDescriptionOfTimeInterval:timeValue]];
    
    CGFloat ratio = (CGFloat)timeValue / (CGFloat)totalValue;
    self.totalTime.text = [NSString stringWithFormat:@"%@",[NSDate timeDescriptionOfTimeInterval:totalValue]];

    [self.progressView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.bottom.equalTo(@0);
        make.width.equalTo(self.spiltLine.mas_width).multipliedBy(ratio);
    }];
}

- (void)setIsSimpleType:(BOOL)isSimpleType{
    _isSimpleType = isSimpleType;
    if (isSimpleType) {
        self.layer.cornerRadius = 0.f;
        self.imageV.hidden = YES;
        
        [self.time mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.mas_centerX).offset(0);
            make.height.equalTo(@20);
            make.bottom.equalTo(self.mas_centerY);
        }];
        
        [self.totalTime mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.mas_centerX).offset(3);
            make.centerY.equalTo(self.time);
            make.height.equalTo(@20);
        }];
        
        [self.spiltLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.width.equalTo(@160);
            make.height.equalTo(@3);
            make.centerX.equalTo(@0);
            make.top.equalTo(self.time.mas_bottom).offset(16);
        }];
        
        [self.progressView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.top.bottom.equalTo(@0);
            make.width.equalTo(@0);
        }];
    }
}

@end

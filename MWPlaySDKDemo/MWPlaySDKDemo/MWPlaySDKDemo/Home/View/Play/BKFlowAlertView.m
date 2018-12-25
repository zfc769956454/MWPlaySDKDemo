//
//  BKFlowAlertView.m
//  MontnetsLiveKing
//
//  Created by chendb on 2017/9/25.
//  Copyright © 2017年 facebac.com. All rights reserved.
//

#import "BKFlowAlertView.h"

@interface BKFlowAlertView ()
{
    NSInteger   flowTimer;
}
@property (nonatomic, strong) UIImageView   *imageView;

@property (nonatomic, strong) UILabel       *timeLabel;

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@property (nonatomic, strong) NSTimer       *timer;

@end

@implementation BKFlowAlertView

-(void)layoutSubviews{
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.leading.equalTo(self.mas_leading);
        make.width.equalTo(self.mas_width);
        make.height.equalTo(@(16));
    }];
    [_timeLabel.layer setCornerRadius:8.f];
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(2);
        make.width.equalTo(self.mas_width).offset(- 4);
        make.bottom.equalTo(self.timeLabel.mas_top);
        make.top.equalTo(self.mas_top);
    }];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.timeLabel];
        [self addSubview:self.imageView];
        
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:self.tapGesture];
    }
    return self;
}

- (void)clickView:(UITapGestureRecognizer *)tap{
    NSLog(@"点击了红包 准备开抢了！！！");
    if (self.clickGardRedEnvelopeBlock) {
        self.clickGardRedEnvelopeBlock(self.redEnvolpeUrl);
    }
}

- (void)countDownEnvopleTimer{
    flowTimer --;
    [_timeLabel setText:[NSDate judgeTimerWithHourMinuteAndSecond:flowTimer]];
    if (flowTimer == 0) {
        if (self.countDownEndBlock) {
            self.countDownEndBlock();
        }
    }
}

- (void)setActiveTimer:(NSInteger)activeTimer{
    _activeTimer = activeTimer;
    flowTimer = activeTimer;
    [_timeLabel setText:[NSDate judgeTimerWithHourMinuteAndSecond:flowTimer]];
    if (!_timer) {  //防止多次加载计时器
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

- (void)setRedEnvolpeUrl:(NSString *)redEnvolpeUrl{
    _redEnvolpeUrl = redEnvolpeUrl;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        [_imageView setBackgroundColor:kClearColor];
        [_imageView setImage:[UIImage imageNamed:@"envelope_little"]];
    }
    return _imageView;
}

-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        [_timeLabel setBackgroundColor:kcallColor(@"ffe567")];
        [_timeLabel setTextColor:kcallColor(@"f42341")];
        [_timeLabel setFont:[UIFont systemFontOfSize:11.f]];
        [_timeLabel setText:@"04:00:00"];
        [_timeLabel setTextAlignment:NSTextAlignmentCenter];
//        [_timeLabel.layer setBorderColor:[UIColor redColor].CGColor];
//        [_timeLabel.layer setBorderWidth:1.f];
        [_timeLabel.layer setMasksToBounds:YES];
    }
    return _timeLabel;
}

- (UITapGestureRecognizer *)tapGesture{
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickView:)];
    }
    return _tapGesture;
}

- (NSTimer *)timer{
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(countDownEnvopleTimer) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (void)releaseFlowAlertView{
    [_timer invalidate];
    _timer = nil;
    [self removeFromSuperview];
}

@end

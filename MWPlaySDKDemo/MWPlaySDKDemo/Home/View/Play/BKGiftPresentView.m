//
//  BKGiftPresentView.m
//  MontnetsLiveKing
//
//  Created by chendb on 2017/10/30.
//  Copyright © 2017年 facebac.com. All rights reserved.
//

#import "BKGiftPresentView.h"
#import "NSTimer+AutoRetain.h"

@interface BKGiftPresentView ()
{
    NSInteger lastCount;
}
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, copy  ) void(^completeBlock)(BOOL finished);
@property (nonatomic, strong) UIImageView *flowerView;
@property (nonatomic, weak  ) UILabel *floweNum;
@property (nonatomic, weak  ) BKGiftShakeLabel *shakeLabel;
@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, assign) BOOL isWillComplete;

@end

@implementation BKGiftPresentView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _isShow = NO;
        _isWillComplete = NO;
    }
    return self;
}

- (NSTimer *)timer{
    if (!_timer) {
        kWeakSelf(self);
        _timer = [NSTimer nh_scheduledTimerWithTimeInterval:0.6 repeats:YES block:^(NSTimer *timer) {
            kStrongSelf(weakself);
            [strong_weakself fireAnimate];
        }];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

// 根据礼物个数播放动画
- (void)animateWithCompleteBlock:(completeBlock)completed{
    kWeakSelf(self);
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(0, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        [weakself.timer isValid];
    }];
    self.completeBlock = completed;
}

- (void)fireAnimate{
    
    _animCount ++;
    NSString *string = [NSString stringWithFormat:@"X %ld",_animCount];
    if (_animCount > _giftCount) {
        string = [NSString stringWithFormat:@"X %ld",_giftCount];
    }
    CGSize singSize1 =[string sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:24]}];
    if (singSize1.width > _shakeLabel.width) {
        self.shakeLabel.width = singSize1.width + 20;
    }
    //如果计数大于的话 就显示数字 不显示动画
    kWeakSelf(self);
    if (_animCount > _giftCount) {
        self.shakeLabel.text = string;
        if (lastCount >= _giftCount) {
            [NSThread sleepForTimeInterval:1];
            [UIView animateWithDuration:0.2 delay:1 options:UIViewAnimationOptionLayoutSubviews | UIViewAnimationOptionCurveEaseInOut animations:^{
                weakself.frame = CGRectMake(0, weakself.frame.origin.y - 20, weakself.frame.size.width, weakself.frame.size.height);
                weakself.alpha = 0;
                kNSLog(@"\n第一个else ：动画将要已完成%ld",(long)_animCount);
            } completion:^(BOOL finished) {
                kNSLog(@"\n第一个else ：动画已完成%ld",(long)_animCount);
                if (weakself.animCount < weakself.giftCount) {
                    return ;
                }
                weakself.finished = finished;
                if (weakself.completeBlock) weakself.completeBlock(weakself.finished);
                [weakself reset];
                [weakself removeFromSuperview];
                
            }];
        }
        else if(lastCount < _giftCount){
            [self.shakeLabel startAnimWithDuration:0.25 compelete:^(BOOL finished) {
                if (_animCount == _giftCount || _animCount > _giftCount) {
                    CGFloat time;
                    if (_isWillComplete) {
                        [NSThread sleepForTimeInterval:1.0];
                        time = 1.0;
                        _isWillComplete = NO;
                    }else{
                        time = 0.2;
                        [weakself.timer invalidate];
                    }
                    _isWillComplete = YES;
                    
                    [UIView animateWithDuration:time delay:1 options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseInOut animations:^{
                        weakself.frame = CGRectMake(0, weakself.frame.origin.y - 20, weakself.frame.size.width, weakself.frame.size.height);
                        weakself.alpha = 0;
                        kNSLog(@"\n第二个else ：动画将要已完成%ld",(long)_animCount);
                    } completion:^(BOOL finished) {
                        kNSLog(@"\n第二个else ：动画已完成%ld",(long)_animCount);
                        if (weakself.animCount < weakself.giftCount) {
                            return ;
                        }
                        weakself.finished = finished;
                        if (weakself.completeBlock) weakself.completeBlock(weakself.finished);
                        [weakself reset];
                        [weakself removeFromSuperview];
                    }];
                }
            }];
        }
    }else{
        self.shakeLabel.text = string;
        kWeakSelf(self);
        lastCount = _animCount;
        [weakself.shakeLabel startAnimWithDuration:0.25 compelete:^(BOOL finished) {
            if (_animCount == _giftCount || _animCount > _giftCount) {
                CGFloat time;
                if (_isWillComplete) {
                    [NSThread sleepForTimeInterval:1.0];
                    time = 1.0;
                    _isWillComplete = NO;
                }else{
                    time = 0.2;
                    [weakself.timer invalidate];
                }
                _isWillComplete = YES;
                
                [UIView animateWithDuration:time delay:1 options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseInOut animations:^{
                    weakself.frame = CGRectMake(0, weakself.frame.origin.y - 20, weakself.frame.size.width, weakself.frame.size.height);
                    weakself.alpha = 0;
                    kNSLog(@"\n第三个else ：动画将要已完成%ld",(long)_animCount);
                    
                } completion:^(BOOL finished) {
                    kNSLog(@"\n第三个else ：动画已完成%ld",(long)_animCount);
                    if (weakself.animCount < weakself.giftCount) {
                        return ;
                    }
                    weakself.finished = finished;
                    if (weakself.completeBlock) weakself.completeBlock(weakself.finished);
                    [weakself reset];
                    [weakself removeFromSuperview];
                }];
            }
        }];
    }
}

- (void)endAnimation:(NSNotification *)notification{
    [self.layer removeAllAnimations];
    for (UIView *label in self.subviews) {
        [label.layer removeAllAnimations];
        [label removeFromSuperview];
    }
}

- (void)animationComplete{
    self.completeBlock(_finished);
}

- (void)continuePresentFlowers{
    if (!_isShow) {
        _giftCount ++;
        if (_isWillComplete) {
            [self fireAnimate];
        }
        kNSLog(@"＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝连击动画增加%ld",(long)_giftCount);
    }
    //    kNSLog(@"------>>%@",_model.userID);
}

- (void)continuePresentFlowersComplete:(completeBlock)completed{
    self.completeBlock = completed;
}

// 重置
- (void)reset {
    [_timer invalidate];
    _timer = nil;
    _isShow = YES;
    _isWillComplete = NO;
    _shakeLabel.text = @"";
    
    self.frame = _originFrame;
    self.alpha = 1;
    self.animCount = 0;
}

- (instancetype)init {
    if (self = [super init]) {
        
        [self setUI];
        _originFrame = self.frame;
        [kNotificationCenter addObserver:self selector:@selector(endAnimation:) name:@"presentViewRemoveAnimation" object:nil];
    }
    return self;
}


#pragma mark 布局 UI
- (void)layoutSubviews {
    [super layoutSubviews];
    _headImageView.frame = CGRectMake(0, 0, self.frame.size.height, self.frame.size.height);
    _headImageView.layer.borderWidth = 1;
    _headImageView.layer.borderColor = [UIColor clearColor].CGColor;
    _headImageView.layer.cornerRadius = _headImageView.frame.size.height / 2;
    _headImageView.layer.masksToBounds = YES;
    _giftImageView.frame = CGRectMake(self.frame.size.width - 45, self.frame.size.height - 50, 50, 50);
    _nameLabel.frame = CGRectMake(_headImageView.frame.size.width + 5, 5, 140, 10);
    _giftLabel.frame = CGRectMake(_nameLabel.frame.origin.x, CGRectGetMaxY(_headImageView.frame) - 10 - 5, _nameLabel.frame.size.width, 10);
    
    _bgImageView.frame = self.bounds;
    _bgImageView.layer.cornerRadius = self.frame.size.height / 2;
    _bgImageView.layer.masksToBounds = YES;
    _shakeLabel.frame = CGRectMake(CGRectGetMaxX(self.frame) + 5, 10, 90, 30);
}

#pragma mark 初始化 UI
- (void)setUI {
    
    _bgImageView = [[UIImageView alloc] init];
    _bgImageView.backgroundColor = [UIColor blackColor];
    _bgImageView.alpha = 0.3;
    _headImageView = [[UIImageView alloc] init];
    [_headImageView setImage:[UIImage imageNamed:@"placeholder_h"]];
    _headImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickHeadImage)];
    [_headImageView addGestureRecognizer:singleTap];//为imageView添加点击手势
    _giftImageView = [[UIImageView alloc] init];
    _nameLabel = [[UILabel alloc] init];
    _giftLabel = [[UILabel alloc] init];
    _nameLabel.textColor  = [UIColor whiteColor];
    _nameLabel.font = [UIFont systemFontOfSize:12];
    _giftLabel.textColor  = kRGBAColor(17, 230, 236, 1.f);
    _giftLabel.font = [UIFont systemFontOfSize:12];
    
    // 初始化动画label
    BKGiftShakeLabel *shakeLabel =  [[BKGiftShakeLabel alloc] init];
    shakeLabel.font = [UIFont systemFontOfSize:23];
    shakeLabel.borderColor = kRGBAColor(29, 187, 254, 1);
    shakeLabel.textColor = kRGBAColor(29, 187, 254, 1);
    shakeLabel.textAlignment = NSTextAlignmentCenter;
    _animCount = 0;
    
    [self addSubview:_bgImageView];
    [self addSubview:_headImageView];
    [self addSubview:_giftImageView];
    [self addSubview:_nameLabel];
    [self addSubview:_giftLabel];
    [self addSubview:shakeLabel];
    _shakeLabel = shakeLabel;
}

- (void)setGiftModel:(BKGiftEffectModel *)model {
    _giftModel = model;
    if (model.headImage == nil) {
        kWeakSelf(_headImageView);
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:model.receiveUserImgUrl] placeholderImage:[UIImage imageNamed:@"placeholder_h"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                [weak_headImageView setImage:image];
            }else{
                [weak_headImageView setImage:[UIImage imageNamed:@"placeholder_h"]];
            }
        }];
        
    }else{
        _headImageView.image = model.headImage;
    }
    if (model.giftImage == nil) {
        [_giftImageView sd_setImageWithURL:[NSURL URLWithString:model.giftImg]];
    }else{
        _giftImageView.image = model.giftImage;
    }
    _nameLabel.text = model.sendName;
    _giftLabel.text = model.giftName;
    _giftCount = [model.giftCount integerValue];
}

- (void)setGiftCount:(NSInteger)giftCount{
    
    _giftCount = giftCount;
    _animCount = _giftCount;
    NSString *string = [NSString stringWithFormat:@"X %ld",giftCount];
    CGSize singSize1 =[string sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:24]}];
    if (singSize1.width > _shakeLabel.width) {
        self.shakeLabel.width = singSize1.width + 20;
    }
    self.shakeLabel.text = string;
    //    self.shakeLabel.text = [NSString stringWithFormat:@"X %d",giftCount];
    [self.shakeLabel startAnimWithDuration:0.2 compelete:^(BOOL finished) {
        
    }];
}

- (void)clickHeadImage{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickHeadImageWithUserID:)]) {
        
        [self.delegate clickHeadImageWithUserID:_giftModel.sendUserID];
    }
}

-(void)dealloc{
    [kNotificationCenter removeObserver:self];
    kNSLog(@"");
}

@end

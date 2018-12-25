//
//  BKIndicatorView.m
//  BaiKeMiJiaLive
//
//  Created by NegHao on 16/9/5.
//  Copyright © 2016年 facebac. All rights reserved.
//

#import "BKIndicatorView.h"
#import "BKIndicatorAnimatiomProtocol.h"
#import "BKBounceSpotAnimation.h"
#import "BKBounceSpotRoundAnimation.h"

#define kIndicatorDefaultSize CGSizeMake(60,60)

@interface BKIndicatorView ()<CAAnimationDelegate>
@property id<BKIndicatorAnimatiomProtocol> animation;
@property BKIndicatorType type;
@property CGSize size;
@property UIColor *loadingTintColor;

@end


@implementation BKIndicatorView

- (instancetype)initWithType:(BKIndicatorType)type tintColor:(UIColor *)color{

    return [self initWithType:type tintColor:color size:kIndicatorDefaultSize];
}

- (instancetype)initWithType:(BKIndicatorType)type tintColor:(UIColor *)color size:(CGSize)size{
    if (self = [super init]) {
        self.type = type;
        self.loadingTintColor = color;
        self.size = size;
        self.backgroundColor = kClearColor;
        [kNotificationCenter addObserver:self selector:@selector(indicatorWillEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [kNotificationCenter addObserver:self selector:@selector(indicatorWillBecomeActive) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    
    return self;
}


#pragma mark - Animation
- (void)startAnimating{
    [self setHidden:NO];
    self.layer.sublayers = nil;
    [self setToNormalState];
    self.animation = [self animationForIndicatorType:self.type];
    if ([self.animation respondsToSelector:@selector(configAnimationAtLayer:withTintColor:size:)]) {
        
        [self.animation configAnimationAtLayer:self.layer withTintColor:self.loadingTintColor size:self.size];
    }
    self.isAnimating = YES;
}

- (void)stopAnimating{
    [self setHidden:YES];
    if (self.isAnimating == YES) {
        if ([self.animation respondsToSelector:@selector(removeAnimation)]) {
            [self.animation removeAnimation];
            self.isAnimating = NO;
            self.animation = nil;
        }
        [self fadeOutWithAnimation:YES];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}


- (id<BKIndicatorAnimatiomProtocol>)animationForIndicatorType:(BKIndicatorType)type{

    if (type == IndicatorTypeBounceSpot) {
        return [[BKBounceSpotAnimation alloc] init];
    }else{
    
        return nil;
    }
}


#pragma mark - Indicator animation methods
- (void)setToNormalState{
    self.layer.backgroundColor = [UIColor clearColor].CGColor;
    self.layer.speed = 1.0f;
    self.layer.opacity = 1.0;
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(-self.size.width / 2, 20, self.size.width, 30)];
    title.backgroundColor = kClearColor;
    title.textColor = kcallColor(kBasicAppColor);
    title.text = NSLocalizedString(@"loading","");
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont systemFontOfSize:15.f];
    self.layer.contents = title;
    [self.layer addSublayer:title.layer];
}


- (void)setToFadeOutState{
    self.layer.backgroundColor = [UIColor clearColor].CGColor;
    self.layer.sublayers = nil;
    self.layer.opacity = 0.f;
}

- (void)fadeOutWithAnimation:(BOOL)animated{
    if (animated) {
        CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        fadeAnimation.delegate = self;
        fadeAnimation.beginTime = CACurrentMediaTime();
        fadeAnimation.duration = 0.35;
        fadeAnimation.toValue = @(0);
        [self.layer addAnimation:fadeAnimation forKey:@"fadeOut"];
    }
}


#pragma mark - CAAnimation delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [self setToFadeOutState];
}


#pragma mark - Did enter background
- (void)indicatorWillEnterBackground{
    if (self.isAnimating == YES) {
        [self.animation removeAnimation];
    }
}

- (void)indicatorWillBecomeActive{
    if (self.isAnimating == YES) {
        [self startAnimating];
    }
}



@end

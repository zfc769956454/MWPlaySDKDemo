//
//  MWEnterIntoLiveRoomAnimationManger.m
//  MWPlaySDKDemo
//
//  Created by mac on 2019/1/4.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "MWEnterIntoLiveRoomAnimationManger.h"
#import "MWGCDTimerManager.h"

#define gcdTimerInterval  0.01
#define enterIntoDisappearTimerInterval 1.0  //动画时间
static NSString *const enterIntoDisappearTimer = @"enterIntoDisappearTimer";//消失定时器


//UI边距、间距可调动
#define nickNameLabelLeftMargin    10
#define nickNameLabelRightMargin   4
#define enterTitleLabelRightMargin 12
#define enterTitleLabelWidth       72



@interface MWEnterIntoLiveRoomAnimationManger()

/**用户进入试图*/
@property (strong, nonatomic) UIImageView *enterIntoAnimationImageView;
/**进入直播间标题*/
@property (strong, nonatomic) UILabel *enterTitleLabel ;
/**昵称*/
@property (strong, nonatomic) UILabel *nickNameLabel;

/**定时器增长时间*/
@property (assign, nonatomic) CGFloat timerAdd;

@end

@implementation MWEnterIntoLiveRoomAnimationManger

- (instancetype)init
{
    if(self = [super init]){
        
        //转屏
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deviceRotate) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
        
    }
    return self;
}


#pragma mark - public action
- (void)showEnterIntoAnimationWithNickName:(NSString *)nickName {

    if(ObjIsEqualNSNull(nickName)) {
        
        return;
    }
    
    if(self.enterIntoAnimationImageView.mj_x > -kScreenWidth && _enterIntoAnimationImageView.mj_x < 0) {
        
        return;
    }
    
    BOOL isEnterIntoImageViewExist = NO;
    
    if(self.enterIntoAnimationImageView.mj_x >= 0 && self.timerAdd < enterIntoDisappearTimerInterval) {
        
        [[MWGCDTimerManager sharedInstance] cancelTimerWithName:enterIntoDisappearTimer];
        isEnterIntoImageViewExist = YES;
        self.timerAdd = 0;
    
    }
    
    if(nickName.length > 9) {
        nickName = [NSString stringWithFormat:@"%@...",[nickName substringToIndex:9]];
    }
    
    self.nickNameLabel.text = nickName;
    
    CGSize nickNameSize = [self.nickNameLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.nickNameLabel.font} context:nil].size;
    
    self.enterIntoAnimationImageView.mj_w = nickNameSize.width + nickNameLabelLeftMargin + enterTitleLabelWidth + nickNameLabelRightMargin + enterTitleLabelRightMargin + 1;
    
    if(self.enterIntoAnimationImageView.mj_x <= -kScreenWidth)
    {
        
        self.enterIntoAnimationImageView.alpha  = 1;
        self.enterIntoAnimationImageView.hidden = NO;
        
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            CGRect rect = self.enterIntoAnimationImageView.frame;
            rect = CGRectOffset(rect, kScreenWidth, 0);
            self.enterIntoAnimationImageView.frame = rect;
            
            NSLog(@"enterIntoAnimationImageView:%@",NSStringFromCGRect(self.enterIntoAnimationImageView.frame));
            
        } completion:^(BOOL finished) {
            
            [self hiddenEnterIntoAnimation];
        }];
    }
    
    if(isEnterIntoImageViewExist) {
        
        [self hiddenEnterIntoAnimation];
    }
}


-(void)hiddenEnterIntoAnimation
{
    [[MWGCDTimerManager sharedInstance] scheduledDispatchTimerWithName:enterIntoDisappearTimer  timeInterval:gcdTimerInterval queue:nil repeats:YES action:^{
        
        self.timerAdd += gcdTimerInterval;
        
        if(self.timerAdd >= enterIntoDisappearTimerInterval) {
            [[MWGCDTimerManager sharedInstance] cancelTimerWithName:enterIntoDisappearTimer];
            self.timerAdd = 0;
            
            if(self.enterIntoAnimationImageView.frame.origin.x >= 0)
            {
                [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    
                    CGRect rect = self.enterIntoAnimationImageView.frame;
                    rect = CGRectOffset(rect, -kScreenWidth, 0);
                    self.enterIntoAnimationImageView.frame = rect;
                    
                } completion:^(BOOL finished) {
                    
                    self.enterIntoAnimationImageView.alpha  = 0;
                    self.enterIntoAnimationImageView.hidden = YES;
                    
                }];
            }
        }
    }];
    
}


- (void)removeEnterIntoView {
    
    [self deviceRotate];
    [_enterIntoAnimationImageView removeFromSuperview];
    
}


//转屏
- (void)deviceRotate {
    
    [[MWGCDTimerManager sharedInstance] cancelTimerWithName:enterIntoDisappearTimer];
    self.enterIntoAnimationImageView.hidden = YES;
    self.enterIntoAnimationImageView.alpha  = 0;
    self.enterIntoAnimationImageView.mj_x   = -kScreenWidth;
    self.timerAdd = 0;
    
}



#pragma mark - lazy
- (UIImageView *)enterIntoAnimationImageView {
    
    if(_enterIntoAnimationImageView == nil) {
        
        _enterIntoAnimationImageView = ({
            
            UIImageView *imageView = [UIImageView ZFC_ImageViewChainedCreater:^(ZFC_ImageViewChainedCreater *creater) {
                creater.frame(CGRectMake(-kScreenWidth , kScreenHeight /2 - 17, 152, 34))
                .image([[UIImage imageNamed:@"bg_enterIntoLR"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 12) resizingMode:UIImageResizingModeStretch]);
            }];
            
            self.enterTitleLabel = [UILabel ZFC_LabelChainedCreater:^(ZFC_LabelChainedCreater *creater) {
                creater.textColor([UIColor whiteColor])
                .text(@"进入直播间")
                .textAlignment(NSTextAlignmentRight)
                .font(kFont(14))
                .addIntoView(imageView);
            }];
            self.enterTitleLabel.alpha = 0.8;
            
            self.nickNameLabel = [UILabel ZFC_LabelChainedCreater:^(ZFC_LabelChainedCreater *creater) {
                creater.textColor([UIColor whiteColor])
                .text(@"-")
                .textAlignment(NSTextAlignmentLeft)
                .font(kFont(14))
                .addIntoView(imageView);
            }];
            
            [self.enterTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(imageView);
                make.width.mas_equalTo(enterTitleLabelWidth);
                make.right.equalTo(imageView).offset(-enterTitleLabelRightMargin);
                make.height.mas_equalTo(20);
            }];
            
            [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.centerY.equalTo(imageView);
                make.left.equalTo(imageView).offset(nickNameLabelLeftMargin);
                make.right.equalTo(self.enterTitleLabel.mas_left).offset(-nickNameLabelRightMargin);
                make.height.mas_equalTo(20);
                
            }];
            
            imageView.alpha  = 0;
            imageView.hidden = YES;
            
            imageView;
        });
        [_enterIntoAnimationImageView removeFromSuperview];
        [kWindow addSubview:_enterIntoAnimationImageView];
    }
    
    return _enterIntoAnimationImageView;
    
}


@end

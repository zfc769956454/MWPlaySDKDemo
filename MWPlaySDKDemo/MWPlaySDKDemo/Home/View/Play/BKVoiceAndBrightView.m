//
//  BKVoiceAndBrightView.m
//  MontnetsLiveKing
//
//  Created by 谢敏 on 2018/5/31.
//  Copyright © 2018年 facebac.com. All rights reserved.
//

#import "BKVoiceAndBrightView.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "MWPlayViewController.h"

typedef NS_ENUM(NSUInteger, gestureDirection) {
    gestureDirectionLeftOrRight,
    gestureDirectionUpOrDown,
    gestureDirectionNone
};

@interface BKVoiceAndBrightView ()<UIGestureRecognizerDelegate>

@property (nonatomic,strong) UIView *leftBrightView;
@property (nonatomic,strong) UIView *rightVoiceView;

@property (nonatomic,assign) CGPoint startPoint;
@property (nonatomic,assign) CGFloat original;
@property (nonatomic,strong) MPVolumeView *volumeView;//控制音量的view
@property (nonatomic,strong) UISlider* volumeViewSlider;//控制音量
@property (nonatomic,assign) gestureDirection direction;
@property (nonatomic,assign) CGFloat startVB;

@end

@implementation BKVoiceAndBrightView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kClearColor;
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
        panGesture.delegate = self;
        [self addGestureRecognizer:panGesture];
        
        self.volumeView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width * 9.0 / 16.0);
    }
    return self;
}

- (void)panGesture:(UIPanGestureRecognizer*)sender{
    CGPoint point = [sender locationInView:sender.view];
    CGPoint velocity = [sender velocityInView:sender.view];
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:{
            //记录首次触摸坐标
            _startPoint = point;
            //检测用户是触摸屏幕的左边还是右边，以此判断用户是要调节音量还是亮度，左边是亮度，右边是音量
            if (_startPoint.x <= self.frame.size.width / 2.0) {
                //亮度
                self.startVB = [UIScreen mainScreen].brightness;
            } else {
                //音量
                self.startVB = self.volumeViewSlider.value;
            }
            //方向置为无
            self.direction = gestureDirectionNone;
            //分析出用户滑动的方向
            CGPoint velocity = [sender velocityInView:sender.view];
            BOOL isVerticalGesture = fabs(velocity.y) > fabs(velocity.x);
            if (isVerticalGesture) {
                self.direction = gestureDirectionUpOrDown;
            }else {
                self.direction = gestureDirectionLeftOrRight;
            }
            break;
        }
        case UIGestureRecognizerStateChanged:{
            //得出手指移动的距离
            CGPoint panPoint = CGPointMake(point.x - self.startPoint.x, point.y - self.startPoint.y);
            if (self.direction == gestureDirectionNone) {
                return;
            } else if (self.direction == gestureDirectionUpOrDown) {
                
                if (self.isOnlyProgress) {
                    return;
                }
                //音量和亮度
                if (self.startPoint.x <= self.frame.size.width / 2.0) {
                    //调节亮度
                    if (panPoint.y < 0) {
                        //增加亮度
                        [[UIScreen mainScreen] setBrightness:self.startVB + (-panPoint.y / 30.0 / 10)];
                    } else {
                        //减少亮度
                        [[UIScreen mainScreen] setBrightness:self.startVB - (panPoint.y / 30.0 / 10)];
                    }

                } else {
                    //音量
                    if (panPoint.y < 0) {
                        //增大音量
                        [self.volumeViewSlider setValue:self.startVB + (-panPoint.y / 30.0 / 10) animated:YES];

                    } else {
                        //减少音量
                        [self.volumeViewSlider setValue:self.startVB - (panPoint.y / 30.0 / 10) animated:YES];
                    }
                }
            } else if (self.direction == gestureDirectionLeftOrRight ) {
                //进度
                CGFloat factor = 0.0;
                CGFloat len = kScreenWidth;
                if(len<=0) len = 600;
                factor = [self getMovieDuration]/180;
                if(factor < 1.0) factor = 1.0;
                CGFloat temp = velocity.x*2*factor /len;
                if (temp<=0) {
                    if (temp>-1) {
                        temp=-1;
                    }
                }else {
                    if (temp<1) {
                        temp = 1;
                    }
                }
                [sender setTranslation:CGPointZero inView:sender.view];
                if (self.draggingBlock) {
                    self.draggingBlock(NO,temp);
                }
            }
            break;
        }
        
        case UIGestureRecognizerStateEnded:{
            if (self.draggingBlock) {
                self.draggingBlock(YES,0);
            }
            break;
        }
        default:
            break;
    }
}

-(GLfloat)getMovieDuration
{
    return [[self viewController] playerItemDuration];
}
    
- (MPVolumeView *)volumeView {
    if (!_volumeView) {
        _volumeView  = [[MPVolumeView alloc] init];
        [_volumeView sizeToFit];
        for (UIView *view in [_volumeView subviews]){
            if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
                self.volumeViewSlider = (UISlider*)view;
                break;
            }
        }
    }
    return _volumeView;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if([touch.view isKindOfClass:[UISlider class]]){
        return NO;
    }else{
        return YES;
    }
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

@end

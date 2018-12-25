//
//  BKDefinitionChooseView.m
//  MontnetsLiveKing
//
//  Created by mac on 2018/6/14.
//  Copyright © 2018年 facebac.com. All rights reserved.
//

#import "BKDefinitionChooseView.h"


#define minWH      (MIN(kScreenWidth, kScreenHeight))
#define leftMargin (31.5  * minWH/375)
#define topMargin  (112.5 * minWH/375)
#define bottomW    160
#define bottomH    80

@interface BKDefinitionChooseView ()

/**清晰度数组*/
@property (nonatomic, copy)    NSArray *definitionButtons;

/**当前播放清晰度*/
@property (nonatomic, assign)  NSInteger currentChooseIndex;

/**当前播放方向*/
@property (nonatomic, assign)  PlayDirection playDirection;

/**底部试图*/
@property (strong, nonatomic) UIView *bottomView;

/**记录上一次点击按钮*/
@property (strong, nonatomic) UIButton *lastClickButton;

@end


//BKDefinitionChooseView *chooseView = [[BKDefinitionChooseView alloc]initWithFrame:[UIScreen mainScreen].bounds buttons:@[@"原画",@"超清",@"高清",@"标清"] currentChooseIndex:1 playDirection:PlayDirectionVertical];
//[chooseView show:kWindow];


@implementation BKDefinitionChooseView

- (instancetype)initWithFrame:(CGRect)frame
                      buttons:(NSArray *)definitionButtons
           currentChooseIndex:(NSInteger)currentChooseIndex
                playDirection:(PlayDirection)playDirection{
    
    if(self=[super initWithFrame:frame]){
        
        self.clipsToBounds   = YES;
        self.backgroundColor = [UIColor clearColor];
        
        _definitionButtons   = definitionButtons;
        _currentChooseIndex  = currentChooseIndex;
        _playDirection       = playDirection;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeSelf)];
        [self addGestureRecognizer:tap];
        
        [self addSubview:self.bottomView];
        [self createDefinitionButtons];
        
        [kNotificationCenter addObserver:self selector:@selector(deviceOrientationChange) name:UIDeviceOrientationDidChangeNotification object:nil];
        
    }
    return self;
    
}


#pragma mark - notification
- (void)deviceOrientationChange{
    [self removeSelf];
}


#pragma mark - action

- (void)removeSelf{
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        if(self.playDirection == PlayDirectionHorizontal){
            
            self.bottomView.mj_x = kScreenWidth;
        }else{
            
            self.bottomView.mj_y = kScreenHeight ;
        }
        
    } completion:^(BOOL finished) {
//         [self removeFromSuperview];
        
        self.hidden = YES;
    }];
}


- (void)show:(UIView *)view {
    
    [view addSubview:self];
    
    self.hidden = NO;

    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        if(self.playDirection == PlayDirectionHorizontal){
      
            self.bottomView.mj_x = kScreenWidth - bottomW;
        }else{
            
            self.bottomView.mj_y = kScreenHeight - bottomH;
        }
        
    } completion:nil];
    
}


#pragma mark - gestureRecognizerdeleagte
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    }else if ([touch.view isDescendantOfView:_bottomView]){
        return NO;
    }
    return YES;
}


#pragma mark - layoutUI
- (void)createDefinitionButtons{
    
    [_definitionButtons enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGFloat btnW = (kScreenWidth - leftMargin * minWH *2/375)/_definitionButtons.count;
        CGFloat btnX = leftMargin  + btnW * idx;
        CGFloat btnY = 0;
        CGFloat btnH = self.bottomView.mj_h;
        if(self.playDirection == PlayDirectionHorizontal) {
            btnW = self.bottomView.mj_w;
            btnX = 0;
            btnH = (kScreenHeight - topMargin * minWH *2 /375)/self.definitionButtons.count;
            btnY = topMargin + btnH * idx;
        }
        NSLog(@"btnY:%f",btnY);
        
        
        UIButton *createButton = [UIButton ZFC_ButtonChainedCreater:^(ZFC_ButtonChainedCreater *creater) {
             creater.backgroundColor([UIColor clearColor])
            .frame(CGRectMake(btnX, btnY, btnW, btnH))
            .title(title, UIControlStateNormal)
            .titleColor([UIColor whiteColor], UIControlStateNormal)
            .titleColor([UIColor colorWithHexString:@"#2B94FF"], UIControlStateSelected)
            .titleLabelFont(kFont(14))
            .tag(idx)
            .actionBlock(^(UIButton *button){
    
                if (button == self.lastClickButton) {
                    return;
                }
                
                self.lastClickButton.selected = NO;
                button.selected = !button.selected;
                self.lastClickButton = button;
                
                [self removeSelf];

                if(self.definitionButtonActionBlock){
                    self.definitionButtonActionBlock(button.titleLabel.text,button.tag);
                }
            })
            .addIntoView(self.bottomView);
        }];
        
        if(idx == self.currentChooseIndex){
            createButton.selected = YES;
            self.lastClickButton = createButton;
        }
       
    }];
    
}


- (UIView *)bottomView{
    
    if(_bottomView == nil){
        
        _bottomView = ({
            
            CGFloat viewX = 0;
            CGFloat viewY = kScreenHeight;
            CGFloat viewW = kScreenWidth;
            CGFloat viewH = bottomH;
            if(_playDirection == PlayDirectionHorizontal){
                viewX = kScreenWidth;
                viewY = 0;
                viewW = bottomW;
                viewH = kScreenHeight;
            }
            
            UIView *view = [UIButton ZFC_ButtonChainedCreater:^(ZFC_ButtonChainedCreater *creater) {
                creater.backgroundColor([[UIColor blackColor]colorWithAlphaComponent:0.85])
                .frame(CGRectMake(viewX, viewY, viewW, viewH))
                .addIntoView(self);
            }];
            view;
            
        });
        
    }
    return _bottomView;
}

- (void)resetDefinitions:(NSArray *)definitionButtons currentChooseIndex:(NSInteger)currentChooseIndex{
    
    _definitionButtons   = definitionButtons;
    _currentChooseIndex  = currentChooseIndex;
    
    //[self.bottomView removeAllSubviews];//先移除之前的
    [self createDefinitionButtons];//再重新设置清晰度
}

@end

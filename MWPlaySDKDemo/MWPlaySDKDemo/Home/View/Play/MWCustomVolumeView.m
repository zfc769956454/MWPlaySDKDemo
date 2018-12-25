//
//  MWCustomVolumeView.m
//  MWPlaySDKDemo
//
//  Created by mac on 2018/12/11.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "MWCustomVolumeView.h"

@interface  MWCustomVolumeView()

@property(nonatomic,weak)UIButton *MPButton;

@end


@implementation MWCustomVolumeView

- (instancetype)init{
    if(self = [self initWithFrame:CGRectZero]){
        self.backgroundColor = [UIColor clearColor];
        self.showsVolumeSlider = NO;
        self.tag = 1;
        [self initMPButton];
    }
    return self;
}
//这个的目的是在AirPlay没有任何设备时也能呼出Picker使用
- (void)initMPButton{
    UIButton *button = nil;
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            button = (UIButton *)subView;
            break;
        }
    }
    [button setImage:nil forState:UIControlStateNormal];
    [button setImage:nil forState:UIControlStateHighlighted];
    [button setImage:nil forState:UIControlStateSelected];
    [button setBounds:CGRectZero];
    self.MPButton = button;
}

//在自定义按钮的按下事件中发送给MPButton
//此处sparkVolumView为一个SparkMPVolumnView实例
-(void)airPlayButtonAction:(UIButton *)sender{
    [self.MPButton sendActionsForControlEvents:UIControlEventTouchUpInside];
}



@end

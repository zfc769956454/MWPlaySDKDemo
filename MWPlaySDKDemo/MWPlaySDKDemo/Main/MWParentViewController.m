//
//  BKParentViewController.m
//  MontnetsLiveKing
//
//  Created by 富成赵 on 2018/3/24.
//  Copyright © 2018年 facebac.com. All rights reserved.
//

#import "MWParentViewController.h"


@interface MWParentViewController ()

@end

@implementation MWParentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
}

//不支持转屏的页面
-(BOOL)shouldAutorotate{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskPortrait;
}

//Presentation推出支持的屏幕旋转
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    
    return UIInterfaceOrientationPortrait;
}


@end

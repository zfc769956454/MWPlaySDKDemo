//
//  MWNavigationController.m
//  MWPlaySDKDemo
//
//  Created by mac on 2018/11/23.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "MWNavigationController.h"

@interface MWNavigationController ()

@end

@implementation MWNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
  
}



//注意关联Main.storyboard中的class
//支持旋转
-(BOOL)shouldAutorotate{
    return [[self.viewControllers lastObject] shouldAutorotate];
}

//支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return [[self.viewControllers lastObject] supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return [[self.viewControllers lastObject] preferredInterfaceOrientationForPresentation];
}

@end

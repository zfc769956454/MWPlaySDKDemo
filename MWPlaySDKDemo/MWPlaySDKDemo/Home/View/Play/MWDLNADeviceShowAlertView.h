//
//  MWDLNADeviceShowAlertView.h
//  MWPlaySDKDemo
//
//  Created by mac on 2018/12/17.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MRDLNA/MRDLNA.h>

@protocol MWDLNADeviceShowAlertViewDelegate <NSObject>

- (void)DLNAStartPlay:(CLUPnPDevice *)device; //去投屏

@end


@interface MWDLNADeviceShowAlertView : UIView

@property (nonatomic,weak) id<MWDLNADeviceShowAlertViewDelegate>delegate;


//显示
- (void)showWithDevices:(NSArray *)array;

//移除
- (void)removeSelf;

@end



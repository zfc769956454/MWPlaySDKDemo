//
//  BKFlowAlertView.h
//  MontnetsLiveKing
//
//  Created by chendb on 2017/9/25.
//  Copyright © 2017年 facebac.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BKFlowAlertView : UIView

@property (nonatomic, assign) NSInteger activeTimer;

@property (nonatomic, copy) NSString    *redEnvolpeUrl;

@property (nonatomic ,copy) void (^clickGardRedEnvelopeBlock)(NSString *redEnvolpeUrl);

@property (nonatomic ,copy) void (^countDownEndBlock)();

- (void)releaseFlowAlertView;

@end

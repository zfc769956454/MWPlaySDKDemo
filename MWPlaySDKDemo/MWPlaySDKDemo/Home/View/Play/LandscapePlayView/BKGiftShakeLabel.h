//
//  BKGiftShakeLabel.h
//  MontnetsLiveKing
//
//  Created by chendb on 2017/10/30.
//  Copyright © 2017年 facebac.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^completeBlock)(BOOL finished);

@interface BKGiftShakeLabel : UILabel

// 动画时间
@property (nonatomic,assign) NSTimeInterval duration;

// 描边颜色
@property (nonatomic,strong) UIColor *borderColor;

@property (nonatomic,assign,getter=isFinished) BOOL finished;

- (void)startAnimWithDuration:(NSTimeInterval)duration compelete:(completeBlock)compelete;

@end

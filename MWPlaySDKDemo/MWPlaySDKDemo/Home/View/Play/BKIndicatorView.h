//
//  BKIndicatorView.h
//  BaiKeMiJiaLive
//
//  Created by NegHao on 16/9/5.
//  Copyright © 2016年 facebac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BKIndicatorType){
    IndicatorTypeBounceSpot,
    
};


@interface BKIndicatorView : UIView
@property BOOL isAnimating;

/**
 *  初始化提示视图
 *
 *  @param type  提示类型
 *  @param color view颜色
 */
- (instancetype)initWithType:(BKIndicatorType)type tintColor:(UIColor *)color;


/**
 *  初始化提示视图
 *
 *  @param type  提示类型
 *  @param color view颜色
 *  @param size  大小
 */
- (instancetype)initWithType:(BKIndicatorType)type tintColor:(UIColor *)color size:(CGSize)size;


/**
 *  开始动画
 */
- (void)startAnimating;


/**
 *  结束动画
 */
- (void)stopAnimating;

@end

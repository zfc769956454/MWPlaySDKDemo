//
//  UIView+MWChangeFrame.h
//  MWPlaySDKDemo
//
//  Created by mac on 2018/11/21.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (MWChangeFrame)

@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;

@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;


@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize size;

@end

NS_ASSUME_NONNULL_END

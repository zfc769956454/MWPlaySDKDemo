//
//  BKBarrageMoveView.h
//  BaiKeMiJiaLive
//
//  Created by NegHao on 2016/12/27.
//  Copyright © 2016年 facebac.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define BarrageViewHeight  20

@class BKBarrageModel;
@interface BKBarrageMoveView : UIView
@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, assign) BOOL previousIsShow;
@property (nonatomic, assign) NSInteger selfYposition;
@property (nonatomic, assign) NSInteger index;

- (void)setContentModel:(BKBarrageModel *)model;
//过场动画，根据长度计算时间
- (void)grounderAnimation:(id)model;

//固定高度求文字长度
+ (CGFloat)calculateMsgWidth:(NSString *)msg andWithLabelFont:(UIFont*)font andWithHeight:(NSInteger)height;
@end

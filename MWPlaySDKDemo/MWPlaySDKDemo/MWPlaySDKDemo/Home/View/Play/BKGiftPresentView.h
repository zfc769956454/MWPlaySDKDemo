//
//  BKGiftPresentView.h
//  MontnetsLiveKing
//
//  Created by chendb on 2017/10/30.
//  Copyright © 2017年 facebac.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BKGiftEffectModel.h"
#import "BKGiftShakeLabel.h"

@protocol BKGiftPresentViewDelegate <NSObject>

- (void)clickHeadImageWithUserID:(NSString*)userID;

@end


@interface BKGiftPresentView : UIView

@property (nonatomic, weak) id<BKGiftPresentViewDelegate> delegate;

@property (nonatomic, strong) BKGiftEffectModel  *giftModel;
@property (nonatomic,strong) UIImageView *headImageView; // 头像
@property (nonatomic,strong) UIImageView *giftImageView; // 礼物
@property (nonatomic,strong) UILabel *nameLabel; // 送礼物者
@property (nonatomic,strong) UILabel *giftLabel; // 礼物名称
@property (nonatomic,assign) NSInteger giftCount; // 礼物个数
@property (nonatomic,assign) NSInteger animCount; // 动画执行到了第几次
@property (nonatomic,assign) CGRect originFrame; // 记录原始坐标
@property (nonatomic,assign,getter=isFinished) BOOL finished;

- (void)animateWithCompleteBlock:(completeBlock)completed;

- (void)continuePresentFlowersComplete:(completeBlock)completed;

- (void)continuePresentFlowers;

@end

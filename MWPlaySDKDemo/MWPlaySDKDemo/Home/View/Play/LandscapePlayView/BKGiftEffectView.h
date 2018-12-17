//
//  BKGiftEffectView.h
//  MontnetsLiveKing
//
//  Created by chendb on 2017/10/27.
//  Copyright © 2017年 facebac.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BKGiftEffectModel.h"
#import "BKGiftEffectOperation.h"


@protocol BKGiftEffectViewDelegate <NSObject>

- (void)showGiftSenderInfoWithID:(NSString*)userID;

@end

@interface BKGiftEffectView : UIView

@property (nonatomic, weak) id<BKGiftEffectViewDelegate> delegate;

@property (nonatomic, assign) NSInteger     giftLineNum;    //小礼物显示行数


- (void)displayGiftAnimationEffectWithModel:(BKGiftEffectModel *)effectModel;

- (void)cancelEffectOperation;

- (void)releaseEffcetView;

@end

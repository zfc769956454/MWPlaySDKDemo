//
//  BKGiftEffectOperation.h
//  MontnetsLiveKing
//
//  Created by chendb on 2017/10/30.
//  Copyright © 2017年 facebac.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BKGiftEffectModel.h"
#import "BKGiftPresentView.h"

#define GiftBoxHeight   40      //礼物弹框高度
#define GiftBoxSpace    10      //礼物间的间隔

@interface BKGiftEffectOperation : NSOperation

@property (nonatomic, assign) NSInteger  linenumber;      //小礼物显示弹出框行数

@property (nonatomic, assign) NSInteger  linecount;       //小礼物弹框显示第几行

@property (nonatomic, strong) BKGiftEffectModel *effectModel;

@property (nonatomic, assign) NSInteger   giftcount;    //礼物个数

//@property (nonatomic,strong) NSString *senderID;

//@property (nonatomic,assign) int       giftID;

@property (nonatomic, strong)   BKGiftPresentView   *presentView;

@property (nonatomic, weak  ) UIView *listView;

- (void)cancelOperation;

@end

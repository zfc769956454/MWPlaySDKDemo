//
//  BKGiftEffectModel.h
//  MontnetsLiveKing
//
//  Created by chendb on 2017/10/27.
//  Copyright © 2017年 facebac.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BKGiftEffectModel : NSObject

@property (nonatomic , strong) NSString *amount;
@property (nonatomic , strong) NSString *giftCount;
@property (nonatomic , assign) int      giftID;
@property (nonatomic , strong) NSString *giftName;
@property (nonatomic , strong) NSString *giftImg;

@property (nonatomic,strong) UIImage *headImage; //头像
@property (nonatomic,strong) UIImage *giftImage; //礼物
@property (nonatomic, copy) NSString *sendName; //送礼物者
@property (nonatomic, copy) NSString *sendUserID;
@property (nonatomic, copy) NSString *receiveUserImgUrl;

@property (nonatomic,strong) NSMutableDictionary *userGifts;

+ (BKGiftEffectModel *)shareEffectModel;


@end

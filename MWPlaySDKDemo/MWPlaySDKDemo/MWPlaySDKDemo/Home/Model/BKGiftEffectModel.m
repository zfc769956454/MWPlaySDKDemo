//
//  BKGiftEffectModel.m
//  MontnetsLiveKing
//
//  Created by chendb on 2017/10/27.
//  Copyright © 2017年 facebac.com. All rights reserved.
//

#import "BKGiftEffectModel.h"

@interface BKGiftEffectModel ()

@end

static BKGiftEffectModel *giftEffectModel = nil;

@implementation BKGiftEffectModel

- (instancetype)init{
    self = [super init];
    if (self) {
        _userGifts = [[NSMutableDictionary alloc]init];
    }
    return self;
}

+ (BKGiftEffectModel *)shareEffectModel{
    if (giftEffectModel == nil) {
        giftEffectModel = [[BKGiftEffectModel alloc]init];
    }
    return giftEffectModel;
}

@end

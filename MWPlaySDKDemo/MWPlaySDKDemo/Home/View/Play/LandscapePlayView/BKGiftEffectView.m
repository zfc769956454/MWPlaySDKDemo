//
//  BKGiftEffectView.m
//  MontnetsLiveKing
//
//  Created by chendb on 2017/10/27.
//  Copyright © 2017年 facebac.com. All rights reserved.
//

#import "BKGiftEffectView.h"

@interface BKGiftEffectView ()<BKGiftPresentViewDelegate>
{
    int      giftShowOrder;
}
@property (nonatomic, strong) NSOperationQueue     *animationQueue;// 全局动画队列

@property (nonatomic, strong) NSMutableDictionary  *giftUers;

@property (nonatomic, strong) BKGiftEffectOperation *lastOperation;

@end

@implementation BKGiftEffectView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = NO;
        
    }
    return self;
}

- (void)displayGiftAnimationEffectWithModel:(BKGiftEffectModel *)effectModel{
    
    NSString *userID = [NSString stringWithFormat:@"%@%d",effectModel.sendUserID,effectModel.giftID];
    self.giftUers = [BKGiftEffectModel shareEffectModel].userGifts;
    __block __typeof(self) weakself = self;
    __block BKGiftEffectOperation *lastOperation = [self.giftUers objectForKey:userID];
    lastOperation.presentView.delegate = self;
    //        8800b11a1d4a90c42
    if (lastOperation) {
        if (!lastOperation.finished) {
            [lastOperation.presentView continuePresentFlowers];
        }
        
        [lastOperation.presentView continuePresentFlowersComplete:^(BOOL finished) {
            [lastOperation cancelOperation];
            [lastOperation cancel];
            [weakself.giftUers removeObjectForKey:userID];
            [[BKGiftEffectModel shareEffectModel].userGifts removeObjectForKey:userID];
            lastOperation = nil;
            [BKGiftEffectModel shareEffectModel].userGifts = self.giftUers;
        }];
        
    }else{
        BKGiftEffectOperation *op = [[BKGiftEffectOperation alloc] init]; // 初始化操作
        op.presentView.delegate = self;
        op.linecount = giftShowOrder; // 设置操作的 index
        op.linenumber = 2;
        if (giftShowOrder != (_giftLineNum - 1)) {
            giftShowOrder ++;
        }else{
            giftShowOrder = 0;
        }
        op.listView = self;
        op.effectModel = effectModel;
        [self.giftUers setObject:op forKey:userID];
        _lastOperation = _lastOperation ? op : _lastOperation;
        [self.animationQueue addOperation:op];
        [BKGiftEffectModel shareEffectModel].userGifts = self.giftUers;
    }
}

- (NSOperationQueue *)animationQueue{
    if (_animationQueue == nil) {
        _animationQueue = [[NSOperationQueue alloc] init];
        _animationQueue.maxConcurrentOperationCount = _giftLineNum; // 队列分发
    }
    return _animationQueue;
}

- (void)cancelEffectOperation{
    [_animationQueue cancelAllOperations];
}

- (void)releaseEffcetView{
    NSArray *keyArr = [self.giftUers allKeys];
    for (NSString *key in keyArr) {
        BKGiftEffectOperation *operation = [self.giftUers objectForKey:key];
        [operation cancel];
    }
    [self.giftUers removeAllObjects];
    [_animationQueue cancelAllOperations];
}

- (void)clickHeadImageWithUserID:(NSString *)userID{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(showGiftSenderInfoWithID:)]) {
        
        [self.delegate showGiftSenderInfoWithID:userID];
    }
}

@end

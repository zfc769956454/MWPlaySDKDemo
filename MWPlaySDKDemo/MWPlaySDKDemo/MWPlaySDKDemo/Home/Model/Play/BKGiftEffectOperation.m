//
//  BKGiftEffectOperation.m
//  MontnetsLiveKing
//
//  Created by chendb on 2017/10/30.
//  Copyright © 2017年 facebac.com. All rights reserved.
//

#import "BKGiftEffectOperation.h"

@interface BKGiftEffectOperation ()

@property (nonatomic, getter=isFinished)  BOOL finished;

@property (nonatomic, getter=isExecuting) BOOL executing;

@end

@implementation BKGiftEffectOperation

@synthesize finished = _finished;
@synthesize executing = _executing;

- (BKGiftPresentView *)presentView{
    if (!_presentView) {
        _presentView = [[BKGiftPresentView alloc]init];
    }
    return _presentView;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _executing = NO;
        _finished  = NO;
    }
    return self;
}

- (void)setEffectModel:(BKGiftEffectModel *)effectModel{
    _effectModel = effectModel;
    self.presentView.giftModel = effectModel;
}

- (void)start{
    
    if ([self isCancelled]) {
        self.finished = YES;
        return;
    }
    self.executing = YES;
    __block kWeakSelf(self)
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        CGFloat presentH = GiftBoxHeight;
        CGFloat coverY = GiftBoxHeight + GiftBoxSpace * 2;
        CGFloat space  = GiftBoxHeight + GiftBoxSpace;

        CGFloat presentW = presentH + 185;
        // index ％ 2 控制最多允许出现几行
        CGFloat y = coverY - (_linecount % _linenumber) * space;
        for (UIView *view in [_listView subviews]) {
            CGFloat viewY = view.frame.origin.y;
            if (y == viewY) {
                _linecount = _linecount + 1;
                y = coverY - (_linecount % _linenumber) * space;
            }
        }
        
        weakself.presentView.frame = CGRectMake(-weakself.listView.frame.size.width / 2, y, presentW, presentH);
        weakself.presentView.originFrame = weakself.presentView.frame;
        [weakself.listView addSubview:weakself.presentView];
        [weakself.presentView sendSubviewToBack:weakself.listView];
        
        [weakself.presentView animateWithCompleteBlock:^(BOOL finished) {
            [[BKGiftEffectModel shareEffectModel].userGifts removeObjectForKey:[NSString stringWithFormat:@"%@%d",_effectModel.sendUserID,_effectModel.giftID]];
            weakself.finished = finished;
        }];
        
    }];
}

#pragma mark -  手动触发 KVO
- (void)setExecuting:(BOOL)executing
{
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)setFinished:(BOOL)finished
{
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
    
}

- (void)cancel{
    [super cancel];
}
- (void)cancelOperation{
    self.finished = YES;
}

@end

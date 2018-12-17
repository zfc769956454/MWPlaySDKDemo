//
//  BKBarrageView.m
//  BaiKeMiJiaLive
//
//  Created by NegHao on 2016/12/27.
//  Copyright © 2016年 facebac.com. All rights reserved.
//

#import "BKBarrageView.h"
#import "BKBarrageMoveView.h"
#import "BKBarrageProtocol.h"

@interface BKBarrageView ()<BKBarrageProtocol>
{
    NSMutableArray *grounderArray;
    NSMutableArray *modelArray;
    NSInteger grounderCount;
    int       postionCount;
}

@end

@implementation BKBarrageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        grounderArray = [[NSMutableArray alloc] init];
        modelArray = [[NSMutableArray alloc] init];
        grounderCount = 0;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nextView:) name:@"nextView" object:nil];
        postionCount = self.height / (BarrageViewHeight);
        for (int i = 0; i < postionCount; i++) {
            BKBarrageMoveView *grounder = [[BKBarrageMoveView alloc] init];
            grounder.isShow = NO;
            grounder.index = i;
            [grounderArray addObject:grounder];
        }
    }
    return self;
}

- (void)setBarrageConcentWithModel:(id<BKBarrageProtocol>)obj headImage:(UIImage *)headImage{
    
    [modelArray addObject:obj.barrageModel];
    
}

- (void)setContentModel:(BKBarrageModel *)model{
    [modelArray addObject:model];
    [self checkView];
}

- (void)nextView:(NSNotification *)notification{

    [self checkView];
}

- (void)checkView{
    if (modelArray.count == 0) {
        return;
    }
    
    __weak BKBarrageView *this = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        for (BKBarrageMoveView *view in grounderArray) {
            if (view.isShow == NO) {
                view.selfYposition = view.index * (BarrageViewHeight + 5) + 35;
                view.isShow = YES;
                if (modelArray.count > 0) {
                    [view setContentModel:modelArray[0]];
                    [this addSubview:view];
                    [view grounderAnimation:modelArray[0]];
                    [modelArray removeObjectAtIndex:0];
                }
                break;
            }
        }
    });
}

- (void)dealloc{

    [kNotificationCenter removeObserver:self];
}

@end

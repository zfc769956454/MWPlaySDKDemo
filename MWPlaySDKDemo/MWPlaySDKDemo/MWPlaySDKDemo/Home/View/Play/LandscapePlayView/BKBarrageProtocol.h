//
//  BKBarrageProtocol.h
//  BaiKeMiJiaLive
//
//  Created by NegHao on 2016/12/27.
//  Copyright © 2016年 facebac.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BKBarrageModel.h"

@protocol BKBarrageProtocol <NSObject>

@optional
@property (nonatomic, copy) BKBarrageModel *barrageModel;
@property (nonatomic, copy) UIImage *headImage;

- (void)setBarrageConcentWithModel:(id<BKBarrageProtocol>)obj headImage:(UIImage *)headImage;

@end

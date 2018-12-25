//
//  MWScreenRecordingScrollView.m
//  MWPlaySDKDemo
//
//  Created by mac on 2018/12/5.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "MWPreventScreenRecordingScrollView.h"

@interface MWPreventScreenRecordingScrollView()

/**滚动的label*/
@property (nonatomic,strong)UILabel *scrollLabel;

@end


@implementation MWPreventScreenRecordingScrollView


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        [self layoutUI];
    }
    return self;
}


- (void)layoutUI {
    
    [self addSubview:self.scrollLabel];
    [self.scrollLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
}



- (void)beginScrollWithAnimation {

    CABasicAnimation *moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(kScreenWidth, self.mj_y)];
    moveAnimation.toValue   = [NSValue valueWithCGPoint:CGPointMake(-self.mj_w, self.mj_y)];
    moveAnimation.duration = 3.0;
    moveAnimation.removedOnCompletion = YES;
    moveAnimation.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:moveAnimation forKey:@"moveAnimation"];
    
}

- (void)stopScrollWithAnimation {
    
    [self.layer removeAllAnimations];
}


- (UILabel *)scrollLabel {
    
    if (_scrollLabel == nil) {
        
        _scrollLabel = ({
            
            UILabel *label = [UILabel ZFC_LabelChainedCreater:^(ZFC_LabelChainedCreater *creater) {
                creater.textColor([UIColor redColor])
                .font([UIFont systemFontOfSize:15])
                .textAlignment(NSTextAlignmentRight)
                .text(@"防录屏");
            }];
            
            label;
        });
    }
    return _scrollLabel;
}


@end

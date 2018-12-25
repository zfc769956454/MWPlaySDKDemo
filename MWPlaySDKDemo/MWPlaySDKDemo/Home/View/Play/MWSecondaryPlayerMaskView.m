//
//  MWSecondaryPlayerMaskView.m
//  MWPlaySDKDemo
//
//  Created by mac on 2018/11/29.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "MWSecondaryPlayerMaskView.h"

@interface MWSecondaryPlayerMaskView ()

@property (nonatomic,strong) UIImageView *endImageView;

@property (nonatomic,strong) UILabel *endTitleLabel;


@end

@implementation MWSecondaryPlayerMaskView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView == self) {
        return nil;
    }
    return hitView;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if(self=[super initWithFrame:frame]){
        
        self.clipsToBounds = YES;
        
        [self layoutUI];
    }
    return self;
}


- (void)layoutUI {
    
    [self addSubview:self.endImageView];
    [self addSubview:self.endTitleLabel];
    
    
    [self.endImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.endTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.centerY.equalTo(self);
        make.height.mas_equalTo(25);
    }];
    
}


- (UILabel *)endTitleLabel {
    
    if (_endTitleLabel == nil) {
        
        _endTitleLabel = [UILabel ZFC_LabelChainedCreater:^(ZFC_LabelChainedCreater *creater) {
            creater.text(@"已结束")
            .textAlignment(NSTextAlignmentCenter)
            .textColor([UIColor redColor])
            .font([UIFont systemFontOfSize:15]);
        }];
    }
    return _endTitleLabel;
}


- (UIImageView *)endImageView {
    
    if (_endImageView == nil) {
        
        _endImageView = [UIImageView new];
        _endImageView.image = [UIImage imageNamed:@"live_cover"];
        
    }
    return _endImageView;
}


@end

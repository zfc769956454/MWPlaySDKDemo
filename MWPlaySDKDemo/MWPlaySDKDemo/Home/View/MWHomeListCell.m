//
//  MWHomeListCell.m
//  MWPlaySDKDemo
//
//  Created by mac on 2018/11/27.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "MWHomeListCell.h"


@interface MWHomeListCell()

@property (nonatomic,strong)UIImageView *coverImageView;

@property (nonatomic,strong)UILabel *stateLabel;

@property (nonatomic,strong)UILabel *liveNameLabel;

@property (nonatomic,strong)UILabel *liveTimeLabel;


@end

@implementation MWHomeListCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self layoutUI];
    }
    return self;
}

- (void)layoutUI {
    [self.contentView addSubview:self.coverImageView];
    [self.contentView addSubview:self.liveTimeLabel];
    [self.contentView addSubview:self.liveNameLabel];
    [self.contentView addSubview:self.stateLabel];
    
    
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(10);
        make.width.height.mas_equalTo(60);
    }];
    
    [self.liveNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.coverImageView.mas_right).offset(10);
        make.top.equalTo(self.contentView).offset(15);
        make.width.mas_equalTo(180);
        make.height.mas_equalTo(25);
    }];
    
    [self.liveTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.liveNameLabel.mas_bottom).offset(12);
        make.left.width.height.equalTo(self.liveNameLabel);
    }];
    
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-10);
        make.top.top.equalTo(self.liveNameLabel);
        make.width.mas_equalTo(80);
    }];
    
}


- (void)setLiveListModel:(MWLiveListModel *)liveListModel {
    
    self.liveNameLabel.text = liveListModel.liveName;
    self.liveTimeLabel.text = liveListModel.planTime;
    if ([liveListModel.liveStatus integerValue] == 0) {
        self.stateLabel.text = @"预告";
    }else if ([liveListModel.liveStatus integerValue] == 1) {
        self.stateLabel.text = @"直播中";
    }else {
        self.stateLabel.text = @"直播结束";
    }
}



- (void)setVideoListModel:(MWVideoListModel *)videoListModel {
    
    self.liveNameLabel.text = videoListModel.videoName;
    self.liveTimeLabel.text = videoListModel.createTime;
    self.stateLabel.text = [NSString stringWithFormat:@"观看人数:%ld",videoListModel.totalViews];
}


- (UILabel *)liveTimeLabel{
    
    if (_liveTimeLabel == nil) {
        
        _liveTimeLabel = [UILabel ZFC_LabelChainedCreater:^(ZFC_LabelChainedCreater *creater) {
            
            creater.font([UIFont systemFontOfSize:15])
            .textAlignment(NSTextAlignmentLeft)
            .textColor([UIColor colorWithHexString:@"#666666"]);
            
        }];
        
    }
    return _liveTimeLabel;
}


- (UILabel *)liveNameLabel {
    
    if (_liveNameLabel == nil) {
        
        _liveNameLabel = [UILabel ZFC_LabelChainedCreater:^(ZFC_LabelChainedCreater *creater) {
            
            creater.font([UIFont systemFontOfSize:17])
            .textAlignment(NSTextAlignmentLeft)
            .textColor([UIColor colorWithHexString:@"#333333"]);
            
        }];
        
    }
    return _liveNameLabel;
}


- (UILabel *)stateLabel {
    
    if (_stateLabel == nil) {
        
        _stateLabel = [UILabel ZFC_LabelChainedCreater:^(ZFC_LabelChainedCreater *creater) {
            
            creater.font([UIFont systemFontOfSize:12])
            .textAlignment(NSTextAlignmentRight)
            .textColor([UIColor colorWithHexString:@"#999999"]);
            
        }];

    }
    return _stateLabel;
}


- (UIImageView *)coverImageView {
    
    if (_coverImageView == nil) {
        
        _coverImageView = [UIImageView ZFC_ImageViewChainedCreater:^(ZFC_ImageViewChainedCreater *creater) {
            creater.layerCornerRadius(3)
            .image([UIImage imageNamed:@"live_cover"]);
        }];
    }
    
    return _coverImageView;
}


@end

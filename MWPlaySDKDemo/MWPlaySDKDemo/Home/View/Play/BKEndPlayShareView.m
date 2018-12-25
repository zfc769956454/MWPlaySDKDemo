//
//  BKPlaybackShareView.m
//  MontnetsLiveKing
//
//  Created by lzp on 2018/1/23.
//  Copyright © 2018年 facebac.com. All rights reserved.
//

#import "BKEndPlayShareView.h"
#import "UIImage+BKExtension.h"

@interface BKEndPlayShareView()
@property(nonatomic)UIImageView *coverImageView;
@property(nonatomic)UIView *contentMaskView;
@property(nonatomic)UILabel *titleLabel;
@property(nonatomic)UILabel *shareTitle;
@property(nonatomic)UIButton *replayBtn;
@property(nonatomic,assign)CGSize btnSize;
@property(nonatomic,assign)CGFloat btnSpace;
@property(nonatomic,assign)CGFloat itemStartX;
@end

@implementation BKEndPlayShareView

- (instancetype)init{
    self = [super init];
    if(self){
        [self setupUI];
    }
    return self ;
}

#pragma mark -- UI

- (void)setupUI{
    [self addSubview:self.coverImageView];
    [self addSubview:self.contentMaskView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.shareTitle];
    [self addSubview:self.replayBtn];
    
    NSArray *array = [self createShareItem];
    
    self.btnSize = CGSizeMake(34, 34);
    self.btnSpace = 15.0 ;
    self.itemStartX = (MIN(kScreenWidth,kScreenHeight) - array.count * self.btnSize.width - (array.count + 1) * self.btnSpace) / 2.0 ;
    
    [self.coverImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    [self.contentMaskView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.shareTitle.mas_top).mas_offset(-15);
        make.centerX.mas_equalTo(self);
    }];
    [self.shareTitle mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.centerY.mas_equalTo(self).mas_offset(-5);
    }];
    [self.replayBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).mas_offset(-3);
        make.bottom.mas_equalTo(self).mas_offset(-3);
        make.size.mas_equalTo(CGSizeMake(65, 34));
    }];
    
    NSInteger index = 0 ;
    for(BKMoreViewItem *item in array){
        UIButton *btn = [self createBtnWithItem:item];
        [self addSubview:btn];
        [btn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.shareTitle.mas_bottom).mas_offset(5);
            make.left.mas_equalTo(self).mas_offset(self.itemStartX + index * (self.btnSize.width + self.btnSpace) + self.btnSpace);
            make.size.mas_equalTo(self.btnSize);
        }];
        index ++ ;
    }
}

#pragma mark -- 创建按钮

- (UIButton *)createBtnWithItem:(BKMoreViewItem *)item{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:item.iconName] forState:UIControlStateNormal];
    [btn setTag:item.itemType];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:10]];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor clearColor]];
    [btn addTarget:self action:@selector(itemBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    return btn ;
}

- (void)itemBtnClicked:(id)sender{
    UIButton *btn = (UIButton *)sender;
    if(self.delegate && [self.delegate respondsToSelector:@selector(shareContentWithType:)]){
        [self.delegate shareContentWithType:btn.tag];
    }
}

#pragma mark -- 创建分享项

- (NSArray<BKMoreViewItem *> *)createShareItem{
    BKMoreViewItem *item = [[BKMoreViewItem alloc]initWithType:KKMoreItemTypeWXFriend iconName:@"endShareIcWechat" title:@"微信"];
    BKMoreViewItem *item1 = [[BKMoreViewItem alloc]initWithType:KKMoreItemTypeWXTimesmp iconName:@"endShareIcMoments" title:@"朋友圈"];
    BKMoreViewItem *item2 = [[BKMoreViewItem alloc]initWithType:KKMoreItemTypeWeiBo iconName:@"endShareIcWeibo" title:@"微博"];
    BKMoreViewItem *item3 = [[BKMoreViewItem alloc]initWithType:KKMoreItemTypeQQ iconName:@"endShareIcQq" title:@"QQ"];
    BKMoreViewItem *item4 = [[BKMoreViewItem alloc]initWithType:KKMoreItemTypeQZone iconName:@"endShareIcQqSpace" title:@"QQ空间"];
    
   
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    
    [array addObjectsFromArray:@[item,item1]];
    
    [array addObject:item2];
    
    [array addObjectsFromArray:@[item3,item4]];
    
    return array;
}

#pragma mark -- 重播按钮点击

- (void)replayBtnClicked{
    if(self.delegate && [self.delegate respondsToSelector:@selector(replayVideo)]){
        [self.delegate replayVideo];
    }
}

#pragma mark -- @property setter

- (void)setShowReplayBtn:(BOOL)showReplayBtn{
    _showReplayBtn = showReplayBtn;
    _replayBtn.hidden = YES;

}

- (void)setCorverImage:(UIImage *)corverImage{
    if(!corverImage){
        corverImage = [UIImage imageNamed:@"livecoverdefault"];
    }
    self.coverImageView.image = [UIImage blurryImage:corverImage withBlurLevel:5];
}

#pragma mark -- @property getter

- (UIImageView *)coverImageView{
    if(!_coverImageView){
        _coverImageView = ({
            UIImageView *view = [UIImageView new];
            view.contentMode = UIViewContentModeScaleAspectFill;
            view.layer.masksToBounds = YES ;
            view ;
        });
    }
    return _coverImageView;
}

- (UIView *)contentMaskView{
    if(!_contentMaskView){
        _contentMaskView = ({
            UIView *view = [UIView new];
            view.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.7];
            view ;
        });
    }
    return _contentMaskView;
}

- (UILabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel = ({
            UILabel *view = [UILabel new];
            view.textAlignment = NSTextAlignmentCenter;
            view.textColor = [UIColor whiteColor];
            view.font = [UIFont systemFontOfSize:15];
            view.text = @"已结束";
            view;
        });
    }
    return _titleLabel;
}

- (UILabel *)shareTitle{
    if(!_shareTitle){
        _shareTitle = ({
            UILabel *view = [UILabel new];
            view.textAlignment = NSTextAlignmentCenter;
            view.textColor = [UIColor whiteColor];
            view.font = [UIFont systemFontOfSize:12];
            view.text = @"分享";
            view ;
        });
    }
    return _shareTitle;
}

- (UIButton *)replayBtn{
    if(!_replayBtn){
        _replayBtn = ({
            UIButton *view = [UIButton new];
            [view setImage:[UIImage imageNamed:@"timeShiftIcBack"] forState:UIControlStateNormal];
            [view setTitle:@"重播" forState:UIControlStateNormal];
            [view.titleLabel setFont:[UIFont systemFontOfSize:11]];
            [view addTarget:self action:@selector(replayBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            view ;
        });
    }
    return _replayBtn;
}

@end

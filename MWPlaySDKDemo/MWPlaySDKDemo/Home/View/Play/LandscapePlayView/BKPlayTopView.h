//
//  BKPlayTopView.h
//  MontnetsLiveKing
//
//  Created by chendb on 2017/10/31.
//  Copyright © 2017年 facebac.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BKPlayTopViewDelegate <NSObject>

- (void)eixtFullScreenPlayer:(UIButton *)button;

- (void)fullScreenSharePlay:(UIButton *)button;

- (void)clickUserHeadImage;

- (void)closeBarrageTopView:(UIButton *)sender;

- (void)showDefinitionView;

@end

@interface BKPlayTopView : UIView

@property (nonatomic, weak) id<BKPlayTopViewDelegate> delegate;

@property (nonatomic, strong) UIImageView   *coverImg;

@property (nonatomic, strong) UILabel       *titleLab;

@property (nonatomic, strong) UILabel       *numLabel;

@property (nonatomic, strong) UILabel       *totalLabel;

@property (nonatomic, copy) NSString        *definition;

@property (nonatomic, strong) UIButton      *definitionBtn;

@property (nonatomic, assign) BOOL      isLive;

-(instancetype)initWithFrame:(CGRect)frame isLive:(BOOL)isLive;

- (void)hideDefinitionBtn:(BOOL)hide;

@end

//
//  BKDefinitionChooseView.h
//  MontnetsLiveKing
//
//  Created by mac on 2018/6/14.
//  Copyright © 2018年 facebac.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PlayDirection)
{
    PlayDirectionHorizontal    = 0   , //横屏播放
    PlayDirectionVertical            , //竖屏播放
};

typedef void(^BK_definitionButtonActionBlock)(NSString *definition,NSInteger currentIndex);

@interface BKDefinitionChooseView : UIView

@property (nonatomic,copy)BK_definitionButtonActionBlock definitionButtonActionBlock;


/**
 @param frame frame
 @param definitionButtons  清晰度数组
 @param currentChooseIndex 当前播放选中的(注意：起始位置->0)
 @param playDirection 播放方向
 */
- (instancetype)initWithFrame:(CGRect)frame
                      buttons:(NSArray *)definitionButtons
           currentChooseIndex:(NSInteger)currentChooseIndex
                playDirection:(PlayDirection)playDirection;

- (void)show:(UIView *)view;

- (void)resetDefinitions:(NSArray *)definitionButtons currentChooseIndex:(NSInteger)currentChooseIndex;

@end

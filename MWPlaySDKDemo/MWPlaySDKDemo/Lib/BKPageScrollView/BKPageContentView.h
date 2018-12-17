//
//  ZJContentView.h
//  ZJScrollPageView
//
//  Created by jasnig on 16/5/6.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BKPageScrollPageViewDelegate.h"
#import "BKPageCollectionView.h"
#import "BKPageScrollSegmentView.h"
#import "UIViewController+BKPageScrollPageController.h"



@interface BKPageContentView : UIView

/** 必须设置代理和实现相关的方法*/
@property(weak, nonatomic)id<BKPageScrollPageViewDelegate> delegate;
@property (strong, nonatomic, readonly) BKPageCollectionView *collectionView;
// 当前控制器
@property (strong, nonatomic, readonly) UIViewController<ZJScrollPageViewChildVcDelegate> *currentChildVc;

/**初始化方法
 *
 */
- (instancetype)initWithFrame:(CGRect)frame segmentView:(BKPageScrollSegmentView *)segmentView parentViewController:(UIViewController *)parentViewController delegate:(id<BKPageScrollPageViewDelegate>) delegate;

/** 给外界可以设置ContentOffSet的方法 */
- (void)setContentOffSet:(CGPoint)offset animated:(BOOL)animated;
/** 给外界 重新加载内容的方法 */
- (void)reload;


@end

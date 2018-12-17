//
//  BKEndLiveCorverView.h
//  MontnetsLiveKing
//
//  Created by lzp on 2017/9/6.
//  Copyright © 2017年 facebac.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BKEndLiveCorverView : UIView
@property(nonatomic,assign)BOOL isEndLive;//是否是结束直播
@property(nonatomic,assign)NSInteger watchCount;
@property(nonatomic,assign)BOOL watchViewHidden;
@property(nonatomic,strong)UIImage *corverImage;
@property(nonatomic,assign)BOOL isReloadVideo;//是否是重新获取视频
@property(nonatomic,copy) void (^reloadBlock)(void);

- (void)onlyCover;//关闭网络，只显示封面

@end

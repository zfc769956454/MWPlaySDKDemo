//
//  BKPlaybackShareView.h
//  MontnetsLiveKing
//
//  Created by lzp on 2018/1/23.
//  Copyright © 2018年 facebac.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BKMoreViewItem.h"

@protocol BKEndPlayShareViewDelegate <NSObject>
@optional
- (void)replayVideo;
- (void)shareContentWithType:(NSInteger)type;
@end

@interface BKEndPlayShareView : UIView
@property(nonatomic,weak)id<BKEndPlayShareViewDelegate>delegate;
@property(nonatomic)UIImage *corverImage;
@property(nonatomic,assign)BOOL showReplayBtn;
@end

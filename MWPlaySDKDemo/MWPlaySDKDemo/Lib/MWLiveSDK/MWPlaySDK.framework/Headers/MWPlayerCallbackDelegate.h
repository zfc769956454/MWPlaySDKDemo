//
//  MWPlayerCallbackDelegate.h
//  MWPlaySDKDemo
//
//  Created by mac on 2018/11/26.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MWVideoPlayer;
@protocol MWPlayerCallbackDelegate <NSObject>

/**
 播放器播放状态的回调方法
 @param playerId (播放点播)会传nil
 @param code 播放器的状态
 @param player 当前播放器
 */
- (void)playerCallbackWithMessage:(id)playerId msgCode:(MWCallbackType)code player:(MWVideoPlayer *)player;

@end



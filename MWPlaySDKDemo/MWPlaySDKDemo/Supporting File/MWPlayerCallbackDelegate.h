//
//  MWPlayerCallbackDelegate.h
//  MWPlaySDKDemo
//
//  Created by mac on 2018/11/26.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MWMixPlayer;
@protocol MWPlayerCallbackDelegate <NSObject>

/**
 播放器播放状态的回调方法
 @param playerid (播放点播)会传nil
 @param code 回调的各种状态码
 @param player 把播放器本身回调出去
 */
- (void)playerCallbackWithMessage:(id)playerid msgCode:(MWCallbackType)code player:(MWMixPlayer *)player;

@end



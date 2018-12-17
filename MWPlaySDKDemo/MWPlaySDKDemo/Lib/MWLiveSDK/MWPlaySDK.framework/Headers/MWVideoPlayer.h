//
//  MWVideoPlayer.h
//  MWPlaySDKDemo
//
//  Created by mac on 2018/11/26.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "MWMixPlayer.h"

@interface MWVideoPlayer : MWMixPlayer

/**
 初始化方法
 @param frame     画面坐标、大小
 @param type      MWPlayerTypeRecord 播放点播，MWPlayerTypeLive 播放直播
 @param delegate  播放器回调代理
 @param response 回调block,成功success = YES msg:回调信息
 */
- (instancetype)initWithFrame:(CGRect)frame
                      andType:(MWPlayerType)type
                  andDelegate:(id<MWPlayerCallbackDelegate>)delegate
                     response:(void(^)(BOOL success,NSString *msg))response;


@end



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


/** 开始播放
 @param playURL 设置播放器的播放URL
 @param bufferTime 缓存时间，(播放点播)不支持该值
 @param offset 偏移时间，单位秒
 */
- (void)mw_start:(NSString *)playURL bufferTime:(NSInteger)bufferTime offset:(NSInteger)offset;


/** 暂停 */
- (void)mw_pause;

/** 暂停后恢复 */
- (void)mw_resume;

/** 停止播放 无法恢复
 要调用此方法 才能释放资源
 */
- (void)mw_stop;

/**
 进度调整到某个时间点
 value 单位秒
 */
- (void)mw_seekTo:(NSInteger)value;

/** 获取节目的时间长度，单位秒 */
- (CGFloat)mw_getDuration;

/** 获取当前播放的时间，单位秒 */
- (CGFloat)mw_getCurrentTime;

/** 获取已缓冲数据的时间长度，单位秒 */
- (CGFloat)mw_getBufferTime;

/**
 设置视频画面拉伸方式
 @param mode 拉伸方式
 @param redraw (播放点播)不支持该值
 */
- (void)mw_setVideoScale:(MWPlayerScaleModeType)mode redraw:(BOOL)redraw;

/**
 打印版本信息 (播放点播)此方法无效
 */
- (void)mw_printPlayerVer;

/**
 设置是否静音
 */
- (void)mw_setMute:(BOOL)isMute;


@end



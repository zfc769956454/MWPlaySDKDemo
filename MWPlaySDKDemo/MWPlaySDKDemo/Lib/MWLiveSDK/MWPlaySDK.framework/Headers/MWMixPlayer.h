//
//  MWMixPlayer.h
//  PlayerDemo
//
//  Created by LZJ on 2018/3/29.
//  Copyright © 2018年 LZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWPlayerEnumHeader.h"
#import "MWPlayerCallbackDelegate.h"


@interface MWMixPlayer : UIView


/** 开始播放
 @param playURL 设置播放器的播放URL
 @param bufferTime 缓存时间，(播放点播)不支持该值
 @param offset 偏移时间，单位秒
 */
- (void)start:(NSString *)playURL bufferTime:(NSInteger)bufferTime offset:(NSInteger)offset;


/** 暂停 */
- (void)pause;

/** 暂停后恢复 */
- (void)resume;

/** 停止播放 无法恢复
 要调用此方法 才能释放资源
 */
- (void)stop;

/**
 进度调整到某个时间点
 value 单位秒
 */
- (void)seekTo:(NSInteger)value;

/** 获取节目的时间总长度，单位秒 */
- (CGFloat)getDuration;

/** 获取当前播放的时间，单位秒 */
- (CGFloat)getCurrentTime;

/** 获取已缓冲数据的时间长度，单位秒 */
- (CGFloat)getBufferTime;

/**
 设置视频画面拉伸方式
 @param mode 拉伸方式
 @param redraw (播放点播)不支持该值
 */
- (void)setVideoScale:(MWPlayerScaleModeType)mode redraw:(BOOL)redraw;

/**
 打印版本信息 (播放点播)此方法无效
 */
- (void)printPlayerVer;

/**
 设置是否静音
 */
- (void)setMute:(BOOL)isMute;


@end

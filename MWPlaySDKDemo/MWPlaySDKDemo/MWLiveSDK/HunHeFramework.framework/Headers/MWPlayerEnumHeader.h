//
//  MWPlayerEnum.h
//  PlayerDemo
//
//  Created by LZJ on 2018/4/9.
//  Copyright © 2018年 LZJ. All rights reserved.
//

#ifndef MWPlayerEnumHeader_h
#define MWPlayerEnumHeader_h

#pragma mark - 枚举

/**
 * 播放器类型
 */
typedef enum : NSUInteger {
    MWPlayerTypeRecord = 0, //录像
    MWPlayerTypeLive   = 1  //直播
} MWPlayerType;


/**
 * 播放器回调状态
 */
typedef enum : NSUInteger {
    MWCallbackTypeOK              = 0,  //播放正常    (*播放录像没有此回调*）
    MWCallbackTypeOutOfMemory     = 1,  //内存不足    (*播放录像没有此回调*）
    MWCallbackTypeNoSourceDemux   = 2,  //无法处理播放地址
    MWCallbackTypeNoAudioCodec    = 3,  //无音频解码器 (*播放录像没有此回调*)
    MWCallbackTypeNoVideoCodec    = 4,  //无视频解码器 (*播放录像没有此回调*)
    
    MWCallbackTypeConnectServer   = 21, //正在连接服务器
    MWCallbackTypeNetworkError    = 22, //网络错误
    MWCallbackTypeMediaSpecError  = 23, //媒体格式错误 (*播放录像没有此回调*)
    MWCallbackTypeNoPlayObject    = 24, //无播放对象
    MWCallbackTypeNetTimeOut      = 25, //网络超时
    
    MWCallbackTypeOpenAVDevice    = 50, //(*播放录像没有此回调*)
    MWCallbackTypeNotifyMediaInfo = 51, //媒体信息获取完毕
    MWCallbackTypeStartBufferData = 52, //开始缓冲数据
    MWCallbackTypePrePlay         = 53, //即将开始播放
    MWCallbackTypeStartPlay       = 54, //开始播放
    MWCallbackTypePlayFinish      = 55, //播放完成
    MWCallbackTypeLiveBuffering   = 56  //直播缓冲中   (*播放录像没有此回调*)
} MWCallbackType;



/**
 * 视频屏幕拉伸方式
 */
typedef enum : NSUInteger {
    MWPlayerScaleModeTypeOriginal = 0, //播放直播->原视频大小，裁剪多余部分 (*播放录像没有此屏幕比例*)
    MWPlayerScaleModeTypeFit      = 1, //保持纵横比,适合层范围
    MWPlayerScaleModeTypeFill     = 2, //拉伸填充层边界
    MWPlayerScaleModeTypeResize   = 3  //播放录像->拉伸填充层边界 (*直播播放器没有此屏幕比例*)
} MWPlayerScaleModeType;



#endif /* MWPlayerEnumHeader_h */

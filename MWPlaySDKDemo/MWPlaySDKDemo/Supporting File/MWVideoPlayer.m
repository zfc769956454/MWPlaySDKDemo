//
//  MWVideoPlayer.m
//  MWPlaySDKDemo
//
//  Created by mac on 2018/11/26.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "MWVideoPlayer.h"
#import "MWSDKConfigHelper.h"

@implementation MWVideoPlayer


- (instancetype)initWithFrame:(CGRect)frame andType:(MWPlayerType)type andDelegate:(id<MWPlayerCallbackDelegate>)delegate response:(void (^)(BOOL, NSString *))response{
    
    if (![[[MWSDKConfigHelper sharedInstance] valueForKey:@"sdkVerifyState"] boolValue]) {
        if (response) {
            response(NO,@"初始化sdk失败");
        }
        return nil;
    }
    if (self = [super initWithFrame:frame andType:type andDelegate:delegate]) {
        
        if (response) {
            response(YES,@"初始化sdk成功");
        }
        
    }
    return self;
}




- (void)mw_start:(NSString *)playURL bufferTime:(NSInteger)bufferTime offset:(NSInteger)offset {
    
    [super start:playURL bufferTime:bufferTime offset:offset];
    
}



- (void)mw_pause {
    
    [super pause];
}


- (void)mw_resume {
    
    [super resume];
    
}


- (void)mw_stop {
    [super stop];
}


- (void)mw_seekTo:(NSInteger)value {
    
    [super seekTo:value];
    
}


- (CGFloat)mw_getDuration {
    
   return  [super getDuration];
    
}


- (CGFloat)mw_getCurrentTime {
    
   return [super getCurrentTime];
    
}


- (CGFloat)mw_getBufferTime {
    
   return  [super getBufferTime];
    
}


- (void)mw_setVideoScale:(MWPlayerScaleModeType)mode redraw:(BOOL)redraw {
    
    [super setVideoScale:mode redraw:redraw];
}


- (void)mw_printPlayerVer {
    
    [super printPlayerVer];
    
}


- (void)mw_setMute:(BOOL)isMute {
    
    [super setMute:isMute];
    
}


@end

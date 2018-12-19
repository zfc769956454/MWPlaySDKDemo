//
//  MWPlayChatViewController.h
//  MWPlaySDKDemo
//
//  Created by mac on 2018/11/21.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BKPageScrollPageViewDelegate.h"

@protocol MWLiveChatViewControllerDelegate <NSObject>

/**
 发消息

 @param inputText 文本
 */
- (void)sendMsg:(NSString *)inputText;

/**
 发礼物
 */
- (void)sendGif;

/**
 点赞
 */
- (void)sendParas;

/**
 清晰度选择
 */
- (void)definitionChoose:(NSInteger)currentIndex;

/**
 切换不同播放的url
 */
- (void)changeShortVideo;


/**
 发送问卷答案
 */
- (void)sendQuestionnaireAnswer;

/**
 获取问卷统计结果
 */
- (void)getQuestionnaireResult;

/**
 获取历史消息

 @param lastMessageID 最后一条消息id
 */
- (void)getChatRoomHistoryMessage:(NSString *)lastMessageID;

@end

@interface MWLiveChatViewController : UIViewController<ZJScrollPageViewChildVcDelegate>

@property (nonatomic,weak) id <MWLiveChatViewControllerDelegate>delegate;

/** 主屏清晰度当前选中的index */
@property (nonatomic, assign) NSInteger definitionChooseCurrentIndex_mvp;

/** 次屏清晰度当前选中的index */
@property (nonatomic, assign) NSInteger definitionChooseCurrentIndex_svp;

/** 是否是主屏在播放 */
@property (nonatomic,assign)BOOL isMainPlay;

- (void)reviceMsgWithSocketData:(MWLiveSocketData *)data;

@end



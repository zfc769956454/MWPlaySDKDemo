//
//  BKVoiceAndBrightView.h
//  MontnetsLiveKing
//
//  Created by 谢敏 on 2018/5/31.
//  Copyright © 2018年 facebac.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BKVoiceAndBrightView : UIView

@property (nonatomic,assign)BOOL isOnlyProgress;//只接收快进手势

@property (nonatomic,copy) void (^draggingBlock)(BOOL isDragEnd,NSInteger trans);

@end

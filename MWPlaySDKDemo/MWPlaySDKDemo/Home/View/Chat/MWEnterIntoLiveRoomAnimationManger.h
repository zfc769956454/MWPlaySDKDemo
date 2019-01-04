//
//  MWEnterIntoLiveRoomAnimationManger.h
//  MWPlaySDKDemo
//
//  Created by mac on 2019/1/4.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

//进入直播间动画管理类
@interface MWEnterIntoLiveRoomAnimationManger : NSObject

//进入显示
- (void)showEnterIntoAnimationWithNickName:(NSString *)nickName;

//移除
- (void)removeEnterIntoView;

@end



//
//  NSTimer+AutoRetain.h
//  BaiKeTheVoice
//
//  Created by NegHao on 2017/1/8.
//  Copyright © 2017年 facebac.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BKProxy.h"

@interface NSTimer (AutoRetain)
/** 内部已做处理，不会造成循环引用 */
+ (NSTimer *)nh_scheduledTimerWithTimeInterval:(NSTimeInterval)inerval
                                        repeats:(BOOL)repeats
                                          block:(void(^)(NSTimer *timer))block;

/** 内部已做处理，不会造成循环引用 */
+ (NSTimer *)nh_scheduledTimerTimeInterval:(NSTimeInterval)ti
                                    target:(id)aTarget
                                  selector:(SEL)aSelector
                                  userInfo:(nullable id)userInfo
                                   repeats:(BOOL)yesOrNo;

@end

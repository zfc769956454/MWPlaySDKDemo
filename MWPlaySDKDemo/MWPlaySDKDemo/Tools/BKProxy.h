//
//  BKProxy.h
//  MontnetsLiveKing
//
//  Created by nenhall_work on 2018/6/20.
//  Copyright © 2018年 facebac.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BKProxy : NSProxy
+ (id)proxyWithTarget:(nonnull id)target;
@property (weak, nonatomic) id target;

@end

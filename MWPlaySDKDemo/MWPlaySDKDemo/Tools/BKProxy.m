//
//  BKProxy.m
//  MontnetsLiveKing
//
//  Created by nenhall_work on 2018/6/20.
//  Copyright © 2018年 facebac.com. All rights reserved.
//

#import "BKProxy.h"

@implementation BKProxy

+ (id)proxyWithTarget:(id)target {
    BKProxy *proxy = [BKProxy alloc];
    proxy.target = target;
    return proxy;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    
    return [_target methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    
    [invocation invokeWithTarget:_target];
}

@end

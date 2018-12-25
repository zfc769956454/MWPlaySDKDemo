//
//  MWLiveSocketData.m
//  BaiKeLive
//
//  Created by chendb on 16/5/14.
//  Copyright © 2016年 simope. All rights reserved.
//

#import "MWLiveSocketData.h"
#import "MJExtension.h"
#import "MWSocketInfo.h"


@interface MWLiveSocketData()

@end

@implementation MWLiveSocketData

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"message":@"msg",@"code":@"cmd",@"liveinfo":@"data"};
}

- (id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    if (copy){
        [copy setLiveinfo:self.liveinfo];
    }
    return copy;
}

@end

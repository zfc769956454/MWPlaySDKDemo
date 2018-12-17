//
//  MWHomeListModel.m
//  MWPlaySDKDemo
//
//  Created by mac on 2018/11/27.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "MWLiveListModel.h"

@implementation MWLiveListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"liveId":@"id"};
}

@end

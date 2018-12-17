//
//  BKMontUserCenter.m
//  MontnetsLiveKing
//
//  Created by 谢敏 on 2017/7/17.
//  Copyright © 2017年 facebac.com. All rights reserved.
//

#import "MWMontUserCenter.h"
#import "MWNetworkHelper.h"
#import "MWLiveApiHeader.h"
#import "NSString+append.h"


#define  urlHost @"http://nx.facebac.com/farmbank-server"
#define  urlHost_socket @"http://nx.facebac.com:9882"


@implementation MWMontUserCenter

+ (void)querySocketInfoWithLiveId:(NSString *)liveId
                         complete:(CompleteBlock)complete {
    
    MWNetworkHelper *helper = [MWNetworkHelper shareInstance];
    NSDictionary *parameters = @{ @"cmd" : @"lb",@"liveID" :liveId ? liveId : @""};
    [helper POST:[NSString stringWithFormat:@"%@/dispatcher.action",urlHost_socket] Parameters:parameters Success:^(id responseObject) {
         if (complete) complete(responseObject,nil);
    } Failure:^(NSError *error) {
         if (complete) complete(nil, error);
    }];
    
}



+ (void)queryLiveListComplete:(CompleteBlock)complete {
    
    MWNetworkHelper *helper = [MWNetworkHelper shareInstance];
    [helper POST:[NSString stringWithFormat:@"%@/liveInfo/getLiveInfoList.action",urlHost] Parameters:nil Success:^(id responseObject) {
        if (complete) complete(responseObject,nil);
    } Failure:^(NSError *error) {
        if (complete) complete(nil, error);
    }];
    
}


+ (void)queryLiveDetailInfoWithLiveId:(NSString *)liveId
                               userId:(NSString *)userId
                             complete:(CompleteBlock)complete {
    
    MWNetworkHelper *helper = [MWNetworkHelper shareInstance];
    NSDictionary *paraDic = @{@"liveId":liveId ? liveId :@"",@"userId":userId ? userId : @""};
    //getLiveInfoByAdmin.action(可以获取到推流地址) getLiveInfo.action
    [helper POST:[NSString stringWithFormat:@"%@/liveInfo/getLiveInfo.action",urlHost] Parameters:paraDic Success:^(id responseObject) {
        if (complete) complete(responseObject,nil);
    } Failure:^(NSError *error) {
        if (complete) complete(nil, error);
    }];
    
}


+ (void)queryVideoListComplete:(CompleteBlock)complete {
    
    MWNetworkHelper *helper = [MWNetworkHelper shareInstance];
    [helper POST:[NSString stringWithFormat:@"%@/shortVideo/getShortVideoList.action",urlHost] Parameters:nil Success:^(id responseObject) {
        if (complete) complete(responseObject,nil);
    } Failure:^(NSError *error) {
        if (complete) complete(nil, error);
    }];
    
}

+ (void)queryVideoDetailInfoWithVideoId:(NSString *)videoId
                             complete:(CompleteBlock)complete {
    
    MWNetworkHelper *helper = [MWNetworkHelper shareInstance];
    NSDictionary *paraDic = @{@"shortVideoId":videoId ? videoId :@""};
    [helper POST:[NSString stringWithFormat:@"%@/shortVideo/getShortVideo.action",urlHost] Parameters:paraDic Success:^(id responseObject) {
        if (complete) complete(responseObject,nil);
    } Failure:^(NSError *error) {
        if (complete) complete(nil, error);
    }];
    
}


@end

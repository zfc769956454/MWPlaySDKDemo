//
//  MWSDKConfigHelper.h
//  MWPlaySDKDemo
//
//  Created by mac on 2018/11/26.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MWSDKConfigHelper : NSObject


+(instancetype) sharedInstance;

/**
 初始化sdk

 @param sdkVersion sdk版本号
 @param sdkVersionKey sdk验证ksy
 @param response 回调block,成功success = YES msg:回调信息
 */
- (void) initWithSDKVersion:(NSString *)sdkVersion
              sdkVersionKey:(NSString *)sdkVersionKey
                   response:(void(^)(BOOL success,NSString *msg))response;


@end



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



/**
 当前SDK初始化状态,用于特殊状态下,如果返回NO,请调用上面的方法再进行初始化
 */
@property (nonatomic,assign,readonly) BOOL sdkState;

@end



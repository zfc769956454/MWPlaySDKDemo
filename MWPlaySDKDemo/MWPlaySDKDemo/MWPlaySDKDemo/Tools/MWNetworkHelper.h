//
//  MWNetworkHelper.h
//  BaiKeLive
//
//  Created by simope on 16/6/12.
//  Copyright © 2016年 simope. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSInteger{
    
    StatusUnknown = -1,//未知状态
    StatusNotReachable = 0,//无网状态
    StatusReachableViaWWAN = 1,//手机网络
    StatusReachableViaWiFi = 2,//Wifi网络
    
} NetworkStatus;

/**
 *  请求成功
 */
typedef void (^Success)(id success);

/**
 *  请求失败
 */
typedef void (^Failure)(NSError *failure);

/**
 *  请求结果
 */
typedef void (^RequestResult)(Success,Failure);


@interface MWNetworkHelper : NSObject

@property (nonatomic, assign) NetworkStatus netStatus;
@property (nonatomic, strong) NSOutputStream *outputStream;

/**取消所有网络请求*/
+ (void)cancelAllOperations;

/**
 *  建立网络请求单例
 */
+ (id)shareInstance;


/**
 *  GET请求
 *
 *  @param url        请求接口
 *  @param parameters 向服务器请求时的参数
 *  @param success    请求成功，block的参数为服务返回的数据
 *  @param failure    请求失败，block的参数为错误信息
 */
- (void)GET:(NSString *)url
 Parameters:(NSDictionary *)parameters
    Success:(void(^)(id responseObject))success
    Failure:(void (^)(NSError *error))failure;

/**
 *  POST请求
 *
 *  @param url        要提交的数据结构
 *  @param parameters 要提交的数据
 *  @param success    成功执行，block的参数为服务器返回的内容
 *  @param failure    执行失败，block的参数为错误信息
 */
- (void)POST:(NSString *)url
  Parameters:(NSDictionary *)parameters
     Success:(void(^)(id responseObject))success
     Failure:(void(^)(NSError *error))failure;


/**
 *   监听网络状态的变化
 */
+ (void)checkingNetworkResult:(void(^)(NetworkStatus status))result;

@end

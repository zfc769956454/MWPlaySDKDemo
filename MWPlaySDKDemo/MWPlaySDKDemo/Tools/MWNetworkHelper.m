//
//  MWNetworkHelper.m
//  BaiKeLive
//
//  Created by simope on 16/6/12.
//  Copyright © 2016年 simope. All rights reserved.
//

#import "MWNetworkHelper.h"
#import "AFNetworking.h"
#import "MWLiveApiHeader.h"
#import "NSString+BKExtension.h"
#import "MWCommonHeader.h"


static NSString * const kAFNetworkingLockName = @"com.alamofire.networking.operation.lock";
static NSTimeInterval timeoutInterval = 10;

@interface MWNetworkHelper ()<UIAlertViewDelegate>

@property (readwrite, nonatomic, strong) NSRecursiveLock *lock;

@property (readwrite, nonatomic, assign) BOOL hasPopAnAlert;

@end

@implementation MWNetworkHelper
@synthesize outputStream = _outputStream;

+(void)cancelAllOperations{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.operationQueue cancelAllOperations];
}

/**
 *  建立网络请求单例
 */
+ (id)shareInstance{
    static MWNetworkHelper *helper;
    static dispatch_once_t onceToken;
    
    __weak MWNetworkHelper *weakSelf = helper;
    dispatch_once(&onceToken, ^{
        if (helper == nil) {
            helper = [[MWNetworkHelper alloc]init];
            weakSelf.lock = [[NSRecursiveLock alloc] init];
            weakSelf.lock.name = kAFNetworkingLockName;
        }
    });
    return helper;
}


/**
 *  GET请求
 */
- (void)GET:(NSString *)url Parameters:(NSDictionary *)parameters Success:(void (^)(id))success Failure:(void (^)(NSError *))failure{

    //断言
    NSAssert(url != nil, @"url不能为空");
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    //使用AFNetworking进行网络请求
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //因为服务器返回的数据如果不是application/json格式的数据
    //需要以NSData的方式接收,然后自行解析
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.requestSerializer.timeoutInterval = timeoutInterval;
    
    //发起get请求
    [manager GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

        //将返回的数据转成json数据格式
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments error:nil];
        
        if (result == nil || [result isKindOfClass:[NSNull class]]) { //添加后台返回空 或 null 判断
            NSError *error = [NSError errorWithDomain:@"result null" code:400 userInfo:@{}];
            if (failure) failure(error);
            return;
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

        //通过block,将错误信息回传给用户
        if (failure) failure(error);
    }];
}



/**
 *  POST请求
 */
- (void)POST:(NSString *)url Parameters:(NSDictionary *)parameters Success:(void (^)(id))success Failure:(void (^)(NSError *))failure{
 
    NSAssert(url != nil, @"url不能为空");
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    });
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = timeoutInterval;

    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

        if ([url hasSuffix:@"report/100001"]) {//请求加密上报的秘钥接口，成功后保存服务器生成的cookie
            
            //获取cookie
            NSArray*cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
            //把cookie进行归档并转换为NSData类型
            NSData*cookiesData = [NSKeyedArchiver archivedDataWithRootObject:cookies];
            
            //存储归档后的cookie
            kSetLocalUserinfos(cookiesData, @"klocal_uploadCookie");
        }
        
        NSDictionary *result;

        result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments error:nil];
        
        if (result == nil || [result isKindOfClass:[NSNull class]]) { //添加后台返回空 或 null 判断
            NSError *error = [NSError errorWithDomain:@"result null" code:400 userInfo:@{}];
            if (failure) failure(error);
            return;
        }
        //通过block，将数据回掉给用户
        if (success) success(result);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

        if (failure) failure(error);
    }];
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


/**
 *   监听网络状态的变化
 */
+ (void)checkingNetworkResult:(void (^)(NetworkStatus))result {
    
    AFNetworkReachabilityManager *reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [reachabilityManager startMonitoring];
    [reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {

        if (status == AFNetworkReachabilityStatusUnknown) {
            
            if (result) result(StatusUnknown);
            
        }else if (status == AFNetworkReachabilityStatusNotReachable){
            
            if (result) result(StatusNotReachable);
            
        }else if (status == AFNetworkReachabilityStatusReachableViaWWAN){
            
            if (result) result(StatusReachableViaWWAN);
            
        }else if (status == AFNetworkReachabilityStatusReachableViaWiFi){
            
            if (result) result(StatusReachableViaWiFi);
            
        }
    }];
}


/**
 *   取消所有正在执行的网络请求项
 */
- (void)cancelAllNetworkingRequest{

    //开发中...
}


- (NSOutputStream *)outputStream {
    if (!_outputStream) {
        self.outputStream = [NSOutputStream outputStreamToMemory];
    }
    
    return _outputStream;
}


- (void)setOutputStream:(NSOutputStream *)outputStream {
    [self.lock lock];
    if (outputStream != _outputStream) {
        if (_outputStream) {
            [_outputStream close];
        }
        _outputStream = outputStream;
    }
    [self.lock unlock];
}


- (NSString *)pathForTemporaryFileWithPrefix:(NSString *)prefix{
    NSString    *result;
    NSString    *newResult;
    CFUUIDRef   uuid;
    CFStringRef uuidStr;
    uuid = CFUUIDCreate(NULL);
    
    uuidStr = CFUUIDCreateString(NULL, uuid);
    
    result = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-%@", prefix, uuidStr]];
    newResult = [NSString stringWithFormat:@"%@",uuidStr];
    CFRelease(uuidStr);
    CFRelease(uuid);
    
    return result;
}

@end

//
//  MWSDKConfigHelper.m
//  MWPlaySDKDemo
//
//  Created by mac on 2018/11/26.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "MWSDKConfigHelper.h"

#define kRequestTimeOut 20 //默认请求超时秒数
#define checkSdkVersion @"http://nx.facebac.com/checkSdkVersion.action"

@interface MWSDKConfigHelper ()

@property (nonatomic,copy) NSString *sdkVerifyState;

@property (nonatomic,assign) NSInteger requestTime;

@end


@implementation MWSDKConfigHelper

+(instancetype) sharedInstance {
    static MWSDKConfigHelper* _mwHelper = nil;
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _mwHelper = [[super allocWithZone:NULL] init] ;
    });
    return _mwHelper ;
}


- (instancetype)init
{
    if(self=[super init]){
        self.sdkVerifyState = @"0";
        self.requestTime = 0;
    }
    return self;
}

+(id)allocWithZone:(struct _NSZone *)zone
{
    return [MWSDKConfigHelper sharedInstance] ;
}

-(id)copyWithZone:(struct _NSZone *)zone
{
    return [MWSDKConfigHelper sharedInstance] ;
}

- (void)initWithSDKVersion:(NSString *)sdkVersion sdkVersionKey:(NSString *)sdkVersionKey response:(void(^)(BOOL success,NSString *msg))response {
    
    
    if (response) {
        [self setValue: @"1" forKey:@"sdkVerifyState"];
        response(YES,@"初始化SDK成功");
    }
    
//    NSDictionary *parameters = @{@"version ":sdkVersion,@"versionKey":sdkVersionKey,@"sdkPv":@"ios"};
//    [self POST:checkSdkVersion parameters:parameters success:^(id  _Nonnull result) {
//
//        if (result && ![result isEqual:[NSNull class]]) {
//
//            if (response) {
//                [self setValue: ([result[@"code"] intValue] == 200) ? @"1" : @"0" forKey:@"sdkVerifyState"];
//                response(([result[@"code"] intValue] == 200) ? YES : NO,result[@"msg"]);
//            }
//
//        }else {
//            if (response) {
//                [self setValue: @"0" forKey:@"sdkVerifyState"];
//                response(NO,result[@"msg"]);
//            }
//        }
//        self.requestTime = 0;
//
//    } failure:^(NSError * _Nonnull error) {
//        self.requestTime++;
//        if (self.requestTime <= 3) {
//
//            [self initWithSDKVersion:sdkVersion sdkVersionKey:sdkVersionKey response:response];
//
//        }else {
//            if (response) {
//                [self setValue: @"0" forKey:@"sdkVerifyState"];
//                response(NO,@"初始化SDK失败");
//            }
//            self.requestTime = 0;
//        }
//    }];
}




- (void)POST:(NSString *)URLString parameters:(NSDictionary *)parameters success:(void (^ _Nullable)(id _Nonnull))success failure:(void (^ _Nullable)(NSError * _Nonnull))failure {
    NSOperationQueue *queue = [NSOperationQueue currentQueue]; //记录调用方法时的队列
    NSURL *url = [NSURL URLWithString:URLString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.timeoutInterval = kRequestTimeOut;
    if (parameters) { //如果有请求参数
        request.HTTPBody = [[self transParaToStringFrom:parameters] dataUsingEncoding:NSUTF8StringEncoding];
    }
    request.HTTPMethod = @"POST";
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [queue addOperationWithBlock:^{ //回到本来的队列
            if (error) { //请求出错
                !failure ?: failure(error);
            } else {
                NSError *err;
                id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments error:&err]; //解析JSON
                if (err) {
                    !failure ?: failure(err); //解析出错
                } else {
                    !success ?: success(obj); //请求成功
                }
            }
        }];
    }];
    [task resume];
}

- (NSString *)transParaToStringFrom:(NSDictionary *)parameters {
    NSMutableString *paras = [NSMutableString string];
    [parameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [paras appendString:[NSString stringWithFormat:@"%@%@=%@",paras.length == 0 ? @"" : @"&", (NSString *)key, (NSString *)obj]];
    }];
    return [paras copy];
}


@end

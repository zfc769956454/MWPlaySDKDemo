//
//  BKPersonalInfoModel.m
//  MontnetsLiveKing
//
//  Created by lzp on 2017/10/30.
//  Copyright © 2017年 facebac.com. All rights reserved.
//

#import "MWPersonalInfoModel.h"
#import "MWDictionaryUtils.h"


@implementation MWPersonalLiveInfo

#pragma mark -- NSCoding

- (id)initWithCoder:(NSCoder *)decoder{
    if (self = [super init]) {
        [self mj_decode:decoder];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder{
    [self mj_encode:encoder];
}

- (id)valueForUndefinedKey:(NSString *)key {
    return @"";
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
}




- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property{
    if ([oldValue isKindOfClass:[NSNull class]]) {
        if (property.type.typeClass == [NSDate class]) {
            NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
            fmt.dateFormat = @"yyyy-MM-dd hh:mm";
            return [fmt dateFromString:oldValue];
        }else if(property.type.typeClass == [NSString class]){
            return @"0";
        }else if(property.type.typeClass == [NSNumber class]){
            return [NSNumber numberWithInteger:0];
        }
    }
    return oldValue;
}

@end

@implementation MWPersonalInfo

#pragma mark -- NSCoding

- (id)initWithCoder:(NSCoder *)decoder{
    if (self = [super init]) {
        [self mj_decode:decoder];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder{
    [self mj_encode:encoder];
}

- (id)valueForUndefinedKey:(NSString *)key {
    return @"";
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
}

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property{
    if ([oldValue isKindOfClass:[NSNull class]]) {
        if (property.type.typeClass == [NSDate class]) {
            NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
            fmt.dateFormat = @"yyyy-MM-dd hh:mm";
            return [fmt dateFromString:oldValue];
        }else if(property.type.typeClass == [NSString class]){
            return @"0";
        }else if(property.type.typeClass == [NSNumber class]){
            return [NSNumber numberWithInteger:0];
        }
    }
    return oldValue;
}

@end

@implementation MWPersonalInfoModel
#pragma mark -- NSCoding

- (id)initWithCoder:(NSCoder *)decoder{
    if (self = [super init]) {
        [self mj_decode:decoder];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder{
    [self mj_encode:encoder];
}

- (id)valueForUndefinedKey:(NSString *)key {
    return @"";
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
}

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property{
    if ([oldValue isKindOfClass:[NSNull class]]) {
        if (property.type.typeClass == [NSDate class]) {
            NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
            fmt.dateFormat = @"yyyy-MM-dd hh:mm";
            return [fmt dateFromString:oldValue];
        }else if(property.type.typeClass == [NSString class]){
            return @"0";
        }else if(property.type.typeClass == [NSNumber class]){
            return [NSNumber numberWithInteger:0];
        }
    }
    return oldValue;
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{ @"liveInfoArray" : [MWPersonalLiveInfo class] };
}

- (void)setParams:(NSDictionary *)params{
    if(params){
        self.userInfo = [MWPersonalInfo mj_objectWithKeyValues:params[@"userInfo"]];
        self.liveParams = [params safeDicForKey:@"liveParams"];
        self.liveInfoArray = [MWPersonalLiveInfo mj_objectArrayWithKeyValuesArray:self.liveParams[@"list"]];
    }
}

@end

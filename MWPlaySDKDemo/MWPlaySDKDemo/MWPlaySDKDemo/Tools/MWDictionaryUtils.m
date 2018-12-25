//
//  ASDictionaryUtils.m
//  Copoor



#import "MWDictionaryUtils.h"
#import <objc/runtime.h>
#import <objc/objc-api.h>
#import <objc/runtime.h>

@implementation NSDictionary(AirsourceExtensions)

- (id)safeObjectForKey:(id)aKey
{
    id retObj = [self objectForKey:aKey];
    if (retObj == [NSNull null])
    {
        return nil;
    }
    
    NSString * keyString = ASDynamicCast(NSString, aKey);
    //try to convert to other case to match
    if (!retObj && keyString) 
    {
        NSArray * keyList = [NSArray arrayWithObjects:[keyString lowercaseString], [keyString uppercaseString], [keyString capitalizedString], nil];
        for (NSString * tryKey in keyList) 
        {
            retObj = [self objectForKey:tryKey];
            if (retObj == [NSNull null])
                return nil;
            if (retObj)
                break;
        }
    }
    return retObj;
}

-(NSNumber*)safeNumberForKey:(id)aKey
{
    return ASDynamicCast(NSNumber, [self safeObjectForKey:aKey]);
}

-(NSString*)safeStringForKey:(id)aKey
{
    id obj = [self objectForKey:aKey];
    NSString * str = ASDynamicCast(NSString, obj);
    if (!str) {
        NSNumber *data = ASDynamicCast(NSNumber, obj);
        if (data) {
            str = [NSString stringWithFormat:@"%@",data];
        }
    }
    return (str ? str :  @"");
}

- (NSDictionary *) safeDicForKey:(id)aKey{
    id obj = [self objectForKey:aKey];
    NSDictionary * dic = ASDynamicCast(NSDictionary, obj);
    if (!dic) {
        return @{};
    }
    return dic;
}

-(NSString*)safeStringPriceForKey:(id)aKey
{
    id obj = [self safeObjectForKey:aKey];
    NSString * str = ASDynamicCast(NSString, obj);
    NSNumber * num = ASDynamicCast(NSNumber, obj);
    return str ? : ([NSString stringWithFormat:@"%@元", num]);
}

-(NSString*)safeStringPriceForKey:(id)aKey withFormat:(NSString *)format
{
    id obj = [self safeObjectForKey:aKey];
    NSString * str = ASDynamicCast(NSString, obj);
    NSNumber * num = ASDynamicCast(NSNumber, obj);
    return str ? : ([NSString stringWithFormat:format, [num doubleValue]]);
}

-(NSString*)safeStringDistanceForKey:(id)aKey
{
    NSNumber * num = [self safeNumberForKey:aKey];
    double distance = [num doubleValue];
    if (distance > 99) {
        return [NSString stringWithFormat:@"距离>99km"];
    }else if (distance > 1){
        return [NSString stringWithFormat:@"距离%.0fkm", distance];
    }else{
        return [NSString stringWithFormat:@"距离%.0f米", distance*1000];
    }
}

-(NSString*)safeStringDistanceForKey:(id)aKey withPropty:(NSString *)propty
{
    NSNumber * num = [self safeNumberForKey:aKey];
    double distance = [num doubleValue];
    if (distance > 99) {
        return [NSString stringWithFormat:@"%@>99km", propty];
    }else if (distance > 1){
        return [NSString stringWithFormat:@"%@%.0fkm", propty, distance];
    }else{
        return [NSString stringWithFormat:@"%@%.0f米", propty, distance*1000];
    }
}

- (NSArray *)cleanupNullArray:(NSArray *)arr
{
    NSMutableArray * retArr = [NSMutableArray array];
    for (NSDictionary * val in arr) {
        if (![val isKindOfClass:[NSNull class]]) {
            if([val isKindOfClass:[NSDictionary class]]){
                [retArr addObject:[val cleanupNull]];
            }else if([val isKindOfClass:[NSArray class]]){
                [retArr addObject:[self cleanupNullArray:(NSArray *)val]];
            }else{
                [retArr addObject:val];
            }
        }
    }
    return retArr;
}

- (NSDictionary *)cleanupNull
{
    NSMutableDictionary * retDict = [NSMutableDictionary dictionary];
    NSArray * keys = [self allKeys];
    for (NSString * key in keys) {
        id val = [self objectForKey:key];
        if (![val isKindOfClass:[NSNull class]]) {
            if([val isKindOfClass:[NSDictionary class]]){
                [retDict setObject:[val cleanupNull] forKey:key];
            }else if([val isKindOfClass:[NSArray class]]){
                [retDict setObject:[self cleanupNullArray:(NSArray *)val] forKey:key];
            }else{
                [retDict setObject:val forKey:key];
            }
        }
    }
    return retDict;
}
@end

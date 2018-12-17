//
//  ASDictionaryUtils.h
//  Copoor


#import <Foundation/Foundation.h>

@interface NSDictionary(AirsourceExtensions)

-(id)safeObjectForKey:(id)aKey;
-(NSNumber*)safeNumberForKey:(id)aKey;
-(NSString*)safeStringForKey:(id)aKey;
-(NSString*)safeStringPriceForKey:(id)aKey;
//-(NSDate *)safeStringDateForKey:(id)aKey;
-(NSString*)safeStringDistanceForKey:(id)aKey;
-(NSString*)safeStringDistanceForKey:(id)aKey withPropty:(NSString *)propty;
-(NSString*)safeStringPriceForKey:(id)aKey withFormat:(NSString *)format;
//- (NSArray *)keyValuePairs;
//-(NSString*)safeStringUrlForKey:(id)aKey;
- (NSDictionary *)cleanupNull;
- (NSDictionary *) safeDicForKey:(id)aKey;

@end

#define ASDynamicCast(C, o) ({ __typeof__(o) ASDynamicCast__o = (o); [ASDynamicCast__o isKindOfClass:[C class]] ? (C*)ASDynamicCast__o : nil; })

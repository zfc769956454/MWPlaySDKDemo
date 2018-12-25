//
//  BKKingLiveInfoModel.m
//  MontnetsLiveKing
//
//  Created by 谢敏 on 2017/7/19.
//  Copyright © 2017年 facebac.com. All rights reserved.
//

#import "MWKingLiveInfoModel.h"

@implementation MWKingLiveInfoModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID": @"id",};
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
//    [aCoder encodeObject:_ID forKey:@"ID"];
//    [aCoder encodeObject:_live_name forKey:@"live_name"];
//    [aCoder encodeObject:_live_text forKey:@"live_text"];
//    [aCoder encodeObject:_begin_time forKey:@"begin_time"];
//    [aCoder encodeObject:_end_time forKey:@"end_time"];
//    [aCoder encodeInt:_live_status forKey:@"live_status"];
//    [aCoder encodeObject:_live_cover_url forKey:@"live_cover_url"];
//    [aCoder encodeObject:_live_cover_id forKey:@"live_cover_id"];
//    [aCoder encodeObject:_live_text_imgsid forKey:@"live_text_imgsid"];
//    [aCoder encodeObject:_live_text_imgsurl forKey:@"live_text_imgsurl"];
//    [aCoder encodeObject:_push_url forKey:@"push_url"];
//    [aCoder encodeObject:_share_url forKey:@"share_url"];
//    [aCoder encodeObject:_definition forKey:@"definition"];
//    [aCoder encodeObject:_view_pass forKey:@"view_pass"];
//    [aCoder encodeObject:_play_m3u8_url forKey:@"play_m3u8_url"];
//    [aCoder encodeObject:_play_url forKey:@"play_url"];
//    [aCoder encodeObject:_liveCoverData forKey:@"liveCoverData"];
    
    [self mj_encode:aCoder];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    
//    if (self = [super init]) {
//        
//        _ID = [aDecoder decodeObjectForKey:@"ID"];
//        _live_name = [aDecoder decodeObjectForKey:@"live_name"];
//        _live_text = [aDecoder decodeObjectForKey:@"live_text"];
//        _begin_time = [aDecoder decodeObjectForKey:@"begin_time"];
//        _end_time = [aDecoder decodeObjectForKey:@"end_time"];
//        _live_status = [aDecoder decodeIntForKey:@"live_status"];
//        _live_cover_url = [aDecoder decodeObjectForKey:@"live_cover_url"];
//        _live_cover_id = [aDecoder decodeObjectForKey:@"live_cover_id"];
//        _live_text_imgsid = [aDecoder decodeObjectForKey:@"live_text_imgsid"];
//        _live_text_imgsurl = [aDecoder decodeObjectForKey:@"live_text_imgsurl"];
//        _push_url = [aDecoder decodeObjectForKey:@"push_url"];
//        _share_url = [aDecoder decodeObjectForKey:@"share_url"];
//        _definition = [aDecoder decodeObjectForKey:@"definition"];
//        _view_pass = [aDecoder decodeObjectForKey:@"view_pass"];
//        _play_m3u8_url = [aDecoder decodeObjectForKey:@"play_m3u8_url"];
//        _play_url = [aDecoder decodeObjectForKey:@"play_url"];
//        _liveCoverData = [aDecoder decodeObjectForKey:@"liveCoverData"];
//    }
//    return self;
    
    self = [super init];
    if(self){
        [self mj_decode:aDecoder];
    }
    return self ;
}


- (id)copyWithZone:(NSZone *)zone {
    
//    BKKingLiveInfoModel *model = [[BKKingLiveInfoModel alloc] init];
    
    NSDictionary *parameters = [self mj_keyValues].copy;

    MWKingLiveInfoModel *model = [MWKingLiveInfoModel mj_objectWithKeyValues:parameters];

    return model;
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{ @"detailsList" : [BKDefinitionDetailModel class] };
}

@end

@implementation BKDefinitionDetailModel

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [self mj_encode:aCoder];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super init];
    if(self){
        [self mj_decode:aDecoder];
    }
    return self ;
}


- (id)copyWithZone:(NSZone *)zone {
    
    NSDictionary *parameters = [self mj_keyValues].copy;
    
    BKDefinitionDetailModel *model = [BKDefinitionDetailModel mj_objectWithKeyValues:parameters];
    
    return model;
}


@end

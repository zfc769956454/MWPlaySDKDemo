//
//Created by ESJsonFormatForMac on 18/11/27.
//

#import "MWVideoDetailModel.h"

@implementation MWVideoDetailModel




- (id)initWithResult:(FMResultSet *)rs{
    self = [super init];
    if (self) {
        self.liveId = [rs stringForColumn:@"video_id"];
        self.lastWatchTime = [rs intForColumn:@"lastWatchTime"];
    }
    return self;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"liveId":@"id"};
}

@end


@implementation MWDefinitionModel


@end



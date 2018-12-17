//
//  BKFlowRedEnvelopeModel.m
//  MontnetsLiveKing
//
//  Created by chendb on 2017/9/25.
//  Copyright © 2017年 facebac.com. All rights reserved.
//

#import "BKFlowRedEnvelopeModel.h"

@implementation BKFlowRedEnvelopeModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"name":@"name"};
}

@end





@implementation BKFlowInfoModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"nickName":@"nickName",};
}


//获取显示红包地址
+ (NSString *)loadFlowRedEnvelopeInfoWithModel:(BKFlowInfoModel *)model Image:(NSString *)image anchorImage:(NSString *)anchorImg wallet:(NSString *)wallet userID:(NSString *)userID{
    NSString *h5Url = [NSString stringWithFormat:@"%@&openId=%@&signNature=%@&closeUrl=http://montnets.facebac.com/montnet20170707/H5/videoplayer/bac_liveKing/closePar.html&nickName=%@&headImg=%@&anchorName=%@&anchorImg=%@",
                       wallet,userID,model.strTmp,model.nickName,image,model.anchorName,anchorImg];
    return  h5Url;
}

@end

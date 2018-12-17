//
//  BKFlowRedEnvelopeModel.h
//  MontnetsLiveKing
//
//  Created by chendb on 2017/9/25.
//  Copyright © 2017年 facebac.com. All rights reserved.
//

#import <Foundation/Foundation.h>


#define    BKFlowCloseUrl    @"http://montnets.facebac.com/montnet20170707/H5/videoplayer/bac_liveKing/closePar.html"


@interface BKFlowRedEnvelopeModel : NSObject

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *date1;

@property (nonatomic, strong) NSString *date2;

@property (nonatomic, strong) NSString *wallet;

@property (nonatomic, strong) NSString *portrait;

@property (nonatomic, strong) NSString *datetime;

@property (nonatomic, strong) NSString *type;

@property (nonatomic, strong) NSString *redID;

@property (nonatomic, strong) NSString *user_title; //主播昵称

@property (nonatomic, strong) NSString *head_url; //主播头像

@end



@interface BKFlowInfoModel : NSObject

@property (nonatomic, strong) NSString *resultCode;

@property (nonatomic, strong) NSString *anchorName;

@property (nonatomic, strong) NSString *nickName;

@property (nonatomic, strong) NSString *strTmp;

@property (nonatomic, strong) NSString *resultMessage;

//获取显示红包地址
+ (NSString *)loadFlowRedEnvelopeInfoWithModel:(BKFlowInfoModel *)model Image:(NSString *)image anchorImage:(NSString *)anchorImg wallet:(NSString *)wallet userID:(NSString *)userID;


@end

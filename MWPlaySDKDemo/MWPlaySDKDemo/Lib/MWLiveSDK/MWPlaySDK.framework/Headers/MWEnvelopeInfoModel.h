//
//  MWEnvelopeInfoModel.h
//  BaiKeMiJiaLive
//
//  Created by chendb on 2017/2/23.
//  Copyright © 2017年 facebac.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MWEnvelopeInfoModel : NSObject

@property (nonatomic ,assign) int       rp_child_index;     //红包序列号
@property (nonatomic ,strong) NSString  *rp_fromID;     //发送红包者ID
@property (nonatomic ,strong) NSString  *rp_id;         //红包ID
@property (nonatomic ,assign) int       rp_recv_status; //红包领取状态    0未领取    1领取
@property (nonatomic ,assign) long long rp_recv_time;   //红包领取时间
@property (nonatomic ,strong) NSString  *rp_toID;       //红包领取者ID
@property (nonatomic ,assign) int       rp_toID_gender; //红包领取者性别   0男      1女
@property (nonatomic ,strong) NSString  *rp_toID_imgUrl;//红包领取者头像
@property (nonatomic ,strong) NSString  *rp_toID_nickName;  //红包领取者昵称
@property (nonatomic ,assign) int       rp_value;           //领取金额

@end

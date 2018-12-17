//
//  BKPersonlLiveCell.h
//  MontnetsLiveKing
//
//  Created by lzp on 2017/10/17.
//  Copyright © 2017年 facebac.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWPersonalInfoModel.h"

@class BKPersonlLiveCell;
@protocol BKPersonlLiveCellDelegate <NSObject>
- (void)showMoreWithLiveInfo:(MWPersonalLiveInfo *) data;
@end

@interface MWPersonlLiveCell : UITableViewCell
@property(nonatomic,weak)id<BKPersonlLiveCellDelegate>delegate;
@property(nonatomic,copy)NSString *headUrl;
@property(nonatomic,copy)NSString *userName;
@property(nonatomic)UIImage *corverImage;
- (void)refreshWith:(MWPersonalLiveInfo *)data;
- (void)setIsVerify:(BOOL)isVerify isDefaultFollow:(BOOL)isDefaultFollow;
@end

//
//  BKMoreViewItem.h
//  MontnetsLiveKing
//
//  Created by lzp on 2017/10/25.
//  Copyright © 2017年 facebac.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,KKMoreItemType) {
    KKMoreItemTypeWXTimesmp ,//微信朋友圈
    KKMoreItemTypeWXFriend ,//微信好友
    KKMoreItemTypeQQ ,//QQ
    KKMoreItemTypeQZone ,//QQ空间
    KKMoreItemTypeWeiBo //微博
};

@interface BKMoreViewItem : UIView
@property(nonatomic,assign)KKMoreItemType itemType;
@property(nonatomic,copy)NSString *iconName;
@property(nonatomic,copy)NSString *title;
- (instancetype)initWithType:(KKMoreItemType)type iconName:(NSString *)iconName title:(NSString *)title;
@end

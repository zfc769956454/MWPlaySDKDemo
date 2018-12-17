//
//  MWCommentMsgCell.h
//  MontnetsLiveKing
//
//  Created by lzp on 2017/8/31.
//  Copyright © 2017年 facebac.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWCommentData.h"


@protocol MWChatMsgCellDelegate <NSObject>
- (void)tapHeadImageWithInfo:(MWLiveSocketData *)info;
@end

@interface MWChatMsgCell : UITableViewCell

@property(nonatomic,weak)id<MWChatMsgCellDelegate>delegate;

+ (CGFloat)fetchCellHeightWithInfo:(MWCommentData *)info;
+ (CGFloat)fetchCommentTextWidth;
+ (UIFont *)fetchFont;
+ (CGFloat)fetchLineSpace;
- (void)refreshCellWithInfo:(MWCommentData *)info;

@end

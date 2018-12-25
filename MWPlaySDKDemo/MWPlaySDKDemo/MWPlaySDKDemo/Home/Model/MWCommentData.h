//
//  MWCommentData.h
//  MontnetsLiveKing
//
//  Created by lzp on 2017/9/14.
//  Copyright © 2017年 facebac.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MWCommentData : NSObject
@property(nonatomic)MWLiveSocketData *sockData;
@property(nonatomic,assign)CGFloat maxCommemtTextWidth;//由外部传入，最大的文本宽度
@property(nonatomic)UIFont *textFont;//由外部传入，文本的字体
@property(nonatomic)UIColor *textColor;//由外部传入，文本的颜色
@property(nonatomic,assign)CGFloat lineSpace;//行间隔，由外部传入
@property(nonatomic,readonly)CGSize commemtTextSize;//文本的Size
@property(nonatomic,readonly)NSAttributedString *commentText;

@end

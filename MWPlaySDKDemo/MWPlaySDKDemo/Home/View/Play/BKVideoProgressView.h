//
//  BKVideoProgressView.h
//  MontnetsLiveKing
//
//  Created by 谢敏 on 2018/7/27.
//  Copyright © 2018年 facebac.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BKVideoProgressView : UIView

@property (nonatomic,assign) BOOL isSimpleType;
- (void)setTimeValue:(NSInteger)timeValue totalValue:(NSInteger)totalValue trans:(NSInteger)trans;

@end

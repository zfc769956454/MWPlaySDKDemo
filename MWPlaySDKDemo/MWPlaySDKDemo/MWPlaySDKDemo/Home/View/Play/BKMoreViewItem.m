//
//  BKMoreViewItem.m
//  MontnetsLiveKing
//
//  Created by lzp on 2017/10/25.
//  Copyright © 2017年 facebac.com. All rights reserved.
//

#import "BKMoreViewItem.h"

@implementation BKMoreViewItem

- (instancetype)initWithType:(KKMoreItemType)type iconName:(NSString *)iconName title:(NSString *)title{
    if(self = [super init]){
        self.itemType = type;
        self.iconName = iconName;
        self.title = title;
    }
    return self ;
}

@end

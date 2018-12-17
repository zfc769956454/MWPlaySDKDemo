//
//  NSString+append.m
//  MontnetsLiveKing
//
//  Created by neghao on 2017/10/25.
//  Copyright © 2017年 facebac.com. All rights reserved.
//

#import "NSString+append.h"

@implementation NSString (append)


- (NSString *)bk_stringByAppendingString:(NSString *)aString {
   return [NSString stringWithFormat:@"%@/%@",(self),(aString)];
}

@end

//
//  BKIndicatorAnimatiomProtocol.h
//  BaiKeMiJiaLive
//
//  Created by NegHao on 16/9/5.
//  Copyright © 2016年 facebac. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BKIndicatorAnimatiomProtocol <NSObject>

- (void)configAnimationAtLayer:(CALayer *)layer withTintColor:(UIColor *)color size:(CGSize)size;
- (void)removeAnimation;

@end

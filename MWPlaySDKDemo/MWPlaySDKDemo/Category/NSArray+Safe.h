//
//  NSArray+Safe.h
//  MontnetsLiveKing
//
//  Created by lzp on 2017/9/14.
//  Copyright © 2017年 facebac.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray<__covariant ObjectType> (Safe)

- (ObjectType)safeObjectAtIndex:(NSInteger)index;

- (NSArray *)safeSubarrayWithRange:(NSRange)range;

- (NSArray *)head:(NSUInteger)count;

@end

@interface NSMutableArray<ObjectType> (Safe)

- (void)safeAddObject:(ObjectType)aObj;
- (void)safeRemoveObjectAtIndex:(NSInteger)index;

@end

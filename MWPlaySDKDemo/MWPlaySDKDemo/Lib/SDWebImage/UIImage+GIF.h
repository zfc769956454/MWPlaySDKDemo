//
//  UIImage+GIF.h
//  LBGIFImage
//
//  Created by Laurin Brandner on 06.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (GIF)

+ (UIImage *)sd_animatedGIFNamed:(NSString *)name;

+ (UIImage *)sd_animatedGIFWithData:(NSData *)data;

- (UIImage *)sd_animatedImageByScalingAndCroppingToSize:(CGSize)size;

+ (UIImage *)shareImage:(NSData *)imagedata;

//对图片尺寸进行压缩--
+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
//
//  UIImage+BKExtension.h
//  BaiKeMiJiaLive
//
//  Created by simope on 16/7/19.
//  Copyright © 2016年 facebac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (BKExtension)

/**
 *  通过RGB颜色生成图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 *  图片压缩，data为空时返回一张默认图片
 *
 *  @param data 图片的data
 *  @param size 压缩后图片尺寸
 *
 *  @return 返回一张新的图片
 */
+ (UIImage *)imageWithData:(NSData *)data scaledToSize:(CGSize)size;
/**
 *  @param 对图片大小进行压缩(100kb左右)
 */
+ (NSData *)imageJPEGRepresentationData:(UIImage *)myimage;
/**
 *  图片压缩
 *
 *  @param image   要压缩的图片
 *  @param newSize 压缩后图片尺寸
 *
 *  @return 返回一张新的图片
 */
+ (UIImage*)imageWithChangeImage:(UIImage*)image scaledToSize:(CGSize)newSize;


/**
 *  按固定宽度对图片压缩
 *
 *  @param sourceImage 图片资源
 *  @param defineWidth 设置固定宽度
 *
 */
+ (UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;


/**
 *  返回一张可以随意拉伸不变形的图片
 *
 *  @param name 图片名字
 */
+ (UIImage *)resizableImage:(NSString *)name;


/**
 高撕模糊效果
 @param image 原图
 @param blur 模糊度
 */
+ (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur;
+ (UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;


/**
 将图片压缩到一定的大小
 */
+ (UIImage *)compressSizeAndQualityImage:(UIImage *)image toByte:(NSUInteger)maxLength;


/**
 截取某个view上的指定区域成返回一张相应图片

 @param rect 截取范围
 @param capInsets 内偏
 @param view 要截取的对象
 */
+ (UIImage *)snapshotViewFromRect:(CGRect)rect withCapInsets:(UIEdgeInsets)capInsets view:(UIView *)view;

@end
